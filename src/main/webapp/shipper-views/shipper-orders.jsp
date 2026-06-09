<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Shipper App | H&M Sport Shoes</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg: #F0F4FF;
            --white: #FFFFFF;
            --primary: #4318FF;
            --green: #05CD99;
            --orange: #FF754C;
            --blue: #3965FF;
            --yellow: #f39c12;
            --red: #e74c3c;
            --purple: #8e44ad;
            --gray: #A3AED0;
            --dark: #2B3674;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg); color: var(--dark); min-height: 100vh; }

        /* NAV */
        .nav { background: var(--white); padding: 16px 24px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 20px rgba(67,24,255,0.08); position: sticky; top: 0; z-index: 100; }
        .nav-brand { display: flex; align-items: center; gap: 10px; }
        .nav-brand .icon { width: 40px; height: 40px; background: linear-gradient(135deg, var(--primary), #7551FF); border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white; font-size: 18px; }
        .nav-brand h1 { font-size: 18px; font-weight: 800; color: var(--primary); }
        .nav-user { display: flex; align-items: center; gap: 12px; font-weight: 600; font-size: 14px; color: var(--dark); }
        .nav-user a { color: var(--orange); text-decoration: none; font-size: 13px; display: flex; align-items: center; gap: 5px; padding: 7px 14px; border-radius: 10px; background: rgba(255,117,76,0.08); transition: 0.2s; }
        .nav-user a:hover { background: rgba(255,117,76,0.15); }

        .container { max-width: 960px; margin: 0 auto; padding: 24px 16px; }

        /* ALERT */
        .alert { padding: 14px 20px; border-radius: 14px; margin-bottom: 20px; font-weight: 600; font-size: 14px; display: flex; align-items: center; gap: 10px; }
        .alert-success { background: rgba(5,205,153,0.12); color: #027a5f; border: 1px solid rgba(5,205,153,0.25); }
        .alert-info { background: rgba(67,24,255,0.08); color: var(--primary); border: 1px solid rgba(67,24,255,0.15); }

        /* STATS BAR */
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; margin-bottom: 24px; }
        .stat-card { background: var(--white); border-radius: 18px; padding: 18px; text-align: center; box-shadow: 0 4px 20px rgba(0,0,0,0.04); }
        .stat-card .num { font-size: 28px; font-weight: 800; }
        .stat-card .lbl { font-size: 12px; color: var(--gray); font-weight: 600; margin-top: 4px; }
        .stat-shipping .num { color: var(--orange); }
        .stat-cod .num { color: var(--yellow); }
        .stat-done .num { color: var(--green); }
        .stat-return .num { color: var(--red); }

        /* ORDER CARD */
        .order-card { background: var(--white); border-radius: 20px; padding: 20px; margin-bottom: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.04); border-left: 4px solid transparent; transition: 0.2s; }
        .order-card:hover { transform: translateY(-2px); box-shadow: 0 8px 30px rgba(0,0,0,0.08); }
        .order-card.status-shipping { border-left-color: var(--orange); }
        .order-card.status-rescheduled { border-left-color: var(--purple); }
        .order-card.status-cod { border-left-color: var(--yellow); }
        .order-card.status-returning { border-left-color: var(--red); }
        .order-card.status-done { border-left-color: var(--green); opacity: 0.75; }

        .order-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 14px; }
        .order-id { font-size: 18px; font-weight: 800; color: var(--dark); }
        .order-id span { color: var(--primary); }

        .badge { padding: 5px 12px; border-radius: 8px; font-size: 12px; font-weight: 700; }
        .badge-shipping { background: rgba(255,117,76,0.12); color: var(--orange); }
        .badge-rescheduled { background: rgba(142,68,173,0.12); color: var(--purple); }
        .badge-cod { background: rgba(243,156,18,0.12); color: var(--yellow); }
        .badge-returning { background: rgba(231,76,60,0.12); color: var(--red); }
        .badge-done { background: rgba(5,205,153,0.12); color: var(--green); }

        .order-info { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 16px; }
        .info-row { display: flex; flex-direction: column; gap: 2px; }
        .info-row-full { grid-column: 1 / -1; }
        .info-label { font-size: 11px; color: var(--gray); font-weight: 700; text-transform: uppercase; }
        .info-value { font-size: 14px; font-weight: 600; color: var(--dark); }
        .info-value.cod-amount { font-size: 18px; font-weight: 800; color: var(--blue); }
        .info-value.paid { color: var(--green); font-size: 14px; }

        /* ACTION BUTTONS */
        .action-row { display: flex; gap: 10px; flex-wrap: wrap; border-top: 1px solid rgba(0,0,0,0.06); padding-top: 16px; margin-top: 4px; }
        .btn { padding: 10px 18px; border-radius: 12px; font-weight: 700; font-size: 13px; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 7px; transition: 0.2s; text-decoration: none; }
        .btn:hover { filter: brightness(0.92); transform: translateY(-1px); }
        .btn-view { background: var(--bg); color: var(--gray); }
        .btn-deliver { background: linear-gradient(135deg, var(--green), #03b07f); color: white; box-shadow: 0 4px 14px rgba(5,205,153,0.3); }
        .btn-reschedule { background: rgba(142,68,173,0.1); color: var(--purple); border: 1.5px solid rgba(142,68,173,0.3); }
        .btn-boom { background: rgba(231,76,60,0.08); color: var(--red); border: 1.5px solid rgba(231,76,60,0.25); }

        /* MODAL */
        .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(17,20,45,0.5); backdrop-filter: blur(6px); z-index: 999; justify-content: center; align-items: center; }
        .modal-overlay.active { display: flex; }
        .modal-box { background: var(--white); border-radius: 24px; padding: 32px; width: 100%; max-width: 440px; box-shadow: 0 24px 60px rgba(0,0,0,0.15); animation: modalIn .2s ease; }
        @keyframes modalIn { from { transform: translateY(20px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .modal-icon { width: 56px; height: 56px; border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 24px; margin: 0 auto 16px; }
        .modal-title { font-size: 18px; font-weight: 800; text-align: center; margin-bottom: 6px; }
        .modal-sub { font-size: 13px; color: var(--gray); text-align: center; margin-bottom: 20px; line-height: 1.5; }
        .modal-input { width: 100%; padding: 13px 16px; border: 1.5px solid #e0e7ff; border-radius: 12px; font-family: inherit; font-size: 14px; outline: none; transition: 0.2s; box-sizing: border-box; }
        .modal-input:focus { border-color: var(--primary); }
        .modal-actions { display: flex; gap: 10px; margin-top: 20px; }
        .modal-actions .btn { flex: 1; justify-content: center; padding: 13px; font-size: 14px; }
        .btn-cancel-modal { background: var(--bg); color: var(--gray); }

        /* DETAIL SECTION */
        .detail-card { background: var(--white); border-radius: 20px; padding: 24px; margin-bottom: 24px; box-shadow: 0 4px 20px rgba(0,0,0,0.04); }
        .detail-card h3 { font-size: 18px; font-weight: 800; margin-bottom: 16px; display: flex; justify-content: space-between; align-items: center; }
        .detail-close { color: var(--gray); font-size: 22px; text-decoration: none; }
        .detail-table { width: 100%; border-collapse: collapse; }
        .detail-table th { text-align: left; padding: 10px 0; font-size: 12px; color: var(--gray); font-weight: 700; text-transform: uppercase; border-bottom: 2px solid var(--bg); }
        .detail-table td { padding: 14px 0; border-bottom: 1px solid var(--bg); vertical-align: middle; }

        /* EMPTY STATE */
        .empty { text-align: center; padding: 60px 20px; color: var(--gray); }
        .empty i { font-size: 52px; margin-bottom: 16px; display: block; color: #C8D2F0; }
        .empty p { font-size: 15px; font-weight: 600; }

        /* LEGEND */
        .legend { background: var(--white); border-radius: 16px; padding: 16px 20px; margin-bottom: 20px; display: flex; gap: 16px; flex-wrap: wrap; align-items: center; box-shadow: 0 2px 12px rgba(0,0,0,0.03); }
        .legend-title { font-size: 12px; font-weight: 700; color: var(--gray); text-transform: uppercase; }
        .legend-item { display: flex; align-items: center; gap: 6px; font-size: 12px; font-weight: 600; }
        .legend-dot { width: 10px; height: 10px; border-radius: 50%; }

        @media (max-width: 600px) {
            .stats-row { grid-template-columns: repeat(2, 1fr); }
            .order-info { grid-template-columns: 1fr; }
            .action-row { flex-direction: column; }
            .btn { justify-content: center; }
        }
    </style>
</head>
<body>

<div class="nav">
    <div class="nav-brand">
        <div class="icon"><i class="fa-solid fa-truck-fast"></i></div>
        <h1>H&M Shipper App</h1>
    </div>
    <div class="nav-user">
        <span><i class="fa-solid fa-user-circle"></i> ${sessionScope.currentUser.fullName}</span>
        <a href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i> Thoát</a>
    </div>
</div>

<div class="container">

    <%-- ALERT --%>
    <c:if test="${not empty sessionScope.shipperMsg}">
        <div class="alert alert-success">
            ${sessionScope.shipperMsg}
        </div>
        <c:remove var="shipperMsg" scope="session"/>
    </c:if>

    <%-- STATS --%>
    <div class="stats-row">
        <div class="stat-card stat-shipping">
            <div class="num">
                <c:set var="cntShipping" value="0"/>
                <c:forEach var="o" items="${orders}">
                    <c:if test="${o.orderStatus == 'ORDER_SHIPPING' || o.orderStatus == 'RESCHEDULED'}">
                        <c:set var="cntShipping" value="${cntShipping + 1}"/>
                    </c:if>
                </c:forEach>
                ${cntShipping}
            </div>
            <div class="lbl">Cần giao</div>
        </div>
        <div class="stat-card stat-cod">
            <div class="num">
                <c:set var="cntCod" value="0"/>
                <c:forEach var="o" items="${orders}">
                    <c:if test="${o.orderStatus == 'PENDING_COD'}">
                        <c:set var="cntCod" value="${cntCod + 1}"/>
                    </c:if>
                </c:forEach>
                ${cntCod}
            </div>
            <div class="lbl">Chờ đối soát</div>
        </div>
        <div class="stat-card stat-done">
            <div class="num">
                <c:set var="cntDone" value="0"/>
                <c:forEach var="o" items="${orders}">
                    <c:if test="${o.orderStatus == 'ORDER_COMPLETED' || o.orderStatus == 'ORDER_DELIVERED'}">
                        <c:set var="cntDone" value="${cntDone + 1}"/>
                    </c:if>
                </c:forEach>
                ${cntDone}
            </div>
            <div class="lbl">Hoàn thành</div>
        </div>
        <div class="stat-card stat-return">
            <div class="num">
                <c:set var="cntReturn" value="0"/>
                <c:forEach var="o" items="${orders}">
                    <c:if test="${o.orderStatus == 'RETURNING'}">
                        <c:set var="cntReturn" value="${cntReturn + 1}"/>
                    </c:if>
                </c:forEach>
                ${cntReturn}
            </div>
            <div class="lbl">Đang hoàn</div>
        </div>
    </div>

    <%-- LEGEND --%>
    <div class="legend">
        <span class="legend-title">Trạng thái:</span>
        <span class="legend-item"><span class="legend-dot" style="background:var(--orange)"></span> Đang giao</span>
        <span class="legend-item"><span class="legend-dot" style="background:var(--purple)"></span> Hẹn lại</span>
        <span class="legend-item"><span class="legend-dot" style="background:var(--yellow)"></span> Chờ đối soát COD</span>
        <span class="legend-item"><span class="legend-dot" style="background:var(--red)"></span> Đang hoàn</span>
        <span class="legend-item"><span class="legend-dot" style="background:var(--green)"></span> Hoàn thành</span>
    </div>

    <%-- ORDER DETAIL (when selected) --%>
    <c:if test="${not empty selectedOrder}">
        <div class="detail-card" id="detailSection">
            <h3>
                Chi tiết đơn #${selectedOrder.id}
                <a href="${pageContext.request.contextPath}/shipper/orders" class="detail-close" title="Đóng">&times;</a>
            </h3>
            <p style="font-size:13px;color:var(--gray);margin-bottom:16px;">
                <i class="fa-solid fa-box"></i> Danh sách sản phẩm trong đơn
            </p>
            <table class="detail-table">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th style="text-align:center">SL</th>
                        <th style="text-align:right">Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${selectedOrder.items}">
                        <tr>
                            <td style="display:flex;align-items:center;gap:12px;">
                                <img src="${item.imageUrl}" style="width:44px;height:44px;border-radius:10px;object-fit:cover;" onerror="this.src='https://placehold.co/80x80?text=Giay'">
                                <div>
                                    <div style="font-weight:700;font-size:14px;">${item.productName}</div>
                                    <small style="color:var(--gray);">${item.colorName} / ${item.sizeName}</small>
                                </div>
                            </td>
                            <td style="text-align:center;font-weight:700;">${item.quantity}</td>
                            <td style="text-align:right;font-weight:700;color:var(--blue);">
                                <fmt:formatNumber value="${item.unitPrice * item.quantity}" type="number"/>₫
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <div style="text-align:right;margin-top:16px;font-size:18px;font-weight:800;color:var(--primary);">
                Thu COD: <fmt:formatNumber value="${selectedOrder.grandTotal}" type="number"/>₫
            </div>
            <c:if test="${not empty selectedOrder.shippingAddress}">
                <div style="margin-top:8px;font-size:14px;color:var(--dark);">
                    <i class="fa-solid fa-location-dot"></i> Địa chỉ: ${selectedOrder.shippingAddress}
                </div>
            </c:if>
            <c:if test="${not empty selectedOrder.phoneNumber}">
                <div style="margin-top:4px;font-size:14px;color:var(--dark);">
                    <i class="fa-solid fa-phone"></i> SĐT: ${selectedOrder.phoneNumber}
                </div>
            </c:if>
        </div>
        <script>document.getElementById('detailSection').scrollIntoView({behavior:'smooth'});</script>
    </c:if>

    <%-- ORDER LIST --%>
    <div id="orderListContainer" style="width: 100%;">
    <c:if test="${empty orders}">
        <div class="empty">
            <i class="fa-solid fa-box-open"></i>
            <p>Bạn chưa được phân công đơn hàng nào.</p>
        </div>
    </c:if>

    <c:forEach var="order" items="${orders}">
        <c:set var="cardClass" value=""/>
        <c:choose>
            <c:when test="${order.orderStatus == 'ORDER_SHIPPING'}"><c:set var="cardClass" value="status-shipping"/></c:when>
            <c:when test="${order.orderStatus == 'RESCHEDULED'}"><c:set var="cardClass" value="status-rescheduled"/></c:when>
            <c:when test="${order.orderStatus == 'PENDING_COD'}"><c:set var="cardClass" value="status-cod"/></c:when>
            <c:when test="${order.orderStatus == 'RETURNING'}"><c:set var="cardClass" value="status-returning"/></c:when>
            <c:otherwise><c:set var="cardClass" value="status-done"/></c:otherwise>
        </c:choose>

        <div class="order-card ${cardClass}">
            <div class="order-top">
                <div class="order-id">Đơn <span>#${order.id}</span></div>
                <c:choose>
                    <c:when test="${order.orderStatus == 'ORDER_SHIPPING'}">
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'WARRANTY'}">
                                <span class="badge badge-shipping" style="background: rgba(67,24,255,0.1); color: var(--primary);"><i class="fa-solid fa-truck-ramp-box"></i> Đang lấy hàng</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-shipping"><i class="fa-solid fa-truck-fast"></i> Đang giao</span>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:when test="${order.orderStatus == 'RESCHEDULED'}">
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'WARRANTY'}">
                                <span class="badge badge-rescheduled"><i class="fa-solid fa-rotate"></i> Hẹn lấy lại</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-rescheduled"><i class="fa-solid fa-rotate"></i> Hẹn giao lại</span>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:when test="${order.orderStatus == 'PENDING_COD'}">
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'WARRANTY'}">
                                <span class="badge badge-cod" style="background: rgba(67,24,255,0.08); color: var(--primary);"><i class="fa-solid fa-circle-check"></i> Đang đối soát lấy hàng</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-cod"><i class="fa-solid fa-sack-dollar"></i> Chờ đối soát COD</span>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:when test="${order.orderStatus == 'RETURNING'}">
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'WARRANTY'}">
                                <span class="badge badge-returning"><i class="fa-solid fa-box-open"></i> Không lấy được hàng</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-returning"><i class="fa-solid fa-box-open"></i> Đang hoàn hàng</span>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:when test="${order.orderStatus == 'ORDER_DELIVERED' || order.orderStatus == 'ORDER_COMPLETED'}">
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'WARRANTY'}">
                                <span class="badge badge-done"><i class="fa-solid fa-check-circle"></i> Đã lấy hàng</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-done"><i class="fa-solid fa-check-circle"></i> Hoàn thành</span>
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${order.reviewed}"><span class="badge" style="background:#e8f4fd;color:#3498db;margin-left:5px;">Đã đánh giá</span></c:if>
                    </c:when>
                    <c:otherwise><span class="badge" style="background:#f0f0f0;color:#999;">${order.vietnameseStatus}</span></c:otherwise>
                </c:choose>
            </div>

            <div class="order-info">
                <div class="info-row">
                    <c:choose>
                        <c:when test="${order.paymentMethod == 'WARRANTY'}">
                            <span class="info-label"><i class="fa-solid fa-shield-halved"></i> Loại đơn</span>
                            <span class="info-value" style="color:var(--primary);font-weight:700;">Thu hồi / Bảo hành (Không thu tiền)</span>
                        </c:when>
                        <c:otherwise>
                            <span class="info-label"><i class="fa-solid fa-money-bill-wave"></i> Thu COD</span>
                            <c:choose>
                                <c:when test="${order.paymentStatus == 'PAID' || order.paymentStatus == 'COD_COLLECTED'}">
                                    <span class="info-value paid"><i class="fa-solid fa-check-circle"></i> Đã thu / Đã thanh toán</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="info-value cod-amount"><fmt:formatNumber value="${order.grandTotal}" type="number"/>₫</span>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </div>
                <c:if test="${not empty order.phoneNumber}">
                <div class="info-row">
                    <span class="info-label"><i class="fa-solid fa-phone"></i> SĐT khách</span>
                    <span class="info-value">
                        <a href="tel:${order.phoneNumber}" style="color:var(--blue);text-decoration:none;font-weight:700;">
                            ${order.phoneNumber}
                        </a>
                    </span>
                </div>
                </c:if>
                <c:if test="${not empty order.shippingAddress}">
                <div class="info-row" style="grid-column: 1 / -1;">
                    <span class="info-label">
                        <c:choose>
                            <c:when test="${order.paymentMethod == 'WARRANTY'}">
                                <i class="fa-solid fa-location-dot"></i> Địa chỉ lấy hàng
                            </c:when>
                            <c:otherwise>
                                <i class="fa-solid fa-location-dot"></i> Địa chỉ giao
                            </c:otherwise>
                        </c:choose>
                    </span>
                    <span class="info-value" style="font-size:13px;">${order.shippingAddress}</span>
                </div>
                </c:if>
                <c:if test="${not empty order.trackingCode}">
                <div class="info-row">
                    <span class="info-label"><i class="fa-solid fa-barcode"></i> Mã vận đơn</span>
                    <span class="info-value" style="font-family:monospace;font-size:13px;">${order.trackingCode}</span>
                </div>
                </c:if>
            </div>

            <%-- ACTION BUTTONS based on status --%>
            <div class="action-row">
                <a href="${pageContext.request.contextPath}/shipper/orders?action=view&orderId=${order.id}" class="btn btn-view">
                    <i class="fa-solid fa-eye"></i> Chi tiết
                </a>

                <c:if test="${order.orderStatus == 'ORDER_DELIVERED' || order.orderStatus == 'ORDER_COMPLETED'}">
                    <button type="button" class="btn btn-boom" onclick="openReturnModal('${order.id}')">
                        <i class="fa-solid fa-undo"></i> Hoàn hàng
                    </button>
                </c:if>

                <%-- Đang giao: 3 hành động chính --%>
                <c:if test="${order.orderStatus == 'ORDER_SHIPPING' || order.orderStatus == 'RESCHEDULED'}">
                    <c:choose>
                        <c:when test="${order.paymentMethod == 'WARRANTY'}">
                            <button type="button" class="btn btn-deliver" onclick="openDeliverModal('${order.id}', true)">
                                <i class="fa-solid fa-check-double"></i> Lấy hàng thành công
                            </button>
                            <button type="button" class="btn btn-reschedule" onclick="openRescheduleModal('${order.id}', true)">
                                <i class="fa-solid fa-calendar-plus"></i> Hẹn lấy lại
                            </button>
                            <button type="button" class="btn btn-boom" onclick="openBoomModal('${order.id}', true)">
                                <i class="fa-solid fa-triangle-exclamation"></i> Không lấy được
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" class="btn btn-deliver" onclick="openDeliverModal('${order.id}', false)">
                                <i class="fa-solid fa-check-double"></i> Giao thành công
                            </button>
                            <button type="button" class="btn btn-reschedule" onclick="openRescheduleModal('${order.id}', false)">
                                <i class="fa-solid fa-calendar-plus"></i> Khách hẹn lại
                            </button>
                            <button type="button" class="btn btn-boom" onclick="openBoomModal('${order.id}', false)">
                                <i class="fa-solid fa-triangle-exclamation"></i> Khách boom
                            </button>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </div>

            <%-- PENDING_COD: Chờ shipper nộp tiền về kho --%>
            <c:if test="${order.orderStatus == 'PENDING_COD'}">
                <c:choose>
                    <c:when test="${order.paymentMethod == 'WARRANTY'}">
                        <div style="margin-top:12px;padding:12px 16px;background:rgba(67,24,255,0.06);border-radius:12px;border:1px solid rgba(67,24,255,0.2);font-size:13px;font-weight:600;color:var(--primary);">
                            <i class="fa-solid fa-info-circle"></i>
                            Đã lấy hàng thành công từ khách. Vui lòng bàn giao gói hàng về kho để hoàn tất đối soát.
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="margin-top:12px;padding:12px 16px;background:rgba(243,156,18,0.08);border-radius:12px;border:1px solid rgba(243,156,18,0.2);font-size:13px;font-weight:600;color:var(--yellow);">
                            <i class="fa-solid fa-info-circle"></i>
                            Đã thu tiền khách. Vui lòng nộp/chuyển khoản tiền COD về tài khoản của Shop để đối soát.
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <%-- RETURNING: Đang chuyển hoàn --%>
            <c:if test="${order.orderStatus == 'RETURNING'}">
                <c:choose>
                    <c:when test="${order.paymentMethod == 'WARRANTY'}">
                        <div style="margin-top:12px;padding:12px 16px;background:rgba(231,76,60,0.07);border-radius:12px;border:1px solid rgba(231,76,60,0.2);font-size:13px;font-weight:600;color:var(--red);">
                            <i class="fa-solid fa-box-open"></i>
                            Yêu cầu thu hồi bị huỷ/thất bại. Bỏ qua đơn này hoặc bàn giao lại (nếu có).
                            <c:if test="${not empty order.cancelReason}">
                                <br><span style="opacity:0.75;">Lý do thất bại: ${order.cancelReason}</span>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="margin-top:12px;padding:12px 16px;background:rgba(231,76,60,0.07);border-radius:12px;border:1px solid rgba(231,76,60,0.2);font-size:13px;font-weight:600;color:var(--red);">
                            <i class="fa-solid fa-box-open"></i>
                            Đơn đang trên đường hoàn về shop. Vui lòng bàn giao gói hàng cho Shop.
                            <c:if test="${not empty order.returnReason}">
                                <br><span style="opacity:0.75;">Lý do khách: ${order.returnReason}</span>
                            </c:if>
                            <c:if test="${not empty order.cancelReason}">
                                <br><span style="opacity:0.75;">Ghi chú: ${order.cancelReason}</span>
                            </c:if>
                        </div>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </div>
    </c:forEach>
    </div>

</div>

<%-- MODAL: Giao thành công --%>
<div class="modal-overlay" id="modalDeliver">
    <div class="modal-box">
        <div class="modal-icon" style="background:rgba(5,205,153,0.12);color:var(--green);"><i class="fa-solid fa-check-double"></i></div>
        <div class="modal-title" style="color:var(--green);">Xác nhận giao thành công</div>
        <div class="modal-sub">Bạn xác nhận đã giao hàng và thu tiền COD từ khách thành công?<br>Hành động này không thể hoàn tác.</div>
        <form action="${pageContext.request.contextPath}/shipper/orders" method="post">
            <input type="hidden" name="action" value="deliver">
            <input type="hidden" name="orderId" id="deliverOrderId" value="">
            <div class="modal-actions">
                <button type="button" class="btn btn-cancel-modal" onclick="closeAllModals()"><i class="fa-solid fa-xmark"></i> Huỷ</button>
                <button type="submit" class="btn btn-deliver"><i class="fa-solid fa-check-double"></i> Xác nhận giao xong</button>
            </div>
        </form>
    </div>
</div>

<%-- MODAL: Khách hẹn lại --%>
<div class="modal-overlay" id="modalReschedule">
    <div class="modal-box">
        <div class="modal-icon" style="background:rgba(142,68,173,0.1);color:var(--purple);"><i class="fa-solid fa-calendar-plus"></i></div>
        <div class="modal-title" style="color:var(--purple);">Khách hẹn giao lại</div>
        <div class="modal-sub">Chọn thời gian khách muốn nhận hàng lại.</div>
        <form action="${pageContext.request.contextPath}/shipper/orders" method="post" onsubmit="mergeRescheduleNote()">
            <input type="hidden" name="action" value="reschedule">
            <input type="hidden" name="orderId" id="rescheduleOrderId" value="">

            <div style="margin-bottom:14px;">
                <label style="display:block;font-size:11px;font-weight:700;color:var(--gray);text-transform:uppercase;margin-bottom:6px;">Thời gian giao lại</label>
                <input type="datetime-local" id="rescheduleDatetime" class="modal-input"
                       style="width:100%;padding:13px 16px;border:1.5px solid #e0e7ff;border-radius:12px;font-family:inherit;font-size:14px;outline:none;transition:0.2s;box-sizing:border-box;"
                       oninput="syncRescheduleNote()">
            </div>

            <div style="margin-bottom:4px;">
                <label style="display:block;font-size:11px;font-weight:700;color:var(--gray);text-transform:uppercase;margin-bottom:6px;">Ghi chú thêm (không bắt buộc)</label>
                <input type="text" name="rescheduleNote" id="rescheduleNote" class="modal-input"
                       placeholder="VD: Gọi trước 30 phút...">
            </div>

            <div class="modal-actions">
                <button type="button" class="btn btn-cancel-modal" onclick="closeAllModals()"><i class="fa-solid fa-xmark"></i> Huỷ</button>
                <button type="submit" class="btn btn-reschedule" style="background:var(--purple);color:white;"><i class="fa-solid fa-check"></i> Xác nhận hẹn lại</button>
            </div>
        </form>
    </div>
</div>

<%-- MODAL: Khách boom --%>
<div class="modal-overlay" id="modalBoom">
    <div class="modal-box">
        <div class="modal-icon" style="background:rgba(231,76,60,0.1);color:var(--red);"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <div class="modal-title" style="color:var(--red);">Khách không nhận hàng</div>
        <div class="modal-sub">Ghi rõ lý do để shop theo dõi (không bắt buộc).<br>Đơn sẽ chuyển sang trạng thái <strong>Đang hoàn hàng</strong>.</div>
        <form action="${pageContext.request.contextPath}/shipper/orders" method="post">
            <input type="hidden" name="action" value="boom">
            <input type="hidden" name="orderId" id="boomOrderId" value="">
            <input type="text" name="boomReason" class="modal-input" placeholder="VD: Khách không bắt máy / từ chối nhận...">
            <div class="modal-actions">
                <button type="button" class="btn btn-cancel-modal" onclick="closeAllModals()"><i class="fa-solid fa-xmark"></i> Huỷ</button>
                <button type="submit" class="btn btn-boom" style="background:var(--red);color:white;"><i class="fa-solid fa-box-open"></i> Chuyển hoàn hàng</button>
            </div>
        </form>
    </div>
</div>

<%-- MODAL: Shipper ghi nhận yêu cầu hoàn từ khách --%>
<div class="modal-overlay" id="modalReturn">
    <div class="modal-box">
        <div class="modal-icon" style="background:rgba(231,76,60,0.1);color:var(--red);"><i class="fa-solid fa-rotate-left"></i></div>
        <div class="modal-title" style="color:var(--red);">Ghi nhận hoàn hàng từ khách</div>
        <div class="modal-sub">Ghi lý do khách muốn hoàn hàng (không bắt buộc).<br>Đơn sẽ chuyển sang trạng thái <strong>Đang hoàn hàng</strong>.</div>
        <form action="${pageContext.request.contextPath}/shipper/orders" method="post">
            <input type="hidden" name="action" value="boom">
            <input type="hidden" name="orderId" id="returnOrderId" value="">
            <input type="text" name="boomReason" class="modal-input" placeholder="VD: Khách muốn đổi size / sản phẩm lỗi...">
            <div class="modal-actions">
                <button type="button" class="btn btn-cancel-modal" onclick="closeAllModals()"><i class="fa-solid fa-xmark"></i> Huỷ</button>
                <button type="submit" class="btn btn-boom" style="background:var(--red);color:white;"><i class="fa-solid fa-rotate-left"></i> Xác nhận hoàn hàng</button>
            </div>
        </form>
    </div>
</div>

<script>
function openDeliverModal(orderId, isWarranty) {
    document.getElementById('deliverOrderId').value = orderId;
    var modal = document.getElementById('modalDeliver');
    if (isWarranty) {
        modal.querySelector('.modal-title').innerText = "Xác nhận lấy hàng thành công";
        modal.querySelector('.modal-title').style.color = "var(--green)";
        modal.querySelector('.modal-sub').innerHTML = "Bạn xác nhận đã thu hồi sản phẩm từ khách thành công?<br>Hành động này không thể hoàn tác.";
        modal.querySelector('.btn-deliver').innerHTML = "<i class='fa-solid fa-check-double'></i> Xác nhận đã lấy hàng";
    } else {
        modal.querySelector('.modal-title').innerText = "Xác nhận giao thành công";
        modal.querySelector('.modal-title').style.color = "var(--green)";
        modal.querySelector('.modal-sub').innerHTML = "Bạn xác nhận đã giao hàng và thu tiền COD từ khách thành công?<br>Hành động này không thể hoàn tác.";
        modal.querySelector('.btn-deliver').innerHTML = "<i class='fa-solid fa-check-double'></i> Xác nhận giao xong";
    }
    modal.classList.add('active');
}
function openRescheduleModal(orderId, isWarranty) {
    document.getElementById('rescheduleOrderId').value = orderId;
    var modal = document.getElementById('modalReschedule');
    if (isWarranty) {
        modal.querySelector('.modal-title').innerText = "Hẹn lấy lại hàng";
        modal.querySelector('.modal-title').style.color = "var(--purple)";
        modal.querySelector('.modal-sub').innerText = "Chọn thời gian muốn lấy hàng lại từ khách.";
        modal.querySelector('label[style*="text-transform:uppercase"]').innerText = "Thời gian lấy lại";
        modal.querySelector('.btn-reschedule').innerHTML = "<i class='fa-solid fa-check'></i> Xác nhận hẹn lấy lại";
        window.currentIsWarranty = true;
    } else {
        modal.querySelector('.modal-title').innerText = "Khách hẹn giao lại";
        modal.querySelector('.modal-title').style.color = "var(--purple)";
        modal.querySelector('.modal-sub').innerText = "Chọn thời gian khách muốn nhận hàng lại.";
        modal.querySelector('label[style*="text-transform:uppercase"]').innerText = "Thời gian giao lại";
        modal.querySelector('.btn-reschedule').innerHTML = "<i class='fa-solid fa-check'></i> Xác nhận hẹn lại";
        window.currentIsWarranty = false;
    }

    // Default: tomorrow 08:00
    const tomorrow = new Date();
    tomorrow.setDate(tomorrow.getDate() + 1);
    tomorrow.setHours(8, 0, 0, 0);
    const pad = n => String(n).padStart(2, '0');
    const defaultVal = tomorrow.getFullYear() + '-' + pad(tomorrow.getMonth()+1) + '-' + pad(tomorrow.getDate())
                     + 'T' + pad(tomorrow.getHours()) + ':' + pad(tomorrow.getMinutes());
    document.getElementById('rescheduleDatetime').value = defaultVal;
    syncRescheduleNote();

    document.getElementById('rescheduleNote').value = '';
    setTimeout(() => document.getElementById('rescheduleNote').focus(), 150);
    modal.classList.add('active');
}

function syncRescheduleNote() {
    const dt = document.getElementById('rescheduleDatetime').value;
    if (!dt) return;
    const d = new Date(dt);
    const days = ['CN','T2','T3','T4','T5','T6','T7'];
    const label = days[d.getDay()] + ' ' + String(d.getDate()).padStart(2,'0') + '/'
                + String(d.getMonth()+1).padStart(2,'0') + ' lúc '
                + String(d.getHours()).padStart(2,'0') + 'h' + String(d.getMinutes()).padStart(2,'0');
    // Auto-fill note with formatted date if note is empty or was auto-filled before
    const noteEl = document.getElementById('rescheduleNote');
    if (!noteEl.dataset.manualEdit) {
        var prefix = window.currentIsWarranty ? 'Hẹn lấy: ' : 'Hẹn giao: ';
        noteEl.placeholder = prefix + label;
    }
    // Store formatted time to be sent alongside note
    document.getElementById('rescheduleDatetime').dataset.label = label;
}
function openBoomModal(orderId, isWarranty) {
    document.getElementById('boomOrderId').value = orderId;
    var modal = document.getElementById('modalBoom');
    if (isWarranty) {
        modal.querySelector('.modal-title').innerText = "Không lấy được hàng";
        modal.querySelector('.modal-title').style.color = "var(--red)";
        modal.querySelector('.modal-sub').innerHTML = "Ghi rõ lý do không thu hồi được sản phẩm (không bắt buộc).<br>Đơn sẽ chuyển sang trạng thái <strong>Đang hoàn hàng</strong>.";
        modal.querySelector('.modal-input').placeholder = "VD: Khách không liên lạc được / hủy yêu cầu bảo hành...";
        modal.querySelector('.btn-boom').innerHTML = "<i class='fa-solid fa-box-open'></i> Không lấy được hàng";
    } else {
        modal.querySelector('.modal-title').innerText = "Khách không nhận hàng";
        modal.querySelector('.modal-title').style.color = "var(--red)";
        modal.querySelector('.modal-sub').innerHTML = "Ghi rõ lý do để shop theo dõi (không bắt buộc).<br>Đơn sẽ chuyển sang trạng thái <strong>Đang hoàn hàng</strong>.";
        modal.querySelector('.modal-input').placeholder = "VD: Khách không bắt máy / từ chối nhận...";
        modal.querySelector('.btn-boom').innerHTML = "<i class='fa-solid fa-box-open'></i> Chuyển hoàn hàng";
    }
    modal.classList.add('active');
    modal.querySelector('.modal-input').value = '';
    setTimeout(() => modal.querySelector('.modal-input').focus(), 100);
}
function openReturnModal(orderId) {
    document.getElementById('returnOrderId').value = orderId;
    document.getElementById('modalReturn').classList.add('active');
    document.querySelector('#modalReturn .modal-input').value = '';
    setTimeout(() => document.querySelector('#modalReturn .modal-input').focus(), 100);
}
function mergeRescheduleNote() {
    const dtEl = document.getElementById('rescheduleDatetime');
    const noteEl = document.getElementById('rescheduleNote');
    const label = dtEl.dataset.label || '';
    const extra = noteEl.value.trim();
    if (label) {
        var prefix = window.currentIsWarranty ? 'Hẹn lấy: ' : 'Hẹn giao: ';
        noteEl.value = prefix + label + (extra ? ' | ' + extra : '');
    }
}
function closeAllModals() {
    document.querySelectorAll('.modal-overlay').forEach(m => m.classList.remove('active'));
}
// Close on backdrop click
document.querySelectorAll('.modal-overlay').forEach(overlay => {
    overlay.addEventListener('click', function(e) {
        if (e.target === this) closeAllModals();
    });
});

// Intercept all status update forms on the shipper page for AJAX updates
document.querySelectorAll('form[action*="/shipper/orders"]').forEach(form => {
    form.addEventListener('submit', async function(e) {
        if (form.dataset.skipAjax === "true") return;
        
        const actionInput = form.querySelector('input[name="action"]');
        if (!actionInput) return;
        
        e.preventDefault();
        
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalBtnHtml = submitBtn ? submitBtn.innerHTML : '';
        if (submitBtn) {
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fa-solid fa-spinner fa-spin"></i> Đang cập nhật...';
        }
        
        try {
            const formData = new URLSearchParams(new FormData(form));
            const response = await fetch(form.action, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: formData.toString()
            });
            
            if (response.ok) {
                const htmlText = await response.text();
                const parser = new DOMParser();
                const doc = parser.parseFromString(htmlText, 'text/html');
                
                const newStats = doc.querySelector('.stats-row');
                if (newStats) {
                    document.querySelector('.stats-row').innerHTML = newStats.innerHTML;
                }
                
                const newOrderList = doc.querySelector('#orderListContainer');
                if (newOrderList) {
                    document.getElementById('orderListContainer').innerHTML = newOrderList.innerHTML;
                }
                
                const newAlert = doc.querySelector('.alert');
                let alertEl = document.querySelector('.container .alert');
                if (newAlert) {
                    if (!alertEl) {
                        alertEl = document.createElement('div');
                        alertEl.className = newAlert.className;
                        document.querySelector('.container').prepend(alertEl);
                    }
                    alertEl.innerHTML = newAlert.innerHTML;
                    alertEl.style.display = 'flex';
                } else if (alertEl) {
                    alertEl.style.display = 'none';
                }
                
                closeAllModals();
            } else {
                console.warn('AJAX failed, falling back to standard submit. Status:', response.status);
                // Temporarily disable the interceptor for this form submission to prevent infinite loops
                form.dataset.skipAjax = "true";
                form.submit();
            }
        } catch (error) {
            console.error('Error updating order via AJAX, falling back to standard submit:', error);
            form.dataset.skipAjax = "true";
            form.submit();
        } finally {
            if (submitBtn) {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalBtnHtml;
            }
        }
    });
});

// Scroll position memory to prevent scroll resets during full-page reloads/fallbacks
window.addEventListener('beforeunload', function() {
    localStorage.setItem('shipperScrollPos', window.scrollY);
});

window.addEventListener('load', function() {
    const pos = localStorage.getItem('shipperScrollPos');
    if (pos !== null) {
        window.scrollTo(0, parseInt(pos, 10));
        localStorage.removeItem('shipperScrollPos');
    }
});
</script>
</body>
</html>
