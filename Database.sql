<invoke name="write_to_file">
<parameter name="TargetFile">c:\Users\Dell\Documents\NetBeansProjects\RestaurantManagement\src\main\java\com\mycompany\restaurantmanagement\dto\DashboardStats.java</parameter>
<parameter name="CodeContent">package com.mycompany.restaurantmanagement.dto;

/**
 * Data Transfer Object for admin dashboard statistics
 */
public class DashboardStats {
    private int totalUsers;
    private int ordersToday;
    private double revenueToday;
    private int pendingApprovals;

    public DashboardStats() {
    }

    public DashboardStats(int totalUsers, int ordersToday, double revenueToday, int pendingApprovals) {
        this.totalUsers = totalUsers;
        this.ordersToday = ordersToday;
        this.revenueToday = revenueToday;
        this.pendingApprovals = pendingApprovals;
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getOrdersToday() {
        return ordersToday;
    }

    public void setOrdersToday(int ordersToday) {
        this.ordersToday = ordersToday;
    }

    public double getRevenueToday() {
        return revenueToday;
    }

    public void setRevenueToday(double revenueToday) {
        this.revenueToday = revenueToday;
    }

    public int getPendingApprovals() {
        return pendingApprovals;
    }

    public void setPendingApprovals(int pendingApprovals) {
        this.pendingApprovals = pendingApprovals;
    }
}
</parameter>
</invoke><invoke name="write_to_file">
<parameter name="TargetFile">c:\Users\Dell\Documents\NetBeansProjects\RestaurantManagement\src\main\java\com\mycompany\restaurantmanagement\dao\DashboardDAO.java</parameter>
<parameter name="CodeContent">package com.mycompany.restaurantmanagement.dao;

import com.mycompany.restaurantmanagement.dto.DashboardStats;
import com.mycompany.restaurantmanagement.model.User;
import com.mycompany.restaurantmanagement.util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for admin dashboard operations
 */
public class DashboardDAO {
    private static final Logger LOGGER = Logger.getLogger(DashboardDAO.class.getName());
    
    /**
     * Gets statistics for the admin dashboard
     * @return DashboardStats containing total users, orders today, revenue today, and pending approvals
     */
    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            // Get total users
            stats.setTotalUsers(getTotalUsers(conn));
            
            // Get orders today
            stats.setOrdersToday(getOrdersToday(conn));
            
            // Get revenue today
            stats.setRevenueToday(getRevenueToday(conn));
            
            // Get pending approvals
            stats.setPendingApprovals(getPendingApprovals(conn));
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting dashboard stats", e);
        }
        
        return stats;
    }
    
    /**
     * Gets the total number of users
     * @param conn Database connection
     * @return Total number of users
     * @throws SQLException If a database error occurs
     */
    private int getTotalUsers(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'true'";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * Gets the number of orders placed today
     * @param conn Database connection
     * @return Number of orders today
     * @throws SQLException If a database error occurs
     */
    private int getOrdersToday(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * Gets the total revenue from orders placed today
     * @param conn Database connection
     * @return Total revenue today
     * @throws SQLException If a database error occurs
     */
    private double getRevenueToday(Connection conn) throws SQLException {
        String sql = "SELECT SUM(total_amount) FROM orders WHERE DATE(created_at) = CURDATE()";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }
    
    /**
     * Gets the number of pending user approvals
     * @param conn Database connection
     * @return Number of pending approvals
     * @throws SQLException If a database error occurs
     */
    private int getPendingApprovals(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 'false'";
        try (PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * Gets a list of users pending approval
     * @return List of pending users
     */
    public List<User> getPendingUsers() {
        List<User> pendingUsers = new ArrayList<>();
        
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "SELECT * FROM users WHERE status = 'false'";
            try (PreparedStatement stmt = conn.prepareStatement(sql);
                 ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setMobileNumber(rs.getString("mobile_number"));
                    user.setUserRole(rs.getString("user_role"));
                    user.setStudentNumber(rs.getString("student_number"));
                    user.setStaffId(rs.getString("staff_id"));
                    user.setStatus(rs.getString("status"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    pendingUsers.add(user);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting pending users", e);
        }
        
        return pendingUsers;
    }
    
    /**
     * Approves a user account
     * @param userId User ID to approve
     * @return true if successful, false otherwise
     */
    public boolean approveUser(int userId) {
        try (Connection conn = DatabaseUtil.getConnection()) {
            String sql = "UPDATE users SET status = 'true' WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                return stmt.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error approving user", e);
            return false;
        }
    }
}
</parameter>
</invoke>-- Create database
CREATE DATABASE IF NOT EXISTS restaurant_management;
USE restaurant_management;

-- Create users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    mobile_number VARCHAR(20),
    user_role ENUM('student', 'staff', 'admin', 'customer') NOT NULL DEFAULT 'student',
    student_number VARCHAR(9),
    staff_id VARCHAR(6),
    security_question VARCHAR(255) NOT NULL,
    answer VARCHAR(255) NOT NULL,
    status ENUM('true', 'false') NOT NULL DEFAULT 'false',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create menu_items table
CREATE TABLE menu_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50),
    image_url VARCHAR(255),
    available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('PENDING', 'PREPARING', 'READY', 'DELIVERED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    payment_status ENUM('PENDING', 'PAID', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_address TEXT,
    notes TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create order_items table (for order details)
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE CASCADE
);

-- Insert default admin user (password: Admin123!)
INSERT INTO users (name, email, password, user_role, security_question, answer, status) 
VALUES ('System Administrator', 'admin@restaurant.com', 'Admin123!', 'admin', 'Default', 'admin', 'true');

-- Insert sample data for testing

-- Sample users
INSERT INTO users (name, email, password, user_role, student_number, security_question, answer, status) 
VALUES 
('John Student', 'student@test.com', 'Student123!', 'student', '123456789', 'What is your name?', 'John', 'true'),
('Jane Staff', 'staff@test.com', 'Staff123!', 'staff', NULL, 'What is your department?', 'Kitchen', 'false'),
('Bob Customer', 'customer@test.com', 'Customer123!', 'customer', NULL, 'What is your city?', 'Cape Town', 'true');

INSERT INTO users (name, email, password, user_role, staff_id, security_question, answer, status) 
VALUES ('Sarah Manager', 'manager@test.com', 'Manager123!', 'staff', 'STAFF1', 'What is your role?', 'Manager', 'true');

-- Sample menu items
INSERT INTO menu_items (name, description, price, category) VALUES
('Burger Deluxe', 'Beef burger with cheese, lettuce, tomato', 85.00, 'Main Course'),
('Chicken Wings', 'Spicy buffalo chicken wings (6 pieces)', 65.00, 'Appetizer'),
('Caesar Salad', 'Fresh lettuce with caesar dressing and croutons', 55.00, 'Salad'),
('Margherita Pizza', 'Classic pizza with tomato, mozzarella, and basil', 120.00, 'Main Course'),
('Chocolate Cake', 'Rich chocolate cake with vanilla ice cream', 45.00, 'Dessert'),
('Coffee', 'Fresh brewed coffee', 25.00, 'Beverage'),
('Orange Juice', 'Fresh squeezed orange juice', 30.00, 'Beverage'),
('Fish and Chips', 'Beer battered fish with crispy chips', 95.00, 'Main Course');

-- Sample orders
INSERT INTO orders (user_id, total_amount, status, payment_status, delivery_address) VALUES
(2, 150.00, 'DELIVERED', 'PAID', '123 Main Street, Cape Town'),
(3, 85.00, 'PREPARING', 'PAID', '456 Oak Avenue, Johannesburg'),
(4, 200.00, 'PENDING', 'PENDING', '789 Pine Road, Durban');

-- Sample order items
INSERT INTO order_items (order_id, menu_item_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 85.00, 85.00),
(1, 2, 1, 65.00, 65.00),
(2, 4, 1, 120.00, 120.00),
(3, 1, 2, 85.00, 170.00),
(3, 7, 1, 30.00, 30.00);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_users_role ON users(user_role);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_menu_item_id ON order_items(menu_item_id);