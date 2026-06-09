<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Đặt Hàng Thành Công | H&amp;M Sport Shoes</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body { font-family: 'Inter', sans-serif; background: #f4f6f9; color: #1a1a2e; }

        /* ===== PAGE WRAPPER ===== */
        .success-page {
            min-height: calc(100vh - 140px);
            padding: 40px 20px 60px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* ===== HERO BANNER ===== */
        .success-hero {
            text-align: center;
            margin-bottom: 40px;
            animation: fadeInDown 0.6s ease;
        }
        .success-icon-wrap {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: linear-gradient(135deg, #00c48c, #00a67e);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 8px 32px rgba(0, 196, 140, 0.35);
            animation: popIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275) both;
        }
        .success-icon-wrap i { font-size: 42px; color: #fff; }
        .success-hero h1 {
            font-size: 30px;
            font-weight: 800;
            color: #1a1a2e;
            margin-bottom: 8px;
        }
        .success-hero p {
            font-size: 15px;
            color: #6b7280;
        }
        .order-ref {
            display: inline-block;
            margin-top: 12px;
            background: #eef2ff;
            color: #4f46e5;
            padding: 6px 18px;
            border-radius: 30px;
            font-size: 14px;
            font-weight: 600;
        }

        /* ===== MAIN GRID ===== */
        .success-grid {
            width: 100%;
            max-width: 1080px;
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 24px;
            align-items: start;
        }
        @media(max-width: 768px) {
            .success-grid { grid-template-columns: 1fr; }
        }

        /* ===== CARD ===== */
        .sc-card {
            background: #fff;
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 2px 16px rgba(0,0,0,0.06);
            margin-bottom: 20px;
            animation: fadeInUp 0.5s ease both;
        }
        .sc-card:nth-child(2) { animation-delay: 0.1s; }
        .sc-card:nth-child(3) { animation-delay: 0.2s; }
        .sc-card-title {
            font-size: 15px;
            font-weight: 700;
            color: #1a1a2e;
            display: flex;
            align-items: center;
            gap: 9px;
            margin-bottom: 20px;
            padding-bottom: 14px;
            border-bottom: 1px solid #f3f4f6;
        }
        .sc-card-title i { color: #ee4d2d; font-size: 16px; }

        /* ===== PRODUCT LIST ===== */
        .product-item {
            display: flex;
            gap: 16px;
            align-items: flex-start;
            padding: 14px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        .product-item:last-child { border-bottom: none; padding-bottom: 0; }
        .product-img {
            width: 72px;
            height: 72px;
            border-radius: 12px;
            object-fit: cover;
            background: #f9fafb;
            flex-shrink: 0;
            border: 1px solid #e5e7eb;
        }
        .product-img-placeholder {
            width: 72px; height: 72px;
            border-radius: 12px;
            background: linear-gradient(135deg, #f3f4f6, #e5e7eb);
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
            color: #9ca3af; font-size: 22px;
        }
        .product-info { flex: 1; min-width: 0; }
        .product-name {
            font-size: 14px;
            font-weight: 600;
            color: #1a1a2e;
            margin-bottom: 4px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .product-meta {
            font-size: 12px;
            color: #9ca3af;
            margin-bottom: 6px;
        }
        .product-price {
            font-size: 15px;
            font-weight: 700;
            color: #ee4d2d;
        }
        .product-qty {
            font-size: 12px;
            color: #6b7280;
            margin-top: 2px;
        }

        /* ===== ORDER INFO GRID ===== */
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }
        @media(max-width: 480px) { .info-grid { grid-template-columns: 1fr; } }
        .info-item label {
            display: block;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            color: #9ca3af;
            letter-spacing: 0.05em;
            margin-bottom: 4px;
        }
        .info-item span {
            font-size: 14px;
            font-weight: 600;
            color: #1a1a2e;
        }
        .info-item .badge-status {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 4px 12px;
            background: #fef3c7;
            color: #d97706;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        /* ===== RIGHT SIDEBAR ===== */
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            font-size: 14px;
            color: #4b5563;
            border-bottom: 1px solid #f3f4f6;
        }
        .summary-row:last-of-type { border-bottom: none; }
        .summary-row.discount { color: #16a34a; }
        .summary-row.free { color: #16a34a; }
        .summary-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 16px;
            padding-top: 16px;
            border-top: 2px solid #1a1a2e;
            font-weight: 800;
            font-size: 17px;
            color: #1a1a2e;
        }
        .summary-total .total-amount { color: #ee4d2d; font-size: 20px; }

        /* Coupon badge */
        .coupon-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: #f0fdf4;
            border: 1px dashed #86efac;
            border-radius: 12px;
            padding: 12px 16px;
            margin-top: 12px;
        }
        .coupon-code {
            font-size: 14px;
            font-weight: 700;
            color: #15803d;
            letter-spacing: 0.05em;
        }
        .coupon-desc { font-size: 12px; color: #6b7280; margin-top: 2px; }
        .coupon-save { font-size: 15px; font-weight: 700; color: #16a34a; }

        /* ===== BUTTONS ===== */
        .btn-continue {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            width: 100%;
            padding: 15px;
            border-radius: 14px;
            background: linear-gradient(135deg, #ee4d2d, #ff6b47);
            color: #fff;
            font-size: 15px;
            font-weight: 700;
            text-decoration: none;
            margin-top: 20px;
            transition: all 0.25s;
            box-shadow: 0 4px 15px rgba(238,77,45,0.3);
        }
        .btn-continue:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(238,77,45,0.4);
        }
        .btn-track {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 9px;
            width: 100%;
            padding: 13px;
            border-radius: 14px;
            background: #fff;
            border: 1.5px solid #e5e7eb;
            color: #1a1a2e;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            margin-top: 10px;
            transition: all 0.2s;
        }
        .btn-track:hover {
            border-color: #ee4d2d;
            color: #ee4d2d;
            background: #fff5f3;
        }

        /* ===== SUPPORT BOX ===== */
        .support-box {
            margin-top: 20px;
            padding: 16px;
            background: #f9fafb;
            border-radius: 14px;
        }
        .support-box p {
            font-size: 12px;
            font-weight: 700;
            color: #9ca3af;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 12px;
        }
        .support-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
            color: #4b5563;
            margin-bottom: 8px;
            font-weight: 500;
        }
        .support-item i { color: #ee4d2d; width: 16px; }

        /* ===== ANIMATIONS ===== */
        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        @keyframes popIn {
            0%   { transform: scale(0); opacity: 0; }
            80%  { transform: scale(1.1); }
            100% { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="success-page">

    <%-- ===== HERO ===== --%>
    <div class="success-hero">
        <div class="success-icon-wrap">
            <i class="fa-solid fa-check"></i>
        </div>
        <h1>Đặt hàng thành công!</h1>
        <p>Cảm ơn bạn đã tin tưởng H&amp;M Sport Shoes. Đơn hàng của bạn đã được xác nhận.</p>
        <c:if test="${order != null}">
            <span class="order-ref"><i class="fa-solid fa-receipt"></i> &nbsp;Mã đơn: #${order.id}</span>
        </c:if>
    </div>

    <%-- ===== MAIN GRID ===== --%>
    <div class="success-grid">

        <%-- ===== LEFT COLUMN ===== --%>
        <div class="left-col">

            <%-- Sản phẩm đã đặt --%>
            <div class="sc-card">
                <div class="sc-card-title">
                    <i class="fa-solid fa-box-open"></i> Sản phẩm đã đặt
                </div>
                <c:choose>
                    <c:when test="${order != null && not empty order.items}">
                        <c:forEach var="item" items="${order.items}">
                            <div class="product-item">
                                <c:choose>
                                    <c:when test="${not empty item.imageUrl}">
                                        <c:choose>
                                            <c:when test="${item.imageUrl.startsWith('http')}">
                                                <img class="product-img"
                                                     src="${item.imageUrl}"
                                                     alt="${item.productName}"
                                                     onerror="this.style.display='none';this.nextSibling.style.display='flex';">
                                            </c:when>
                                            <c:otherwise>
                                                <img class="product-img"
                                                     src="${pageContext.request.contextPath}${item.imageUrl.startsWith('/') ? '' : '/'}${item.imageUrl}"
                                                     alt="${item.productName}"
                                                     onerror="this.style.display='none';this.nextSibling.style.display='flex';">
                                            </c:otherwise>
                                        </c:choose>
                                        <div class="product-img-placeholder" style="display:none;"><i class="fa-solid fa-shoe-prints"></i></div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="product-img-placeholder"><i class="fa-solid fa-shoe-prints"></i></div>
                                    </c:otherwise>
                                </c:choose>
                                <div class="product-info">
                                    <div class="product-name">${item.productName}</div>
                                    <div class="product-meta">
                                        Màu: ${item.colorName} &nbsp;•&nbsp; Size: ${item.sizeName}
                                    </div>
                                    <div class="product-price">
                                        <fmt:formatNumber value="${item.unitPrice}" type="number"/>₫
                                    </div>
                                    <div class="product-qty">× ${item.quantity} sản phẩm</div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align:center;padding:24px;color:#9ca3af;">
                            <i class="fa-solid fa-box-open" style="font-size:36px;margin-bottom:10px;display:block;"></i>
                            Không tìm thấy sản phẩm
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <%-- Thông tin đơn hàng --%>
            <c:if test="${order != null}">
            <div class="sc-card">
                <div class="sc-card-title">
                    <i class="fa-solid fa-circle-info"></i> Thông tin đơn hàng
                </div>
                <div class="info-grid">
                    <div class="info-item">
                        <label>Mã đơn hàng</label>
                        <span>#${order.id}</span>
                    </div>
                    <div class="info-item">
                        <label>Ngày đặt</label>
                        <span>
                            <c:choose>
                                <c:when test="${order.createdAtTimestamp != null}">
                                    <fmt:formatDate value="${order.createdAtTimestamp}" pattern="dd/MM/yyyy HH:mm"/>
                                </c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item">
                        <label>Trạng thái</label>
                        <span class="badge-status">
                            <i class="fa-solid fa-clock"></i> ${order != null ? order.vietnameseStatus : 'Chờ xác nhận'}
                        </span>
                    </div>
                    <div class="info-item">
                        <label>Thanh toán</label>
                        <span>
                            <c:choose>
                                <c:when test="${order.paymentMethod == 'COD'}">
                                    <i class="fa-solid fa-money-bill-wave" style="color:#f59e0b;"></i> Thanh toán khi nhận hàng
                                </c:when>
                                <c:when test="${order.paymentMethod == 'VNPAY'}">
                                    <i class="fa-solid fa-credit-card" style="color:#3b82f6;"></i> VNPay
                                </c:when>
                                <c:otherwise>${order.paymentMethod}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-item" style="grid-column:1/-1;">
                        <label>Địa chỉ giao hàng</label>
                        <span>${not empty order.shippingAddress ? order.shippingAddress : '—'}</span>
                    </div>
                    <c:if test="${not empty order.phoneNumber}">
                    <div class="info-item">
                        <label>Số điện thoại</label>
                        <span>${order.phoneNumber}</span>
                    </div>
                    </c:if>
                    <c:if test="${not empty order.orderNote}">
                    <div class="info-item" style="grid-column:1/-1;">
                        <label>Ghi chú</label>
                        <span>${order.orderNote}</span>
                    </div>
                    </c:if>
                </div>
            </div>
            </c:if>

        </div><%-- end left-col --%>

        <%-- ===== RIGHT SIDEBAR ===== --%>
        <div class="right-col">
            <div class="sc-card" style="position:sticky;top:24px;">
                <div class="sc-card-title">
                    <i class="fa-solid fa-receipt"></i> Tóm tắt đơn hàng
                </div>

                <c:if test="${order != null}">
                    <div class="summary-row">
                        <span>Tạm tính</span>
                        <span><fmt:formatNumber value="${order.subTotal}" type="number"/>₫</span>
                    </div>

                    <c:if test="${order.discountAmount != null && order.discountAmount > 0}">
                    <div class="summary-row discount">
                        <span><i class="fa-solid fa-tag"></i> Giảm giá</span>
                        <span>-<fmt:formatNumber value="${order.discountAmount}" type="number"/>₫</span>
                    </div>
                    </c:if>

                    <div class="summary-row">
                        <span>Phí vận chuyển</span>
                        <c:choose>
                            <c:when test="${order.shippingFee == 0}">
                                <span class="free"><i class="fa-solid fa-check"></i> Miễn phí</span>
                            </c:when>
                            <c:otherwise>
                                <span><fmt:formatNumber value="${order.shippingFee}" type="number"/>₫</span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="summary-total">
                        <span>Tổng cộng</span>
                        <span class="total-amount"><fmt:formatNumber value="${order.grandTotal}" type="number"/>₫</span>
                    </div>

                    <%-- Coupon --%>
                    <c:if test="${order.discountAmount != null && order.discountAmount > 0}">
                    <div class="coupon-row">
                        <div>
                            <div class="coupon-code"><i class="fa-solid fa-ticket"></i> Mã giảm giá đã dùng</div>
                            <div class="coupon-desc">Tiết kiệm <fmt:formatNumber value="${order.discountAmount}" type="number"/>₫</div>
                        </div>
                        <div class="coupon-save">-<fmt:formatNumber value="${order.discountAmount}" type="number"/>₫</div>
                    </div>
                    </c:if>
                </c:if>

                <a href="${pageContext.request.contextPath}/menu" class="btn-continue">
                    <i class="fa-solid fa-bag-shopping"></i> Tiếp tục mua sắm
                </a>
                <a href="${pageContext.request.contextPath}/account#order-history" class="btn-track">
                    <i class="fa-solid fa-truck-fast"></i> Theo dõi đơn hàng
                </a>

                <div class="support-box">
                    <p>Cần hỗ trợ?</p>
                    <div class="support-item">
                        <i class="fa-solid fa-phone"></i>
                        Hotline: 0367 085 888
                    </div>
                    <div class="support-item">
                        <i class="fa-solid fa-envelope"></i>
                        hm_sport@gmail.com
                    </div>
                    <div class="support-item">
                        <i class="fa-solid fa-location-dot"></i>
                        136 Kim Giang, Hoàng Mai, Hà Nội
                    </div>
                </div>
            </div>
        </div><%-- end right-col --%>

    </div><%-- end success-grid --%>
</div><%-- end success-page --%>

<jsp:include page="footer.jsp"/>

</body>
</html>
