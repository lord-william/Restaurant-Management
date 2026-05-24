-- ============================================================
-- Supabase PostgreSQL Schema for Restaurant Management System
-- ============================================================
-- Run this in the Supabase SQL Editor (Dashboard > SQL Editor)
-- ============================================================

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    mobile_number VARCHAR(10) NOT NULL,
    user_role VARCHAR(10) NOT NULL CHECK (user_role IN ('student', 'staff', 'admin')),
    student_number VARCHAR(9) NULL,
    staff_id VARCHAR(6) NULL,
    status VARCHAR(10) NOT NULL DEFAULT 'false' CHECK (status IN ('true', 'false')),
    security_question VARCHAR(255) NOT NULL,
    answer VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
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
        student_number IS NULL OR student_number ~ '^[0-9]{9}$'
    ),
    CONSTRAINT chk_staff_id CHECK (
        staff_id IS NULL OR staff_id ~ '^[A-Z0-9]{6}$'
    ),
    CONSTRAINT chk_mobile_number CHECK (
        mobile_number ~ '^[0-9]{10}$'
    )
);

-- Create menu_items table
CREATE TABLE IF NOT EXISTS menu_items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    image_url VARCHAR(255),
    available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0,
    service_fee DECIMAL(10, 2) NOT NULL DEFAULT 0,
    delivery_fee DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'cancelled', 'paid')),
    is_delivery BOOLEAN NOT NULL DEFAULT FALSE,
    delivery_address VARCHAR(255) NULL,
    payment_method VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create order_items table
CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    flavor VARCHAR(100) NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_user_role ON users(user_role);
CREATE INDEX IF NOT EXISTS idx_status ON users(status);
CREATE INDEX IF NOT EXISTS idx_orders_date ON orders(created_at);
CREATE INDEX IF NOT EXISTS idx_orders_user ON orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_menu ON order_items(menu_item_id);

-- ============================================================
-- Create trigger for auto-updating updated_at column
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE TRIGGER update_menu_items_updated_at
    BEFORE UPDATE ON menu_items
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE OR REPLACE TRIGGER update_orders_updated_at
    BEFORE UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- Insert sample data
-- ============================================================

-- Sample admin user (automatically approved)
INSERT INTO users (name, email, password, mobile_number, user_role, status, security_question, answer)
VALUES ('Admin User', 'arthurndumiso@gmail.com', 'Nkuna@19', '1234567890', 'admin', 'true', 'What is your pet name?', 'Fluffy')
ON CONFLICT (email) DO NOTHING;

-- Sample students (automatically approved)
INSERT INTO users (name, email, password, mobile_number, user_role, student_number, status, security_question, answer)
VALUES 
('John Doe', 'john@university.edu', 'StudentPass123!', '0987654321', 'student', '123456789', 'true', 'What is your favorite color?', 'Blue'),
('Sarah Smith', 'sarah@university.edu', 'StudentPass123!', '0987654322', 'student', '123456790', 'true', 'What is your favorite color?', 'Green'),
('Mike Johnson', 'mike@university.edu', 'StudentPass123!', '0987654323', 'student', '123456791', 'true', 'What is your favorite color?', 'Red'),
('Lisa Brown', 'lisa@university.edu', 'StudentPass123!', '0987654324', 'student', '123456792', 'true', 'What is your favorite color?', 'Yellow')
ON CONFLICT (email) DO NOTHING;

-- Sample staff users (some approved, some pending)
INSERT INTO users (name, email, password, mobile_number, user_role, staff_id, status, security_question, answer)
VALUES 
('Jane Smith', 'jane@restaurant.com', 'StaffPass123!', '5555555555', 'staff', 'ABC123', 'false', 'What is your childhood nickname?', 'Janie'),
('Bob Wilson', 'bob@restaurant.com', 'BobPass123!', '9876543210', 'staff', 'XYZ789', 'true', 'What is your mother maiden name?', 'Johnson'),
('Emily Davis', 'emily@restaurant.com', 'EmilyPass123!', '5555555556', 'staff', 'EFG456', 'true', 'What city were you born in?', 'Johannesburg')
ON CONFLICT (email) DO NOTHING;

-- Additional pending user
INSERT INTO users (name, email, password, mobile_number, user_role, student_number, status, security_question, answer)
VALUES ('Robert Johnson', 'robert@example.com', 'RobertPass123!', '4561237890', 'student', '456123789', 'false', 'What is your favorite movie?', 'The Godfather')
ON CONFLICT (email) DO NOTHING;

-- ============================================================
-- BEVERAGES
-- ============================================================
INSERT INTO menu_items (name, description, price, category, image_url, available) VALUES
('Fresh Orange Juice', 'Freshly squeezed orange juice, 300ml', 25.00, 'Beverages', '/images/All/liquifruit_orange.png', TRUE),
('Coca-Cola', 'Classic Coca-Cola, 330ml can', 15.00, 'Beverages', '/images/All/coca_cola.jpg', TRUE),
('Cappuccino', 'Espresso with steamed milk and a layer of milk foam', 22.00, 'Beverages', '/images/All/cappoccino.jpg', TRUE),
('Rooibos Tea', 'South African Rooibos tea, served with honey and lemon on the side', 18.00, 'Beverages', '/images/All/rooibos.jpg', TRUE),
('Smoothie - Strawberry Banana', 'Strawberry and banana smoothie with yogurt and honey', 30.00, 'Beverages', '/images/All/strawberry-banana-smoothie.png', TRUE),
('Smoothie - Mango Pineapple', 'Mango and pineapple smoothie with yogurt and a hint of lime', 32.00, 'Beverages', '/images/All/mango-pineapple-smoothie.png', TRUE),
('Smoothie - Green Machine', 'Spinach, kale, banana, and pineapple smoothie with almond milk', 35.00, 'Beverages', '/images/All/green-smoothie.png', TRUE),
('Ice Cream Shake - Vanilla', 'Classic vanilla milkshake topped with whipped cream', 35.00, 'Beverages', '/images/All/vanilla-shake.png', TRUE),
('Ice Cream Shake - Chocolate', 'Rich chocolate milkshake topped with whipped cream and chocolate syrup', 38.00, 'Beverages', '/images/All/chocolate-shake.png', TRUE),
('Ice Cream Shake - Strawberry', 'Creamy strawberry milkshake with real strawberry pieces and whipped cream', 38.00, 'Beverages', '/images/All/strawberry-shake.png', TRUE)
ON CONFLICT DO NOTHING;

-- ============================================================
-- BREAKFAST
-- ============================================================
INSERT INTO menu_items (name, description, price, category, image_url, available) VALUES
('Scrambled Eggs', 'Fluffy scrambled eggs with chives, served with toast', 35.00, 'Breakfast', '/images/All/scrumbledegg.jpg', TRUE),
('Breakfast Sandwich', 'Egg and cheese sandwich with your choice of bacon or sausage', 40.00, 'Breakfast', '/images/All/Sandwitch.jpg', TRUE),
('Oatmeal', 'Steel-cut oatmeal served with brown sugar, raisins, and fresh fruit', 30.00, 'Breakfast', '/images/All/oats.jpg', TRUE),
('Breakfast Platter', 'Two eggs any style, bacon or sausage, toast, and fresh fruit', 55.00, 'Breakfast', '/images/All/Sandwitch.jpg', TRUE)
ON CONFLICT DO NOTHING;

-- ============================================================
-- MEALS
-- ============================================================
INSERT INTO menu_items (name, description, price, category, image_url, available) VALUES
('Macaroni & Cheese', 'Creamy homemade mac and cheese with a crispy top layer', 45.00, 'Meals', '/images/All/macaronindcheese.jpg', TRUE),
('Hamburger', 'Fresh grilled beef patty with lettuce, tomato, and special sauce', 45.00, 'Meals', '/images/All/hampburger.jpg', TRUE),
('Margherita Pizza', 'Classic margherita pizza with fresh mozzarella and basil', 55.00, 'Meals', '/images/All/pizza.jpg', TRUE),
('Beef Burger & Fries', 'Juicy beef burger with lettuce, cheese, and a side of crispy fries', 60.00, 'Meals', '/images/All/beefburger.jpg', TRUE)
ON CONFLICT DO NOTHING;

-- ============================================================
-- SPECIALS
-- ============================================================
INSERT INTO menu_items (name, description, price, category, image_url, available) VALUES
('Weekend Breakfast Bundle', 'Enjoy our breakfast platter with fresh orange juice and coffee for a special price', 70.00, 'Specials', '/images/All/breakfast-bundle.png', TRUE),
('Student Meal Deal', 'Hamburger, fries, and soft drink at a discounted price with valid student ID', 50.00, 'Specials', '/images/All/student-meal.png', TRUE),
('Family Dinner Package', 'Feeds 4: Choice of 2 large pizzas, 4 soft drinks, and a chocolate cake', 200.00, 'Specials', '/images/All/family-dinner.png', TRUE),
('Vegetarian Combo', 'Veggie burger with sweet potato fries and a fresh fruit smoothie', 75.00, 'Specials', '/images/All/vegetarian-combo.png', TRUE),
('Chef''s Special', 'Changing weekly: Ask your server about our chef''s special of the week', 65.00, 'Specials', '/images/All/chefs-special.png', TRUE)
ON CONFLICT DO NOTHING;

-- ============================================================
-- TREATS
-- ============================================================
INSERT INTO menu_items (name, description, price, category, image_url, available) VALUES
('Choc Cake', 'Rich chocolate cake with ganache frosting and decorative piping', 35.00, 'Treats', '/images/All/chocolate_cake.jpg', TRUE),
('Eet-Sum-Mor', 'Baker''s Eet-Sum-Mor Original Shortbread Biscuits made with quality ingredients', 18.50, 'Treats', '/images/All/eat_sum_more.jpg', TRUE),
('Choc Chip Biscuits', 'Baker''s Eet-Sum-Mor Chocolate Chip Shortbread Biscuits with 11% chocolate chips', 19.50, 'Treats', '/images/All/eat_sum_more_chocolate.jpg', TRUE),
('Custard Creams', 'Baker''s Topper Custard Flavoured Cream Biscuits, 125g pack', 15.90, 'Treats', '/images/All/toppers_custard.jpg', TRUE),
('Mint Choc Biscuits', 'Baker''s Topper Mint Chocolate Cream Biscuits, 125g pack', 16.90, 'Treats', '/images/All/toppers_mint.jpg', TRUE),
('Vanilla Creams', 'Baker''s Topper Vanilla Flavoured Cream Biscuits, 125g pack', 15.90, 'Treats', '/images/All/topper_vanilla.jpg', TRUE),
('Sour Cream & Onion Chips', 'Lay''s Sour Cream & Onion Flavored Potato Chips', 12.90, 'Treats', '/images/All/lays.jpg', TRUE),
('All Dressed Chips', 'Lay''s All Dressed Potato Chips with a combination of savory, tangy and sweet flavors', 12.90, 'Treats', '/images/All/lays_alldressed_potato.jpg', TRUE),
('BBQ Chips', 'Lay''s Barbecue Flavored Potato Chips with smoky BBQ seasoning', 12.90, 'Treats', '/images/All/lays_bbq.jpg', TRUE),
('Classic Chips', 'Lay''s Classic Potato Chips - Simple, crispy potato chips with salt', 12.90, 'Treats', '/images/All/lays_classic.jpg', TRUE),
('5 Star Bar', 'Cadbury 5 Star Chocolate Bar, 48.5g', 9.90, 'Treats', '/images/All/chocolate_5star.png', TRUE),
('Astros Candy', 'Cadbury Astros Candy and Chocolate Coated Biscuit Bites, 40g', 15.50, 'Treats', '/images/All/astros_candy.png', TRUE),
('Dairy Milk', 'Cadbury Dairy Milk Chocolate Bar, 150g', 22.00, 'Treats', '/images/All/chocolate.png', TRUE),
('Lunch Bar', 'Cadbury Lunch Bar Chocolate with peanuts and rice crisps, 48g', 15.00, 'Treats', '/images/All/lunchbar.png', TRUE),
('Lunch Bar Dream', 'Cadbury Lunch Bar Dream white chocolate version, 48g', 15.00, 'Treats', '/images/All/lunchbar_dream.png', TRUE),
('PS Chocolate', 'Cadbury PS Milk Chocolate Bar, 48g', 12.00, 'Treats', '/images/All/ps_chocolate.png', TRUE),
('Wine Gums', 'Beacon Maynards Original Wine Gums, fruity flavored gummies, 100g', 14.00, 'Treats', '/images/All/maynards.png', TRUE),
('Mint Smoothies', 'Beacon Smoothies Mint Flavored Candy, 288g pack', 15.00, 'Treats', '/images/All/smoothies.png', TRUE)
ON CONFLICT DO NOTHING;

-- ============================================================
-- VEGETARIAN
-- ============================================================
INSERT INTO menu_items (name, description, price, category, image_url, available) VALUES
('Vegetable Stir Fry', 'Fresh vegetables stir-fried with ginger, garlic, and soy sauce, served with rice', 45.00, 'Vegetarian', '/images/All/vegetable-stir-fry.png', TRUE),
('Veggie Burger', 'Plant-based burger patty with lettuce, tomato, onion, and vegan mayo, served with sweet potato fries', 50.00, 'Vegetarian', '/images/All/veggie-burger.png', TRUE),
('Mushroom Risotto', 'Creamy risotto with sautéed mushrooms, parmesan cheese, and fresh herbs', 55.00, 'Vegetarian', '/images/All/mushrooms.jpg', TRUE),
('Mediterranean Platter', 'Falafel, hummus, tabbouleh, olives, and pita bread', 60.00, 'Vegetarian', '/images/All/mediterranean-platter.png', TRUE),
('Vegetable Curry', 'Mixed vegetable curry with coconut milk and aromatic spices, served with basmati rice', 50.00, 'Vegetarian', '/images/All/vegetable-curry.png', TRUE),
('Eggplant Parmesan', 'Baked eggplant with tomato sauce, mozzarella, and parmesan cheese, served with garlic bread', 48.00, 'Vegetarian', '/images/All/eggplant-parmesan.png', TRUE),
('Falafel Wrap', 'Crispy falafel with tahini sauce, lettuce, tomato, and cucumber in a whole wheat wrap', 40.00, 'Vegetarian', '/images/All/falafel-wrap.png', TRUE)
ON CONFLICT DO NOTHING;

-- ============================================================
-- Verification queries
-- ============================================================
SELECT 'Database setup verification' AS message;

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
    COALESCE(SUM(total_amount), 0) as revenue_today
FROM orders 
WHERE created_at::date = CURRENT_DATE;

-- Total menu items
SELECT COUNT(*) as total_menu_items FROM menu_items WHERE available = TRUE;
