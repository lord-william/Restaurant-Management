package com.mycompany.restaurantmanagement.controller;

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
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/dashboard"})
public class DashboardServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(DashboardServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get user info from session (needed for JSP)
        User user = (User) session.getAttribute("user");
        request.setAttribute("user", user);
        String userRole = (String) session.getAttribute("userRole");
        
        try {
            // Fetch dashboard statistics from database
            fetchDashboardStatistics(request);
            
            // Redirect to appropriate dashboard based on role
            if ("admin".equals(userRole)) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            } else if ("staff".equals(userRole)) {
                response.sendRedirect(request.getContextPath() + "/staff/dashboard");
                return;
            } else {
                // Default to user/student dashboard
                // We don't have a separate UserDashboardServlet yet, so we'll forward directly
                fetchDashboardStatistics(request);
                request.getRequestDispatcher("/WEB-INF/views/userDashboard.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching dashboard statistics: {0}", e.getMessage());
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
     * Fetches statistics from the database for the dashboard
     * @param request HttpServletRequest to set attributes for JSP
     * @throws SQLException if a database error occurs
     */
    private void fetchDashboardStatistics(HttpServletRequest request) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseUtil.getConnection();
            
            // 1. User statistics - count by role
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT user_role, COUNT(*) as count, " +
                    "SUM(CASE WHEN status = 'true' THEN 1 ELSE 0 END) as active_count, " +
                    "SUM(CASE WHEN status = 'false' THEN 1 ELSE 0 END) as pending_count " +
                    "FROM users GROUP BY user_role")) {
                
                try (ResultSet rs = stmt.executeQuery()) {
                    int totalUsers = 0;
                    int studentCount = 0;
                    int staffCount = 0;
                    int adminCount = 0;
                    int pendingCount = 0;
                    
                    while (rs.next()) {
                        String role = rs.getString("user_role");
                        int count = rs.getInt("count");
                        int activeCount = rs.getInt("active_count");
                        int rolePendingCount = rs.getInt("pending_count");
                        
                        totalUsers += count;
                        pendingCount += rolePendingCount;
                        
                        if ("student".equalsIgnoreCase(role)) {
                            studentCount = count;
                        } else if ("staff".equalsIgnoreCase(role)) {
                            staffCount = count;
                        } else if ("admin".equalsIgnoreCase(role)) {
                            adminCount = count;
                        }
                    }
                    
                    // Set attributes for JSP
                    request.setAttribute("totalUsers", totalUsers);
                    request.setAttribute("studentCount", studentCount);
                    request.setAttribute("staffCount", staffCount);
                    request.setAttribute("adminCount", adminCount);
                    request.setAttribute("pendingCount", pendingCount);
                }
            }
            
            // 2. Order statistics for today
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(*) as orders_today, COALESCE(SUM(total_amount), 0) as revenue_today " +
                    "FROM orders WHERE created_at::date = CURRENT_DATE")) {
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int dailyOrders = rs.getInt("orders_today");
                        double dailyRevenue = rs.getDouble("revenue_today");
                        
                        request.setAttribute("dailyOrders", dailyOrders);
                        request.setAttribute("dailyRevenue", String.format("%.2f", dailyRevenue));
                    } else {
                        request.setAttribute("dailyOrders", 0);
                        request.setAttribute("dailyRevenue", "0.00");
                    }
                }
            }
            
            // 3. Order statistics for this month
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(*) as orders_this_month, COALESCE(SUM(total_amount), 0) as revenue_this_month " +
                    "FROM orders WHERE EXTRACT(YEAR FROM created_at) = EXTRACT(YEAR FROM CURRENT_DATE) AND EXTRACT(MONTH FROM created_at) = EXTRACT(MONTH FROM CURRENT_DATE)")) {
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int monthlyOrders = rs.getInt("orders_this_month");
                        double monthlyRevenue = rs.getDouble("revenue_this_month");
                        
                        request.setAttribute("totalOrders", monthlyOrders);
                        request.setAttribute("monthlyRevenue", String.format("%.2f", monthlyRevenue));
                    } else {
                        request.setAttribute("totalOrders", 0);
                        request.setAttribute("monthlyRevenue", "0.00");
                    }
                }
            }
            
            // 4. Total menu items
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(*) as total_menu_items FROM menu_items WHERE available = TRUE")) {
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int menuItems = rs.getInt("total_menu_items");
                        request.setAttribute("menuItems", menuItems);
                    } else {
                        request.setAttribute("menuItems", 0);
                    }
                }
            }
            
            // 5. Pending approvals (users with status=false)
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(*) as pending_approvals FROM users WHERE status = 'false'")) {
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        int pendingApprovals = rs.getInt("pending_approvals");
                        request.setAttribute("pendingApprovals", pendingApprovals);
                    } else {
                        request.setAttribute("pendingApprovals", 0);
                    }
                }
            }
            
        } finally {
            DatabaseUtil.closeConnection(conn);
        }
    }
}
