package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.dao.OrderDao;
import com.mycompany.restaurantmanagement.model.User;
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
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AdminRevenueServlet", urlPatterns = {"/admin/revenue"})
public class AdminRevenueServlet extends HttpServlet {
    
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
        
        try {
            // Get revenue data
            BigDecimal dailyRevenue = orderDao.getDailyRevenue();
            BigDecimal weeklyRevenue = getWeeklyRevenue();
            BigDecimal monthlyRevenue = orderDao.getMonthlyRevenue();
            
            // Format the revenue with currency
            DecimalFormat df = new DecimalFormat("#,##0.00");
            String formattedDailyRevenue = df.format(dailyRevenue);
            String formattedWeeklyRevenue = df.format(weeklyRevenue);
            String formattedMonthlyRevenue = df.format(monthlyRevenue);
            
            // Generate sample data for charts (in a real app, this would come from the database)
            List<String> dailyLabels = new ArrayList<>();
            List<String> dailyData = new ArrayList<>();
            
            // Sample daily data for the last 7 days
            dailyLabels.add("May 07"); dailyData.add("150.00");
            dailyLabels.add("May 08"); dailyData.add("275.50");
            dailyLabels.add("May 09"); dailyData.add("180.25");
            dailyLabels.add("May 10"); dailyData.add("320.75");
            dailyLabels.add("May 11"); dailyData.add("295.40");
            dailyLabels.add("May 12"); dailyData.add("450.60");
            dailyLabels.add("May 13"); dailyData.add(dailyRevenue.toString());
            
            // Sample category data
            List<String> categoryLabels = new ArrayList<>();
            List<String> categoryData = new ArrayList<>();
            categoryLabels.add("Main Course"); categoryData.add("45");
            categoryLabels.add("Beverages"); categoryData.add("25");
            categoryLabels.add("Sides"); categoryData.add("20");
            categoryLabels.add("Desserts"); categoryData.add("10");
            
            // Convert to JSON strings for JavaScript
            String dailyLabelsJson = convertToJsonArray(dailyLabels);
            String dailyDataJson = convertToJsonArray(dailyData);
            String categoryLabelsJson = convertToJsonArray(categoryLabels);
            String categoryDataJson = convertToJsonArray(categoryData);
            
            // Sample revenue details
            List<Map<String, Object>> revenueDetails = new ArrayList<>();
            Map<String, Object> todayDetails = new HashMap<>();
            todayDetails.put("date", new java.util.Date());
            todayDetails.put("orderCount", orderDao.countDailyOrders());
            todayDetails.put("revenue", formattedDailyRevenue);
            todayDetails.put("averageOrderValue", calculateAverageOrderValue(dailyRevenue, orderDao.countDailyOrders()));
            revenueDetails.add(todayDetails);
            
            // Set attributes
            request.setAttribute("dailyRevenue", formattedDailyRevenue);
            request.setAttribute("weeklyRevenue", formattedWeeklyRevenue);
            request.setAttribute("monthlyRevenue", formattedMonthlyRevenue);
            request.setAttribute("dailyLabelsJson", dailyLabelsJson);
            request.setAttribute("dailyDataJson", dailyDataJson);
            request.setAttribute("categoryLabelsJson", categoryLabelsJson);
            request.setAttribute("categoryDataJson", categoryDataJson);
            request.setAttribute("revenueDetails", revenueDetails);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Error loading revenue data: " + e.getMessage());
        }
        
        // Forward to the revenue dashboard
        request.getRequestDispatcher("/WEB-INF/views/admin-revenue.jsp").forward(request, response);
    }
    
    private BigDecimal getWeeklyRevenue() {
        // This is a simplified version - you should implement proper weekly calculation
        // For now, we'll estimate it as 7 times the daily revenue
        return orderDao.getDailyRevenue().multiply(new BigDecimal("7"));
    }
    
    private String calculateAverageOrderValue(BigDecimal totalRevenue, int orderCount) {
        if (orderCount == 0) return "0.00";
        
        BigDecimal average = totalRevenue.divide(new BigDecimal(orderCount), 2, BigDecimal.ROUND_HALF_UP);
        DecimalFormat df = new DecimalFormat("#,##0.00");
        return df.format(average);
    }
    
    private String convertToJsonArray(List<String> list) {
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            if (i > 0) json.append(",");
            json.append("\"").append(list.get(i)).append("\"");
        }
        json.append("]");
        return json.toString();
    }
}