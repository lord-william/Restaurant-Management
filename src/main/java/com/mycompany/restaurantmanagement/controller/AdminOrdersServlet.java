package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.dao.OrderDao;
import com.mycompany.restaurantmanagement.model.Order;
import com.mycompany.restaurantmanagement.model.User;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminOrdersServlet", urlPatterns = {"/admin/orders"})
public class AdminOrdersServlet extends HttpServlet {
    
    @Inject
    private OrderDao orderDao;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and has admin role
        if (currentUser == null || !"admin".equals(currentUser.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }
        
        // Handle status update action from GET request
        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("id");
        String newStatus = request.getParameter("status");
        
        if ("updateStatus".equals(action) && orderIdStr != null && newStatus != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                orderDao.updateStatus(orderId, newStatus);
                session.setAttribute("success", "Order status updated successfully");
                
                // Redirect to preserve the filter
                String filter = request.getParameter("filter");
                String redirectUrl = request.getContextPath() + "/admin/orders";
                if (filter != null && !filter.equals("all")) {
                    redirectUrl += "?filter=" + filter;
                }
                response.sendRedirect(redirectUrl);
                return;
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid order ID");
            }
        }
        
        // Get orders based on filter
        String filter = request.getParameter("filter");
        List<Order> orders;
        
        if (filter != null && !filter.isEmpty() && !filter.equals("all")) {
            orders = orderDao.findByStatus(filter);
            request.setAttribute("currentFilter", filter);
        } else {
            orders = orderDao.findAll();
            request.setAttribute("currentFilter", "all");
        }
        
        // Get count of orders by status for the filter buttons
        int pendingCount = orderDao.countByStatus("pending");
        int preparingCount = orderDao.countByStatus("preparing");
        int readyCount = orderDao.countByStatus("ready");
        int deliveredCount = orderDao.countByStatus("delivered");
        
        // Set attributes
        request.setAttribute("orders", orders);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("preparingCount", preparingCount);
        request.setAttribute("readyCount", readyCount);
        request.setAttribute("deliveredCount", deliveredCount);
        
        // Forward to the orders management page
        request.getRequestDispatcher("/WEB-INF/views/admin-orders.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and has admin role
        if (currentUser == null || !"admin".equals(currentUser.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }
        
        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("id");
        
        if (orderIdStr != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                
                if ("updateStatus".equals(action)) {
                    String newStatus = request.getParameter("status");
                    if (newStatus != null) {
                        orderDao.updateStatus(orderId, newStatus);
                        session.setAttribute("success", "Order status updated successfully");
                    }
                } else if ("delete".equals(action)) {
                    orderDao.delete(orderId);
                    session.setAttribute("success", "Order deleted successfully");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid order ID");
            }
        }
        
        // Redirect back to orders page with the same filter
        String currentFilter = request.getParameter("currentFilter");
        String redirectUrl = request.getContextPath() + "/admin/orders";
        if (currentFilter != null && !currentFilter.equals("all")) {
            redirectUrl += "?filter=" + currentFilter;
        }
        response.sendRedirect(redirectUrl);
    }
}