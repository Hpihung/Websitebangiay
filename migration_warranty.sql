-- Migration: Tạo bảng warranty_requests
-- Chạy script này trong MySQL Workbench hoặc phpMyAdmin

CREATE TABLE IF NOT EXISTS `warranty_requests` (
    `id`          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id`     INT UNSIGNED NOT NULL,
    `order_id`    INT UNSIGNED NOT NULL,
    `product_id`  INT UNSIGNED NOT NULL,
    `reason`      VARCHAR(500) NOT NULL,
    `description` TEXT,
    `image_url`   VARCHAR(1000),
    `status`      ENUM('PENDING','PROCESSING','COMPLETED','REJECTED') DEFAULT 'PENDING',
    `created_at`  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at`  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_wr_user`    FOREIGN KEY (`user_id`)    REFERENCES `users`(`id`)    ON DELETE CASCADE,
    CONSTRAINT `fk_wr_order`   FOREIGN KEY (`order_id`)   REFERENCES `orders`(`id`)   ON DELETE CASCADE,
    CONSTRAINT `fk_wr_product` FOREIGN KEY (`product_id`) REFERENCES `product`(`id`)  ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
