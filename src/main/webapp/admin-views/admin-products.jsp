<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<style>
    /* Unity-Inspired Global Overrides */
    .toolbar { display: flex; gap: 16px; align-items: center; margin-bottom: 32px; flex-wrap: wrap; }
    .btn-unity {
        padding: 12px 24px; border-radius: 12px; font-weight: 700; font-size: 14px;
        border: none; cursor: pointer; transition: 0.2s;
        display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-primary { background: var(--unity-primary); color: #fff; }
    .btn-secondary { background: var(--white); color: var(--unity-gray); border: 1px solid var(--border-color); }

    .search-input {
        background: var(--white); border-radius: 12px; padding: 12px 16px;
        display: flex; align-items: center; gap: 12px; flex: 1; min-width: 200px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.02);
    }
    .search-input input { border: none; outline: none; background: transparent; width: 100%; font-family: inherit; }

    /* Faithful Table with Unity Skin */
    .data-card { background: var(--white); border-radius: 24px; padding: 24px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); overflow-x: auto; }
    .u-table { width: 100%; border-collapse: collapse; min-width: 1000px; }
    .u-table th {
        text-align: left; padding: 16px 20px; color: var(--unity-gray);
        font-weight: 600; font-size: 13px; text-transform: uppercase;
        border-bottom: 1px solid var(--border-color);
    }
    .u-table td { padding: 20px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 14px; }
    .u-table tr:hover { background: #fcfcff; }

    .p-img { width: 64px; height: 64px; border-radius: 12px; object-fit: cover; background: #eee; }
    .p-id { font-weight: 700; color: #ccc; font-size: 12px; }
    .p-name { font-weight: 700; color: var(--unity-black); font-size: 15px; }
    .p-desc { color: var(--unity-gray); font-size: 13px; max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
    .p-price { font-weight: 700; color: var(--unity-blue); }
    .p-stock { font-weight: 600; color: var(--unity-black); }
    .p-rating { color: var(--unity-green); font-weight: 700; display: flex; align-items: center; gap: 4px; }

    /* Form Styles */
    .modal-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(17, 20, 45, 0.4); backdrop-filter: blur(8px);
        display: none; justify-content: center; align-items: center; z-index: 2000;
    }
    .modal-content {
        background: var(--white); width: 850px; max-height: 90vh; border-radius: 32px; padding: 40px;
        box-shadow: 0 40px 80px rgba(0,0,0,0.1); overflow-y: auto;
    }
    .form-group { margin-bottom: 24px; }
    .form-group label { display: block; font-weight: 700; font-size: 12px; color: var(--unity-gray); margin-bottom: 8px; text-transform: uppercase; }
    .form-group input, .form-group select, .form-group textarea {
        width: 100%; background: var(--unity-bg); border: 2px solid transparent; padding: 14px 18px;
        border-radius: 12px; font-family: inherit; font-weight: 600; outline: none; transition: 0.2s;
    }
    .form-group input:focus { border-color: var(--unity-primary); background: var(--white); }
</style>

<div class="toolbar">
    <div class="search-input">
        <i class="fa-solid fa-magnifying-glass" style="color: var(--unity-gray);"></i>
        <form action="${pageContext.request.contextPath}/admin/products" method="get" style="width:100%;">
            <input type="text" name="name" placeholder="Tìm kiếm sản phẩm..." value="${param.name}">
        </form>
    </div>
    
    <select onchange="location.href='${pageContext.request.contextPath}/admin/products?brandId=' + this.value" style="padding: 12px; border-radius: 12px; border: 1px solid var(--border-color); font-weight: 600; outline: none;">
        <option value="">Tất cả thương hiệu</option>
        <c:forEach var="b" items="${brands}">
            <option value="${b.id}" ${param.brandId == b.id ? 'selected' : ''}>${b.name}</option>
        </c:forEach>
    </select>

    <button class="btn-unity btn-primary" onclick="openProductModal()">
        <i class="fa-solid fa-plus"></i> Thêm sản phẩm
    </button>
</div>

<c:if test="${not empty param.error}">
    <div style="background-color: #ffebee; color: #c62828; padding: 15px; border-radius: 12px; margin-bottom: 20px; font-weight: 600; display: flex; align-items: center; gap: 10px; border: 1px solid #ffcdd2; font-size: 14px;">
        <i class="fa-solid fa-triangle-exclamation"></i>
        <span>
            <c:choose>
                <c:when test="${param.error == 'duplicate_name'}">Tên sản phẩm đã tồn tại trong hệ thống!</c:when>
                <c:when test="${param.error == 'price'}">Giá bán không hợp lệ!</c:when>
                <c:otherwise>Không thể lưu sản phẩm (${param.error})</c:otherwise>
            </c:choose>
        </span>
    </div>
</c:if>

<div class="data-card">
    <table class="u-table">
        <thead>
            <tr>
                <th style="width: 50px;">ID</th>
                <th style="width: 80px;">Ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Thương hiệu</th>
                <th>Giá bán</th>
                <th>Kho hàng</th>
                <th>Đánh giá</th>
                <th>Trạng thái</th>
                <th style="text-align: right;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <td><span class="p-id">#${p.id}</span></td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty productImgMap[p.id] && fn:startsWith(productImgMap[p.id], 'http')}">
                                <img src="${productImgMap[p.id]}" class="p-img" onerror="this.src='https://placehold.co/100x100?text=Giay'">
                            </c:when>
                            <c:when test="${not empty productImgMap[p.id]}">
                                <img src="${pageContext.request.contextPath}${productImgMap[p.id]}" class="p-img" onerror="this.src='https://placehold.co/100x100?text=Giay'">
                            </c:when>
                            <c:otherwise>
                                <img src="https://placehold.co/100x100?text=Giay" class="p-img">
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div class="p-name">${p.name}</div>
                        <div class="p-desc">${p.description}</div>
                    </td>
                    <td>
                        <c:forEach var="b" items="${brands}">
                            <c:if test="${b.id == p.brandId}">${b.name}</c:if>
                        </c:forEach>
                    </td>
                    <td><div class="p-price">${p.price}₫</div></td>
                    <td><div class="p-stock">${productStockMap[p.id.toString()] != null ? productStockMap[p.id.toString()] : 0} <small style="color: var(--unity-gray); font-weight: 500;">(Tổng)</small></div></td>
                    <td>
                        <div class="p-rating">
                            <i class="fa-solid fa-star" style="color: #FFCE73; font-size: 12px;"></i>
                            ${productRatingMap[p.id.toString()] != null ? productRatingMap[p.id.toString()] : '0.0'}
                            <span style="color: var(--unity-gray); font-weight: 400; font-size: 12px;">(${productVoteMap[p.id.toString()] != null ? productVoteMap[p.id.toString()] : 0})</span>
                        </div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${p.status == 'selling'}"><span style="color: var(--unity-green); font-weight: 700;">Đang bán</span></c:when>
                            <c:when test="${p.status == 'stopped'}"><span style="color: #FF7675; font-weight: 700;">Ngừng bán</span></c:when>
                            <c:otherwise><span style="color: var(--unity-gray); font-weight: 700;">Sắp ra mắt</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td style="text-align: right;">
                        <div style="display: flex; gap: 12px; justify-content: flex-end;">
                            <a href="${pageContext.request.contextPath}/admin/products?edit=${p.id}" style="color: var(--unity-gray); font-size: 18px;"><i class="fa-solid fa-pen-to-square"></i></a>
                            <a href="${pageContext.request.contextPath}/admin/variants?productId=${p.id}" style="color: var(--unity-gray); font-size: 18px;"><i class="fa-solid fa-layer-group"></i></a>
                            <form action="${pageContext.request.contextPath}/admin/products" method="post" style="margin:0;">
                                <input type="hidden" name="deleteId" value="${p.id}">
                                <button type="submit" style="background:none; border:none; color: var(--unity-gray); font-size: 18px; cursor:pointer;" onclick="return confirm('Xóa sản phẩm?')"><i class="fa-solid fa-trash"></i></button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<c:if test="${totalPages > 1}">
    <div style="display: flex; justify-content: center; margin-top: 24px; gap: 8px;">
        <c:if test="${currentPage > 1}">
            <a href="${pageContext.request.contextPath}/admin/products?page=${currentPage - 1}" class="btn-unity btn-secondary" style="padding: 8px 16px;">Trước</a>
        </c:if>
        
        <c:forEach begin="1" end="${totalPages}" var="i">
            <a href="${pageContext.request.contextPath}/admin/products?page=${i}" class="btn-unity ${i == currentPage ? 'btn-primary' : 'btn-secondary'}" style="padding: 8px 16px;">${i}</a>
        </c:forEach>
        
        <c:if test="${currentPage < totalPages}">
            <a href="${pageContext.request.contextPath}/admin/products?page=${currentPage + 1}" class="btn-unity btn-secondary" style="padding: 8px 16px;">Sau</a>
        </c:if>
    </div>
</c:if>

<%-- MODAL: GIỮ NGUYÊN CÁC TRƯỜNG DỮ LIỆU CŨ --%>
<div id="productModal" class="modal-overlay" style="display: ${isEdit ? 'flex' : 'none'};">
    <div class="modal-content">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 32px;">
            <h2 style="margin:0; font-weight: 800; color: var(--unity-black);">${isEdit ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới'}</h2>
            <i class="fa-solid fa-xmark" style="font-size: 24px; cursor:pointer; color: var(--unity-gray);" onclick="closeProductModal()"></i>
        </div>
        
        <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data">
            <c:if test="${isEdit}"><input type="hidden" name="id" value="${product.id}" /></c:if>
            <input type="hidden" name="existingImgUrl" value="${productImg}" />
            <c:set var="subArr" value="${not empty subImgUrls ? subImgUrls.split(',') : null}" />
            <input type="hidden" name="existingSubImgUrl1" value="${subArr[0]}" />
            <input type="hidden" name="existingSubImgUrl2" value="${subArr[1]}" />
            <input type="hidden" name="existingSubImgUrl3" value="${subArr[2]}" />
            <input type="hidden" name="existingSubImgUrl4" value="${subArr[3]}" />
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
                <div class="form-group">
                    <label>Tên sản phẩm</label>
                    <input type="text" name="name" value="${product.name}" required>
                </div>
                <div class="form-group">
                    <label>Thương hiệu</label>
                    <select name="brandId">
                        <c:forEach var="b" items="${brands}">
                            <option value="${b.id}" ${isEdit && product.brandId == b.id ? 'selected' : ''}>${b.name}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>Giá bán (₫)</label>
                    <input type="number" name="price" value="${product.price}" required>
                </div>
                <div class="form-group">
                    <label>Trạng thái hiển thị</label>
                    <select name="status">
                        <option value="selling" ${!isEdit || product.status == 'selling' ? 'selected' : ''}>Đang bán</option>
                        <option value="stopped" ${isEdit && product.status == 'stopped' ? 'selected' : ''}>Ngừng bán</option>
                        <option value="upcoming" ${isEdit && product.status == 'upcoming' ? 'selected' : ''}>Sắp ra mắt</option>
                    </select>
                </div>
                
                <div class="form-group" style="grid-column: span 2;">
                    <label>Ảnh chính</label>
                    <div style="display: flex; align-items: center; gap: 16px;">
                        <input type="file" name="imgFile" accept="image/*" onchange="previewProductImg(this, 'main-preview')" style="flex: 1;" ${isEdit ? '' : 'required'}>
                        <div id="main-preview" style="width: 80px; height: 80px; border-radius: 12px; border: 2px dashed #ccc; overflow: hidden; display: flex; align-items: center; justify-content: center; background: #f8fafc; flex-shrink: 0;">
                            <c:choose>
                                <c:when test="${not empty productImg && fn:startsWith(productImg, 'http')}">
                                    <img src="${productImg}" style="width: 100%; height: 100%; object-fit: cover;">
                                </c:when>
                                <c:when test="${not empty productImg}">
                                    <img src="${pageContext.request.contextPath}${productImg}" style="width: 100%; height: 100%; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <img style="width: 100%; height: 100%; object-fit: cover; display: none;">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <div class="form-group" style="grid-column: span 2;">
                    <label>Ảnh phụ (Tối đa 4 ảnh)</label>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <!-- Sub Image 1 -->
                        <div style="display: flex; align-items: center; gap: 10px; background: var(--unity-bg); padding: 10px; border-radius: 12px;">
                            <div style="flex: 1;">
                                <span style="font-size: 11px; font-weight: 700; color: var(--unity-gray); display: block; margin-bottom: 4px;">Ảnh phụ 1</span>
                                <input type="file" name="subImgFile1" accept="image/*" onchange="previewProductImg(this, 'sub1-preview')" style="font-size: 11px; padding: 4px; width: 100%;">
                            </div>
                            <div id="sub1-preview" style="width: 50px; height: 50px; border-radius: 8px; border: 1px dashed #ccc; overflow: hidden; display: flex; align-items: center; justify-content: center; background: #fff; flex-shrink: 0;">
                                <c:choose>
                                    <c:when test="${not empty subArr[0] && fn:startsWith(subArr[0], 'http')}">
                                        <img src="${subArr[0]}" style="width:100%; height:100%; object-fit:cover;">
                                    </c:when>
                                    <c:when test="${not empty subArr[0]}">
                                        <img src="${pageContext.request.contextPath}${subArr[0]}" style="width:100%; height:100%; object-fit:cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img style="width:100%; height:100%; object-fit:cover; display:none;">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Sub Image 2 -->
                        <div style="display: flex; align-items: center; gap: 10px; background: var(--unity-bg); padding: 10px; border-radius: 12px;">
                            <div style="flex: 1;">
                                <span style="font-size: 11px; font-weight: 700; color: var(--unity-gray); display: block; margin-bottom: 4px;">Ảnh phụ 2</span>
                                <input type="file" name="subImgFile2" accept="image/*" onchange="previewProductImg(this, 'sub2-preview')" style="font-size: 11px; padding: 4px; width: 100%;">
                            </div>
                            <div id="sub2-preview" style="width: 50px; height: 50px; border-radius: 8px; border: 1px dashed #ccc; overflow: hidden; display: flex; align-items: center; justify-content: center; background: #fff; flex-shrink: 0;">
                                <c:choose>
                                    <c:when test="${not empty subArr[1] && fn:startsWith(subArr[1], 'http')}">
                                        <img src="${subArr[1]}" style="width:100%; height:100%; object-fit:cover;">
                                    </c:when>
                                    <c:when test="${not empty subArr[1]}">
                                        <img src="${pageContext.request.contextPath}${subArr[1]}" style="width:100%; height:100%; object-fit:cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img style="width:100%; height:100%; object-fit:cover; display:none;">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Sub Image 3 -->
                        <div style="display: flex; align-items: center; gap: 10px; background: var(--unity-bg); padding: 10px; border-radius: 12px;">
                            <div style="flex: 1;">
                                <span style="font-size: 11px; font-weight: 700; color: var(--unity-gray); display: block; margin-bottom: 4px;">Ảnh phụ 3</span>
                                <input type="file" name="subImgFile3" accept="image/*" onchange="previewProductImg(this, 'sub3-preview')" style="font-size: 11px; padding: 4px; width: 100%;">
                            </div>
                            <div id="sub3-preview" style="width: 50px; height: 50px; border-radius: 8px; border: 1px dashed #ccc; overflow: hidden; display: flex; align-items: center; justify-content: center; background: #fff; flex-shrink: 0;">
                                <c:choose>
                                    <c:when test="${not empty subArr[2] && fn:startsWith(subArr[2], 'http')}">
                                        <img src="${subArr[2]}" style="width:100%; height:100%; object-fit:cover;">
                                    </c:when>
                                    <c:when test="${not empty subArr[2]}">
                                        <img src="${pageContext.request.contextPath}${subArr[2]}" style="width:100%; height:100%; object-fit:cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img style="width:100%; height:100%; object-fit:cover; display:none;">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Sub Image 4 -->
                        <div style="display: flex; align-items: center; gap: 10px; background: var(--unity-bg); padding: 10px; border-radius: 12px;">
                            <div style="flex: 1;">
                                <span style="font-size: 11px; font-weight: 700; color: var(--unity-gray); display: block; margin-bottom: 4px;">Ảnh phụ 4</span>
                                <input type="file" name="subImgFile4" accept="image/*" onchange="previewProductImg(this, 'sub4-preview')" style="font-size: 11px; padding: 4px; width: 100%;">
                            </div>
                            <div id="sub4-preview" style="width: 50px; height: 50px; border-radius: 8px; border: 1px dashed #ccc; overflow: hidden; display: flex; align-items: center; justify-content: center; background: #fff; flex-shrink: 0;">
                                <c:choose>
                                    <c:when test="${not empty subArr[3] && fn:startsWith(subArr[3], 'http')}">
                                        <img src="${subArr[3]}" style="width:100%; height:100%; object-fit:cover;">
                                    </c:when>
                                    <c:when test="${not empty subArr[3]}">
                                        <img src="${pageContext.request.contextPath}${subArr[3]}" style="width:100%; height:100%; object-fit:cover;">
                                    </c:when>
                                    <c:otherwise>
                                        <img style="width:100%; height:100%; object-fit:cover; display:none;">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-group" style="grid-column: span 2;">
                    <label>Mô tả chi tiết</label>
                    <textarea name="description" rows="5">${product.description}</textarea>
                </div>
            </div>
            
            <div style="display: flex; justify-content: flex-end; gap: 16px; margin-top: 24px;">
                <button type="button" class="btn-unity btn-secondary" onclick="closeProductModal()">Hủy bỏ</button>
                <button type="submit" class="btn-unity btn-primary">${isEdit ? 'Lưu thay đổi' : 'Xác nhận thêm'}</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openProductModal() { document.getElementById('productModal').style.display = 'flex'; }
    function closeProductModal() { 
        document.getElementById('productModal').style.display = 'none'; 
        if(window.location.search.includes('edit=')) window.location.href = '${pageContext.request.contextPath}/admin/products';
    }
    function previewProductImg(input, previewId) {
        const box = document.getElementById(previewId);
        let img = box.querySelector('img');
        if (!img) {
            img = document.createElement('img');
            img.style.width = '100%';
            img.style.height = '100%';
            img.style.objectFit = 'cover';
            box.appendChild(img);
        }
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                img.src = e.target.result;
                img.style.display = 'block';
            };
            reader.readAsDataURL(input.files[0]);
        }
    }
</script>