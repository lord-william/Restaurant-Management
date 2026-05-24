-- Drop database if it exists
DROP DATABASE IF EXISTS restaurant_db;

-- Create database
CREATE DATABASE restaurant_db;

-- Use the database
USE restaurant_db;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    mobile_number VARCHAR(10) NOT NULL,
    student_number VARCHAR(9) UNIQUE,
    password VARCHAR(200) NOT NULL,
    security_question VARCHAR(200) NOT NULL,
    answer VARCHAR(200) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'false',
    role ENUM('ADMIN', 'STAFF', 'USER') NOT NULL DEFAULT 'USER',
    registration_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    reset_token VARCHAR(255),
    reset_token_expiry DATETIME
);

-- Menu categories table
CREATE TABLE menu_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    image_url VARCHAR(255)
);

-- Menu items table
CREATE TABLE menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_url VARCHAR(255),
    is_vegetarian BOOLEAN NOT NULL DEFAULT FALSE,
    is_vegan BOOLEAN NOT NULL DEFAULT FALSE,
    is_gluten_free BOOLEAN NOT NULL DEFAULT FALSE,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    preparation_time INT, -- in minutes
    FOREIGN KEY (category_id) REFERENCES menu_categories(category_id)
);

-- Orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    table_number INT,
    order_status ENUM('PENDING', 'PREPARING', 'READY', 'DELIVERED', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    order_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('PENDING', 'PAID', 'REFUNDED') NOT NULL DEFAULT 'PENDING',
    payment_method ENUM('CASH', 'CREDIT_CARD', 'DEBIT_CARD', 'ONLINE') DEFAULT NULL,
    special_instructions TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Order items table
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    special_instructions TEXT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id)
);

-- Reservations table
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    guest_name VARCHAR(100) NOT NULL,
    guest_email VARCHAR(100),
    guest_phone VARCHAR(20) NOT NULL,
    party_size INT NOT NULL,
    reservation_date DATE NOT NULL,
    reservation_time TIME NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') NOT NULL DEFAULT 'PENDING',
    special_requests TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Feedback table
CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_id INT,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    feedback_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Insert admin user (password: admin123)
INSERT INTO users (name, email, mobile_number, password, security_question, answer, status, role) 
VALUES ('Admin User', 'admin@restaurant.com', '0000000000', 'admin123', 'What is your favorite food?', 'Pizza', 'true', 'ADMIN');

-- Insert sample menu categories
INSERT INTO menu_categories (name, description) VALUES 
('Treats', 'Delicious sweet treats and desserts'),
('Meals', 'Main course meals and dishes'),
('Beverages', 'Refreshing drinks and beverages'),
('Breakfast', 'Start your day with our breakfast options'),
('Vegetarian', 'Vegetarian friendly options'),
('Specials', 'Chef special dishes and seasonal items');

-- Insert sample menu items
INSERT INTO menu_items (category_id, name, description, price, is_vegetarian, preparation_time) VALUES
(1, 'Chocolate Brownie', 'Rich chocolate brownie with vanilla ice cream', 7.99, TRUE, 5),
(1, 'Cheesecake', 'New York style cheesecake with berry compote', 8.99, TRUE, 5),
(2, 'Grilled Chicken', 'Herb marinated grilled chicken with seasonal vegetables', 15.99, FALSE, 20),
(2, 'Beef Burger', 'Premium beef patty with cheese, lettuce, tomato and special sauce', 14.99, FALSE, 15),
(3, 'Fresh Orange Juice', 'Freshly squeezed orange juice', 4.99, TRUE, 3),
(3, 'Coffee', 'Premium roast coffee', 3.99, TRUE, 5),
(4, 'Eggs Benedict', 'Poached eggs with hollandaise sauce on English muffin', 12.99, FALSE, 15),
(4, 'Pancake Stack', 'Fluffy pancakes with maple syrup and fresh berries', 10.99, TRUE, 10),
(5, 'Vegetable Stir Fry', 'Fresh vegetables stir fried with tofu in a savory sauce', 13.99, TRUE, 15),
(5, 'Garden Salad', 'Mixed greens with fresh vegetables and house dressing', 9.99, TRUE, 10),
(6, 'Chef\'s Special Pasta', 'Chef\'s daily pasta special with garlic bread', 16.99, FALSE, 20),
(6, 'Seafood Platter', 'Selection of fresh seafood grilled to perfection', 24.99, FALSE, 25);
