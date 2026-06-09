USE ltw_sportshoess;
ALTER TABLE orders ADD COLUMN tracking_code VARCHAR(100);
ALTER TABLE orders ADD COLUMN shipping_unit VARCHAR(100);
ALTER TABLE orders ADD COLUMN processed_by VARCHAR(100);

UPDATE orders SET order_status = 'PENDING' WHERE order_status = 'NEW';
UPDATE orders SET order_status = 'CONFIRMED' WHERE order_status = 'PROCESSING';
UPDATE orders SET order_status = 'SHIPPING' WHERE order_status = 'DELIVERED';
