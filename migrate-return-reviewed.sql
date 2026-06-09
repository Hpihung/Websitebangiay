-- Migration: Add return_reason and reviewed columns to orders table
-- Run this script ONCE against your database

ALTER TABLE orders
    ADD COLUMN return_reason VARCHAR(500) DEFAULT NULL COMMENT 'Ly do khach hoan hang',
    ADD COLUMN reviewed TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 = da danh gia';
