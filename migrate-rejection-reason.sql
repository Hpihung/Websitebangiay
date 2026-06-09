-- Migration: Add rejection_reason column to orders table
-- Run this script ONCE against your database

ALTER TABLE orders
    ADD COLUMN rejection_reason VARCHAR(500) DEFAULT NULL COMMENT 'Ly do tu choi hoan hang';
