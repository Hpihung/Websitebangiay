<%@ page import="dao.JDBIConnector" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    JDBIConnector.getJdbi().useHandle(handle -> {
        // Fix all null payment methods to COD and if COMPLETED -> PAID
        handle.execute("UPDATE orders SET payment_method = 'COD' WHERE payment_method IS NULL");
        handle.execute("UPDATE orders SET payment_status = 'PAID' WHERE payment_method = 'COD' AND order_status = 'COMPLETED'");
    });
    out.println("<h2>Đã tự động fix dữ liệu đơn #32 và các đơn cũ!</h2>");
%>
