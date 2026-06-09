-- ----------------------------
-- Table structure for coupons
-- ----------------------------
DROP TABLE IF EXISTS `coupons`;
CREATE TABLE `coupons` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL,
  `discount_type` enum('PERCENTAGE', 'FIXED_AMOUNT') NOT NULL,
  `discount_value` decimal(10, 2) NOT NULL,
  `min_order_value` decimal(10, 2) DEFAULT 0,
  `max_discount_amount` decimal(10, 2) DEFAULT NULL,
  `usage_limit` int DEFAULT NULL,
  `used_count` int DEFAULT 0,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_coupon_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Table structure for coupon_usages
-- ----------------------------
DROP TABLE IF EXISTS `coupon_usages`;
CREATE TABLE `coupon_usages` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `coupon_id` int UNSIGNED NOT NULL,
  `user_id` int UNSIGNED NOT NULL,
  `order_id` int UNSIGNED NOT NULL,
  `used_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Sample Data
INSERT INTO `coupons` (`code`, `discount_type`, `discount_value`, `min_order_value`, `usage_limit`, `start_date`, `end_date`)
VALUES ('HELLO2026', 'PERCENTAGE', 10, 500000, 100, '2026-01-01 00:00:00', '2026-12-31 23:59:59'),
       ('HM50K', 'FIXED_AMOUNT', 50000, 200000, 50, '2026-01-01 00:00:00', '2026-12-31 23:59:59');
