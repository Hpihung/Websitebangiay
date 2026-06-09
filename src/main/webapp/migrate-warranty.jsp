<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.JDBIConnector" %>
<%@ page import="org.jdbi.v3.core.Handle" %>
<%
    try (Handle handle = JDBIConnector.getJdbi().open()) {
        String sql = "CREATE TABLE IF NOT EXISTS warranty_requests (" +
                     "id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, " +
                     "user_id INT UNSIGNED NOT NULL, " +
                     "order_id INT UNSIGNED NOT NULL, " +
                     "product_id INT UNSIGNED NOT NULL, " +
                     "reason VARCHAR(255), " +
                     "description TEXT, " +
                     "image_url VARCHAR(500), " +
                     "status VARCHAR(50) DEFAULT 'PENDING', " +
                     "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                     "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, " +
                     "request_type VARCHAR(50) DEFAULT 'EXCHANGE', " +
                     "exchange_size VARCHAR(50), " +
                     "refund_bank_name VARCHAR(100), " +
                     "refund_account_number VARCHAR(100), " +
                     "refund_account_holder VARCHAR(100), " +
                     "return_method VARCHAR(50) DEFAULT 'PICKUP', " +
                     "pickup_address VARCHAR(500), " +
                     "pickup_phone VARCHAR(50), " +
                     "FOREIGN KEY (user_id) REFERENCES users(id), " +
                     "FOREIGN KEY (order_id) REFERENCES orders(id), " +
                     "FOREIGN KEY (product_id) REFERENCES product(id)" +
                     ")";
        handle.execute(sql);

        // Safe alters if the table already exists
        try {
            handle.execute("ALTER TABLE warranty_requests ADD COLUMN request_type VARCHAR(50) DEFAULT 'EXCHANGE'");
        } catch (Exception ignored) {}
        try {
            handle.execute("ALTER TABLE warranty_requests ADD COLUMN exchange_size VARCHAR(50)");
        } catch (Exception ignored) {}
        try {
            handle.execute("ALTER TABLE warranty_requests ADD COLUMN refund_bank_name VARCHAR(100)");
        } catch (Exception ignored) {}
        try {
            handle.execute("ALTER TABLE warranty_requests ADD COLUMN refund_account_number VARCHAR(100)");
        } catch (Exception ignored) {}
        try {
            handle.execute("ALTER TABLE warranty_requests ADD COLUMN refund_account_holder VARCHAR(100)");
        } catch (Exception ignored) {}
        try {
            handle.execute("ALTER TABLE warranty_requests ADD COLUMN return_method VARCHAR(50) DEFAULT 'PICKUP'");
        } catch (Exception ignored) {}
        try {
            handle.execute("ALTER TABLE warranty_requests ADD COLUMN pickup_address VARCHAR(500)");
        } catch (Exception ignored) {}
        try {
            handle.execute("ALTER TABLE warranty_requests ADD COLUMN pickup_phone VARCHAR(50)");
        } catch (Exception ignored) {}

        out.println("Tạo/Cập nhật bảng warranty_requests thành công!");
    } catch (Exception e) {
        out.println("Lỗi: " + e.getMessage());
        e.printStackTrace();
    }
%>
