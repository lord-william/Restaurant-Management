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

@WebServlet(name = "StaffOrdersServlet", urlPatterns = {"/staff/orders"})
public class StaffOrdersServlet extends HttpServlet {
    
    @Inject
    private OrderDao orderDao;
    
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
        
        // Get all orders
        List<Order> orders = orderDao.findAll();
        request.setAttribute("orders", orders);
        
        // Forward to the staff orders page
        request.getRequestDispatcher("/WEB-INF/views/staff-orders.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Check if user is logged in and has staff role
        if (currentUser == null || !"staff".equals(currentUser.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }
        
        String action = request.getParameter("action");
        int orderId = Integer.parseInt(request.getParameter("id"));
        
        // Process order actions (change status, etc.)
        if ("updateStatus".equals(action)) {
            String newStatus = request.getParameter("status");
            orderDao.updateStatus(orderId, newStatus);
            session.setAttribute("message", "Order status updated successfully");
        }
        
        response.sendRedirect(request.getContextPath() + "/staff/orders");
    }
}
