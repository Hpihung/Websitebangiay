<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .acc-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; }
    .acc-header h2 { font-weight: 800; font-size: 24px; color: var(--unity-black); margin: 0; }

    .u-card { background: var(--white); border-radius: 24px; padding: 32px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); margin-bottom: 32px; }
    .card-title { font-weight: 800; font-size: 18px; color: var(--unity-black); margin-bottom: 24px; display: flex; align-items: center; gap: 12px; }

    .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
    .u-group { margin-bottom: 0; }
    .u-group label { display: block; font-weight: 700; font-size: 11px; color: var(--unity-gray); margin-bottom: 8px; text-transform: uppercase; }
    .u-group input, .u-group select {
        width: 100%; background: var(--unity-bg); border: 2px solid transparent; padding: 14px 16px;
        border-radius: 12px; font-family: inherit; font-weight: 600; outline: none; transition: 0.2s;
    }
    .u-group input:focus { border-color: var(--unity-primary); background: var(--white); }

    .btn-unity {
        padding: 14px 28px; border-radius: 12px; font-weight: 700; font-size: 14px;
        border: none; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-primary { background: var(--unity-primary); color: #fff; }
    
    .u-table { width: 100%; border-collapse: collapse; }
    .u-table th { text-align: left; padding: 16px 20px; color: var(--unity-gray); font-weight: 600; font-size: 13px; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
    .u-table td { padding: 20px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 14px; }
    
    .role-badge { padding: 4px 10px; border-radius: 6px; font-weight: 800; font-size: 11px; text-transform: uppercase; }
    .role-admin { background: rgba(108, 93, 211, 0.1); color: var(--unity-primary); }
    .role-user { background: rgba(128, 129, 145, 0.1); color: var(--unity-gray); }
    .role-shipper { background: rgba(255, 117, 76, 0.1); color: #FF754C; }

    .status-dot { width: 8px; height: 8px; border-radius: 50%; display: inline-block; margin-right: 8px; }
    .status-active { background: var(--unity-green); }
    .status-inactive { background: #FF7675; }

    .btn-action {
        width: 36px; height: 36px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center;
        background: var(--unity-bg); color: var(--unity-gray); transition: 0.2s; border: none; cursor: pointer; text-decoration: none;
    }
    .btn-action:hover { background: var(--unity-primary); color: #fff; }
</style>

<div class="acc-header">
    <h2>Quản lý tài khoản</h2>
</div>

<div class="u-card">
    <div class="card-title">
        <i class="fa-solid fa-user-pen" style="color: var(--unity-primary);"></i>
        <c:choose>
            <c:when test="${empty user.id}">Tạo tài khoản mới</c:when>
            <c:otherwise>Chỉnh sửa tài khoản #${user.id}</c:otherwise>
        </c:choose>
    </div>
    <form action="${pageContext.request.contextPath}/admin/accounts" method="post">
        <input type="hidden" name="id" value="${user.id}"/>
        <div class="form-grid">
            <div class="u-group">
                <label>Họ và tên</label>
                <input type="text" name="full_name" value="${user.fullName}" required placeholder="Nguyễn Văn A">
            </div>
            <div class="u-group">
                <label>Email liên hệ</label>
                <input type="email" name="email" value="${user.email}" required placeholder="example@mail.com">
            </div>
            <div class="u-group">
                <label>Mật khẩu</label>
                <input type="password" name="password" 
                       placeholder="${user.id == null ? 'Nhập mật khẩu' : 'Để trống nếu giữ nguyên'}"
                       ${user.id == null ? 'required' : ''}>
            </div>
            <div class="u-group">
                <label>Số điện thoại</label>
                <input type="text" name="phone_number" value="${user.phoneNumber}" placeholder="0901234567">
            </div>
            <div class="u-group">
                <label>Vai trò (Role)</label>
                <select name="role">
                    <option value="user" ${user.role == 'user' ? 'selected' : ''}>User (Khách)</option>
                    <option value="admin" ${user.role == 'admin' ? 'selected' : ''}>Admin (Quản trị)</option>
                    <option value="SHIPPER" ${user.role == 'SHIPPER' ? 'selected' : ''}>Shipper (Giao hàng)</option>
                </select>
            </div>
            <div class="u-group">
                <label>Trạng thái</label>
                <select name="is_active">
                    <option value="true" ${user.active ? 'selected' : ''}>Hoạt động</option>
                    <option value="false" ${!user.active ? 'selected' : ''}>Bị khóa</option>
                </select>
            </div>
        </div>
        <div style="margin-top: 32px; display: flex; justify-content: flex-end; gap: 16px;">
            <c:if test="${user.id != null}">
                <a href="${pageContext.request.contextPath}/admin/accounts" class="btn-unity" style="background: var(--unity-bg); color: var(--unity-gray); text-decoration: none;">Hủy bỏ</a>
            </c:if>
            <button type="submit" class="btn-unity btn-primary">
                <i class="fa-solid fa-save"></i> ${user.id == null ? "Thêm mới" : "Cập nhật tài khoản"}
            </button>
        </div>
    </form>
</div>

<div class="u-card" style="padding: 24px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; padding: 0 8px;">
        <div style="font-weight: 800; font-size: 16px;">Danh sách người dùng</div>
        <div style="display: flex; gap: 12px;">
            <input type="text" id="accFilter" placeholder="Tìm kiếm nhanh..." style="background: var(--unity-bg); border: none; padding: 10px 16px; border-radius: 10px; font-size: 13px; outline: none; width: 250px;">
        </div>
    </div>
    
    <table class="u-table">
        <thead>
            <tr>
                <th style="width: 50px;">ID</th>
                <th>Thông tin người dùng</th>
                <th>Số điện thoại</th>
                <th>Vai trò</th>
                <th>Trạng thái</th>
                <th>Ngày tạo</th>
                <th style="text-align: right;">Thao tác</th>
            </tr>
        </thead>
        <tbody id="accTableBody">
            <c:forEach var="u" items="${users}">
                <tr>
                    <td style="font-weight: 700; color: var(--unity-gray);">#${u.id}</td>
                    <td>
                        <div style="font-weight: 700; color: var(--unity-black);">${u.fullName}</div>
                        <div style="font-size: 12px; color: var(--unity-gray); margin-top: 2px;">${u.email}</div>
                    </td>
                    <td style="font-weight: 600;">${u.phoneNumber}</td>
                    <td>
                        <c:set var="roleClass" value="role-user" />
                        <c:if test="${u.role.toLowerCase() == 'admin'}"><c:set var="roleClass" value="role-admin" /></c:if>
                        <c:if test="${u.role.toLowerCase() == 'shipper'}"><c:set var="roleClass" value="role-shipper" /></c:if>
                        <span class="role-badge ${roleClass}">${u.role}</span>
                    </td>
                    <td>
                        <div style="display: flex; align-items: center; font-weight: 700; font-size: 13px; color: ${u.active ? 'var(--unity-green)' : '#FF7675'}">
                            <span class="status-dot ${u.active ? 'status-active' : 'status-inactive'}"></span>
                            ${u.active ? 'Active' : 'Locked'}
                        </div>
                    </td>
                    <td style="color: var(--unity-gray); font-weight: 500;">${u.createdAt}</td>
                    <td style="text-align: right;">
                        <div style="display: flex; gap: 8px; justify-content: flex-end;">
                            <a href="${pageContext.request.contextPath}/admin/accounts?user=${u.id}" class="btn-action" title="Chỉnh sửa"><i class="fa-solid fa-pen"></i></a>
                            <a href="${pageContext.request.contextPath}/admin/accounts?delete=${u.id}" class="btn-action" title="Xóa" onclick="return confirm('Xóa tài khoản này?')"><i class="fa-solid fa-trash"></i></a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty users}">
                <tr><td colspan="7" style="text-align: center; padding: 48px; color: var(--unity-gray); font-style: italic;">Chưa có tài khoản nào được tạo</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<script>
    document.getElementById('accFilter').addEventListener('keyup', function() {
        let val = this.value.toLowerCase();
        let rows = document.querySelectorAll('#accTableBody tr');
        rows.forEach(row => {
            let text = row.innerText.toLowerCase();
            row.style.display = text.includes(val) ? '' : 'none';
        });
    });
</script>