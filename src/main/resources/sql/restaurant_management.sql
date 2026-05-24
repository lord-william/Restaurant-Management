-- SQL Script to create local database for development

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS restaurant_management;

-- Use the database
USE restaurant_management;

-- Drop tables if they exist
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS menu_categories;
DROP TABLE IF EXISTS users;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    mobile_number VARCHAR(10) NOT NULL,
    student_number VARCHAR(9) UNIQUE,
    staff_id VARCHAR(6) UNIQUE,
    password VARCHAR(200) NOT NULL,
    security_question VARCHAR(200) NOT NULL,
    answer VARCHAR(200) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'false',
    `role` VARCHAR(20) NOT NULL DEFAULT 'student'
);

-- Menu Categories table
CREATE TABLE menu_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url VARCHAR(255)
);

-- Menu Items table
CREATE TABLE menu_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category_id INT,
    image_url VARCHAR(255),
    FOREIGN KEY (category_id) REFERENCES menu_categories(id)
);

-- Orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    table_number INT,
    status VARCHAR(50) DEFAULT 'Pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Order Items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    menu_item_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- Insert admin user
INSERT INTO users (
    name, 
    email, 
    mobile_number, 
    password, 
    security_question, 
    answer, 
    status,
    `role`
) VALUES (
    'System Administrator',
    'admin@restaurant.ump.ac.za',
    '0000000000',
    'Admin@123',
    'What is your role?',
    'administrator',
    'true',
    'admin'
);

-- Check if admin was created
SELECT * FROM users WHERE email = 'admin@restaurant.ump.ac.za';
