<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<style>
    .coup-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; }
    .coup-header h2 { font-weight: 800; font-size: 24px; color: var(--unity-black); margin: 0; }
    
    .u-card { background: var(--white); border-radius: 24px; padding: 32px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); }
    
    .u-table { width: 100%; border-collapse: collapse; }
    .u-table th { text-align: left; padding: 16px 20px; color: var(--unity-gray); font-weight: 600; font-size: 12px; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
    .u-table td { padding: 20px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 14px; }
    
    .coupon-tag {
        background: rgba(108, 93, 211, 0.05); color: var(--unity-primary); padding: 6px 14px;
        border-radius: 10px; font-weight: 800; font-family: 'JetBrains Mono', monospace;
        border: 2px dashed rgba(108, 93, 211, 0.2); font-size: 14px;
    }

    .badge { padding: 6px 12px; border-radius: 8px; font-weight: 700; font-size: 12px; }
    .badge-on { background: rgba(127, 186, 122, 0.15); color: var(--unity-green); }
    .badge-off { background: rgba(255, 117, 76, 0.15); color: #FF754C; }

    .btn-unity {
        padding: 12px 24px; border-radius: 12px; font-weight: 700; font-size: 14px;
        border: none; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px; text-decoration: none;
    }
    .btn-primary { background: var(--unity-primary); color: #fff; }

    .btn-icon {
        width: 36px; height: 36px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center;
        background: var(--unity-bg); color: var(--unity-gray); border: none; cursor: pointer; transition: 0.2s; text-decoration: none;
    }
    .btn-icon:hover { background: var(--unity-primary); color: #fff; }
</style>

<div class="coup-header">
    <div>
        <h2>Quản lý Coupon</h2>
        <p style="color: var(--unity-gray); font-weight: 500; margin-top: 8px;">Tạo và quản lý các mã giảm giá cho khách hàng</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/coupon/add" class="btn-unity btn-primary">
        <i class="fa-solid fa-plus"></i> Thêm mã mới
    </a>
</div>

<div class="u-card">
    <table class="u-table">
        <thead>
            <tr>
                <th>Mã (Code)</th>
                <th>Chiết khấu</th>
                <th>Áp dụng</th>
                <th>Điều kiện (Min/Max)</th>
                <th>Sử dụng</th>
                <th>Trạng thái</th>
                <th style="text-align: right;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="c" items="${coupons}">
                <tr>
                    <td><span class="coupon-tag">${c.code}</span></td>
                    <td>
                        <div style="font-weight: 800; color: var(--unity-black); font-size: 16px;">
                            <fmt:formatNumber value="${c.discountValue}" maxFractionDigits="0"/>${c.discountType == 'PERCENTAGE' ? '%' : '₫'}
                        </div>
                        <div style="font-size: 11px; color: var(--unity-gray); font-weight: 700; margin-top: 4px;">
                            ${c.discountType == 'PERCENTAGE' ? 'PHẦN TRĂM' : 'SỐ TIỀN CỐ ĐỊNH'}
                        </div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${couponProductCounts[c.id] == 0}">
                                <span style="font-weight: 700; color: var(--unity-green);">Tất cả sản phẩm</span>
                            </c:when>
                            <c:otherwise>
                                <span style="font-weight: 700; color: var(--unity-blue);">${couponProductCounts[c.id]} sản phẩm</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div style="font-size: 13px; font-weight: 600; color: var(--unity-black);">Min: <fmt:formatNumber value="${c.minOrderValue}" maxFractionDigits="0"/>₫</div>
                        <c:if test="${not empty c.maxDiscountAmount}">
                            <div style="font-size: 11px; color: var(--unity-gray); font-weight: 700; margin-top: 4px;">TỐI ĐA: <fmt:formatNumber value="${c.maxDiscountAmount}" maxFractionDigits="0"/>₫</div>
                        </c:if>
                    </td>
                    <td>
                        <div style="font-weight: 800; color: var(--unity-black);">${c.usedCount} <small style="color: var(--unity-gray); font-weight: 500;">/ ${not empty c.usageLimit ? c.usageLimit : '∞'}</small></div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${c.active}">
                                <span class="badge badge-on">● Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-off">● Vô hiệu</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="text-align: right;">
                        <div style="display: flex; gap: 8px; justify-content: flex-end;">
                            <a href="${pageContext.request.contextPath}/admin/coupon/edit?id=${c.id}" class="btn-icon" title="Sửa"><i class="fa-solid fa-pen"></i></a>
                            <a href="${pageContext.request.contextPath}/admin/coupon/delete?id=${c.id}" class="btn-icon" title="Xóa" style="color: #FF7675;" onclick="return confirm('Xóa mã này?')"><i class="fa-solid fa-trash"></i></a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty coupons}">
                <tr><td colspan="7" style="text-align: center; padding: 48px; color: var(--unity-gray); font-style: italic;">Chưa có mã giảm giá nào</td></tr>
            </c:if>
        </tbody>
    </table>
</div>
