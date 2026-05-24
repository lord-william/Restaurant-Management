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
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AdminUserServlet", urlPatterns = {"/admin/user"})
public class AdminUserServlet extends HttpServlet {
    
    @Inject
    private UserDao userDao;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        com.mycompany.restaurantmanagement.model.User currentUser = 
            (com.mycompany.restaurantmanagement.model.User) session.getAttribute("user");
        
        // Check if user is logged in and has admin role
        if (currentUser == null || !"admin".equals(currentUser.getUserRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }
        
        String action = request.getParameter("action");
        String userIdStr = request.getParameter("id");
        
        if (action == null || userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            com.mycompany.restaurantmanagement.model.User targetUser = userDao.findById(userId);
            
            if (targetUser == null) {
                request.setAttribute("error", "User not found");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }
            
            // Check if it's an AJAX request
            boolean isAjaxRequest = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
            
            // Process the requested action
            switch (action) {
                case "view":
                    request.setAttribute("targetUser", targetUser);
                    request.getRequestDispatcher("/admin/user-detail.jsp").forward(request, response);
                    break;
                    
                case "approve":
                    // Only the original admin (ID 1) can approve users or other admins can approve non-admins
                    boolean success = false;
                    String message = "";
                    
                    if (currentUser.getId() == 1 || !"admin".equals(targetUser.getUserRole())) {
                        userDao.updateStatus(userId, "true");
                        message = "User " + targetUser.getName() + " has been approved";
                        success = true;
                    } else {
                        message = "Only the system administrator can approve admin accounts";
                    }
                    
                    if (isAjaxRequest) {
                        // Send JSON response for AJAX requests
                        sendJsonResponse(response, success, message);
                    } else {
                        // Regular form submit - redirect with session message
                        if (success) {
                            request.getSession().setAttribute("success", message);
                        } else {
                            request.getSession().setAttribute("error", message);
                        }
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    }
                    break;
                    
                case "promote":
                    // Determine the next role (student -> staff, staff -> admin)
                    String currentRole = targetUser.getUserRole();
                    String newRole = null;
                    boolean promotionSuccess = false;
                    String promotionMessage = "";
                    
                    if ("student".equals(currentRole)) {
                        newRole = "staff";
                        promotionSuccess = true;
                    } else if ("staff".equals(currentRole)) {
                        // Only ID 1 can promote to admin
                        if (currentUser.getId() != 1) {
                            promotionMessage = "Only the system administrator can promote to admin role";
                            promotionSuccess = false;
                        } else {
                            newRole = "admin";
                            promotionSuccess = true;
                        }
                    } else {
                        promotionMessage = "Cannot promote from current role";
                        promotionSuccess = false;
                    }
                    
                    if (promotionSuccess) {
                        userDao.updateRole(userId, newRole);
                        promotionMessage = "User " + targetUser.getName() + " has been promoted to " + newRole;
                    }
                    
                    if (isAjaxRequest) {
                        // Send JSON response for AJAX requests
                        sendJsonResponse(response, promotionSuccess, promotionMessage);
                    } else {
                        // Regular form submit - redirect with session message
                        if (promotionSuccess) {
                            request.getSession().setAttribute("success", promotionMessage);
                        } else {
                            request.getSession().setAttribute("error", promotionMessage);
                        }
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    }
                    break;

                    
                case "delete":
                    // Cannot delete the original admin (ID 1) or admins cannot delete other admins unless they are ID 1
                    boolean deleteSuccess = false;
                    String deleteMessage = "";
                    
                    if (targetUser.getId() == 1) {
                        deleteMessage = "Cannot delete the system administrator account";
                    } else if ("admin".equals(targetUser.getUserRole()) && currentUser.getId() != 1) {
                        deleteMessage = "Only the system administrator can delete admin accounts";
                    } else {
                        userDao.delete(userId);
                        deleteMessage = "User has been deleted";
                        deleteSuccess = true;
                    }
                    
                    if (isAjaxRequest) {
                        // Send JSON response for AJAX requests
                        sendJsonResponse(response, deleteSuccess, deleteMessage);
                    } else {
                        // Regular form submit - redirect with session message
                        if (deleteSuccess) {
                            request.getSession().setAttribute("success", deleteMessage);
                        } else {
                            request.getSession().setAttribute("error", deleteMessage);
                        }
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    }
                    break;
                    
                default:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }
    
    /**
     * Helper method to send JSON response for AJAX requests
     */
    private void sendJsonResponse(HttpServletResponse response, boolean success, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("success", success);
        jsonResponse.put("message", message);
        
        PrintWriter out = response.getWriter();
        out.print("{\"success\":"+success+",\"message\":\"" + message + "\"}");
        out.flush();
    }
}
