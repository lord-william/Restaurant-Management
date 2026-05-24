-- Alter the orders table to add additional fields needed for the cart functionality
USE restaurant_management;

-- Add delivery-related fields and payment details to orders table
ALTER TABLE orders 
ADD COLUMN subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0 AFTER user_id,
ADD COLUMN service_fee DECIMAL(10, 2) NOT NULL DEFAULT 0 AFTER subtotal,
ADD COLUMN delivery_fee DECIMAL(10, 2) NOT NULL DEFAULT 0 AFTER service_fee,
ADD COLUMN is_delivery BOOLEAN NOT NULL DEFAULT FALSE AFTER total_amount,
ADD COLUMN delivery_address VARCHAR(255) NULL AFTER is_delivery,
MODIFY COLUMN status ENUM('pending', 'processing', 'completed', 'cancelled', 'paid') NOT NULL DEFAULT 'pending';

-- Add flavor and item_name fields to order_items table
ALTER TABLE order_items
ADD COLUMN item_name VARCHAR(100) NOT NULL AFTER menu_item_id,
ADD COLUMN flavor VARCHAR(100) NULL AFTER price;

-- Create index for better performance when querying orders by date
CREATE INDEX IF NOT EXISTS idx_order_date ON orders(created_at);
