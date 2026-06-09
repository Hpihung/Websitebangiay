-- Table structure for coupon_products
CREATE TABLE IF NOT EXISTS `coupon_products` (
  `coupon_id` int UNSIGNED NOT NULL,
  `product_id` int UNSIGNED NOT NULL,
  PRIMARY KEY (`coupon_id`, `product_id`),
  FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
