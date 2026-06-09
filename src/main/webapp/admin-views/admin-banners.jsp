<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    .ban-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; }
    .ban-header h2 { font-weight: 800; font-size: 24px; color: var(--unity-black); margin: 0; }

    .u-card { background: var(--white); border-radius: 24px; padding: 32px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); margin-bottom: 32px; }
    .card-title { font-weight: 800; font-size: 18px; color: var(--unity-black); margin-bottom: 24px; display: flex; align-items: center; gap: 12px; }

    .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px; }
    .u-group { margin-bottom: 24px; }
    .u-group label { display: block; font-weight: 700; font-size: 11px; color: var(--unity-gray); margin-bottom: 8px; text-transform: uppercase; }
    .u-input, .u-select {
        width: 100%; background: var(--unity-bg); border: 2px solid transparent; padding: 14px 16px;
        border-radius: 12px; font-family: inherit; font-weight: 600; outline: none; transition: 0.2s;
    }
    .u-input:focus, .u-select:focus { border-color: var(--unity-primary); background: var(--white); }

    .btn-unity {
        padding: 14px 28px; border-radius: 12px; font-weight: 700; font-size: 14px;
        border: none; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-primary { background: var(--unity-primary); color: #fff; }

    .u-table { width: 100%; border-collapse: collapse; }
    .u-table th { text-align: left; padding: 16px 20px; color: var(--unity-gray); font-weight: 600; font-size: 12px; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
    .u-table td { padding: 20px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 14px; }
    
    .ban-img { width: 120px; height: 60px; border-radius: 10px; object-fit: cover; background: #eee; }
    
    .status-badge { padding: 6px 12px; border-radius: 8px; font-weight: 700; font-size: 12px; }
    .status-active { background: rgba(127, 186, 122, 0.15); color: var(--unity-green); }
    .status-inactive { background: rgba(128, 129, 145, 0.1); color: var(--unity-gray); }

    .btn-icon {
        width: 36px; height: 36px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center;
        background: var(--unity-bg); color: var(--unity-gray); border: none; cursor: pointer; transition: 0.2s; text-decoration: none;
    }
    .btn-icon:hover { background: var(--unity-primary); color: #fff; }
</style>

<div class="ban-header">
    <h2>Quản lý Banner</h2>
</div>

<div class="u-card">
    <div class="card-title">
        <i class="fa-solid ${banner.id > 0 ? 'fa-pen-to-square' : 'fa-image'}" style="color: var(--unity-primary);"></i>
        ${banner.id > 0 ? 'Cập nhật banner' : 'Thêm banner mới'}
    </div>
    <form action="${pageContext.request.contextPath}/admin/banners" method="post">
        <input type="hidden" name="id" value="${banner.id}"/>
        <div class="form-grid">
            <div class="u-group">
                <label>Tiêu đề banner</label>
                <input type="text" name="title" value="${banner.title}" class="u-input" required placeholder="Nhập tiêu đề...">
            </div>
            <div class="u-group">
                <label>URL liên kết (Link)</label>
                <input type="text" name="linkUrl" value="${banner.linkUrl}" class="u-input" placeholder="vd: /collection/new-arrival">
            </div>
            <div class="u-group">
                <label>URL Hình ảnh</label>
                <input type="text" name="imgUrl" value="${banner.imgUrl}" class="u-input" placeholder="https://...">
            </div>
            <div class="u-group">
                <label>Vị trí hiển thị</label>
                <input type="text" name="position" value="${banner.position}" class="u-input" placeholder="vd: HOME_TOP">
            </div>
            <div class="u-group">
                <label>Thứ tự ưu tiên</label>
                <input type="number" name="sortOrder" value="${banner.sortOrder}" class="u-input" min="0">
            </div>
            <div class="u-group">
                <label>Trạng thái</label>
                <select name="active" class="u-select">
                    <option value="true" ${empty banner || banner.active ? 'selected' : ''}>Hoạt động (Active)</option>
                    <option value="false" ${not empty banner && !banner.active ? 'selected' : ''}>Tạm ẩn (Inactive)</option>
                </select>
            </div>
            <div class="u-group">
                <label>Ngày bắt đầu</label>
                <input type="datetime-local" name="startDate" value="${banner.startDateInput}" class="u-input">
            </div>
            <div class="u-group">
                <label>Ngày kết thúc</label>
                <input type="datetime-local" name="endDate" value="${banner.endDateInput}" class="u-input">
            </div>
        </div>
        <div style="display: flex; justify-content: flex-end; gap: 16px;">
            <c:if test="${banner.id > 0}">
                <a href="${pageContext.request.contextPath}/admin/banners" class="btn-unity" style="background: var(--unity-bg); color: var(--unity-gray); text-decoration: none;">Hủy</a>
            </c:if>
            <button type="submit" class="btn-unity btn-primary">
                <i class="fa-solid fa-save"></i> ${banner.id > 0 ? 'Cập nhật' : 'Thêm banner'}
            </button>
        </div>
    </form>
</div>

<div class="u-card" style="padding: 24px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; padding: 0 8px;">
        <div style="font-weight: 800; font-size: 16px;">Danh sách Banner</div>
        <div style="display: flex; gap: 12px;">
            <input type="text" id="banFilter" placeholder="Tìm kiếm nhanh..." style="background: var(--unity-bg); border: none; padding: 10px 16px; border-radius: 10px; font-size: 13px; outline: none; width: 200px;">
        </div>
    </div>

    <table class="u-table">
        <thead>
            <tr>
                <th style="width: 50px;">ID</th>
                <th>Ảnh xem trước</th>
                <th>Thông tin banner</th>
                <th>Vị trí / Thứ tự</th>
                <th>Trạng thái</th>
                <th>Thời gian chạy</th>
                <th style="text-align: right;">Thao tác</th>
            </tr>
        </thead>
        <tbody id="banTableBody">
            <c:forEach var="b" items="${banners}">
                <tr>
                    <td style="font-weight: 700; color: var(--unity-gray);">#${b.id}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty b.imgUrl && fn:startsWith(b.imgUrl, 'http')}">
                                <img src="${b.imgUrl}" class="ban-img" onerror="this.src='https://placehold.co/400x200?text=Banner'">
                            </c:when>
                            <c:when test="${not empty b.imgUrl}">
                                <img src="${pageContext.request.contextPath}${b.imgUrl}" class="ban-img" onerror="this.src='https://placehold.co/400x200?text=Banner'">
                            </c:when>
                            <c:otherwise>
                                <img src="https://placehold.co/400x200?text=Banner" class="ban-img">
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div style="font-weight: 700; color: var(--unity-black);">${b.title}</div>
                        <div style="font-size: 12px; color: var(--unity-blue); margin-top: 2px; overflow: hidden; text-overflow: ellipsis; max-width: 150px; white-space: nowrap;">${b.linkUrl}</div>
                    </td>
                    <td>
                        <div style="font-weight: 600; font-size: 13px;">${b.position}</div>
                        <div style="font-size: 11px; color: var(--unity-gray); font-weight: 700;">ORDER: ${b.sortOrder}</div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${b.active}">
                                <span class="status-badge status-active">● Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-inactive">● Hidden</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="font-size: 12px; color: var(--unity-gray); line-height: 1.4;">
                        <div>Từ: ${b.startDateInput}</div>
                        <div>Đến: ${b.endDateInput}</div>
                    </td>
                    <td style="text-align: right;">
                        <div style="display: flex; gap: 8px; justify-content: flex-end;">
                            <a href="${pageContext.request.contextPath}/admin/banners?edit=${b.id}" class="btn-icon" title="Sửa"><i class="fa-solid fa-pen"></i></a>
                            <a href="${pageContext.request.contextPath}/admin/banners?delete=${b.id}" class="btn-icon" title="Xóa" style="color: #FF7675;" onclick="return confirm('Xóa banner này?')"><i class="fa-solid fa-trash"></i></a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty banners}">
                <tr><td colspan="7" style="text-align: center; padding: 48px; color: var(--unity-gray); font-style: italic;">Chưa có banner nào</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<script>
    document.getElementById('banFilter').addEventListener('keyup', function() {
        let val = this.value.toLowerCase();
        let rows = document.querySelectorAll('#banTableBody tr');
        rows.forEach(row => {
            let text = row.innerText.toLowerCase();
            row.style.display = text.includes(val) ? '' : 'none';
        });
    });
</script>
