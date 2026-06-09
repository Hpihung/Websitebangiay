<%@ page import="dao.JDBIConnector" %>
<%@ page import="org.jdbi.v3.core.Jdbi" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Jdbi jdbi = JDBIConnector.getJdbi();
    try {
        jdbi.useHandle(handle -> {
            try { handle.execute("ALTER TABLE orders ADD COLUMN tracking_code VARCHAR(100)"); } catch (Exception e) {}
            try { handle.execute("ALTER TABLE orders ADD COLUMN shipping_unit VARCHAR(100)"); } catch (Exception e) {}
            try { handle.execute("ALTER TABLE orders ADD COLUMN processed_by VARCHAR(100)"); } catch (Exception e) {}
            
            handle.execute("UPDATE orders SET order_status = 'PENDING' WHERE order_status = 'NEW'");
            handle.execute("UPDATE orders SET order_status = 'CONFIRMED' WHERE order_status = 'PROCESSING'");
            handle.execute("UPDATE orders SET order_status = 'SHIPPING' WHERE order_status = 'DELIVERED'");
        });
        out.print("Migration successful! Status updated to PENDING/CONFIRMED/SHIPPING.");
    } catch (Exception e) {
        out.print("Error: " + e.getMessage());
    }
%>
