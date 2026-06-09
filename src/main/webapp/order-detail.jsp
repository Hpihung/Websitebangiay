<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Chi tiết đơn hàng #${order.id} - H&amp;M Sport Shoes</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/account.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-detail.css?v=<%= System.currentTimeMillis() %>"/>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet"/>
</head>
<body>
<jsp:include page="header.jsp"/>

<div class="od-page">
<div class="od-wrap">

    <%-- Back link --%>
    <a href="${pageContext.request.contextPath}/account#order-history" class="od-back">
        <ion-icon name="arrow-back-outline"></ion-icon> Quay lại lịch sử đơn hàng
    </a>

    <%-- Alert --%>
    <c:if test="${not empty msg}">
        <div class="od-alert od-alert--success">${msg}</div>
        <c:remove var="msg" scope="session"/>
        <c:remove var="msgType" scope="session"/>
    </c:if>

    <%-- ===== HEADER CARD ===== --%>
    <div class="od-header-card">
        <div class="od-header-left">
            <h2>
                <i class="fa-solid fa-receipt" style="font-size:16px;color:#6c5dd3;"></i>
                Đơn hàng #${order.id}
            </h2>
            <div class="od-header-date">
                <i class="fa-regular fa-calendar"></i>
                lúc <c:if test="${order.createdAt != null}">
                    <fmt:formatNumber value="${order.createdAt.hour}" minIntegerDigits="2"/>:<fmt:formatNumber value="${order.createdAt.minute}" minIntegerDigits="2"/>
                    &nbsp;${order.createdAt.dayOfMonth} tháng ${order.createdAt.monthValue}, ${order.createdAt.year}
                </c:if>
            </div>
        </div>
        <div class="od-header-right">
            <c:choose>
                <c:when test="${order.orderStatus == 'PENDING' || order.orderStatus == 'ORDER_PENDING'}"><span class="oh-badge oh-badge--pending"><i class="fa-solid fa-clock"></i> Chờ xác nhận</span></c:when>
                <c:when test="${order.orderStatus == 'CONFIRMED' || order.orderStatus == 'ORDER_CONFIRMED' || order.orderStatus == 'ORDER_PREPARING'}"><span class="oh-badge oh-badge--confirmed"><i class="fa-solid fa-check"></i> Đã xác nhận</span></c:when>
                <c:when test="${order.orderStatus == 'SHIPPING' || order.orderStatus == 'ORDER_SHIPPING'}">
                    <c:choose>
                        <c:when test="${order.paymentMethod == 'WARRANTY'}"><span class="oh-badge oh-badge--shipping"><i class="fa-solid fa-truck-ramp-box"></i> Đang thu hồi</span></c:when>
                        <c:otherwise><span class="oh-badge oh-badge--shipping"><i class="fa-solid fa-truck"></i> Đang giao</span></c:otherwise>
                    </c:choose>
                </c:when>
                <c:when test="${order.orderStatus == 'DELIVERED' || order.orderStatus == 'ORDER_DELIVERED'}">
                    <c:choose>
                        <c:when test="${order.paymentMethod == 'WARRANTY'}"><span class="oh-badge oh-badge--confirmed"><i class="fa-solid fa-warehouse"></i> Đã thu hồi</span></c:when>
                        <c:otherwise><span class="oh-badge oh-badge--confirmed"><i class="fa-solid fa-box"></i> Đã giao</span></c:otherwise>
                    </c:choose>
                </c:when>
                <c:when test="${order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED'}"><span class="oh-badge oh-badge--completed"><i class="fa-solid fa-gift"></i> Hoàn thành</span></c:when>
                <c:when test="${order.orderStatus == 'CANCELLED' || order.orderStatus == 'ORDER_CANCELLED'}"><span class="oh-badge oh-badge--cancelled"><i class="fa-solid fa-xmark"></i> Đã hủy</span></c:when>
                <c:otherwise><span class="oh-badge">${order.vietnameseStatus}</span></c:otherwise>
            </c:choose>
            <div style="text-align:right;">
                <div style="font-size:20px;font-weight:800;color:#ee4d2d;"><fmt:formatNumber value="${order.grandTotal}" type="number" pattern="#,###"/>₫</div>
                <c:if test="${order.discountAmount != null && order.discountAmount > 0}">
                    <div style="font-size:12px;color:#94a3b8;text-decoration:line-through;"><fmt:formatNumber value="${order.subTotal}" type="number" pattern="#,###"/>₫</div>
                </c:if>
            </div>
        </div>
    </div>

    <%-- ===== INFO GRID ===== --%>
    <div class="od-info-grid">
        <%-- Customer Info --%>
        <div class="od-info-card">
            <h3><i class="fa-regular fa-user"></i> Thông tin khách hàng</h3>
            <div class="od-info-row">
                <div class="od-info-label">Họ tên</div>
                <div class="od-info-value">${sessionScope.currentUser.fullName}</div>
            </div>
            <div class="od-info-row">
                <div class="od-info-label">Email</div>
                <div class="od-info-value">${sessionScope.currentUser.email}</div>
            </div>
            <div class="od-info-row">
                <div class="od-info-label">Điện thoại</div>
                <div class="od-info-value">${not empty order.phoneNumber ? order.phoneNumber : sessionScope.currentUser.phoneNumber}</div>
            </div>
            <c:if test="${not empty order.shippingAddress}">
                <div class="od-info-row">
                    <div class="od-info-label">Địa chỉ</div>
                    <div class="od-info-value">${order.shippingAddress}</div>
                </div>
            </c:if>
        </div>

        <%-- Payment Info --%>
        <div class="od-info-card">
            <h3><i class="fa-regular fa-credit-card"></i> Thông tin thanh toán</h3>
            <div class="od-info-row">
                <div class="od-info-label">Phương thức</div>
                <div class="od-info-value">
                    <span class="od-method-pill">
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'COD'}"><i class="fa-solid fa-money-bill-wave"></i> COD</c:when>
                            <c:when test="${order.paymentMethod == 'VNPAY'}"><i class="fa-solid fa-qrcode"></i> Chuyển khoản</c:when>
                            <c:otherwise>${order.paymentMethod}</c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </div>
            <div class="od-info-row">
                <div class="od-info-label">Tổng tiền hàng</div>
                <div class="od-info-value"><fmt:formatNumber value="${order.subTotal}" type="number" pattern="#,###"/>₫</div>
            </div>
            <c:if test="${order.shippingFee != null && order.shippingFee > 0}">
                <div class="od-info-row">
                    <div class="od-info-label">Phí vận chuyển</div>
                    <div class="od-info-value"><fmt:formatNumber value="${order.shippingFee}" type="number" pattern="#,###"/>₫</div>
                </div>
            </c:if>
            <c:if test="${order.discountAmount != null && order.discountAmount > 0}">
                <div class="od-info-row">
                    <div class="od-info-label">Mã giảm giá</div>
                    <div class="od-info-value" style="display: flex; justify-content: space-between; align-items: center; width: 100%;">
                        <span style="background:#f0fdf4;color:#16a34a;padding:2px 8px;border-radius:4px;font-size:11px;font-weight:700;border:1px solid #bbf7d0;margin-right:6px;display:inline-block;">VOUCHER</span>
                        <span style="color:#16a34a;font-weight:700;">−<fmt:formatNumber value="${order.discountAmount}" type="number" pattern="#,###"/>₫</span>
                    </div>
                </div>
            </c:if>
            <div class="od-info-row od-info-total-row">
                <div class="od-info-label" style="font-weight:700;color:#1e293b;">Thành tiền</div>
                <div class="od-info-value" style="font-weight:800;font-size:16px;color:#ee4d2d;"><fmt:formatNumber value="${order.grandTotal}" type="number" pattern="#,###"/>₫</div>
            </div>
        </div>
    </div>

    <%-- ===== PRODUCTS ===== --%>
    <div class="od-products-card">
        <div class="od-products-title">
            <span><i class="fa-solid fa-box"></i>&nbsp; Chi tiết sản phẩm</span>
            <span class="od-products-count">${orderDetails.size()} sản phẩm</span>
        </div>

        <div class="od-table-head">
            <div>Sản phẩm</div>
            <div>Đơn giá</div>
            <div>SL</div>
            <div>Thành tiền</div>
            <div>Hành động</div>
        </div>

        <c:forEach var="item" items="${orderDetails}">
            <div class="od-product-row">
                <%-- Col 1: Product --%>
                <div style="display:flex;align-items:center;gap:10px;">
                    <c:choose>
                        <c:when test="${not empty item.imageUrl && item.imageUrl.startsWith('http')}">
                            <img class="od-product-img" src="${item.imageUrl}" alt="${item.productName}" />
                        </c:when>
                        <c:when test="${not empty item.imageUrl}">
                            <img class="od-product-img" src="${pageContext.request.contextPath}${item.imageUrl}" alt="${item.productName}"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.png'"/>
                        </c:when>
                        <c:otherwise>
                            <img class="od-product-img" src="${pageContext.request.contextPath}/assets/images/placeholder.png" alt="${item.productName}"/>
                        </c:otherwise>
                    </c:choose>
                    <div class="od-product-info">
                        <div class="od-product-name">${item.productName}</div>
                        <div class="od-product-meta">Màu: ${item.colorName}&nbsp;|&nbsp;Size: ${item.sizeName}</div>
                    </div>
                </div>
                <%-- Col 2: Unit price --%>
                <div class="od-product-price-cell"><fmt:formatNumber value="${item.unitPrice}" type="number" pattern="#,###"/>₫</div>
                <%-- Col 3: Qty --%>
                <div class="od-product-qty-cell">${item.quantity}</div>
                <%-- Col 4: Total --%>
                <div class="od-product-total-cell"><fmt:formatNumber value="${item.unitPrice * item.quantity}" type="number" pattern="#,###"/>₫</div>
                <%-- Col 5: Action --%>
                <div class="od-product-action-cell">
                    <c:if test="${order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED'}">
                        <c:choose>
                            <c:when test="${order.receivedAt != null}">
                                <c:set var="myReview" value="${null}"/>
                                <c:forEach var="rev" items="${reviews}">
                                    <c:if test="${rev.productId == item.productId}"><c:set var="myReview" value="${rev}"/></c:if>
                                </c:forEach>
                                <c:choose>
                                    <c:when test="${not empty myReview}">
                                        <div class="od-reviewed-badge">⭐ Đã đánh giá</div>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="od-review-btn" onclick="openReviewModal('${item.productId}')">
                                            <i class="fa-solid fa-star"></i> Đánh giá
                                        </button>
                                        <%-- REVIEW MODAL --%>
                                        <div id="review-modal-overlay-${item.productId}" class="rm-overlay" onclick="closeReviewModal(event,'${item.productId}')">
                                    <form id="review-form-${item.productId}" action="${pageContext.request.contextPath}/orders/${order.id}" method="post" enctype="multipart/form-data" class="rm-modal">
                                        <input type="hidden" name="action" value="review"/>
                                        <input type="hidden" name="productId" value="${item.productId}"/>
                                        <input type="hidden" name="rating" id="rating-${item.productId}" value="5"/>
                                        <div class="rm-header">
                                            <span class="rm-title">Đánh giá sản phẩm</span>
                                            <button type="button" class="rm-close" onclick="forceCloseReviewModal('${item.productId}')">✕</button>
                                        </div>
                                        <div class="rm-product">
                                            <c:choose>
                                                <c:when test="${not empty item.imageUrl && item.imageUrl.startsWith('http')}">
                                                    <img src="${item.imageUrl}" alt="${item.productName}" />
                                                </c:when>
                                                <c:when test="${not empty item.imageUrl}">
                                                    <img src="${pageContext.request.contextPath}${item.imageUrl}" alt="${item.productName}"
                                                         onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.png'"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/assets/images/placeholder.png" alt="${item.productName}"/>
                                                </c:otherwise>
                                            </c:choose>
                                            <span class="rm-product-name">${item.productName}</span>
                                        </div>
                                        <div class="rm-body">
                                            <div class="rm-label">Chất lượng sản phẩm</div>
                                            <div class="rm-stars" data-pid="${item.productId}">
                                                <span class="star active" data-val="1">★</span>
                                                <span class="star active" data-val="2">★</span>
                                                <span class="star active" data-val="3">★</span>
                                                <span class="star active" data-val="4">★</span>
                                                <span class="star active" data-val="5">★</span>
                                            </div>
                                            <div class="rm-label">Hình ảnh thực tế <span style="font-weight:400;color:#aaa">(Chọn ảnh từ máy, tuỳ chọn)</span></div>
                                            <input type="file" name="imageFile" id="imageFile-${item.productId}" accept="image/*"
                                                   style="width:100%;padding:9px;border:1px solid #ddd;border-radius:7px;font-size:12px;box-sizing:border-box;margin-bottom:6px;"
                                                   onchange="previewImgFile(this,'preview-${item.productId}')"/>
                                            <div id="preview-${item.productId}" style="display:none;margin-bottom:8px;">
                                                <img src="" alt="preview" style="max-width:90px;max-height:90px;border-radius:7px;border:1px solid #eee;object-fit:cover;"/>
                                            </div>
                                            <div class="rm-label">Nhận xét <span style="font-weight:400;color:#aaa">(tuỳ chọn)</span></div>
                                            <textarea name="comment" class="rm-textarea" placeholder="Hãy chia sẻ trải nghiệm của bạn về sản phẩm này nhé!"></textarea>
                                            <label class="rm-anon">
                                                <input type="checkbox" name="isAnonymous" id="anon-${item.productId}"/> Đánh giá ẩn danh
                                            </label>
                                            <div class="rm-minor">
                                                <div class="rm-minor-row">
                                                    <span>Dịch vụ người bán</span>
                                                    <span class="rm-minor-stars" id="seller-stars-${item.productId}" data-pid="${item.productId}" data-field="sellerRating">
                                                        <c:forEach begin="1" end="5" var="s"><span class="minor-star active" data-val="${s}" style="cursor:pointer;font-size:18px;color:#f59e0b;">★</span></c:forEach>
                                                    </span>
                                                    <input type="hidden" name="sellerRating" id="sellerRating-${item.productId}" value="5"/>
                                                </div>
                                                <div class="rm-minor-row">
                                                    <span>Tốc độ giao hàng</span>
                                                    <span class="rm-minor-stars" id="delivery-stars-${item.productId}" data-pid="${item.productId}" data-field="deliveryRating">
                                                        <c:forEach begin="1" end="5" var="s"><span class="minor-star active" data-val="${s}" style="cursor:pointer;font-size:18px;color:#f59e0b;">★</span></c:forEach>
                                                    </span>
                                                    <input type="hidden" name="deliveryRating" id="deliveryRating-${item.productId}" value="5"/>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="rm-footer">
                                            <button type="button" class="rm-btn rm-btn--cancel" onclick="forceCloseReviewModal('${item.productId}')">Trở lại</button>
                                            <button type="submit" class="rm-btn rm-btn--submit"><i class="fa-solid fa-paper-plane" style="margin-right:5px"></i>Gửi đánh giá</button>
                                        </div>
                                    </form>
                                </div>
                            </c:otherwise>
                        </c:choose>
                            </c:when>
                            <c:otherwise>
                                <span class="od-reviewed-badge" style="color: #64748b; background: #f1f5f9;"><i class="fa-solid fa-lock"></i> Chưa nhận hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>

    <%-- ===== ACTIONS ===== --%>
    <div class="od-actions">
        <c:if test="${order.orderStatus == 'PENDING'}">
            <button type="button" class="od-btn od-btn--cancel" onclick="showCancelModal(${order.id})">
                <i class="fa-solid fa-xmark"></i> Hủy đơn hàng
            </button>
        </c:if>
        <c:if test="${order.orderStatus == 'DELIVERED' || order.orderStatus == 'ORDER_DELIVERED' || ((order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED') && order.receivedAt == null)}">
            <form action="${pageContext.request.contextPath}/orders/${order.id}" method="post" style="display:inline;"
                  onsubmit="return confirm('Bạn xác nhận đã nhận được hàng?');">
                <input type="hidden" name="action" value="receive"/>
                <button type="submit" class="od-btn od-btn--receive" style="background: linear-gradient(135deg, #2ecc71, #27ae60); color: white; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: 600; display: inline-flex; align-items: center; gap: 8px; transition: opacity 0.2s; font-family: inherit;">
                    <i class="fa-solid fa-check-double"></i> Đã nhận hàng
                </button>
            </form>
        </c:if>
        <c:if test="${order.orderStatus == 'PENDING_COD'}">
            <div class="od-status-banner od-status-banner--warning">
                <i class="fa-solid fa-clock"></i> Hệ thống đang ghi nhận thanh toán. Bạn sẽ nhận thông báo khi đơn hoàn tất.
            </div>
        </c:if>
        <c:if test="${order.orderStatus == 'RESCHEDULED'}">
            <div class="od-status-banner od-status-banner--purple">
                <i class="fa-solid fa-calendar"></i> Đơn hàng sẽ được giao lại trong thời gian sớm nhất.
            </div>
        </c:if>
        <c:if test="${order.orderStatus == 'RETURNING' || order.orderStatus == 'RETURNED'}">
            <div class="od-status-banner od-status-banner--danger">
                <i class="fa-solid fa-cube"></i> Đơn hàng đang hoàn trả về Shop.
            </div>
        </c:if>
    </div>




</div>
</div>

<!-- Cancel Order Modal -->
<div class="modal" id="cancelOrderModal" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center;">
    <div class="modal-content" style="background: #fff; padding: 25px; border-radius: 12px; max-width: 450px; width: 90%; box-shadow: 0 5px 20px rgba(0,0,0,0.15);">
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #f0f0f0; padding-bottom: 15px; margin-bottom: 15px;">
            <h3 style="margin: 0; font-size: 18px; color: #1a1a2e; font-weight: 700;"><ion-icon name="alert-circle" style="color: #cf1322; margin-right: 8px; vertical-align: middle;"></ion-icon>Hủy Đơn Hàng</h3>
            <span class="close-btn" style="cursor: pointer; font-size: 24px; color: #aaa;" onclick="document.getElementById('cancelOrderModal').style.display='none';">&times;</span>
        </div>
        <p style="color: #555; font-size: 14px; margin-bottom: 15px;">Vui lòng cho biết lý do bạn muốn hủy đơn hàng này?</p>
        <form action="${pageContext.request.contextPath}/orders/${order.id}" method="post" id="cancelOrderForm">
            <input type="hidden" name="action" value="cancel"/>
            
            <div style="background: #fffbe6; border: 1px solid #ffe58f; padding: 12px; border-radius: 6px; margin-bottom: 20px; display: flex; align-items: flex-start; gap: 10px;">
                <ion-icon name="information-circle" style="color: #faad14; font-size: 20px; margin-top: 2px; flex-shrink: 0;"></ion-icon>
                <span style="font-size: 13px; color: #666; line-height: 1.5;">Bạn có biết? Bạn có thể cập nhật thông tin nhận hàng cho đơn hàng (1 lần duy nhất). Nếu bạn xác nhận hủy, toàn bộ đơn hàng sẽ được hủy. Chọn lý do hủy phù hợp nhất với bạn nhé!</span>
            </div>

            <div style="display: flex; flex-direction: column; gap: 12px; margin-bottom: 20px; max-height: 300px; overflow-y: auto; padding-right: 10px;">
                <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-size: 14px; color: #333;">
                    <input type="radio" name="cancelReason" value="Tôi muốn cập nhật địa chỉ/sđt nhận hàng." style="width: 18px; height: 18px; accent-color: #ee4d2d;" required>
                    Tôi muốn cập nhật địa chỉ/sđt nhận hàng.
                </label>
                <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-size: 14px; color: #333;">
                    <input type="radio" name="cancelReason" value="Tôi muốn thêm/thay đổi Mã giảm giá" style="width: 18px; height: 18px; accent-color: #ee4d2d;">
                    Tôi muốn thêm/thay đổi Mã giảm giá
                </label>
                <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-size: 14px; color: #333;">
                    <input type="radio" name="cancelReason" value="Tôi muốn thay đổi sản phẩm (kích thước, màu sắc, số lượng...)" style="width: 18px; height: 18px; accent-color: #ee4d2d;">
                    Tôi muốn thay đổi sản phẩm (kích thước, màu sắc, số lượng...)
                </label>
                <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-size: 14px; color: #333;">
                    <input type="radio" name="cancelReason" value="Thủ tục thanh toán rắc rối" style="width: 18px; height: 18px; accent-color: #ee4d2d;">
                    Thủ tục thanh toán rắc rối
                </label>
                <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-size: 14px; color: #333;">
                    <input type="radio" name="cancelReason" value="Tôi tìm thấy chỗ mua khác tốt hơn (Rẻ hơn, uy tín hơn, giao nhanh hơn...)" style="width: 18px; height: 18px; accent-color: #ee4d2d;">
                    Tôi tìm thấy chỗ mua khác tốt hơn (Rẻ hơn, uy tín hơn, giao nhanh hơn...)
                </label>
                <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-size: 14px; color: #333;">
                    <input type="radio" name="cancelReason" value="Tôi không có nhu cầu mua nữa" style="width: 18px; height: 18px; accent-color: #ee4d2d;">
                    Tôi không có nhu cầu mua nữa
                </label>
                <label style="display: flex; align-items: center; gap: 10px; cursor: pointer; font-size: 14px; color: #333;">
                    <input type="radio" name="cancelReason" value="Tôi không tìm thấy lý do hủy phù hợp" style="width: 18px; height: 18px; accent-color: #ee4d2d;">
                    Tôi không tìm thấy lý do hủy phù hợp
                </label>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 15px; border-top: 1px solid #f0f0f0; padding-top: 15px;">
                <button type="button" class="btn" style="background: transparent; color: #555; border: none; padding: 10px 15px; cursor: pointer; font-weight: 600; font-size: 14px;" onclick="document.getElementById('cancelOrderModal').style.display='none';">KHÔNG PHẢI BÂY GIỜ</button>
                <button type="submit" class="btn" style="background: #ee4d2d; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-weight: 600; font-size: 14px;">HỦY ĐƠN HÀNG</button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp"/>

<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
<script>
function showCancelModal(orderId) {
    document.getElementById('cancelOrderModal').style.display = 'flex';
}
function openReviewModal(pid) {
    document.getElementById('review-modal-overlay-' + pid).style.display = 'flex';
    document.body.style.overflow = 'hidden';
}
function closeReviewModal(event, pid) {
    if (event.target.id === 'review-modal-overlay-' + pid) {
        forceCloseReviewModal(pid);
    }
}
function forceCloseReviewModal(pid) {
    document.getElementById('review-modal-overlay-' + pid).style.display = 'none';
    document.body.style.overflow = 'auto';
}
document.querySelectorAll('.rm-stars').forEach(container => {
    const pid = container.getAttribute('data-pid');
    const stars = container.querySelectorAll('.star');
    const input = document.getElementById('rating-' + pid);
    stars.forEach((star, i) => {
        star.addEventListener('mouseover', () => {
            stars.forEach((s, j) => { s.style.color = j <= i ? '#ffce3d' : '#e0e0e0'; });
        });
        star.addEventListener('mouseout', () => {
            const val = parseInt(input.value) - 1;
            stars.forEach((s, j) => { s.style.color = j <= val ? '#ffce3d' : '#e0e0e0'; });
        });
        star.addEventListener('click', () => {
            input.value = i + 1;
            stars.forEach((s, j) => {
                s.classList.toggle('active', j <= i);
                s.style.color = j <= i ? '#ffce3d' : '#e0e0e0';
            });
        });
    });
});

// Minor star ratings (seller + delivery)
document.querySelectorAll('.rm-minor-stars').forEach(container => {
    const pid = container.getAttribute('data-pid');
    const field = container.getAttribute('data-field');
    if (!pid || !field) return;
    const stars = container.querySelectorAll('.minor-star');
    const input = document.getElementById(field + '-' + pid);
    stars.forEach((star, i) => {
        star.addEventListener('mouseover', () => {
            stars.forEach((s, j) => { s.style.color = j <= i ? '#f59e0b' : '#e0e0e0'; });
        });
        star.addEventListener('mouseout', () => {
            const val = input ? parseInt(input.value) - 1 : 4;
            stars.forEach((s, j) => { s.style.color = j <= val ? '#f59e0b' : '#e0e0e0'; });
        });
        star.addEventListener('click', () => {
            if (input) input.value = i + 1;
            stars.forEach((s, j) => {
                s.style.color = j <= i ? '#f59e0b' : '#e0e0e0';
            });
        });
    });
});

// Image File preview
function previewImgFile(input, previewId) {
    const box = document.getElementById(previewId);
    const img = box.querySelector('img');
    if (input.files && input.files[0]) {
        const reader = new FileReader();
        reader.onload = function(e) {
            img.src = e.target.result;
            box.style.display = 'block';
        };
        reader.readAsDataURL(input.files[0]);
    } else {
        box.style.display = 'none';
    }
}

</script>
</body>
</html>
