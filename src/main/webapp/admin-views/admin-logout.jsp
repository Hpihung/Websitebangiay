<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="admin-header">
    <h2>Đăng xuất</h2>
</div>

<div class="logout-box">
    <p class="logout-text">Bạn có chắc chắn muốn thoát khỏi trang quản trị?</p>

    <div class="logout-actions">
        <%--    CONFIRM LOGOUT    --%>
        <form method="post" action="${pageContext.request.contextPath}/admin/logout">
            <button type="submit" class="btn-logout btn-yes">
                <i class="fa fa-sign-out-alt"></i> Đăng xuất
            </button>
        </form>

        <%--    RENDER TO DASHBOARD    --%>
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="btn-logout btn-no">
            Quay lại
        </a>
    </div>
</div>
