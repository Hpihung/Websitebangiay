<%@ page import="dao.JDBIConnector" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Database Migration - Reviews</title>
</head>
<body>
<%
    try {
        JDBIConnector.getJdbi().useHandle(handle -> {
            handle.execute("CREATE TABLE IF NOT EXISTS reviews (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY," +
                    "user_id INT NOT NULL," +
                    "product_id INT NOT NULL," +
                    "order_id INT NOT NULL," +
                    "rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5)," +
                    "comment TEXT," +
                    "image_url VARCHAR(255)," +
                    "seller_service_rating INT," +
                    "delivery_speed_rating INT," +
                    "driver_rating INT," +
                    "is_anonymous BOOLEAN DEFAULT FALSE," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")");
        });
        out.println("<h2>Migration successful! Bảng reviews đã được tạo.</h2>");
    } catch (Exception e) {
        out.println("<h2>Error during migration:</h2>");
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
</body>
</html>
