package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.dao.MenuItemDao;
import com.mycompany.restaurantmanagement.model.MenuItem;
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

@WebServlet(name = "AdminMenuServlet", urlPatterns = {"/admin/menu"})
public class AdminMenuServlet extends HttpServlet {
    
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
        
        // Get all menu items
        List<MenuItem> menuItems = menuItemDao.findAll();
        request.setAttribute("menuItems", menuItems);
        
        // Forward to the menu management page
        request.getRequestDispatcher("/WEB-INF/views/admin-menu.jsp").forward(request, response);
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
        
        // Process menu item actions (add, edit, delete)
        if ("add".equals(action)) {
            session.setAttribute("message", "Menu item added successfully");
        } else if ("edit".equals(action)) {
            session.setAttribute("message", "Menu item updated successfully");
        } else if ("delete".equals(action)) {
            session.setAttribute("message", "Menu item deleted successfully");
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/menu");
    }
}
