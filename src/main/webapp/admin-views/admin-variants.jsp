<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .v-header { margin-bottom: 32px; }
    .v-header h2 { font-weight: 800; font-size: 24px; color: var(--unity-black); margin: 0; }
    .v-header p { color: var(--unity-gray); font-weight: 500; margin-top: 8px; }

    .u-card { background: var(--white); border-radius: 24px; padding: 32px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); margin-bottom: 32px; }
    .card-title { font-weight: 800; font-size: 18px; color: var(--unity-black); margin-bottom: 24px; display: flex; align-items: center; gap: 12px; }
    
    .u-input, .u-select {
        width: 100%; background: var(--unity-bg); border: 2px solid transparent; padding: 14px 16px;
        border-radius: 12px; font-family: inherit; font-weight: 600; outline: none; transition: 0.2s;
    }
    .u-input:focus, .u-select:focus { border-color: var(--unity-primary); background: var(--white); }
    
    .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 24px; margin-bottom: 24px; }
    .input-label { display: block; font-size: 11px; font-weight: 700; color: var(--unity-gray); margin-bottom: 8px; text-transform: uppercase; }

    /* Color Radio Improvements */
    .color-grid { display: flex; flex-wrap: wrap; gap: 12px; }
    .color-option {
        display: inline-flex; align-items: center; gap: 10px; padding: 10px 16px;
        background: var(--unity-bg); border-radius: 14px; cursor: pointer;
        font-size: 14px; font-weight: 700; color: var(--unity-black); transition: 0.2s;
        border: 2px solid transparent;
    }
    .color-option input { display: none; }
    .color-option:hover { background: #EFEFEF; }
    .color-option.active { border-color: var(--unity-primary); background: var(--white); box-shadow: 0 4px 12px rgba(108, 93, 211, 0.1); }
    .color-dot { width: 14px; height: 14px; border-radius: 50%; border: 1px solid rgba(0,0,0,0.1); }

    .btn-unity {
        padding: 14px 28px; border-radius: 12px; font-weight: 700; font-size: 14px;
        border: none; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-primary { background: var(--unity-primary); color: #fff; }
    .btn-secondary { background: var(--unity-bg); color: var(--unity-gray); }

    .u-table { width: 100%; border-collapse: collapse; }
    .u-table th { text-align: left; padding: 16px 20px; color: var(--unity-gray); font-weight: 600; font-size: 12px; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
    .u-table td { padding: 20px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 14px; }
    
    .badge { padding: 6px 12px; border-radius: 8px; font-weight: 700; font-size: 12px; display: inline-flex; align-items: center; gap: 6px; }
    .badge-on { background: rgba(127, 186, 122, 0.15); color: var(--unity-green); }
    .badge-off { background: rgba(255, 117, 76, 0.15); color: #FF754C; }

    .btn-icon {
        width: 36px; height: 36px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center;
        background: var(--unity-bg); color: var(--unity-gray); border: none; cursor: pointer; transition: 0.2s; text-decoration: none;
    }
    .btn-icon:hover { background: var(--unity-primary); color: #fff; }
</style>

<div class="v-header">
    <h2>Quản lý biến thể (Size/Màu)</h2>
    <c:if test="${selectedProduct != null}">
        <p>Sản phẩm đang chọn: <span style="color: var(--unity-black); font-weight: 800;">${selectedProduct.name}</span> (ID: ${selectedProduct.id})</p>
    </c:if>
</div>

<c:if test="${not empty param.error}">
    <div style="background-color: #ffebee; color: #c62828; padding: 15px; border-radius: 12px; margin-bottom: 20px; font-weight: 600; display: flex; align-items: center; gap: 10px; border: 1px solid #ffcdd2; font-size: 14px;">
        <i class="fa-solid fa-triangle-exclamation"></i>
        <span>
            <c:choose>
                <c:when test="${param.error == 'duplicate'}">Biến thể (Sản phẩm - Kích thước - Màu sắc) đã tồn tại!</c:when>
                <c:otherwise>Không thể lưu biến thể (${param.error})</c:otherwise>
            </c:choose>
        </span>
    </div>
</c:if>

<!-- Add/Edit Form -->
<div class="u-card">
    <div class="card-title">
        <i class="fa-solid ${variant != null ? 'fa-pen-to-square' : 'fa-circle-plus'}" style="color: var(--unity-primary);"></i>
        ${variant != null ? 'Cập nhật biến thể' : 'Thêm biến thể mới'}
    </div>
    
    <form action="${pageContext.request.contextPath}/admin/variants" method="post">
        <c:if test="${variant != null}">
            <input type="hidden" name="productId" value="${variant.productId}" />
            <input type="hidden" name="sizeIdOld" value="${variant.sizeId}" />
            <input type="hidden" name="colorIdOld" value="${variant.colorId}" />
        </c:if>

        <div class="form-grid">
            <div>
                <label class="input-label">Sản phẩm</label>
                <c:choose>
                    <c:when test="${variant != null}">
                        <input type="text" class="u-input" style="background:#f8f8f8; color: #aaa; cursor:not-allowed;" 
                               value="<c:forEach var='p' items='${allProducts}'><c:if test='${p.id == variant.productId}'>${p.name}</c:if></c:forEach>" disabled />
                    </c:when>
                    <c:otherwise>
                        <select name="productId" class="u-select" required>
                            <option value="">-- Chọn sản phẩm --</option>
                            <c:forEach var="p" items="${allProducts}">
                                <option value="${p.id}" ${param.productId == p.id ? 'selected' : ''}>${p.name} (#${p.id})</option>
                            </c:forEach>
                        </select>
                    </c:otherwise>
                </c:choose>
            </div>
            <div>
                <label class="input-label">Kích thước (Size)</label>
                <select name="sizeId" class="u-select" required>
                    <c:forEach var="s" items="${sizes}">
                        <option value="${s.id}" ${variant != null && variant.sizeId == s.id ? 'selected' : ''}>${s.name}</option>
                    </c:forEach>
                </select>
            </div>
            <div>
                <label class="input-label">Số lượng tồn kho</label>
                <input type="number" name="stock" class="u-input" min="0" value="${variant != null ? variant.stock : 0}" required />
            </div>
        </div>

        <div style="margin-bottom: 32px;">
            <label class="input-label">Màu sắc</label>
            <div class="color-grid">
                <c:forEach var="c" items="${colors}">
                    <label class="color-option ${variant != null && variant.colorId == c.id ? 'active' : ''}" onclick="selectColor(this)">
                        <input type="radio" name="colorId" value="${c.id}" ${variant != null && variant.colorId == c.id ? 'checked' : ''} required />
                        <span class="color-dot" style="background-color: ${c.hexCode};"></span>
                        ${c.name}
                    </label>
                </c:forEach>
            </div>
        </div>

        <div style="display: flex; justify-content: flex-end; gap: 16px;">
            <c:if test="${variant != null}">
                <a href="${pageContext.request.contextPath}/admin/variants" class="btn-unity btn-secondary" style="text-decoration:none;">Hủy</a>
            </c:if>
            <button type="submit" class="btn-unity btn-primary">
                <i class="fa-solid fa-save"></i> ${variant != null ? 'Lưu thay đổi' : 'Xác nhận thêm'}
            </button>
        </div>
    </form>
</div>

<!-- Filter Section -->
<div class="u-card" style="padding: 24px;">
    <form action="${pageContext.request.contextPath}/admin/variants" method="get" style="display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap;">
        <div style="flex: 1; min-width: 150px;">
            <label class="input-label">Mã SP</label>
            <input type="number" name="productId" class="u-input" value="${param.productId}" placeholder="ID...">
        </div>
        <div style="flex: 1; min-width: 120px;">
            <label class="input-label">Size</label>
            <select name="sizeId" class="u-select">
                <option value="">Tất cả</option>
                <c:forEach var="s" items="${sizes}">
                    <option value="${s.id}" ${param.sizeId == s.id ? 'selected' : ''}>${s.name}</option>
                </c:forEach>
            </select>
        </div>
        <div style="flex: 1; min-width: 120px;">
            <label class="input-label">Màu</label>
            <select name="colorId" class="u-select">
                <option value="">Tất cả</option>
                <c:forEach var="c" items="${colors}">
                    <option value="${c.id}" ${param.colorId == c.id ? 'selected' : ''}>${c.name}</option>
                </c:forEach>
            </select>
        </div>
        <button type="submit" class="btn-unity btn-primary"><i class="fa-solid fa-filter"></i> Lọc</button>
        <a href="${pageContext.request.contextPath}/admin/variants" class="btn-icon" title="Reset"><i class="fa-solid fa-rotate-right"></i></a>
    </form>
</div>

<!-- Table -->
<div class="u-card" style="padding: 24px;">
    <div style="font-weight: 800; font-size: 16px; margin-bottom: 24px; padding-left: 8px;">Danh sách biến thể (${variants.size()})</div>
    <table class="u-table">
        <thead>
            <tr>
                <th style="width: 50px;">STT</th>
                <th>Sản phẩm</th>
                <th>Kích thước</th>
                <th>Màu sắc</th>
                <th>Số lượng</th>
                <th>Trạng thái</th>
                <th style="text-align: right;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="pv" items="${variants}" varStatus="loop">
                <tr>
                    <td style="font-weight: 700; color: var(--unity-gray);">#${loop.index + 1}</td>
                    <td style="font-weight: 700; color: var(--unity-black);">
                        <c:forEach var="p" items="${allProducts}">
                            <c:if test="${p.id == pv.productId}">${p.name} <small style="color:var(--unity-gray)">(ID:${p.id})</small></c:if>
                        </c:forEach>
                    </td>
                    <td><span style="background: var(--unity-bg); padding: 4px 10px; border-radius: 6px; font-weight: 800;">
                        <c:forEach var="s" items="${sizes}">
                            <c:if test="${s.id == pv.sizeId}">${s.name}</c:if>
                        </c:forEach>
                    </span></td>
                    <td>
                        <c:forEach var="c" items="${colors}">
                            <c:if test="${c.id == pv.colorId}">
                                <div style="display: flex; align-items: center; gap: 8px; font-weight: 600;">
                                    <span class="color-dot" style="background-color: ${c.hexCode};"></span>
                                    ${c.name}
                                </div>
                            </c:if>
                        </c:forEach>
                    </td>
                    <td style="font-weight: 800; color: var(--unity-blue); font-size: 16px;">${pv.stock}</td>
                    <td>
                        <c:choose>
                            <c:when test="${pv.discontinueVariant}">
                                <span class="badge badge-off">● Ngừng bán</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-on">● Đang bán</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="text-align: right;">
                        <div style="display: flex; gap: 8px; justify-content: flex-end;">
                            <a href="${pageContext.request.contextPath}/admin/variants?edit=true&productId=${pv.productId}&sizeId=${pv.sizeId}&colorId=${pv.colorId}" class="btn-icon" title="Sửa"><i class="fa-solid fa-pen"></i></a>
                            <c:choose>
                                <c:when test="${!pv.discontinueVariant}">
                                    <a href="${pageContext.request.contextPath}/admin/variants?disable=true&productId=${pv.productId}&sizeId=${pv.sizeId}&colorId=${pv.colorId}" class="btn-icon" style="color: #FF7675;" title="Ngừng bán" onclick="return confirm('Ngừng bán biến thể này?')"><i class="fa-solid fa-ban"></i></a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/admin/variants?restore=true&productId=${pv.productId}&sizeId=${pv.sizeId}&colorId=${pv.colorId}" class="btn-icon" style="color: var(--unity-green);" title="Khôi phục" onclick="return confirm('Khôi phục biến thể này?')"><i class="fa-solid fa-rotate"></i></a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty variants}">
                <tr><td colspan="7" style="text-align: center; padding: 48px; color: var(--unity-gray); font-style: italic;">Không có dữ liệu biến thể phù hợp</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<script>
    function selectColor(el) {
        document.querySelectorAll('.color-option').forEach(opt => opt.classList.remove('active'));
        el.classList.add('active');
    }
</script>