USE ltw_sportshoess;

-- Add new tracking columns for Orders
ALTER TABLE orders ADD COLUMN cancelled_at DATETIME NULL;
ALTER TABLE orders ADD COLUMN delivered_at DATETIME NULL;
ALTER TABLE orders ADD COLUMN received_at DATETIME NULL;
ALTER TABLE orders ADD COLUMN shipper_id BIGINT NULL;

-- If not already present
-- ALTER TABLE orders ADD COLUMN cancel_reason TEXT NULL;

-- Add new Reviews table
CREATE TABLE reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    status VARCHAR(50) DEFAULT 'VISIBLE',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Add Order Status History table
CREATE TABLE order_status_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    note TEXT,
    created_by VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- Update existing order statuses to the new ENUM-like format
UPDATE orders SET order_status = 'ORDER_PENDING' WHERE order_status = 'PENDING';
UPDATE orders SET order_status = 'ORDER_CONFIRMED' WHERE order_status = 'CONFIRMED';
UPDATE orders SET order_status = 'ORDER_SHIPPING' WHERE order_status = 'SHIPPING';
UPDATE orders SET order_status = 'ORDER_CANCELLED' WHERE order_status = 'CANCELLED';
UPDATE orders SET order_status = 'ORDER_DELIVERED' WHERE order_status = 'DELIVERED';
UPDATE orders SET order_status = 'ORDER_COMPLETED' WHERE order_status = 'COMPLETED';
