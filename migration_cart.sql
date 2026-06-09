-- ============================================================
-- PHASE 1: Cart Persistence Migration
-- Database: ltw_sportshoess
-- Run this script ONCE before deploying Phase 1 code
-- ============================================================

-- 1. Tạo bảng cart lưu giỏ hàng theo user
CREATE TABLE IF NOT EXISTS cart (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    product_id  INT NOT NULL,
    color_id    INT NOT NULL,
    size_id     INT NOT NULL,
    quantity    INT NOT NULL DEFAULT 1,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_cart_item (user_id, product_id, color_id, size_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
