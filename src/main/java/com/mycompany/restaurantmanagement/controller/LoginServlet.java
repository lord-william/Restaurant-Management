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

@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    
    // Use the DatabaseUtil class for connections
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        
        // Forward to login JSP page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get parameters from request
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validation
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        LOGGER.log(Level.INFO, "Login attempt: {0}", email);
        
        try {
            // Attempt login with direct JDBC
            User user = null;
            boolean loginSuccess = false;
            String userName = null;
            String userRole = null;
            String userStatus = null;
            int userId = 0;
            String staffId = null;
            String studentNumber = null;
            
            // Integrate with Supabase Auth
            String sessionToken = com.mycompany.restaurantmanagement.util.SupabaseAuthService.logIn(email, password);
            
            if (sessionToken != null) {
                // Auth succeeded via Supabase! Now fetch the role/status from public.users
                try (Connection conn = DatabaseUtil.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(
                            "SELECT id, name, email, password, status, user_role, staff_id, student_number FROM users WHERE email = ?")) {
                    stmt.setString(1, email);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            loginSuccess = true;
                            userName = rs.getString("name");
                            userRole = rs.getString("user_role");
                            userStatus = rs.getString("status");
                            userId = rs.getInt("id");
                            staffId = rs.getString("staff_id");
                            studentNumber = rs.getString("student_number");
                            
                            user = new User();
                            user.setId(userId);
                            user.setName(userName);
                            user.setEmail(email);
                            user.setPassword(password); // Just set to input for session
                            user.setStatus(userStatus);
                            user.setUserRole(userRole);
                            user.setStaffId(staffId);
                            user.setStudentNumber(studentNumber);
                            
                            LOGGER.log(Level.INFO, "Login complete for {0}, role: {1}, status: {2}", 
                                    new Object[]{email, userRole, userStatus});
                        }
                    }
                }
            } else {
                LOGGER.log(Level.INFO, "Supabase API Login failed for {0}", email);
            }
            
            if (loginSuccess && user != null) {
                // Check account status
                if ("false".equalsIgnoreCase(userStatus)) {
                    request.setAttribute("error", "Your account is pending approval. Please wait for admin approval.");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                    return;
                }
                
                // Create session
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);
                
                // Set user role based on the role field in the user model
                if (userRole != null && !userRole.isEmpty()) {
                    session.setAttribute("userRole", userRole.toLowerCase());
                } else {
                    // Fallback to legacy role detection if role field is empty
                    if (staffId != null && !staffId.isEmpty()) {
                        session.setAttribute("userRole", "staff");
                    } else {
                        session.setAttribute("userRole", "student");
                    }
                }
                
                // Redirect to dashboard - DashboardServlet will handle routing based on role
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                // Login failed
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error during login: {0}", e.getMessage());
            request.setAttribute("error", "An error occurred during login: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
