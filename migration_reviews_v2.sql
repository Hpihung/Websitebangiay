-- =============================================
-- Migration V2: Review Management System
-- Run this script in your MySQL database
-- =============================================

-- 1. Add status column to reviews (VISIBLE / HIDDEN)
ALTER TABLE reviews
    ADD COLUMN IF NOT EXISTS status VARCHAR(20) NOT NULL DEFAULT 'VISIBLE' AFTER is_anonymous;

-- 2. Create review_replies table
CREATE TABLE IF NOT EXISTS review_replies (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    review_id   INT NOT NULL,
    admin_id    INT NOT NULL,
    content     TEXT NOT NULL,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE
);

-- 3. Create review_reports table
CREATE TABLE IF NOT EXISTS review_reports (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    review_id   INT NOT NULL,
    user_id     INT NOT NULL,
    reason      TEXT,
    created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE
);
