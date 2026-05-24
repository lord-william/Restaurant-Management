package com.mycompany.restaurantmanagement.controller;

import com.mycompany.restaurantmanagement.dao.MenuItemDao;
import com.mycompany.restaurantmanagement.dao.MenuCategoryDao;
import com.mycompany.restaurantmanagement.model.MenuItem;
import com.mycompany.restaurantmanagement.model.MenuCategory;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "MenuApiServlet", urlPatterns = {"/api/menu"})
public class MenuApiServlet extends HttpServlet {
    
    @Inject
    private MenuItemDao menuItemDao;
    
    @Inject
    private MenuCategoryDao menuCategoryDao;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String category = request.getParameter("category");
        
        PrintWriter out = response.getWriter();
        
        try {
            if ("categories".equals(action)) {
                // Get all categories
                List<MenuCategory> categories = menuCategoryDao.findAll();
                JSONArray categoriesJson = new JSONArray();
                
                for (MenuCategory cat : categories) {
                    JSONObject categoryJson = new JSONObject();
                    categoryJson.put("id", cat.getId());
                    categoryJson.put("name", cat.getName());
                    categoryJson.put("description", cat.getDescription());
                    categoriesJson.put(categoryJson);
                }
                
                out.print(categoriesJson.toString());
                
            } else if ("items".equals(action)) {
                // Get menu items by category
                List<MenuItem> items;
                
                if (category != null && !category.equals("all")) {
                    items = menuItemDao.findByCategory(category);
                } else {
                    items = menuItemDao.findAll();
                }
                
                JSONArray itemsJson = new JSONArray();
                
                for (MenuItem item : items) {
                    JSONObject itemJson = new JSONObject();
                    itemJson.put("id", item.getId());
                    itemJson.put("name", item.getName());
                    itemJson.put("description", item.getDescription());
                    itemJson.put("price", item.getPrice());
                    itemJson.put("imageUrl", item.getImageUrl());
                    itemJson.put("vegetarian", item.isVegetarian());
                    itemJson.put("vegan", item.isVegan());
                    itemJson.put("glutenFree", item.isGlutenFree());
                    itemJson.put("available", item.isAvailable());
                    itemJson.put("preparationTime", item.getPreparationTime());
                    
                    if (item.getCategory() != null) {
                        itemJson.put("category", item.getCategory().getName().toLowerCase());
                    }
                    
                    // Add restaurant availability (hardcoded for now)
                    JSONArray restaurants = new JSONArray();
                    restaurants.put(1); // Great Hall
                    restaurants.put(2); // Building 13
                    restaurants.put(3); // Mumasi
                    itemJson.put("restaurants", restaurants);
                    
                    itemsJson.put(itemJson);
                }
                
                out.print(itemsJson.toString());
                
            } else {
                // Default: return all items organized by category
                JSONObject menuJson = new JSONObject();
                
                // Get categories and their items
                List<MenuCategory> categories = menuCategoryDao.findAll();
                
                for (MenuCategory cat : categories) {
                    String categoryName = cat.getName().toLowerCase();
                    List<MenuItem> items = menuItemDao.findByCategory(cat.getName());
                    
                    JSONArray itemsJson = new JSONArray();
                    for (MenuItem item : items) {
                        if (item.isAvailable()) {
                            JSONObject itemJson = new JSONObject();
                            itemJson.put("id", item.getId());
                            itemJson.put("name", item.getName());
                            itemJson.put("description", item.getDescription());
                            itemJson.put("price", item.getPrice());
                            itemJson.put("imageUrl", item.getImageUrl() != null ? item.getImageUrl() : "/images/placeholder-food.jpg");
                            itemJson.put("vegetarian", item.isVegetarian());
                            itemJson.put("vegan", item.isVegan());
                            itemJson.put("glutenFree", item.isGlutenFree());
                            itemJson.put("category", categoryName);
                            
                            // Add restaurant availability
                            JSONArray restaurants = new JSONArray();
                            restaurants.put(1);
                            restaurants.put(2);
                            restaurants.put(3);
                            itemJson.put("restaurants", restaurants);
                            
                            itemsJson.put(itemJson);
                        }
                    }
                    
                    menuJson.put(categoryName, itemsJson);
                }
                
                out.print(menuJson.toString());
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            JSONObject error = new JSONObject();
            error.put("error", "Failed to fetch menu data: " + e.getMessage());
            out.print(error.toString());
            e.printStackTrace();
        }
    }
}