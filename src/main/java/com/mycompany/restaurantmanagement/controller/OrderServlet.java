package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.util.DatabaseUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Servlet that handles order processing and payment
 */
@WebServlet(name = "OrderServlet", urlPatterns = {"/api/orders"})
public class OrderServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(OrderServlet.class.getName());

    /**
     * Handles the HTTP POST method to create a new order
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Check if user is logged in
        if (userId == null) {
            LOGGER.warning("Unauthorized order attempt - user not logged in");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"User not logged in. Please login to place an order.\", \"redirect\": true}");
            return;
        }
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int orderId = -1;
        
        try {
            // Get request body
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            
            String requestBody = sb.toString();
            LOGGER.info("Order request received: " + requestBody);
            
            JSONObject orderData = new JSONObject(requestBody);
            
            // Verify required fields
            if (!orderData.has("items") || !orderData.has("total") || orderData.getJSONArray("items").length() == 0) {
                LOGGER.warning("Invalid order: missing required fields or empty cart");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Missing required fields or your cart is empty. Please add items to your cart.\"}");
                return;
            }
            
            // Get order details
            JSONArray items = orderData.getJSONArray("items");
            boolean isDelivery = orderData.optBoolean("delivery", false);
            String address = orderData.optString("address", "");
            String paymentMethod = orderData.optString("paymentMethod", "cash");
            double subtotal = orderData.getDouble("total"); // Use total as base price if subtotal not provided
            
            // Calculate fees if not provided
            double serviceFee = orderData.optDouble("serviceFee", subtotal * 0.05); // Default 5% service fee
            double deliveryFee = isDelivery ? orderData.optDouble("deliveryFee", 15.0) : 0; // Default R15 delivery fee
            double total = orderData.optDouble("total", subtotal + serviceFee + deliveryFee);
            
            try {
                // Get database connection
                conn = DatabaseUtil.getConnection();
                
                // Critical section - use transaction
                conn.setAutoCommit(false); 
                
                // Insert into orders table with better error handling
                String orderSql = "INSERT INTO orders (user_id, created_at, subtotal, service_fee, delivery_fee, total_amount, " +
                                 "is_delivery, delivery_address, payment_method, status) " +
                                 "VALUES (?, NOW(), ?, ?, ?, ?, ?, ?, ?, 'pending')";
                
                pstmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
                pstmt.setInt(1, userId);
                pstmt.setDouble(2, subtotal);
                pstmt.setDouble(3, serviceFee);
                pstmt.setDouble(4, deliveryFee);
                pstmt.setDouble(5, total);
                pstmt.setBoolean(6, isDelivery);
                pstmt.setString(7, address);
                pstmt.setString(8, paymentMethod);
                
                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected <= 0) {
                    throw new SQLException("Failed to insert order, no rows affected");
                }
                
                // Get the auto-generated order ID
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    orderId = rs.getInt(1);
                    LOGGER.info("Created new order with ID: " + orderId);
                } else {
                    throw new SQLException("Failed to retrieve generated order ID");
                }
                
                // Insert order items with better validation
                String itemSql = "INSERT INTO order_items (order_id, menu_item_id, item_name, price, quantity, flavor) " +
                               "VALUES (?, ?, ?, ?, ?, ?)";
                
                int totalItemsProcessed = 0;
                try (PreparedStatement itemStmt = conn.prepareStatement(itemSql)) {
                    for (int i = 0; i < items.length(); i++) {
                        JSONObject item = items.getJSONObject(i);
                        
                        // Basic validation
                        if (!item.has("id") || !item.has("name") || !item.has("price")) {
                            LOGGER.warning("Skipping invalid item in order: " + item.toString());
                            continue;
                        }
                        
                        itemStmt.setInt(1, orderId);
                        itemStmt.setInt(2, item.getInt("id"));
                        itemStmt.setString(3, item.getString("name"));
                        itemStmt.setDouble(4, item.getDouble("price"));
                        itemStmt.setInt(5, item.optInt("quantity", 1));
                        
                        // Handle flavor variants properly
                        String flavor = null;
                        if (!item.isNull("flavor")) {
                            flavor = item.getString("flavor");
                        } else if (!item.isNull("parentName")) {
                            flavor = item.getString("parentName");
                        }
                        itemStmt.setString(6, flavor);
                        
                        itemStmt.addBatch();
                        totalItemsProcessed++;
                    }
                    
                    if (totalItemsProcessed == 0) {
                        throw new SQLException("No valid items to add to order");
                    }
                    
                    int[] batchResults = itemStmt.executeBatch();
                    LOGGER.info("Inserted " + batchResults.length + " items into order " + orderId);
                }
                
                // Process payment
                boolean paymentSuccess = processPayment(paymentMethod, total);
                
                if (paymentSuccess) {
                    // Update order status to paid for immediate orders or pending for delivery
                    String status = isDelivery ? "PROCESSING" : "PAID";
                    String updateSql = "UPDATE orders SET status = ? WHERE id = ?";
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setString(1, status);
                        updateStmt.setInt(2, orderId);
                        updateStmt.executeUpdate();
                    }
                    
                    // Commit transaction
                    conn.commit();
                    
                    // Return success response with more details
                    JSONObject successResponse = new JSONObject();
                    successResponse.put("success", true);
                    successResponse.put("orderNumber", orderId);
                    successResponse.put("status", status);
                    successResponse.put("isDelivery", isDelivery);
                    successResponse.put("message", isDelivery ? 
                        "Your order has been placed and will be delivered soon!" : 
                        "Order placed successfully! Please collect at the counter.");
                    
                    // Log success and send response
                    LOGGER.info("Order successfully placed: " + successResponse.toString());
                    out.print(successResponse.toString());
                } else {
                    conn.rollback();
                    LOGGER.warning("Payment failed for order attempt");
                    response.setStatus(HttpServletResponse.SC_PAYMENT_REQUIRED);
                    out.print("{\"error\": \"Payment failed. Please try a different payment method.\"}");
                }
            } catch (SQLException e) {
                if (conn != null) {
                    try {
                        conn.rollback();
                    } catch (SQLException ex) {
                        LOGGER.log(Level.SEVERE, "Error rolling back transaction", ex);
                    }
                }
                
                LOGGER.log(Level.SEVERE, "Database error during order creation", e);
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"Unable to process your order due to a database error. Please try again.\"}");
            } finally {
                // Use DatabaseUtil to properly close resources
                if (rs != null) DatabaseUtil.closeStatement(rs.getStatement());
                if (pstmt != null) DatabaseUtil.closeStatement(pstmt);
                if (conn != null) {
                    try {
                        if (!conn.getAutoCommit()) {
                            conn.setAutoCommit(true);  // Reset auto-commit
                        }
                        DatabaseUtil.closeConnection(conn);
                    } catch (SQLException e) {
                        LOGGER.log(Level.SEVERE, "Error resetting connection state", e);
                    }
                }
            }
        } catch (JSONException e) {
            LOGGER.log(Level.SEVERE, "JSON parsing error in order data", e);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Your order contains invalid data. Please try again.\"}");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error processing order", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"An unexpected error occurred. Please try again later.\"}");
        }
    }
    
    /**
     * Process payment for an order
     * 
     * @param paymentMethod The payment method (cash, card)
     * @param amount The amount to charge
     * @return true if payment successful, false otherwise
     */
    private boolean processPayment(String paymentMethod, double amount) {
        // In a real application, this would integrate with a payment gateway
        // For this demo, we'll simulate a successful payment
        return true;
    }
    
    /**
     * Get orders for the logged-in user
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Check if user is logged in
        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"User not logged in\"}");
            return;
        }
        
        // Get query parameters
        String orderId = request.getParameter("orderId");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            
            // If specific order ID is requested
            if (orderId != null && !orderId.isEmpty()) {
                String orderSql = "SELECT * FROM orders WHERE id = ? AND user_id = ?";
                pstmt = conn.prepareStatement(orderSql);
                pstmt.setInt(1, Integer.parseInt(orderId));
                pstmt.setInt(2, userId);
                
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    JSONObject orderObj = new JSONObject();
                    orderObj.put("id", rs.getInt("id"));
                    orderObj.put("orderDate", rs.getTimestamp("order_date").toString());
                    orderObj.put("subtotal", rs.getDouble("subtotal"));
                    orderObj.put("serviceFee", rs.getDouble("service_fee"));
                    orderObj.put("deliveryFee", rs.getDouble("delivery_fee"));
                    orderObj.put("total", rs.getDouble("total"));
                    orderObj.put("isDelivery", rs.getBoolean("is_delivery"));
                    orderObj.put("deliveryAddress", rs.getString("delivery_address"));
                    orderObj.put("paymentMethod", rs.getString("payment_method"));
                    orderObj.put("status", rs.getString("status"));
                    
                    // Get order items
                    List<JSONObject> items = getOrderItems(conn, Integer.parseInt(orderId));
                    orderObj.put("items", items);
                    
                    out.print(orderObj.toString());
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\": \"Order not found\"}");
                }
            } else {
                // Get all orders for user
                String ordersSql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
                pstmt = conn.prepareStatement(ordersSql);
                pstmt.setInt(1, userId);
                
                rs = pstmt.executeQuery();
                
                JSONArray ordersArray = new JSONArray();
                
                while (rs.next()) {
                    JSONObject orderObj = new JSONObject();
                    int id = rs.getInt("id");
                    
                    orderObj.put("id", id);
                    orderObj.put("orderDate", rs.getTimestamp("order_date").toString());
                    orderObj.put("total", rs.getDouble("total"));
                    orderObj.put("status", rs.getString("status"));
                    
                    ordersArray.put(orderObj);
                }
                
                JSONObject result = new JSONObject();
                result.put("orders", ordersArray);
                
                out.print(result.toString());
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        } catch (JSONException e) {
            LOGGER.log(Level.SEVERE, "JSON error", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"JSON error: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Unexpected error: " + e.getMessage() + "\"}");
        } finally {
            // Close database resources
            if (rs != null) {
                try {
                    rs.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing ResultSet", e);
                }
            }
            
            if (pstmt != null) {
                try {
                    pstmt.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing PreparedStatement", e);
                }
            }
            
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error closing Connection", e);
                }
            }
        }
    }
    
    /**
     * Get items for a specific order
     * 
     * @param conn Database connection
     * @param orderId Order ID
     * @return List of order items as JSONObjects
     */
    private List<JSONObject> getOrderItems(Connection conn, int orderId) throws SQLException, JSONException {
        List<JSONObject> items = new ArrayList<>();
        
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, orderId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    JSONObject item = new JSONObject();
                    item.put("id", rs.getInt("id"));
                    item.put("menuItemId", rs.getInt("menu_item_id"));
                    item.put("name", rs.getString("item_name"));
                    item.put("price", rs.getDouble("price"));
                    item.put("quantity", rs.getInt("quantity"));
                    item.put("flavor", rs.getString("flavor"));
                    
                    items.add(item);
                }
            }
        }
        
        return items;
    }
}
