package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.dao.UserDao;
import com.mycompany.restaurantmanagement.model.User;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Pattern;

public class ResetPasswordServlet extends HttpServlet {
    
    @Inject
    private UserDao userDao;
    
    // Password validation patterns
    private static final Pattern LENGTH_PATTERN = Pattern.compile(".{8,}");
    private static final Pattern UPPERCASE_PATTERN = Pattern.compile(".*[A-Z].*");
    private static final Pattern LOWERCASE_PATTERN = Pattern.compile(".*[a-z].*");
    private static final Pattern NUMBER_PATTERN = Pattern.compile(".*[0-9].*");
    private static final Pattern SYMBOL_PATTERN = Pattern.compile(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*");
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get token and email from request parameters
        String token = request.getParameter("token");
        String email = request.getParameter("email");
        
        // Validate token and email
        if (token == null || token.isEmpty() || email == null || email.isEmpty()) {
            request.setAttribute("error", "Invalid password reset link");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // In a real application, you would verify the token against what's stored in the database
        // For this example, we'll assume the token is valid and proceed
        
        // Forward to reset password JSP page
        request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get parameters from request
        String email = request.getParameter("email");
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validation
        if (email == null || email.isEmpty() || token == null || token.isEmpty() ||
            newPassword == null || newPassword.isEmpty() || confirmPassword == null || confirmPassword.isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        }
        
        // Validate password complexity
        if (!isPasswordValid(newPassword)) {
            request.setAttribute("error", "Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character");
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
            return;
        }
        
        try {
            // Find user by email
            User user = userDao.findByEmail(email);
            
            // Check if user exists
            if (user == null) {
                request.setAttribute("error", "Invalid email address");
                request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
                return;
            }
            
            // In a real application, you would verify the token against what's stored in the database
            // For this example, we'll assume the token is valid and proceed
            
            // Update password
            user.setPassword(newPassword);
            userDao.updatePassword(user.getId(), newPassword);
            
            // Return success message
            request.setAttribute("success", "Your password has been reset successfully. You can now login with your new password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error resetting password: " + e.getMessage());
            request.getRequestDispatcher("/resetPassword.jsp").forward(request, response);
        }
    }
    
    private boolean isPasswordValid(String password) {
        return LENGTH_PATTERN.matcher(password).matches() &&
               UPPERCASE_PATTERN.matcher(password).matches() &&
               LOWERCASE_PATTERN.matcher(password).matches() &&
               NUMBER_PATTERN.matcher(password).matches() &&
               SYMBOL_PATTERN.matcher(password).matches();
    }
}