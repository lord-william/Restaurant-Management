package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.dao.UserDao;
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

@WebServlet(name = "AdminApprovalsServlet", urlPatterns = {"/admin/approvals"})
public class AdminApprovalsServlet extends HttpServlet {
    
    @Inject
    private UserDao userDao;
    
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
        
        String action = request.getParameter("action");
        String userIdStr = request.getParameter("userId");
        
        // Handle approve/reject actions from GET requests
        if (action != null && userIdStr != null) {
            try {
                int userId = Integer.parseInt(userIdStr);
                
                if ("approve".equals(action)) {
                    userDao.updateStatus(userId, "true");
                    session.setAttribute("success", "User approved successfully");
                } else if ("reject".equals(action)) {
                    User targetUser = userDao.findById(userId);
                    if (targetUser != null) {
                        // Prevent deleting admin accounts except by superadmin (id=1)
                        if (currentUser.getId() == 1 || !"admin".equals(targetUser.getUserRole())) {
                            userDao.delete(userId);
                            session.setAttribute("success", "User rejected and account deleted");
                        } else {
                            session.setAttribute("error", "You don't have permission to delete admin accounts");
                        }
                    }
                }
                
                response.sendRedirect(request.getContextPath() + "/admin/approvals");
                return;
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid user ID");
            }
        }
        
        // Get users pending approval
        List<User> pendingUsers = userDao.findByStatus("false");
        request.setAttribute("pendingUsers", pendingUsers);
        
        // Forward to the approvals page
        request.getRequestDispatcher("/WEB-INF/views/admin-approvals.jsp").forward(request, response);
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
        String userIdStr = request.getParameter("id");
        
        if (action != null && userIdStr != null) {
            try {
                int userId = Integer.parseInt(userIdStr);
                
                if ("approve".equals(action)) {
                    userDao.updateStatus(userId, "true");
                    session.setAttribute("success", "User approved successfully");
                } else if ("reject".equals(action)) {
                    User targetUser = userDao.findById(userId);
                    if (targetUser != null) {
                        // Prevent deleting admin accounts except by superadmin (id=1)
                        if (currentUser.getId() == 1 || !"admin".equals(targetUser.getUserRole())) {
                            userDao.delete(userId);
                            session.setAttribute("success", "User rejected and account deleted");
                        } else {
                            session.setAttribute("error", "You don't have permission to delete admin accounts");
                        }
                    }
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid user ID");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/approvals");
    }
}