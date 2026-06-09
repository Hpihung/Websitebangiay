ALTER TABLE `orders`
ADD COLUMN `coupon_id` int UNSIGNED DEFAULT NULL,
ADD COLUMN `discount_amount` decimal(10, 2) DEFAULT 0,
ADD COLUMN `cancel_reason` varchar(255) DEFAULT NULL;

-- Optional: Add foreign key constraint if you want strict referential integrity
-- ALTER TABLE `orders` ADD CONSTRAINT `fk_order_coupon` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE SET NULL;
