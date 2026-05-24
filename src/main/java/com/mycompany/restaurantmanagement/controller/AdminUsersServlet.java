package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.dao.UserDao;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUsersServlet", urlPatterns = {"/admin/users"})
public class AdminUsersServlet extends HttpServlet {
    
    @Inject
    private UserDao userDao;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        com.mycompany.restaurantmanagement.model.User currentUser = (com.mycompany.restaurantmanagement.model.User) session.getAttribute("user");
        
        // Check if user is logged in and has admin role
        if (currentUser == null || !"admin".equals(currentUser.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }
        
        // Get user lists by role
        List<com.mycompany.restaurantmanagement.model.User> allUsers = userDao.findAll();
        List<com.mycompany.restaurantmanagement.model.User> adminUsers = userDao.findByRoleString("admin");
        List<com.mycompany.restaurantmanagement.model.User> staffUsers = userDao.findByRoleString("staff");
        List<com.mycompany.restaurantmanagement.model.User> studentUsers = userDao.findByRoleString("student");
        List<com.mycompany.restaurantmanagement.model.User> pendingUsers = userDao.findByStatus("pending");
        
        // Set attributes
        request.setAttribute("allUsers", allUsers);
        request.setAttribute("adminUsers", adminUsers);
        request.setAttribute("staffUsers", staffUsers);
        request.setAttribute("studentUsers", studentUsers);
        request.setAttribute("pendingUsers", pendingUsers);
        
        // Forward to the user management page
        request.getRequestDispatcher("/WEB-INF/views/admin-users.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        com.mycompany.restaurantmanagement.model.User currentUser = (com.mycompany.restaurantmanagement.model.User) session.getAttribute("user");
        
        // Check if user is logged in and has admin role
        if (currentUser == null || !"admin".equals(currentUser.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }
        
        String action = request.getParameter("action");
        
        // Process user management actions
        if ("add".equals(action)) {
            // Logic for adding a new user
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            
            // Check if email already exists
            com.mycompany.restaurantmanagement.model.User existingUser = userDao.findByEmail(email);
            if (existingUser != null) {
                session.setAttribute("error", "Email already exists");
                response.sendRedirect(request.getContextPath() + "/admin/users");
                return;
            }
            
            // Create new user
            com.mycompany.restaurantmanagement.model.User newUser = new com.mycompany.restaurantmanagement.model.User();
            newUser.setName(name);
            newUser.setEmail(email);
            // Set other properties as needed
            
            userDao.save(newUser);
            session.setAttribute("message", "User added successfully");
            
        } else if ("delete".equals(action)) {
            // Logic for deleting a user
            int userId = Integer.parseInt(request.getParameter("id"));
            userDao.delete(userId);
            session.setAttribute("message", "User deleted successfully");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/users");
    }
}
