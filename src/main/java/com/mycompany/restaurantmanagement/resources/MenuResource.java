package com.mycompany.restaurantmanagement.resources;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import jakarta.ws.rs.core.Context;
import jakarta.servlet.ServletContext;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import org.json.JSONArray;
import org.json.JSONObject;

@Path("/menu")
@Produces(MediaType.APPLICATION_JSON)
public class MenuResource {
    
    private static final String DATA_DIRECTORY = "/data/menu/";
    
    @Context
    private ServletContext servletContext;
    
    @GET
    public Response getAllCategories() {
        try {
            JSONObject result = new JSONObject();
            JSONArray categories = new JSONArray();
            
            // Add each category
            categories.put("treats");
            categories.put("meals");
            categories.put("beverages");
            categories.put("breakfast");
            categories.put("vegetarian");
            categories.put("specials");
            
            result.put("categories", categories);
            return Response.ok(result.toString()).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }
    
    @GET
    @Path("/{category}")
    public Response getMenuByCategory(@PathParam("category") String category) {
        try {
            String filePath = getServletContext().getRealPath(DATA_DIRECTORY + category + ".json");
            File file = new File(filePath);
            
            if (!file.exists()) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"Category not found\"}")
                        .build();
            }
            
            // Read the JSON file
            try (InputStream is = new FileInputStream(file)) {
                byte[] bytes = new byte[(int) file.length()];
                is.read(bytes);
                return Response.ok(new String(bytes)).build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }
    
    @GET
    @Path("/item/{id}")
    public Response getMenuItemById(@PathParam("id") String itemId) {
        try {
            String categoryPrefix = itemId.split("-")[0];
            String category;
            
            // Map prefix to category file
            switch (categoryPrefix) {
                case "treat": category = "treats"; break;
                case "meal": category = "meals"; break;
                case "bev": category = "beverages"; break;
                case "brkfst": category = "breakfast"; break;
                case "veg": category = "vegetarian"; break;
                case "spcl": category = "specials"; break;
                default: category = "treats";
            }
            
            String filePath = getServletContext().getRealPath(DATA_DIRECTORY + category + ".json");
            File file = new File(filePath);
            
            if (!file.exists()) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"Category file not found\"}")
                        .build();
            }
            
            // Read and parse the JSON file
            try (InputStream is = new FileInputStream(file)) {
                byte[] bytes = new byte[(int) file.length()];
                is.read(bytes);
                
                JSONObject categoryData = new JSONObject(new String(bytes));
                JSONArray items = categoryData.getJSONArray("items");
                
                // Search for the item
                for (int i = 0; i < items.length(); i++) {
                    JSONObject item = items.getJSONObject(i);
                    
                    // Check if this is the main item
                    if (item.getString("id").equals(itemId)) {
                        return Response.ok(item.toString()).build();
                    }
                    
                    // Check if this item has variants
                    if (item.has("variants")) {
                        JSONArray variants = item.getJSONArray("variants");
                        for (int j = 0; j < variants.length(); j++) {
                            JSONObject variant = variants.getJSONObject(j);
                            if (variant.getString("id").equals(itemId)) {
                                return Response.ok(variant.toString()).build();
                            }
                        }
                    }
                }
                
                return Response.status(Response.Status.NOT_FOUND)
                        .entity("{\"error\": \"Item not found\"}")
                        .build();
            }
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"" + e.getMessage() + "\"}")
                    .build();
        }
    }
    
    private ServletContext getServletContext() {
        return servletContext;
    }
}