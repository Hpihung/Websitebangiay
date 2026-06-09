<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
    .con-header { margin-bottom: 32px; }
    .con-header h2 { font-weight: 800; font-size: 24px; color: var(--unity-black); margin: 0; }
    .con-header p { color: var(--unity-gray); font-weight: 500; margin-top: 8px; }

    .u-card { background: var(--white); border-radius: 24px; padding: 24px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); }
    
    .u-table { width: 100%; border-collapse: collapse; }
    .u-table th { text-align: left; padding: 16px 20px; color: var(--unity-gray); font-weight: 600; font-size: 12px; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
    .u-table td { padding: 20px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 14px; }
    
    .msg-box { max-width: 350px; background: var(--unity-bg); padding: 16px; border-radius: 14px; font-size: 13px; color: var(--unity-black); line-height: 1.6; border: 1px solid rgba(0,0,0,0.02); }
    
    .sub-badge { background: rgba(108, 93, 211, 0.1); color: var(--unity-primary); padding: 4px 10px; border-radius: 6px; font-weight: 700; font-size: 11px; }

    .btn-icon {
        width: 36px; height: 36px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center;
        background: var(--unity-bg); color: var(--unity-gray); border: none; cursor: pointer; transition: 0.2s;
    }
    .btn-icon:hover { background: #FF7675; color: #fff; }
</style>

<div class="con-header">
    <h2>Lời nhắn khách hàng</h2>
    <p>Quản lý các yêu cầu hỗ trợ và đóng góp ý kiến từ khách hàng qua form liên hệ.</p>
</div>

<div class="u-card">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; padding: 0 8px;">
        <div style="font-weight: 800; font-size: 16px;">Danh sách tin nhắn</div>
        <div style="display: flex; gap: 12px;">
            <input type="text" id="conFilter" placeholder="Tìm kiếm tin nhắn..." style="background: var(--unity-bg); border: none; padding: 10px 16px; border-radius: 10px; font-size: 13px; outline: none; width: 250px;">
        </div>
    </div>

    <table class="u-table">
        <thead>
            <tr>
                <th style="width: 50px;">ID</th>
                <th>Khách hàng</th>
                <th>Chủ đề</th>
                <th>Nội dung lời nhắn</th>
                <th>Ngày gửi</th>
                <th style="text-align: right;">Thao tác</th>
            </tr>
        </thead>
        <tbody id="conTableBody">
            <c:forEach var="c" items="${contacts}">
                <tr style="${!c.read ? 'background: rgba(108, 93, 211, 0.02);' : ''}">
                    <td style="font-weight: 700; color: var(--unity-gray);">#${c.id}</td>
                    <td>
                        <div style="font-weight: 700; color: var(--unity-black);">${c.name}</div>
                        <div style="font-size: 12px; color: var(--unity-gray); margin-top: 4px; display: flex; align-items: center; gap: 6px;">
                            <i class="fa-solid fa-envelope"></i> ${c.email}
                        </div>
                        <div style="font-size: 12px; color: var(--unity-gray); margin-top: 2px; display: flex; align-items: center; gap: 6px;">
                            <i class="fa-solid fa-phone"></i> ${c.phone}
                        </div>
                    </td>
                    <td><span class="sub-badge">${c.subject}</span></td>
                    <td>
                        <div class="msg-box">${c.message}</div>
                    </td>
                    <td style="color: var(--unity-gray); font-weight: 600; font-size: 13px;">${c.createdAt}</td>
                    <td style="text-align: right;">
                        <form action="${pageContext.request.contextPath}/admin/contacts" method="post" onsubmit="return confirm('Xóa lời nhắn này?')">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="${c.id}">
                            <button type="submit" class="btn-icon" title="Xóa tin nhắn"><i class="fa-solid fa-trash-can"></i></button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty contacts}">
                <tr><td colspan="6" style="text-align: center; padding: 48px; color: var(--unity-gray); font-style: italic;">Chưa có lời nhắn nào từ khách hàng</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<script>
    document.getElementById('conFilter').addEventListener('keyup', function() {
        let val = this.value.toLowerCase();
        let rows = document.querySelectorAll('#conTableBody tr');
        rows.forEach(row => {
            let text = row.innerText.toLowerCase();
            row.style.display = text.includes(val) ? '' : 'none';
        });
    });
</script>
