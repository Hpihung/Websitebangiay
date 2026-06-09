<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    dao.JDBIConnector.getJdbi().useHandle(handle -> {
        handle.createUpdate("UPDATE coupons SET is_active = 1 WHERE is_active = 0")
              .execute();
    });
    out.println("<h2>✅ Tất cả coupon đã được kích hoạt!</h2>");
    out.println("<a href='" + request.getContextPath() + "/admin/coupons'>Quay lại quản lý Coupons</a>");
%>
