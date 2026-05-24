package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.dao.UserDao;
import com.mycompany.restaurantmanagement.dao.OrderDao;
import com.mycompany.restaurantmanagement.dao.MenuItemDao;
import com.mycompany.restaurantmanagement.model.User;
import com.mycompany.restaurantmanagement.model.Order;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.List;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {
    
    @Inject
    private UserDao userDao;
    
    @Inject
    private OrderDao orderDao;
    
    @Inject
    private MenuItemDao menuItemDao;
    
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
        
        try {
            // Get real user counts from database
            int totalStudents = userDao.findByRole("student").size();
            int totalStaff = userDao.findByRole("staff").size();
            List<User> allUsers = userDao.findAll();
            List<User> pendingUsers = userDao.findByStatus("false");
            
            // Count active users (status = 'true')
            int activeStudents = totalStudents;
            int activeStaff = totalStaff;
            int totalActiveUsers = activeStudents + activeStaff;
            
            for (User user : allUsers) {
                if ("true".equals(user.getStatus()) && !"admin".equals(user.getUserRole())) {
                    totalActiveUsers++;
                    if ("student".equals(user.getUserRole())) {
                        activeStudents++;
                    } else if ("staff".equals(user.getUserRole())) {
                        activeStaff++;
                    }
                }
            }
            
            // Get real order data
            List<Order> allOrders = orderDao.findAll();
            int dailyOrders = 0;
            int monthlyOrders = 0;
            BigDecimal dailyRevenue = BigDecimal.ZERO;
            BigDecimal monthlyRevenue = BigDecimal.ZERO;
            
            // Get current date components for comparison
            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.YearMonth currentMonth = java.time.YearMonth.now();
            
            for (Order order : allOrders) {
                if (order.getCreatedAt() != null) {
                    // Convert Timestamp to LocalDate for comparison
                    java.time.LocalDate orderDate = order.getCreatedAt().toLocalDateTime().toLocalDate();
                    
                    // Count daily orders and revenue
                    if (orderDate.equals(today)) {
                        dailyOrders++;
                        if (order.getTotalAmount() != null && 
                            ("delivered".equalsIgnoreCase(order.getStatusString()) || 
                             "ready".equalsIgnoreCase(order.getStatusString()))) {
                            dailyRevenue = dailyRevenue.add(order.getTotalAmount());
                        }
                    }
                    
                    // Count monthly orders and revenue
                    if (orderDate.getYear() == currentMonth.getYear() && 
                        orderDate.getMonth() == currentMonth.getMonth()) {
                        monthlyOrders++;
                        if (order.getTotalAmount() != null && 
                            ("delivered".equalsIgnoreCase(order.getStatusString()) || 
                             "ready".equalsIgnoreCase(order.getStatusString()))) {
                            monthlyRevenue = monthlyRevenue.add(order.getTotalAmount());
                        }
                    }
                }
            }
            
            // Get menu item count
            int menuItemCount = 0;
            try {
                if (menuItemDao != null) {
                    menuItemCount = menuItemDao.getMenuItemCount();
                }
            } catch (Exception e) {
                // Fallback if MenuItemDao is not properly initialized
                // Log the error and continue with default value
                System.out.println("Error getting menu item count: " + e.getMessage());
            }
            
            // Format revenue
            DecimalFormat df = new DecimalFormat("#,##0.00");
            String formattedDailyRevenue = df.format(dailyRevenue);
            String formattedMonthlyRevenue = df.format(monthlyRevenue);
            
            // Get pending users for the bottom section
            List<User> displayPendingUsers = pendingUsers;
            if (displayPendingUsers.size() > 5) {
                displayPendingUsers = displayPendingUsers.subList(0, 5);
            }
            
            // Set all attributes with real data
            request.setAttribute("totalUsers", totalActiveUsers);
            request.setAttribute("studentCount", activeStudents);
            request.setAttribute("staffCount", activeStaff);
            request.setAttribute("pendingCount", pendingUsers.size());
            request.setAttribute("dailyOrders", dailyOrders);
            request.setAttribute("totalOrders", monthlyOrders);
            request.setAttribute("dailyRevenue", formattedDailyRevenue);
            request.setAttribute("monthlyRevenue", formattedMonthlyRevenue);
            request.setAttribute("menuItemCount", menuItemCount);
            request.setAttribute("pendingUsers", displayPendingUsers);
            
            System.out.println("DEBUG: Set real data - Total Users: " + totalActiveUsers + 
                              ", Daily Orders: " + dailyOrders + 
                              ", Daily Revenue: " + formattedDailyRevenue);
            
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ERROR getting real data: " + e.getMessage());
            
            // Set default values in case of error
            request.setAttribute("totalUsers", 0);
            request.setAttribute("studentCount", 0);
            request.setAttribute("staffCount", 0);
            request.setAttribute("pendingCount", 0);
            request.setAttribute("dailyOrders", 0);
            request.setAttribute("totalOrders", 0);
            request.setAttribute("dailyRevenue", "0.00");
            request.setAttribute("monthlyRevenue", "0.00");
            request.setAttribute("menuItemCount", 0);
            request.setAttribute("pendingUsers", java.util.Collections.emptyList());
            
            // Optional: Set error message for display
            request.setAttribute("errorMessage", "Unable to load real-time data. Showing default values.");
        }
        
        // Forward to JSP
        request.getRequestDispatcher("/WEB-INF/views/adminDashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}