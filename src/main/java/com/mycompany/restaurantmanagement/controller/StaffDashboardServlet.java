package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.dao.DashboardDAO;
import com.mycompany.restaurantmanagement.dao.MenuItemDao;
import com.mycompany.restaurantmanagement.dao.OrderDao;
import java.sql.SQLException;
import com.mycompany.restaurantmanagement.model.Order;
import com.mycompany.restaurantmanagement.model.User;
import com.mycompany.restaurantmanagement.util.DatabaseUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "StaffDashboardServlet", urlPatterns = {"/staff/dashboard"})
public class StaffDashboardServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(StaffDashboardServlet.class.getName());
    
    // Create instances directly to avoid injection issues
    private OrderDao orderDao;
    private MenuItemDao menuItemDao;
    private DashboardDAO dashboardDAO;
    
    @Override
    public void init() {
        // Initialize DAOs in init to avoid injection issues
        orderDao = new OrderDao();
        menuItemDao = new MenuItemDao();
        dashboardDAO = new DashboardDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and has staff role
        if (currentUser == null || !"staff".equals(currentUser.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }
        
        try {
            // Get dashboard statistics using the DashboardDAO
            Map<String, Object> staffStats;
            try {
                staffStats = dashboardDAO.getStaffDashboardStats();
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error getting staff stats, using fallback: {0}", e.getMessage());
                // Create fallback stats if DashboardDAO fails
                staffStats = getStaffStatsFallback();
            }
            
            // Order statistics - safely get integers from the map
            int pendingOrderCount = getIntValueSafely(staffStats, "pendingOrderCount");
            int processingOrderCount = getIntValueSafely(staffStats, "processingOrderCount");
            int completedOrderCount = getIntValueSafely(staffStats, "completedOrderCount");
            
            // Get order list for display - handle potential exceptions
            List<Order> pendingOrders = new ArrayList<>();
            List<Order> processingOrders = new ArrayList<>();
            List<Order> completedOrders = new ArrayList<>();
            
            try {
                pendingOrders = orderDao.findByStatus("pending");
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error fetching pending orders: {0}", e.getMessage());
            }
            
            try {
                processingOrders = orderDao.findByStatus("processing");
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error fetching processing orders: {0}", e.getMessage());
            }
            
            try {
                completedOrders = orderDao.findByStatus("completed");
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error fetching completed orders: {0}", e.getMessage());
            }
            
            // Get user count from our DashboardStats
            int studentCount = 0;
            try {
                studentCount = dashboardDAO.getUserCountsByRole(null).getOrDefault("student", 0);
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error retrieving student counts: {0}", e.getMessage());
                // Fallback to direct JDBC query
                studentCount = getStudentCountFallback();
                request.setAttribute("errorMessage", "Used fallback method for student counts");
            }
            
            // Count available menu items - handle potential exceptions
            int availableMenuItems = 0;
            int totalMenuItems = 0;
            
            try {
                if (menuItemDao != null) {
                    // Get total menu items count directly
                    totalMenuItems = menuItemDao.getMenuItemCount();
                    
                    // For available menu items, we'll use a fallback approach
                    // since findAvailable() method doesn't exist
                    // You can either:
                    // 1. Use findAll() and filter for available items
                    // 2. Create a findAvailable() method in MenuItemDao
                    // 3. Use direct SQL query (implemented below)
                    
                    availableMenuItems = getAvailableMenuItemsFallback();
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error fetching menu items: {0}", e.getMessage());
                // Set default values in case of error
                availableMenuItems = 0;
                totalMenuItems = 0;
            }
            
            // Calculate low inventory items (simulated for now)
            int lowInventoryCount = 4; // This would be calculated from an inventory management system
            
            // Set order statistics attributes
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("preparingOrders", processingOrders);
            request.setAttribute("completedOrders", completedOrders);
            request.setAttribute("pendingOrderCount", pendingOrderCount);
            request.setAttribute("processingOrderCount", processingOrderCount);
            request.setAttribute("completedOrderCount", completedOrderCount);
            request.setAttribute("lowInventoryCount", lowInventoryCount);
            request.setAttribute("studentCount", studentCount);
            request.setAttribute("availableMenuItems", availableMenuItems);
            request.setAttribute("totalMenuItems", totalMenuItems);
            
            // Get today's order count directly from database if not in staffStats
            int todayOrderCount = getIntValueSafely(staffStats, "todayOrderCount");
            if (todayOrderCount == 0) {
                todayOrderCount = getTodaysOrderCount();
            }
            
            // Get recent orders - limited to 5
            List<Order> recentOrders = new ArrayList<>();
            try {
                recentOrders = orderDao.findAll();
                if (recentOrders != null && recentOrders.size() > 5) {
                    recentOrders = recentOrders.subList(0, 5); // Get most recent 5 orders
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error fetching recent orders: {0}", e.getMessage());
            }
            
            request.setAttribute("todayOrderCount", todayOrderCount);
            request.setAttribute("recentOrders", recentOrders);
            
            // Forward to the dashboard JSP
            request.getRequestDispatcher("/WEB-INF/views/staffDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error loading staff dashboard: {0}", e.getMessage());
            request.setAttribute("error", "An error occurred while loading the dashboard: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Safely extract an integer value from a map, handling potential ClassCastException
     * 
     * @param map The map containing the value
     * @param key The key to look up
     * @return The integer value or 0 if not found or not an integer
     */
    private int getIntValueSafely(Map<String, Object> map, String key) {
        if (map == null || !map.containsKey(key)) {
            return 0;
        }
        
        Object value = map.get(key);
        
        if (value instanceof Integer) {
            return (Integer) value;
        } else if (value instanceof Long) {
            return ((Long) value).intValue();
        } else if (value instanceof String) {
            try {
                return Integer.parseInt((String) value);
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Failed to parse string value as integer: {0}", value);
                return 0;
            }
        } else if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        
        LOGGER.log(Level.WARNING, "Unknown type for key {0}: {1}", new Object[]{key, value != null ? value.getClass().getName() : "null"});
        return 0;
    }
    
    /**
     * Get today's order count directly from the database using JDBC
     * @return Number of orders placed today
     */
    private int getTodaysOrderCount() {
        int count = 0;
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM orders WHERE created_at::date = CURRENT_DATE")) {
                
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error getting today's order count: {0}", e.getMessage());
        }
        
        return count;
    }
    
    /**
     * Creates fallback dashboard statistics when DashboardDAO fails
     * @return Map containing basic statistics retrieved directly using JDBC
     */
    private Map<String, Object> getStaffStatsFallback() {
        Map<String, Object> stats = new HashMap<>();
        
        // Set default values
        stats.put("pendingOrderCount", countOrdersByStatus("pending"));
        stats.put("processingOrderCount", countOrdersByStatus("processing"));
        stats.put("completedOrderCount", countOrdersByStatus("completed"));
        stats.put("todayOrderCount", getTodaysOrderCount());
        stats.put("dailyRevenue", getDailyRevenueFallback());
        
        return stats;
    }
    
    /**
     * Count orders with a specific status using direct JDBC
     * @param status The order status to count
     * @return Number of orders with the specified status
     */
    private int countOrdersByStatus(String status) {
        int count = 0;
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM orders WHERE status = ?")) {
                
            stmt.setString(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error counting orders by status {0}: {1}", 
                    new Object[]{status, e.getMessage()});
        }
        return count;
    }
    
    /**
     * Get daily revenue using direct JDBC
     * @return Total revenue for today
     */
    private double getDailyRevenueFallback() {
        double revenue = 0.0;
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                "SELECT COALESCE(SUM(total_amount), 0) FROM orders " +
                "WHERE created_at::date = CURRENT_DATE " +
                "AND status != 'cancelled'")) {
                
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    revenue = rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error getting daily revenue: {0}", e.getMessage());
        }
        return revenue;
    }
    
    /**
     * Get student count using direct JDBC query
     * @return Number of active student accounts
     */
    private int getStudentCountFallback() {
        int count = 0;
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM users WHERE user_role = 'student' AND status = 'true'")) {
                
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error getting student count: {0}", e.getMessage());
        }
        return count;
    }
    
    /**
     * Get available menu items count using direct JDBC query
     * @return Number of available menu items
     */
    private int getAvailableMenuItemsFallback() {
        int count = 0;
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM menu_items WHERE available = true OR status = 'available'")) {
                
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error getting available menu items count: {0}", e.getMessage());
        }
        return count;
    }
}