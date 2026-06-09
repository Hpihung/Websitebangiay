<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .coll-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; }
    .coll-header h2 { font-weight: 800; font-size: 24px; color: var(--unity-black); margin: 0; }

    .u-card { background: var(--white); border-radius: 24px; padding: 32px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); margin-bottom: 32px; }
    .card-title { font-weight: 800; font-size: 18px; color: var(--unity-black); margin-bottom: 24px; display: flex; align-items: center; gap: 12px; }

    .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 24px; }
    .u-group { margin-bottom: 0; }
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

    /* Custom Checkbox/Switch */
    .switch-container { display: flex; align-items: center; gap: 12px; margin-top: 10px; cursor: pointer; }
    .switch {
        position: relative; display: inline-block; width: 44px; height: 24px;
    }
    .switch input { opacity: 0; width: 0; height: 0; }
    .slider {
        position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0;
        background-color: #E4E4E4; transition: .4s; border-radius: 24px;
    }
    .slider:before {
        position: absolute; content: ""; height: 18px; width: 18px; left: 3px; bottom: 3px;
        background-color: white; transition: .4s; border-radius: 50%;
    }
    input:checked + .slider { background-color: var(--unity-primary); }
    input:checked + .slider:before { transform: translateX(20px); }

    .u-table { width: 100%; border-collapse: collapse; }
    .u-table th { text-align: left; padding: 16px 20px; color: var(--unity-gray); font-weight: 600; font-size: 12px; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
    .u-table td { padding: 20px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 14px; }
    
    .status-badge { padding: 6px 12px; border-radius: 8px; font-weight: 700; font-size: 12px; }
    .status-active { background: rgba(127, 186, 122, 0.15); color: var(--unity-green); }
    .status-inactive { background: rgba(128, 129, 145, 0.1); color: var(--unity-gray); }

    .btn-icon {
        width: 36px; height: 36px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center;
        background: var(--unity-bg); color: var(--unity-gray); border: none; cursor: pointer; transition: 0.2s; text-decoration: none;
    }
    .btn-icon:hover { background: var(--unity-primary); color: #fff; }
</style>

<div class="coll-header">
    <h2>Quản lý bộ sưu tập (Campaigns)</h2>
</div>

<div class="u-card">
    <div class="card-title">
        <i class="fa-solid ${collection.id > 0 ? 'fa-pen-to-square' : 'fa-folder-plus'}" style="color: var(--unity-primary);"></i>
        ${collection.id > 0 ? 'Cập nhật bộ sưu tập' : 'Thêm bộ sưu tập mới'}
    </div>
    <form action="${pageContext.request.contextPath}/admin/collections" method="post">
        <input type="hidden" name="id" value="${collection.id}">
        <div class="form-grid">
            <div class="u-group">
                <label>Tên bộ sưu tập</label>
                <input type="text" name="name" value="${collection.name}" class="u-input" required placeholder="Tên chiến dịch...">
            </div>
            <div class="u-group">
                <label>Slug (URL thân thiện)</label>
                <input type="text" name="slug" value="${collection.slug}" class="u-input" required placeholder="vd: bo-suu-tap-moi">
            </div>
            <div class="u-group">
                <label>Loại chiến dịch</label>
                <select name="ruleSet" class="u-select">
                    <option value="MANUAL" ${collection.ruleSetType == 'MANUAL' ? 'selected' : ''}>Thủ công (Manual)</option>
                    <option value="AUTO" ${collection.ruleSetType == 'AUTO' ? 'selected' : ''}>Tự động (Automatic)</option>
                </select>
            </div>
            <div class="u-group">
                <label>Trạng thái</label>
                <label class="switch-container">
                    <div class="switch">
                        <input type="checkbox" name="active" ${collection.active ? 'checked' : ''}>
                        <span class="slider"></span>
                    </div>
                    <span style="font-weight: 700; font-size: 14px; color: var(--unity-black);">Hiển thị trên website</span>
                </label>
            </div>
        </div>
        <div style="margin-top: 32px; display: flex; justify-content: flex-end; gap: 16px;">
            <c:if test="${collection.id > 0}">
                <a href="${pageContext.request.contextPath}/admin/collections" class="btn-unity" style="background: var(--unity-bg); color: var(--unity-gray); text-decoration: none;">Hủy</a>
            </c:if>
            <button type="submit" class="btn-unity btn-primary">
                <i class="fa-solid fa-save"></i> ${collection.id > 0 ? 'Lưu thay đổi' : 'Tạo bộ sưu tập'}
            </button>
        </div>
    </form>
</div>

<div class="u-card" style="padding: 24px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; padding: 0 8px;">
        <div style="font-weight: 800; font-size: 16px;">Danh sách bộ sưu tập</div>
        <form method="get" action="${pageContext.request.contextPath}/admin/collections" style="display: flex; gap: 12px;">
            <input type="text" name="name" value="${param.name}" placeholder="Tìm theo tên..." style="background: var(--unity-bg); border: none; padding: 10px 16px; border-radius: 10px; font-size: 13px; outline: none;">
            <button type="submit" class="btn-unity" style="padding: 10px 20px; font-size: 12px; background: var(--unity-primary); color: #fff;">Tìm kiếm</button>
        </form>
    </div>

    <table class="u-table">
        <thead>
            <tr>
                <th style="width: 50px;">ID</th>
                <th>Tên chiến dịch</th>
                <th>Slug / URL</th>
                <th>Loại quy tắc</th>
                <th>Trạng thái</th>
                <th style="text-align: right;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="c" items="${collections}">
                <tr>
                    <td style="font-weight: 700; color: var(--unity-gray);">#${c.id}</td>
                    <td style="font-weight: 700; color: var(--unity-black);">${c.name}</td>
                    <td style="color: var(--unity-blue); font-weight: 600;">/${c.slug}</td>
                    <td>
                        <span style="font-weight: 700; color: var(--unity-gray); font-size: 12px;">${c.ruleSetType}</span>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${c.active}">
                                <span class="status-badge status-active">● Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-inactive">● Hidden</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="text-align: right;">
                        <div style="display: flex; gap: 8px; justify-content: flex-end;">
                            <a href="${pageContext.request.contextPath}/admin/collections?edit=${c.id}" class="btn-icon" title="Sửa"><i class="fa-solid fa-pen"></i></a>
                            <form action="${pageContext.request.contextPath}/admin/collections" method="post" style="margin:0;" onsubmit="return confirm('Xóa bộ sưu tập này?');">
                                <input type="hidden" name="deleteId" value="${c.id}">
                                <button type="submit" class="btn-icon" title="Xóa" style="color: #FF7675;"><i class="fa-solid fa-trash"></i></button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty collections}">
                <tr><td colspan="6" style="text-align: center; padding: 48px; color: var(--unity-gray); font-style: italic;">Chưa có bộ sưu tập nào</td></tr>
            </c:if>
        </tbody>
    </table>
</div>