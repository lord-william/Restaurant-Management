package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.dao.UserDao;
import com.mycompany.restaurantmanagement.model.User;
import com.mycompany.restaurantmanagement.util.EmailService;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.UUID;

public class ForgotPasswordServlet extends HttpServlet {
    
    @Inject
    private UserDao userDao;
    
    @Inject
    private EmailService emailService;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to forgot password JSP page
        request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get parameters from request
        String email = request.getParameter("email");
        
        // Validation
        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Email is required");
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            return;
        }
        
        try {
            // Find user by email
            User user = userDao.findByEmail(email);
            
            // Check if user exists
            if (user == null) {
                // Don't reveal if the email exists or not for security reasons
                request.setAttribute("success", "If your email is registered, you will receive a password reset link shortly.");
                request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
                return;
            }
            
            // Generate reset token
            String resetToken = UUID.randomUUID().toString();
            
            // Save reset token (in a real application, you would store this in the database with an expiration time)
            // For now, we'll just assume it's saved and move on
            
            // Create reset link
            String resetLink = request.getScheme() + "://" + request.getServerName() + ":" + 
                              request.getServerPort() + request.getContextPath() + 
                              "/resetPassword?token=" + resetToken + "&email=" + email;
            
            // Send email
            String subject = "Restaurant Management System - Password Reset";
            String body = "Hello " + user.getName() + ",\n\n"
                        + "You have requested to reset your password. Please click the link below to reset your password:\n\n"
                        + resetLink + "\n\n"
                        + "If you did not request this, please ignore this email.\n\n"
                        + "Regards,\nRestaurant Management System";
            
            emailService.sendEmail(email, subject, body);
            
            // Return success message
            request.setAttribute("success", "If your email is registered, you will receive a password reset link shortly.");
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error processing your request: " + e.getMessage());
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
        }
    }
}