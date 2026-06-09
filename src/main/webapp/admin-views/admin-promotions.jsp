<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<style>
    .coup-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; }
    .coup-header h2 { font-weight: 800; font-size: 26px; color: var(--unity-black); margin: 0; }
    
    .u-card { background: var(--white); border-radius: 24px; padding: 32px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); }
    
    .u-table { width: 100%; border-collapse: collapse; }
    .u-table th { text-align: left; padding: 16px 20px; color: var(--unity-gray); font-weight: 600; font-size: 12px; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
    .u-table td { padding: 20px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 14px; }
    
    .promo-name {
        font-weight: 800; font-size: 15px; color: var(--unity-black);
    }
    
    .promo-slug {
        font-size: 12px; color: var(--unity-gray); font-weight: 600; margin-top: 4px;
        background: var(--unity-bg); padding: 4px 8px; border-radius: 6px; display: inline-block;
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
        <h2>Quản lý Khuyến mãi & Flash Sale</h2>
        <p style="color: var(--unity-gray); font-weight: 500; margin-top: 8px;">Tạo chiến dịch chiết khấu sản phẩm và thiết lập sự kiện Flash Sale đếm ngược</p>
    </div>
    <div style="display: flex; gap: 12px;">
        <button onclick="openFlashSaleModal()" class="btn-unity" style="background: linear-gradient(135deg, #ff9800, #ff5722); color: #fff; box-shadow: 0 4px 15px rgba(255, 87, 34, 0.3);">
            <i class="fa-solid fa-bolt"></i> Thêm Flash Sale mới
        </button>
        <a href="${pageContext.request.contextPath}/admin/promotion/add" class="btn-unity btn-primary">
            <i class="fa-solid fa-plus"></i> Thêm khuyến mãi thường
        </a>
    </div>
</div>

<!-- STATS METRICS GRID -->
<div class="metrics-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 20px; margin-bottom: 30px;">
    <div class="metric-card" style="background: var(--white); border-radius: 16px; padding: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.02); display: flex; align-items: center; gap: 20px; border-left: 5px solid var(--unity-primary);">
        <div style="background: rgba(220, 53, 69, 0.1); width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: var(--unity-primary); font-size: 20px;">
            <i class="fa-solid fa-tags"></i>
        </div>
        <div>
            <div style="font-size: 13px; color: var(--unity-gray); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Tổng Chiến Dịch</div>
            <div style="font-size: 24px; font-weight: 800; color: var(--unity-black); margin-top: 4px;">${totalPromotions}</div>
        </div>
    </div>
    <div class="metric-card" style="background: var(--white); border-radius: 16px; padding: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.02); display: flex; align-items: center; gap: 20px; border-left: 5px solid var(--unity-green);">
        <div style="background: rgba(40, 167, 69, 0.1); width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: var(--unity-green); font-size: 20px;">
            <i class="fa-solid fa-circle-check"></i>
        </div>
        <div>
            <div style="font-size: 13px; color: var(--unity-gray); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Đang Diễn Ra</div>
            <div style="font-size: 24px; font-weight: 800; color: var(--unity-black); margin-top: 4px;">${activePromotions}</div>
        </div>
    </div>
    <div class="metric-card" style="background: var(--white); border-radius: 16px; padding: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.02); display: flex; align-items: center; gap: 20px; border-left: 5px solid var(--unity-blue);">
        <div style="background: rgba(0, 123, 255, 0.1); width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: var(--unity-blue); font-size: 20px;">
            <i class="fa-solid fa-clock"></i>
        </div>
        <div>
            <div style="font-size: 13px; color: var(--unity-gray); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Sắp Diễn Ra</div>
            <div style="font-size: 24px; font-weight: 800; color: var(--unity-black); margin-top: 4px;">${upcomingPromotions}</div>
        </div>
    </div>
    <div class="metric-card" style="background: var(--white); border-radius: 16px; padding: 24px; box-shadow: 0 10px 30px rgba(0,0,0,0.02); display: flex; align-items: center; gap: 20px; border-left: 5px solid #6c757d;">
        <div style="background: rgba(108, 117, 125, 0.1); width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: #6c757d; font-size: 20px;">
            <i class="fa-solid fa-circle-xmark"></i>
        </div>
        <div>
            <div style="font-size: 13px; color: var(--unity-gray); font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">Đã Kết Thúc</div>
            <div style="font-size: 24px; font-weight: 800; color: var(--unity-black); margin-top: 4px;">${endedPromotions}</div>
        </div>
    </div>
</div>

<div class="u-card">
    <table class="u-table">
        <thead>
            <tr>
                <th>Chiến dịch</th>
                <th>Mức giảm</th>
                <th>Sản phẩm áp dụng</th>
                <th>Thời gian</th>
                <th>Trạng thái</th>
                <th style="text-align: right;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${promotions}">
                <tr>
                    <td>
                        <div style="display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                            <div class="promo-name">${p.name}</div>
                            <c:if test="${p.flashSale}">
                                <span style="background: linear-gradient(135deg, #ff9800, #ff5722); color: #fff; font-weight: 800; font-size: 10px; padding: 2px 8px; border-radius: 50px; text-transform: uppercase; display: inline-flex; align-items: center; gap: 2px; box-shadow: 0 2px 5px rgba(255, 87, 34, 0.2);">
                                    <i class="fa-solid fa-bolt" style="font-size: 8px;"></i> Flash Sale
                                </span>
                            </c:if>
                        </div>
                        <c:if test="${not empty p.slug}">
                            <div class="promo-slug">${p.slug}</div>
                        </c:if>
                    </td>
                    <td>
                        <div style="font-weight: 800; color: var(--unity-black); font-size: 16px;">
                            <fmt:formatNumber value="${p.discountValue}" maxFractionDigits="0"/>${p.discountType == 'PERCENT' ? '%' : '₫'}
                        </div>
                        <div style="font-size: 11px; color: var(--unity-gray); font-weight: 700; margin-top: 4px;">
                            ${p.discountType == 'PERCENT' ? 'PHẦN TRĂM' : 'SỐ TIỀN CỐ ĐỊNH'}
                        </div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${promotionProductCounts[p.id] == 0}">
                                <span style="font-weight: 700; color: #FF754C;">Chưa áp dụng</span>
                            </c:when>
                            <c:otherwise>
                                <span style="font-weight: 700; color: var(--unity-blue);">${promotionProductCounts[p.id]} sản phẩm</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div style="font-size: 13px; font-weight: 600; color: var(--unity-black);">
                            Bắt đầu: ${not empty p.startDate ? fn:substring(p.startDate, 0, 16).replace('T', ' ') : 'Không giới hạn'}
                        </div>
                        <div style="font-size: 11px; color: var(--unity-gray); font-weight: 700; margin-top: 4px;">
                            Kết thúc: ${not empty p.endDate ? fn:substring(p.endDate, 0, 16).replace('T', ' ') : 'Không giới hạn'}
                        </div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${p.active}">
                                <span class="badge badge-on">● Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-off">● Vô hiệu</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="text-align: right;">
                        <div style="display: flex; gap: 8px; justify-content: flex-end;">
                            <a href="${pageContext.request.contextPath}/admin/promotion/edit?id=${p.id}" class="btn-icon" title="Sửa"><i class="fa-solid fa-pen"></i></a>
                            <a href="${pageContext.request.contextPath}/admin/promotion/delete?id=${p.id}" class="btn-icon" title="Xóa" style="color: #FF7675;" onclick="return confirm('Xóa chiến dịch này?')"><i class="fa-solid fa-trash"></i></a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty promotions}">
                <tr><td colspan="6" style="text-align: center; padding: 48px; color: var(--unity-gray); font-style: italic;">Chưa có chiến dịch khuyến mãi nào</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<!-- FLASH SALE INLINE MODAL -->
<div id="flashSaleModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); backdrop-filter: blur(8px); z-index: 1000; align-items: center; justify-content: center; padding: 20px; transition: all 0.3s ease;">
    <div style="background: rgba(255, 255, 255, 0.95); border-radius: 24px; max-width: 600px; width: 100%; box-shadow: 0 20px 60px rgba(0,0,0,0.15); border: 1px solid rgba(255,255,255,0.25); overflow: hidden; transform: scale(0.9); transition: transform 0.3s ease;" id="modalContent">
        <div style="background: linear-gradient(135deg, #e63946, #d62828); padding: 24px 32px; color: #fff; display: flex; justify-content: space-between; align-items: center;">
            <div style="display: flex; align-items: center; gap: 10px;">
                <i class="fa-solid fa-bolt" style="font-size: 1.5rem; color: #ffeb3b;"></i>
                <h3 style="margin: 0; font-weight: 800; font-size: 1.3rem; letter-spacing: 0.5px; text-transform: uppercase;">Thêm Flash Sale Mới</h3>
            </div>
            <button onclick="closeFlashSaleModal()" style="background: none; border: none; color: #fff; font-size: 1.8rem; cursor: pointer; transition: 0.2s; display: inline-flex;">&times;</button>
        </div>
        
        <form action="${pageContext.request.contextPath}/admin/promotion/save" method="post" style="padding: 32px; max-height: calc(100vh - 150px); overflow-y: auto;">
            <!-- Hidden inputs -->
            <input type="hidden" name="discountType" value="PERCENT" />
            <input type="hidden" name="isFlashSale" value="true" />
            <input type="hidden" name="active" value="true" />

            <div style="margin-bottom: 20px;">
                <label style="display: block; font-weight: 700; font-size: 13px; color: var(--unity-black); text-transform: uppercase; margin-bottom: 8px;">Tên sự kiện Flash Sale <span style="color: #ff3333;">*</span></label>
                <input type="text" name="name" id="fsName" required placeholder="Ví dụ: Siêu Sale Giờ Vàng 20/5" style="width: 100%; padding: 12px 16px; border: 2px solid #eee; border-radius: 12px; font-weight: 600; font-size: 14px; outline: none; transition: border-color 0.2s;" oninput="generateSlug(this.value)" />
            </div>

            <div style="margin-bottom: 20px;">
                <label style="display: block; font-weight: 700; font-size: 13px; color: var(--unity-black); text-transform: uppercase; margin-bottom: 8px;">Đường dẫn Slug <span style="color: #ff3333;">*</span></label>
                <input type="text" name="slug" id="fsSlug" required placeholder="sieu-sale-gio-vang-20-5" style="width: 100%; padding: 12px 16px; border: 2px solid #eee; border-radius: 12px; font-weight: 600; font-size: 14px; outline: none; transition: border-color 0.2s;" />
            </div>

            <div style="margin-bottom: 20px;">
                <label style="display: block; font-weight: 700; font-size: 13px; color: var(--unity-black); text-transform: uppercase; margin-bottom: 8px;">Mức giảm phần trăm (%) <span style="color: #ff3333;">*</span></label>
                <input type="number" name="discountValue" required min="1" max="99" placeholder="Nhập mức phần trăm (Ví dụ: 30)" style="width: 100%; padding: 12px 16px; border: 2px solid #eee; border-radius: 12px; font-weight: 600; font-size: 14px; outline: none; transition: border-color 0.2s;" />
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
                <div>
                    <label style="display: block; font-weight: 700; font-size: 13px; color: var(--unity-black); text-transform: uppercase; margin-bottom: 8px;">Ngày bắt đầu <span style="color: #ff3333;">*</span></label>
                    <input type="datetime-local" name="startDate" id="fsStartDate" required style="width: 100%; padding: 12px 16px; border: 2px solid #eee; border-radius: 12px; font-weight: 600; font-size: 14px; outline: none; transition: border-color 0.2s;" />
                </div>
                <div>
                    <label style="display: block; font-weight: 700; font-size: 13px; color: var(--unity-black); text-transform: uppercase; margin-bottom: 8px;">Ngày kết thúc <span style="color: #ff3333;">*</span></label>
                    <input type="datetime-local" name="endDate" id="fsEndDate" required style="width: 100%; padding: 12px 16px; border: 2px solid #eee; border-radius: 12px; font-weight: 600; font-size: 14px; outline: none; transition: border-color 0.2s;" />
                </div>
            </div>

            <div style="margin-bottom: 28px;">
                <label style="display: block; font-weight: 700; font-size: 13px; color: var(--unity-black); text-transform: uppercase; margin-bottom: 8px;">Chọn sản phẩm áp dụng <span style="color: #ff3333;">*</span></label>
                <div style="border: 2px solid #eee; border-radius: 12px; padding: 12px; max-height: 200px; overflow-y: auto;" id="fsProductsList">
                    <c:forEach var="prod" items="${allProducts}">
                        <label style="display: flex; align-items: center; gap: 12px; padding: 8px; border-radius: 8px; cursor: pointer; transition: background-color 0.2s;" class="fs-prod-item">
                            <input type="checkbox" name="productIds" value="${prod.id}" style="width: 18px; height: 18px; cursor: pointer;" />
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <c:choose>
                                    <c:when test="${not empty prod.imgUrl && prod.imgUrl.startsWith('http')}">
                                        <img src="${prod.imgUrl}" style="width: 32px; height: 32px; object-fit: contain; border-radius: 4px; border: 1px solid #eee;" />
                                    </c:when>
                                    <c:when test="${not empty prod.imgUrl}">
                                        <img src="${pageContext.request.contextPath}${prod.imgUrl}" style="width: 32px; height: 32px; object-fit: contain; border-radius: 4px; border: 1px solid #eee;" />
                                    </c:when>
                                    <c:otherwise>
                                        <img src="https://placehold.co/50/50?text=Shoe" style="width: 32px; height: 32px; object-fit: contain; border-radius: 4px; border: 1px solid #eee;" />
                                    </c:otherwise>
                                </c:choose>
                                <span style="font-weight: 600; font-size: 13px; color: var(--unity-black);">${prod.name}</span>
                            </div>
                        </label>
                    </c:forEach>
                    <c:if test="${empty allProducts}">
                        <div style="color: var(--unity-gray); font-style: italic; text-align: center; padding: 12px;">Không tìm thấy sản phẩm hoạt động nào</div>
                    </c:if>
                </div>
            </div>

            <div style="display: flex; gap: 12px; justify-content: flex-end;">
                <button type="button" onclick="closeFlashSaleModal()" class="btn-unity" style="background: #e9ecef; color: #495057;">Hủy</button>
                <button type="submit" class="btn-unity" style="background: linear-gradient(135deg, #e63946, #d62828); color: #fff; box-shadow: 0 4px 15px rgba(230, 57, 70, 0.3);">Lưu Sự Kiện</button>
            </div>
        </form>
    </div>
</div>

<style>
    .fs-prod-item:hover {
        background-color: rgba(230, 57, 70, 0.05);
    }
</style>

<script>
    function openFlashSaleModal() {
        const modal = document.getElementById('flashSaleModal');
        const content = document.getElementById('modalContent');
        
        // Auto-fill dates with current local time and end date +24 hours
        const now = new Date();
        const tomorrow = new Date(now.getTime() + 24 * 60 * 60 * 1000);
        
        const formatDateTimeLocal = (date) => {
            const pad = (n) => String(n).padStart(2, '0');
            return date.getFullYear() + '-' +
                   pad(date.getMonth() + 1) + '-' +
                   pad(date.getDate()) + 'T' +
                   pad(date.getHours()) + ':' +
                   pad(date.getMinutes());
        };
        
        document.getElementById('fsStartDate').value = formatDateTimeLocal(now);
        document.getElementById('fsEndDate').value = formatDateTimeLocal(tomorrow);
        
        modal.style.display = 'flex';
        setTimeout(() => {
            content.style.transform = 'scale(1)';
        }, 50);
    }

    function closeFlashSaleModal() {
        const modal = document.getElementById('flashSaleModal');
        const content = document.getElementById('modalContent');
        content.style.transform = 'scale(0.9)';
        setTimeout(() => {
            modal.style.display = 'none';
        }, 200);
    }

    function generateSlug(text) {
        let slug = text.toLowerCase()
            .normalize("NFD")
            .replace(/[\u0300-\u036f]/g, "")
            .replace(/đ/g, "d")
            .replace(/([^a-z0-9\s-]|_)+/g, '')
            .trim()
            .replace(/\s+/g, '-')
            .replace(/-+/g, '-');
        document.getElementById('fsSlug').value = slug;
    }
</script>
