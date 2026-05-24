-- Updated Database Script with Fixed Role Names and Additional Tables
DROP DATABASE IF EXISTS restaurant_management;
CREATE DATABASE restaurant_management;
USE restaurant_management;

-- Create the users table with proper role names
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    mobile_number VARCHAR(10) NOT NULL,
    user_role ENUM('student', 'staff', 'admin') NOT NULL,
    student_number VARCHAR(9) NULL,
    staff_id VARCHAR(6) NULL,
    status VARCHAR(10) NOT NULL DEFAULT 'false',
    security_question VARCHAR(255) NOT NULL,
    answer VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_user_role_student CHECK (
        (user_role = 'student' AND student_number IS NOT NULL AND staff_id IS NULL) OR
        (user_role != 'student')
    ),
    CONSTRAINT chk_user_role_staff CHECK (
        (user_role = 'staff' AND staff_id IS NOT NULL AND student_number IS NULL) OR
        (user_role != 'staff')
    ),
    CONSTRAINT chk_student_number CHECK (
        student_number IS NULL OR student_number REGEXP '^[0-9]{9}$'
    ),
    CONSTRAINT chk_staff_id CHECK (
        staff_id IS NULL OR staff_id REGEXP '^[A-Z0-9]{6}$'
    ),
    CONSTRAINT chk_mobile_number CHECK (
        mobile_number REGEXP '^[0-9]{10}$'
    ),
    CONSTRAINT chk_email CHECK (
        email REGEXP '^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$'
    ),
    CONSTRAINT chk_status CHECK (
        status IN ('true', 'false')
    )
);

-- Create the menu_items table
CREATE TABLE menu_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    image_url VARCHAR(255),
    available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create the orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'processing', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    payment_method VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create the order_items table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX idx_email ON users(email);
CREATE INDEX idx_user_role ON users(user_role);
CREATE INDEX idx_status ON users(status);
CREATE INDEX idx_orders_date ON orders(created_at);
CREATE INDEX idx_orders_user ON orders(user_id);

-- Insert sample users matching your dashboard
-- Note: In production, passwords should be hashed!

-- Sample admin user (automatically approved)
INSERT INTO users (name, email, password, mobile_number, user_role, status, security_question, answer)
VALUES ('Admin User', 'arthurndumiso@gmail.com', 'Nkuna@19', '1234567890', 'admin', 'true', 'What is your pet name?', 'Fluffy');

-- Sample students (automatically approved)
INSERT INTO users (name, email, password, mobile_number, user_role, student_number, status, security_question, answer)
VALUES 
('John Doe', 'john@university.edu', 'StudentPass123!', '0987654321', 'student', '123456789', 'true', 'What is your favorite color?', 'Blue'),
('Sarah Smith', 'sarah@university.edu', 'StudentPass123!', '0987654322', 'student', '123456790', 'true', 'What is your favorite color?', 'Green'),
('Mike Johnson', 'mike@university.edu', 'StudentPass123!', '0987654323', 'student', '123456791', 'true', 'What is your favorite color?', 'Red'),
('Lisa Brown', 'lisa@university.edu', 'StudentPass123!', '0987654324', 'student', '123456792', 'true', 'What is your favorite color?', 'Yellow');

-- Sample staff users (some approved, some pending)
INSERT INTO users (name, email, password, mobile_number, user_role, staff_id, status, security_question, answer)
VALUES 
('Jane Smith', 'jane@restaurant.com', 'StaffPass123!', '5555555555', 'staff', 'ABC123', 'false', 'What is your childhood nickname?', 'Janie'),
('Bob Wilson', 'bob@restaurant.com', 'BobPass123!', '9876543210', 'staff', 'XYZ789', 'true', 'What is your mother maiden name?', 'Johnson'),
('Emily Davis', 'emily@restaurant.com', 'EmilyPass123!', '5555555556', 'staff', 'EFG456', 'true', 'What city were you born in?', 'Johannesburg');

-- Additional pending users to show on dashboard
INSERT INTO users (name, email, password, mobile_number, user_role, student_number, status, security_question, answer)
VALUES ('Robert Johnson', 'robert@example.com', 'RobertPass123!', '4561237890', 'student', '456123789', 'false', 'What is your favorite movie?', 'The Godfather');

-- Sample menu items
INSERT INTO menu_items (name, description, price, category, available)
VALUES 
('Cheeseburger', 'Classic beef burger with cheese', 45.99, 'Main', TRUE),
('Chicken Sandwich', 'Grilled chicken with lettuce and mayo', 39.99, 'Main', TRUE),
('French Fries', 'Crispy golden fries', 19.99, 'Side', TRUE),
('Caesar Salad', 'Fresh romaine lettuce with Caesar dressing', 29.99, 'Side', TRUE),
('Chocolate Milkshake', 'Rich and creamy chocolate milkshake', 24.99, 'Beverage', TRUE),
('Fresh Orange Juice', 'Freshly squeezed orange juice', 25.00, 'Beverage', TRUE),
('Coca-Cola', 'Classic Coca-Cola, 330ml can', 15.00, 'Beverage', TRUE),
('Cappuccino', 'Espresso with steamed milk and foam', 22.00, 'Beverage', TRUE);

-- Sample orders for today (using today's date)
INSERT INTO orders (user_id, total_amount, status, payment_method, created_at)
VALUES 
(2, 65.97, 'completed', 'Credit Card', CURDATE()),
(3, 45.98, 'processing', 'Cash', CURDATE()),
(4, 89.96, 'completed', 'Credit Card', CURDATE()),
(5, 45.99, 'pending', 'Mobile Payment', CURDATE()),
(2, 25.00, 'completed', 'Cash', CURDATE()),
(6, 62.98, 'completed', 'Credit Card', CURDATE());

-- Sample order items
INSERT INTO order_items (order_id, menu_item_id, quantity, price)
VALUES 
(1, 1, 1, 45.99),
(1, 3, 1, 19.99),
(2, 2, 1, 39.99),
(2, 6, 1, 6.00),
(3, 1, 1, 45.99),
(3, 4, 1, 29.99),
(3, 5, 1, 24.99),
(4, 1, 1, 45.99),
(5, 6, 1, 25.00),
(6, 2, 1, 39.99),
(6, 3, 1, 19.99),
(6, 8, 1, 22.00);

-- Create views for easier data retrieval
CREATE VIEW user_summary AS
SELECT 
    id,
    name,
    email,
    mobile_number,
    user_role,
    student_number,
    staff_id,
    status,
    created_at,
    updated_at
FROM users;

-- Verify the setup by checking counts (these will be used by your dashboard)
SELECT 'Database setup verification' AS Message;

-- Count by user roles
SELECT 
    user_role,
    COUNT(*) as count,
    SUM(CASE WHEN status = 'true' THEN 1 ELSE 0 END) as active_count,
    SUM(CASE WHEN status = 'false' THEN 1 ELSE 0 END) as pending_count
FROM users 
GROUP BY user_role;

-- Order statistics for today
SELECT 
    COUNT(*) as orders_today,
    SUM(total_amount) as revenue_today
FROM orders 
WHERE DATE(created_at) = CURDATE();

-- Order statistics for this month
SELECT 
    COUNT(*) as orders_this_month,
    SUM(total_amount) as revenue_this_month
FROM orders 
WHERE YEAR(created_at) = YEAR(CURDATE()) 
    AND MONTH(created_at) = MONTH(CURDATE());

-- Total menu items
SELECT COUNT(*) as total_menu_items FROM menu_items WHERE available = TRUE;
