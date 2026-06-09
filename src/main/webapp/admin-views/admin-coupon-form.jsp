<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style>
    .coup-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; }
    .coup-header h2 { font-weight: 800; font-size: 24px; color: var(--unity-black); margin: 0; }
    
    .u-card { background: var(--white); border-radius: 24px; padding: 32px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); }
    .card-title { font-weight: 800; font-size: 18px; color: var(--unity-black); margin-bottom: 24px; display: flex; align-items: center; gap: 12px; }
    
    .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; }
    .u-group { margin-bottom: 24px; }
    .u-group label { display: block; font-weight: 700; font-size: 11px; color: var(--unity-gray); margin-bottom: 8px; text-transform: uppercase; }
    .u-input, .u-select {
        width: 100%; background: var(--unity-bg); border: 2px solid transparent; padding: 14px 16px;
        border-radius: 12px; font-family: inherit; font-weight: 600; outline: none; transition: 0.2s;
    }
    .u-input:focus, .u-select:focus { border-color: var(--unity-primary); background: var(--white); }

    /* Product Multi-select box */
    .product-selector {
        max-height: 250px; overflow-y: auto; border: 2px solid var(--unity-bg); border-radius: 14px;
        padding: 12px; background: var(--white);
    }
    .prod-item {
        display: flex; align-items: center; gap: 12px; padding: 10px; border-radius: 10px;
        transition: 0.2s; cursor: pointer; border-bottom: 1px solid var(--unity-bg);
    }
    .prod-item:last-child { border-bottom: none; }
    .prod-item:hover { background: var(--unity-bg); }
    .prod-item input { width: 18px; height: 18px; accent-color: var(--unity-primary); cursor: pointer; }
    .prod-item label { margin: 0; font-weight: 600; color: var(--unity-black); cursor: pointer; font-size: 14px; text-transform: none; }

    .btn-unity {
        padding: 14px 28px; border-radius: 12px; font-weight: 700; font-size: 14px;
        border: none; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px; text-decoration: none;
    }
    .btn-primary { background: var(--unity-primary); color: #fff; }
    .btn-secondary { background: var(--unity-bg); color: var(--unity-gray); }
</style>

<div class="coup-header">
    <div>
        <h2>${empty coupon ? "Thêm Coupon mới" : "Chỉnh sửa Coupon"}</h2>
        <p style="color: var(--unity-gray); font-weight: 500; margin-top: 8px;">Cấu hình mã giảm giá cho các chiến dịch marketing</p>
    </div>
    <a href="${pageContext.request.contextPath}/admin/coupons" class="btn-unity btn-secondary">
        <i class="fa-solid fa-arrow-left"></i> Quay lại
    </a>
</div>

<div class="u-card">
    <div class="card-title">
        <i class="fa-solid fa-ticket" style="color: var(--unity-primary);"></i>
        Thông tin mã giảm giá
    </div>
    <form action="${pageContext.request.contextPath}/admin/coupon/save" method="post">
        <c:if test="${not empty coupon}">
            <input type="hidden" name="id" value="${coupon.id}">
        </c:if>

        <div class="form-grid">
            <div class="u-group">
                <label>Mã Coupon (CODE)</label>
                <input type="text" name="code" value="${coupon.code}" class="u-input" placeholder="Ví dụ: SUMMER2024" required style="text-transform: uppercase;">
            </div>
            <div class="u-group">
                <label>Loại hình giảm giá</label>
                <select name="discountType" class="u-select" required>
                    <option value="PERCENTAGE" ${coupon.discountType == 'PERCENTAGE' ? 'selected' : ''}>Phần trăm (%)</option>
                    <option value="FIXED_AMOUNT" ${coupon.discountType == 'FIXED_AMOUNT' ? 'selected' : ''}>Số tiền cố định (₫)</option>
                </select>
            </div>
            <div class="u-group">
                <label>Giá trị giảm</label>
                <input type="number" name="discountValue" value="${coupon.discountValue}" class="u-input" step="0.01" required>
            </div>
            <div class="u-group">
                <label>Giá trị đơn tối thiểu (₫)</label>
                <input type="number" name="minOrderValue" value="${coupon.minOrderValue != null ? coupon.minOrderValue : 0}" class="u-input" step="0.01">
            </div>
            <div class="u-group">
                <label>Số tiền giảm tối đa (Cho %)</label>
                <input type="number" name="maxDiscountAmount" value="${coupon.maxDiscountAmount}" class="u-input" step="0.01" placeholder="Để trống nếu không giới hạn">
            </div>
            <div class="u-group">
                <label>Giới hạn lượt dùng</label>
                <input type="number" name="usageLimit" value="${coupon.usageLimit}" class="u-input" placeholder="Để trống nếu không giới hạn">
            </div>
            <div class="u-group">
                <label>Ngày bắt đầu</label>
                <input type="datetime-local" name="startDate" value="${coupon.startDateStr}" class="u-input" required>
            </div>
            <div class="u-group">
                <label>Ngày kết thúc</label>
                <input type="datetime-local" name="endDate" value="${coupon.endDateStr}" class="u-input" required>
            </div>
        </div>

        <div class="u-group">
            <label>Sản phẩm áp dụng (Để trống để áp dụng toàn bộ cửa hàng)</label>
            <div class="product-selector">
                <c:forEach var="p" items="${allProducts}">
                    <div class="prod-item">
                        <input type="checkbox" name="productIds" value="${p.id}" id="prod-${p.id}" 
                               <c:if test="${selectedProductIds != null && selectedProductIds.contains(p.id)}">checked</c:if>>
                        <label for="prod-${p.id}">
                            <span style="color: var(--unity-primary); font-weight: 800;">#${p.id}</span> - ${p.name}
                        </label>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div style="display: flex; align-items: center; gap: 12px; margin-top: 12px;">
            <input type="checkbox" name="active" id="activeChk" style="width: 20px; height: 20px; accent-color: var(--unity-primary);" ${empty coupon || coupon.active ? 'checked' : ''}>
            <label for="activeChk" style="font-weight: 700; color: var(--unity-black); margin: 0; cursor: pointer;">Kích hoạt mã giảm giá này ngay bây giờ</label>
        </div>

        <div style="display: flex; justify-content: flex-end; gap: 16px; margin-top: 40px; padding-top: 24px; border-top: 2px solid var(--unity-bg);">
            <a href="${pageContext.request.contextPath}/admin/coupons" class="btn-unity btn-secondary">Hủy bỏ</a>
            <button type="submit" class="btn-unity btn-primary">
                <i class="fa-solid fa-save"></i> ${empty coupon ? 'Xác nhận tạo mã' : 'Lưu thay đổi'}
            </button>
        </div>
    </form>
</div>
