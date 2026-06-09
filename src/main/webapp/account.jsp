<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.user.User" %>

<% User user = (User) session.getAttribute("currentUser");
   if (user == null) { response.sendRedirect("login.jsp"); return; } %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>H&M - SPORT SHOES</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/favicon_io/favicon.ico" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300;400;500;600;700&family=Roboto:wght@400;500;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/account.css?v=<%= System.currentTimeMillis() %>" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/order-detail.css?v=<%= System.currentTimeMillis() %>" />
</head>

<body id="top">
    <jsp:include page="header.jsp" />

    <main class="TaiKhoanPage">
        <div class="container account-dashboard">
            <h1 class="page-title">Tài Khoản Của Tôi</h1>

            <div class="account-layout">
                <!-- ===== SIDEBAR ===== -->
                <aside class="account-sidebar">
                    <div class="user-info-summary">
                        <p class="user-name-display">
                            Xin chào,
                            <strong><c:out value="${sessionScope.currentUser.fullName}" default="${sessionScope.currentUser.email}" /></strong>
                        </p>
                    </div>
                    <ul class="account-nav-list">
                        <li><a href="#personal-info" data-tab="info">
                            <i class="fa-solid fa-user-circle"></i> Thông tin cá nhân
                        </a></li>
                        <li><a href="#change-password" data-tab="password">
                            <i class="fa-solid fa-lock"></i> Đổi mật khẩu
                        </a></li>
                        <li><a href="#order-history" data-tab="orders">
                            <i class="fa-solid fa-clock-rotate-left"></i> Lịch sử đơn hàng
                        </a></li>
                        <li><a href="#voucher-wallet" data-tab="vouchers">
                            <i class="fa-solid fa-tag"></i> Kho voucher
                        </a></li>
                        <li><a href="#warranty-management" data-tab="warranty">
                            <i class="fa-solid fa-shield-halved"></i> Quản lý bảo hành
                        </a></li>
                        <li>
                            <a href="#" id="btn-logout-trigger">
                                <i class="fa-solid fa-right-from-bracket"></i> Đăng xuất
                            </a>
                        </li>
                    </ul>
                </aside>

                <!-- ===== CONTENT ===== -->
                <div class="account-content">
                    <% String msg = (String) request.getAttribute("msg");
                       String msgType = (String) request.getAttribute("msgType");
                       if (msg != null) {
                           String alertClass = (msgType != null && msgType.equals("success")) ? "alert-success" : "alert-danger"; %>
                    <div class="alert <%= alertClass %>" role="alert" style="margin-bottom:20px;"><%= msg %></div>
                    <% } %>

                    <!-- ===== TAB: THÔNG TIN CÁ NHÂN ===== -->
                    <section id="personal-info" class="tab-content" data-content="info">
                        <h3 class="content-title">Thông Tin Cá Nhân</h3>
                        <p style="color:#8a8fa8;font-size:14px;margin-bottom:0;">Quản lý tên, email và số điện thoại của bạn.</p>
                        <form class="account-form" method="post" action="${pageContext.request.contextPath}/account">
                            <input type="hidden" name="action" value="update-profile" />
                            <div class="input-group">
                                <label for="full-name">Họ và Tên</label>
                                <input type="text" id="full-name" name="fullName" value="<c:out value='${sessionScope.currentUser.fullName}'/>" required />
                            </div>
                            <div class="input-group">
                                <label for="email">Địa chỉ Email</label>
                                <input type="email" id="email" name="email" value="<c:out value='${sessionScope.currentUser.email}'/>" readonly required />
                            </div>
                            <div class="input-group">
                                <label for="phone">Số điện thoại</label>
                                <input type="tel" id="phone" name="phoneNumber" value="<c:out value='${sessionScope.currentUser.phoneNumber}'/>" required />
                            </div>
                            <div class="input-group">
                                <label for="address">Địa chỉ</label>
                                <input type="text" id="address" name="address" value="<c:out value='${sessionScope.currentUser.address}'/>" />
                            </div>
                            <button type="submit" class="btn btn-primary btn-save">Cập Nhật Thông Tin</button>
                        </form>
                    </section>

                    <!-- ===== TAB: ĐỔI MẬT KHẨU ===== -->
                    <section id="change-password" class="tab-content" data-content="password">
                        <h3 class="content-title">Đổi Mật Khẩu</h3>
                        <p style="color:#8a8fa8;font-size:14px;margin-bottom:0;">Đặt mật khẩu mới để tăng cường bảo mật tài khoản.</p>
                        <form class="account-form" method="post" action="${pageContext.request.contextPath}/account">
                            <input type="hidden" name="action" value="change-password" />
                            <div class="input-group">
                                <label for="current-password">Mật khẩu hiện tại</label>
                                <input type="password" id="current-password" name="currentPassword" required />
                            </div>
                            <div class="input-group">
                                <label for="new-password">Mật khẩu mới</label>
                                <input type="password" id="new-password" name="newPassword" required />
                            </div>
                            <div class="input-group">
                                <label for="confirm-password">Xác nhận mật khẩu mới</label>
                                <input type="password" id="confirm-password" name="confirmPassword" required />
                            </div>
                            <button type="submit" class="btn btn-primary btn-save">Đổi Mật Khẩu</button>
                        </form>
                    </section>

                    <!-- ===== TAB: LỊCH SỬ ĐƠN HÀNG ===== -->
                    <section id="order-history" class="tab-content" data-content="orders">
                        <div class="oh-section-header">
                            <div>
                                <h3 class="oh-title">Lịch Sử Đơn Hàng</h3>
                                <p class="oh-subtitle">Theo dõi trạng thái và lịch sử các đơn hàng của bạn.</p>
                            </div>
                        </div>

                        <c:choose>
                            <c:when test="${empty orderHistory}">
                                <div class="oh-empty">
                                    <div class="oh-empty-icon">
                                        <i class="fa-solid fa-bag-shopping"></i>
                                    </div>
                                    <h4>Chưa có đơn hàng nào</h4>
                                    <p>Hãy khám phá và đặt mua những sản phẩm yêu thích của bạn!</p>
                                    <a href="${pageContext.request.contextPath}/products" class="oh-shop-btn">
                                        <i class="fa-solid fa-store"></i> Mua sắm ngay
                                    </a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="oh-list">
                                    <c:forEach var="order" items="${orderHistory}">
                                        <div class="oh-card">

                                            <%-- CARD HEADER --%>
                                            <div class="oh-card-header">
                                                <div class="oh-card-meta">
                                                    <a href="${pageContext.request.contextPath}/orders/${order.id}" class="oh-order-id">
                                                        <i class="fa-solid fa-receipt"></i> Đơn hàng #${order.id}
                                                    </a>
                                                    <span class="oh-order-date">
                                                        <i class="fa-regular fa-calendar"></i>
                                                        <c:if test="${order.createdAt != null}">
                                                            <fmt:formatNumber value="${order.createdAt.hour}" minIntegerDigits="2"/>:<fmt:formatNumber value="${order.createdAt.minute}" minIntegerDigits="2"/> - ${order.createdAt.dayOfMonth}/${order.createdAt.monthValue}/${order.createdAt.year}
                                                        </c:if>
                                                    </span>
                                                </div>
                                                <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 8px;">
                                                    <c:choose>
                                                        <c:when test="${order.orderStatus == 'PENDING' || order.orderStatus == 'ORDER_PENDING'}">
                                                            <span class="oh-badge oh-badge--pending"><i class="fa-solid fa-clock"></i> Chờ xác nhận</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'CONFIRMED' || order.orderStatus == 'ORDER_CONFIRMED' || order.orderStatus == 'ORDER_PREPARING'}">
                                                            <span class="oh-badge oh-badge--confirmed"><i class="fa-solid fa-circle-check"></i> Đã xác nhận</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'SHIPPING' || order.orderStatus == 'ORDER_SHIPPING'}">
                                                            <c:choose>
                                                                <c:when test="${order.paymentMethod == 'WARRANTY'}">
                                                                    <span class="oh-badge oh-badge--shipping"><i class="fa-solid fa-truck-ramp-box"></i> Đang thu hồi</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="oh-badge oh-badge--shipping"><i class="fa-solid fa-truck"></i> Đang giao</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'DELIVERED' || order.orderStatus == 'ORDER_DELIVERED'}">
                                                            <c:choose>
                                                                <c:when test="${order.paymentMethod == 'WARRANTY'}">
                                                                    <span class="oh-badge oh-badge--shipping" style="background: rgba(52, 152, 219, 0.15); color: #2980b9;"><i class="fa-solid fa-warehouse"></i> Đã thu hồi</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="oh-badge oh-badge--shipping" style="background: rgba(52, 152, 219, 0.15); color: #2980b9;"><i class="fa-solid fa-home"></i> Đã giao</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'PENDING_COD'}">
                                                            <span class="oh-badge oh-badge--pending" style="background: rgba(243, 156, 18, 0.15); color: #f39c12;"><i class="fa-solid fa-hand-holding-dollar"></i> Chờ đối soát COD</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'RETURNING'}">
                                                            <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 4px;">
                                                                <span class="oh-badge oh-badge--cancelled" style="background:rgba(231,76,60,0.12);color:#c0392b;"><i class="fa-solid fa-rotate-left"></i> Đang hoàn hàng</span>
                                                                <c:if test="${not empty order.returnReason}">
                                                                    <span style="font-size:11px;color:#c0392b;">Lý do: ${order.returnReason}</span>
                                                                </c:if>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'RETURN_REJECTED'}">
                                                            <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 4px;">
                                                                <span class="oh-badge" style="background:rgba(142,68,173,0.12);color:#6c3483;"><i class="fa-solid fa-xmark"></i> Từ chối hoàn</span>
                                                                <c:if test="${not empty order.rejectionReason}">
                                                                    <span style="font-size:11px;color:#6c3483;max-width:220px;text-align:right;">Lý do: ${order.rejectionReason}</span>
                                                                </c:if>
                                                            </div>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'RETURNED'}">
                                                            <span class="oh-badge oh-badge--cancelled" style="background:rgba(231,76,60,0.08);color:#a93226;"><i class="fa-solid fa-box-open"></i> Đã hoàn hàng</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED'}">
                                                            <span class="oh-badge oh-badge--completed"><i class="fa-solid fa-gift"></i> Hoàn thành</span>
                                                        </c:when>
                                                        <c:when test="${order.orderStatus == 'CANCELLED' || order.orderStatus == 'ORDER_CANCELLED'}">
                                                            <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 4px;">
                                                                <span class="oh-badge oh-badge--cancelled"><i class="fa-solid fa-xmark"></i> Đã hủy</span>
                                                                <c:if test="${not empty order.cancelReason}">
                                                                    <span style="font-size: 11px; color: #cf1322;">Lý do: ${order.cancelReason}</span>
                                                                </c:if>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="oh-badge">${order.vietnameseStatus}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    
                                                </div>
                                            </div>

                                            <%-- TIMELINE STEPPER --%>
                                            <c:if test="${order.orderStatus != 'CANCELLED' && order.orderStatus != 'ORDER_CANCELLED'}">
                                                <c:choose>
                                                    <%-- Return or Warranty Flow --%>
                                                    <c:when test="${order.orderStatus == 'RETURNING' || order.orderStatus == 'RETURNED' || order.orderStatus == 'RETURN_REJECTED' || order.paymentMethod == 'WARRANTY'}">
                                                        <div class="oh-timeline" style="font-size: 11px;">
                                                            <!-- Step 1: Yêu cầu trả hàng / bảo hành -->
                                                            <div class="oh-step oh-step--done">
                                                                <div class="oh-step-dot"><i class="fa-solid fa-file-invoice"></i></div>
                                                                <span class="oh-step-label">
                                                                    <c:choose>
                                                                        <c:when test="${order.paymentMethod == 'WARRANTY'}">Yêu cầu bảo hành</c:when>
                                                                        <c:otherwise>Yêu cầu trả hàng</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </div>
                                                            
                                                            <!-- Line 1 to 2 -->
                                                            <div class="oh-step-line oh-step-line--done"></div>
                                                            
                                                            <!-- Step 2: Đang thu hồi / hoàn trả -->
                                                            <div class="oh-step oh-step--done">
                                                                <div class="oh-step-dot"><i class="fa-solid fa-truck-ramp-box"></i></div>
                                                                <span class="oh-step-label">
                                                                    <c:choose>
                                                                        <c:when test="${order.paymentMethod == 'WARRANTY'}">Đang thu hồi</c:when>
                                                                        <c:otherwise>Đang hoàn trả</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </div>

                                                            <!-- Line 2 to 3 -->
                                                            <div class="oh-step-line ${order.orderStatus == 'RETURNED' || order.orderStatus == 'ORDER_DELIVERED' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step-line--done' : ''}"></div>

                                                            <!-- Step 3: Shop đã nhận -->
                                                            <div class="oh-step ${order.orderStatus == 'RETURNED' || order.orderStatus == 'ORDER_DELIVERED' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step--done' : ''}">
                                                                <div class="oh-step-dot"><i class="fa-solid fa-warehouse"></i></div>
                                                                <span class="oh-step-label">Shop đã nhận</span>
                                                            </div>

                                                            <!-- Line 3 to 4 -->
                                                            <div class="oh-step-line ${order.orderStatus == 'RETURNED' || order.orderStatus == 'RETURN_REJECTED' || order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step-line--done' : ''}"></div>

                                                            <!-- Step 4: Hoàn tất / Từ chối hoàn -->
                                                            <div class="oh-step ${order.orderStatus == 'RETURNED' || order.orderStatus == 'RETURN_REJECTED' || order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step--done' : ''} ${order.orderStatus == 'RETURN_REJECTED' ? 'oh-step--rejected' : ''}">
                                                                <div class="oh-step-dot">
                                                                    <c:choose>
                                                                        <c:when test="${order.orderStatus == 'RETURN_REJECTED'}"><i class="fa-solid fa-circle-xmark" style="color: #cf1322;"></i></c:when>
                                                                        <c:otherwise><i class="fa-solid fa-circle-check"></i></c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <span class="oh-step-label">
                                                                    <c:choose>
                                                                        <c:when test="${order.orderStatus == 'RETURN_REJECTED'}">Từ chối hoàn</c:when>
                                                                        <c:when test="${order.paymentMethod == 'WARRANTY'}">Đã đổi trả</c:when>
                                                                        <c:otherwise>Đã hoàn tiền</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </c:when>
                                                    
                                                    <%-- Normal Purchase Flow --%>
                                                    <c:otherwise>
                                                        <div class="oh-timeline" style="font-size: 11px;">
                                                            <!-- Step 1: Chờ xác nhận -->
                                                            <div class="oh-step oh-step--done">
                                                                <div class="oh-step-dot"><i class="fa-solid fa-clock"></i></div>
                                                                <span class="oh-step-label">Chờ xác nhận</span>
                                                            </div>
                                                            
                                                            <!-- Line 1 to 2 -->
                                                            <div class="oh-step-line ${order.orderStatus != 'PENDING' && order.orderStatus != 'ORDER_PENDING' && order.orderStatus != 'UNPAID' ? 'oh-step-line--done' : ''}"></div>
                                                            
                                                            <!-- Step 2: Đã xác nhận -->
                                                            <div class="oh-step ${order.orderStatus != 'PENDING' && order.orderStatus != 'ORDER_PENDING' && order.orderStatus != 'UNPAID' ? 'oh-step--done' : ''}">
                                                                <div class="oh-step-dot"><i class="fa-solid fa-check-circle"></i></div>
                                                                <span class="oh-step-label">Đã xác nhận</span>
                                                            </div>

                                                            <!-- Line 2 to 3 -->
                                                            <div class="oh-step-line ${order.orderStatus == 'ORDER_PREPARING' || order.orderStatus == 'SHIPPING' || order.orderStatus == 'ORDER_SHIPPING' || order.orderStatus == 'ORDER_DELIVERED' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'PENDING_COD' || order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step-line--done' : ''}"></div>

                                                            <!-- Step 3: Chờ giao hàng -->
                                                            <div class="oh-step ${order.orderStatus == 'ORDER_PREPARING' || order.orderStatus == 'SHIPPING' || order.orderStatus == 'ORDER_SHIPPING' || order.orderStatus == 'ORDER_DELIVERED' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'PENDING_COD' || order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step--done' : ''}">
                                                                <div class="oh-step-dot"><i class="fa-solid fa-box"></i></div>
                                                                <span class="oh-step-label">Chờ giao</span>
                                                            </div>

                                                            <!-- Line 3 to 4 -->
                                                            <div class="oh-step-line ${order.orderStatus == 'SHIPPING' || order.orderStatus == 'ORDER_SHIPPING' || order.orderStatus == 'ORDER_DELIVERED' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'PENDING_COD' || order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step-line--done' : ''}"></div>

                                                            <!-- Step 4: Đang giao -->
                                                            <div class="oh-step ${order.orderStatus == 'SHIPPING' || order.orderStatus == 'ORDER_SHIPPING' || order.orderStatus == 'ORDER_DELIVERED' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'PENDING_COD' || order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step--done' : ''}">
                                                                <div class="oh-step-dot"><i class="fa-solid fa-truck"></i></div>
                                                                <span class="oh-step-label">Đang giao</span>
                                                            </div>

                                                            <!-- Line 4 to 5 -->
                                                            <div class="oh-step-line ${order.orderStatus == 'ORDER_DELIVERED' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'PENDING_COD' || order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step-line--done' : ''}"></div>

                                                            <!-- Step 5: Đã giao -->
                                                            <div class="oh-step ${order.orderStatus == 'ORDER_DELIVERED' || order.orderStatus == 'DELIVERED' || order.orderStatus == 'PENDING_COD' || order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step--done' : ''}">
                                                                <div class="oh-step-dot"><i class="fa-solid fa-home"></i></div>
                                                                <span class="oh-step-label">Đã giao</span>
                                                            </div>

                                                            <!-- Line 5 to 6 -->
                                                            <div class="oh-step-line ${order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step-line--done' : ''}"></div>

                                                            <!-- Step 6: Hoàn thành -->
                                                            <div class="oh-step ${order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED' ? 'oh-step--done' : ''}">
                                                                <div class="oh-step-dot"><i class="fa-solid fa-gift"></i></div>
                                                                <span class="oh-step-label">Hoàn thành</span>
                                                            </div>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>

                                            <%-- TRACKING INFO --%>
                                            <c:if test="${not empty order.trackingCode || not empty order.shippingUnit || not empty order.shippingAddress}">
                                                <div class="oh-tracking">
                                                    <i class="fa-solid fa-location-dot"></i>
                                                    <div class="oh-tracking-info">
                                                        <c:if test="${not empty order.shippingAddress}">
                                                            <span><strong>Địa chỉ:</strong> ${order.shippingAddress} <c:if test="${not empty order.phoneNumber}">- ĐT: ${order.phoneNumber}</c:if></span>
                                                        </c:if>
                                                        <c:if test="${not empty order.shippingUnit}">
                                                            <span><strong>Đơn vị VC:</strong> ${order.shippingUnit}</span>
                                                        </c:if>
                                                        <c:if test="${not empty order.trackingCode}">
                                                            <span><strong>Mã vận đơn:</strong> <code>${order.trackingCode}</code></span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:if>

                                            <%-- PRODUCT LIST --%>
                                            <div class="oh-products">
                                                <c:forEach var="item" items="${order.items}">
                                                    <div class="oh-product-row">
                                                        <div class="oh-product-img">
                                                            <c:choose>
                                                                <c:when test="${not empty item.imageUrl && item.imageUrl.startsWith('http')}">
                                                                    <img src="${item.imageUrl}" alt="${item.productName}" />
                                                                </c:when>
                                                                <c:when test="${not empty item.imageUrl}">
                                                                    <img src="${pageContext.request.contextPath}${item.imageUrl}" alt="${item.productName}"
                                                                        onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.png'" />
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="${pageContext.request.contextPath}/assets/images/placeholder.png" alt="${item.productName}" />
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                        <div class="oh-product-info">
                                                            <span class="oh-product-name">${item.productName}</span>
                                                            <span class="oh-product-variant">
                                                                <c:if test="${item.colorName != null}">Màu: ${item.colorName}</c:if>
                                                                <c:if test="${item.sizeName != null}"> | Size: ${item.sizeName}</c:if>
                                                            </span>
                                                            <span class="oh-product-qty">x${item.quantity}</span>
                                                        </div>
                                                        <div class="oh-product-price">
                                                            <fmt:formatNumber value="${item.unitPrice}" type="number" groupingUsed="true" />đ
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </div>

                                            <%-- CARD FOOTER --%>
                                            <div class="oh-card-footer">
                                                <div class="oh-payment-row" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 10px;">
                                                    <c:choose>
                                                        <c:when test="${order.paymentStatus == 'PAID'}">
                                                            <span class="oh-payment-badge oh-payment-badge--paid">
                                                                <i class="fa-solid fa-circle-check"></i> Đã thanh toán
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="oh-payment-badge oh-payment-badge--unpaid">
                                                                <i class="fa-regular fa-clock"></i> Chưa thanh toán
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <span style="font-size: 13px; color: #555;">
                                                        <i class="fa-solid fa-wallet" style="color: #666; margin-right: 4px;"></i> PT Thanh toán: 
                                                        <strong><c:choose>
                                                            <c:when test="${order.paymentMethod == 'COD'}">Thanh toán khi nhận hàng (COD)</c:when>
                                                            <c:when test="${order.paymentMethod == 'VNPAY'}">Chuyển khoản (VNPay)</c:when>
                                                            <c:otherwise>${order.paymentMethod != null ? order.paymentMethod : 'COD'}</c:otherwise>
                                                        </c:choose></strong>
                                                    </span>
                                                </div>

                                                <div class="oh-summary">
                                                    <div class="oh-summary-row">
                                                        <span>Tạm tính</span>
                                                        <span><fmt:formatNumber value="${order.subTotal}" type="number" groupingUsed="true" />đ</span>
                                                    </div>
                                                    <c:if test="${order.discountAmount != null && order.discountAmount > 0}">
                                                        <div class="oh-summary-row" style="color: #ee4d2d;">
                                                            <span>Giảm giá (Voucher)</span>
                                                            <span>-<fmt:formatNumber value="${order.discountAmount}" type="number" groupingUsed="true" />đ</span>
                                                        </div>
                                                    </c:if>
                                                    <div class="oh-summary-row">
                                                        <span>Phí vận chuyển</span>
                                                        <span><fmt:formatNumber value="${order.shippingFee}" type="number" groupingUsed="true" />đ</span>
                                                    </div>
                                                    <div class="oh-summary-row oh-summary-total">
                                                        <span>Tổng cộng</span>
                                                        <span class="oh-grand-total"><fmt:formatNumber value="${order.grandTotal}" type="number" groupingUsed="true" />đ</span>
                                                    </div>
                                                </div>

                                                <div class="oh-actions">
                                                    <c:if test="${order.orderStatus == 'PENDING' || order.orderStatus == 'ORDER_PENDING'}">
                                                        <button type="button" class="oh-btn oh-btn--cancel" onclick="showCancelModal(${order.id})">
                                                            <i class="fa-solid fa-xmark"></i> Hủy đơn
                                                        </button>
                                                    </c:if>
                                                    <c:if test="${order.orderStatus == 'DELIVERED' || order.orderStatus == 'ORDER_DELIVERED' || ((order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED') && order.receivedAt == null)}">
                                                        <form action="${pageContext.request.contextPath}/account" method="post" style="display:inline;"
                                                              onsubmit="return confirm('Bạn xác nhận đã nhận được hàng?');">
                                                            <input type="hidden" name="action" value="complete-order"/>
                                                            <input type="hidden" name="orderId" value="${order.id}"/>
                                                            <button type="submit" class="oh-btn oh-btn--receive">
                                                                <i class="fa-solid fa-check-double"></i> Đã nhận hàng
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${(order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED') && order.receivedAt != null}"
                                                        ><c:choose>
                                                            <c:when test="${order.reviewed}">
                                                                <span class="oh-btn" style="background:rgba(52,152,219,0.12);color:#2980b9;cursor:default;">
                                                                    <i class="fa-solid fa-circle-check"></i> Đã đánh giá
                                                                </span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="${pageContext.request.contextPath}/orders/${order.id}" class="oh-btn oh-btn--review">
                                                                    <i class="fa-solid fa-star"></i> Đánh giá ngay
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>

                                                    <button type="button" class="oh-btn oh-btn--detail" onclick="openOrderModal(${order.id})">
                                                        <i class="fa-solid fa-eye"></i> Xem chi tiết
                                                    </button>
                                                </div>
                                            </div>

                                        </div>

                                        <%-- ORDER DETAIL MODAL --%>
                                        <div id="od-modal-${order.id}" class="od-modal-overlay" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999; justify-content:center; align-items:center;">
                                            <div class="od-modal-content" style="background:#f7f8fc; width:90%; max-width:1050px; max-height:90vh; overflow-y:auto; border-radius:12px; padding:24px; position:relative;">
                                                <button type="button" onclick="closeOrderModal(${order.id})" style="position:absolute; top:16px; right:20px; background:none; border:none; font-size:24px; color:#94a3b8; cursor:pointer;">&times;</button>
                                                
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
                                                        <span class="od-products-count">${order.items.size()} sản phẩm</span>
                                                    </div>

                                                    <div class="od-table-head">
                                                        <div>Sản phẩm</div>
                                                        <div>Đơn giá</div>
                                                        <div>SL</div>
                                                        <div>Thành tiền</div>
                                                        <div>Hành động</div>
                                                    </div>

                                                    <c:forEach var="item" items="${order.items}">
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
                                                                <c:choose>
                                                                    <c:when test="${order.reviewed}">
                                                                        <div class="od-reviewed-badge">⭐ Đã đánh giá</div>
                                                                    </c:when>
                                                                    <c:when test="${(order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED') && order.receivedAt != null}">
                                                                        <a href="${pageContext.request.contextPath}/orders/${order.id}" class="od-review-btn" style="text-decoration:none;display:inline-block;">
                                                                            <i class="fa-solid fa-star"></i> Đánh giá
                                                                        </a>
                                                                    </c:when>
                                                                    <c:when test="${(order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED') && order.receivedAt == null}">
                                                                        <span class="od-reviewed-badge" style="color: #64748b; background: #f1f5f9;"><i class="fa-solid fa-lock"></i> Chưa nhận hàng</span>
                                                                    </c:when>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                    </c:forEach>
                                                </div>

                                                <%-- ===== ACTIONS ===== --%>
                                                <div class="od-actions" style="margin-top:20px;">
                                                    <c:if test="${order.orderStatus == 'DELIVERED' || order.orderStatus == 'ORDER_DELIVERED' || ((order.orderStatus == 'COMPLETED' || order.orderStatus == 'ORDER_COMPLETED') && order.receivedAt == null)}">
                                                        <form action="${pageContext.request.contextPath}/account" method="post" style="display:inline;"
                                                              onsubmit="return confirm('Bạn xác nhận đã nhận được hàng?');">
                                                            <input type="hidden" name="action" value="complete-order"/>
                                                            <input type="hidden" name="orderId" value="${order.id}"/>
                                                            <button type="submit" class="oh-btn oh-btn--receive" style="margin-right: 10px; padding: 6px 12px; font-size: 13px;">
                                                                <i class="fa-solid fa-check-double"></i> Đã nhận hàng
                                                            </button>
                                                        </form>
                                                    </c:if>
                                                    <c:if test="${order.orderStatus == 'PENDING'}">
                                                        <button type="button" class="od-btn od-btn--cancel" onclick="showCancelModal(${order.id})">
                                                            <i class="fa-solid fa-xmark"></i> Hủy đơn hàng
                                                        </button>
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

                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>

                    <!-- ===== TAB: KHO VOUCHER ===== -->
                    <section id="voucher-wallet" class="tab-content" data-content="vouchers">
                        <h3 class="content-title" style="color:#ee4d2d;">Kho Voucher</h3>
                        <p style="margin-bottom:20px;color:#8a8fa8;font-size:14px;">Lưu và sử dụng mã giảm giá khi thanh toán.</p>
                        <c:choose>
                            <c:when test="${empty vouchers}">
                                <div style="text-align:center;padding:40px 20px;color:#aaa;">
                                    <i class="fa-solid fa-tag" style="font-size:48px;margin-bottom:10px;display:block;"></i>
                                    <p>Hiện chưa có voucher nào.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(320px,1fr));gap:15px;">
                                    <c:forEach var="v" items="${vouchers}">
                                        <div style="display:flex;border-radius:8px;overflow:hidden;box-shadow:0 2px 8px rgba(0,0,0,0.08);border:1px solid #f0f0f0;background:#fff;transition:transform 0.2s,box-shadow 0.2s;"
                                             onmouseenter="this.style.transform='translateY(-2px)';this.style.boxShadow='0 4px 12px rgba(238,77,45,0.15)'"
                                             onmouseleave="this.style.transform='';this.style.boxShadow='0 2px 8px rgba(0,0,0,0.08)'">
                                            <div style="width:90px;background:linear-gradient(135deg,#ee4d2d 0%,#ff6633 100%);display:flex;flex-direction:column;align-items:center;justify-content:center;color:#fff;padding:15px 10px;flex-shrink:0;">
                                                <i class="fa-solid fa-ticket" style="font-size:28px;margin-bottom:5px;"></i>
                                                <span style="font-size:11px;font-weight:bold;text-align:center;">GIẢM GIÁ</span>
                                            </div>
                                            <div style="flex:1;padding:15px;display:flex;flex-direction:column;justify-content:space-between;">
                                                <div>
                                                    <div style="font-weight:bold;font-size:15px;color:#222;margin-bottom:4px;">
                                                        <c:choose>
                                                            <c:when test="${v.discountType == 'PERCENTAGE'}">
                                                                Giảm ${v.discountValue}%
                                                                <c:if test="${v.maxDiscountAmount != null}">
                                                                    <span style="font-size:12px;color:#888;font-weight:normal;">(tối đa <fmt:formatNumber value="${v.maxDiscountAmount}" type="number" groupingUsed="true"/>₫)</span>
                                                                </c:if>
                                                            </c:when>
                                                            <c:otherwise>Giảm <fmt:formatNumber value="${v.discountValue}" type="number" groupingUsed="true"/>₫</c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div style="font-size:12px;color:#888;">Đơn tối thiểu: <fmt:formatNumber value="${v.minOrderValue}" type="number" groupingUsed="true"/>₫</div>
                                                    <div style="font-size:11px;color:#aaa;margin-top:4px;">HSD: <fmt:formatDate value="${v.endDateTimestamp}" pattern="dd/MM/yyyy HH:mm"/></div>
                                                </div>
                                                <div style="display:flex;align-items:center;justify-content:space-between;margin-top:10px;">
                                                    <span style="background:#fff5f0;color:#ee4d2d;padding:3px 10px;border-radius:4px;font-size:13px;font-weight:bold;letter-spacing:1px;border:1px dashed #ee4d2d;">${v.code}</span>
                                                    <button type="button" onclick="copyVoucher(this,'${v.code}')"
                                                            style="background:#ee4d2d;color:#fff;border:none;padding:6px 14px;border-radius:4px;cursor:pointer;font-size:12px;font-weight:bold;transition:background 0.2s;"
                                                            onmouseenter="this.style.background='#d4441f'"
                                                            onmouseleave="this.style.background='#ee4d2d'">Sao chép</button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>

        <!-- ===== TAB: QUẢN LÝ BẢO HÀNH ===== -->
        <section id="warranty-management" class="tab-content" data-content="warranty">
            <!-- Section Header -->
            <div class="wm-header">
                <div>
                    <h3 class="wm-title"><i class="fa-solid fa-shield-halved"></i> Quản lý bảo hành &amp; Đổi trả</h3>
                    <p class="wm-subtitle">Theo dõi và gửi yêu cầu đổi trả trong vòng 7 ngày kể từ khi nhận hàng.</p>
                </div>
                <span class="wm-count-badge">${eligibleWarrantyItems.size() + warrantyRequests.size()} sản phẩm</span>
            </div>

            <!-- ---- Danh sách yêu cầu ĐÃ gửi ---- -->
            <c:if test="${not empty warrantyRequests}">
                <div class="wm-group-label"><i class="fa-solid fa-clock-rotate-left"></i> Yêu cầu đã gửi</div>
                <div class="wm-list">
                    <c:forEach var="req" items="${warrantyRequests}">
                        <div class="wm-card wm-card--sent">
                            <div class="wm-card-img">
                                <c:choose>
                                    <c:when test="${not empty req.productImageUrl && req.productImageUrl.startsWith('http')}">
                                        <img src="${req.productImageUrl}" alt="${req.productName}" />
                                    </c:when>
                                    <c:when test="${not empty req.productImageUrl}">
                                        <img src="${pageContext.request.contextPath}${req.productImageUrl}" alt="${req.productName}"
                                             onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.png'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/placeholder.png" alt="${req.productName}" />
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="wm-card-body">
                                <div class="wm-card-name">${req.productName}</div>
                                <div class="wm-card-sub">
                                    <i class="fa-solid fa-hashtag"></i> Mã yêu cầu: #${req.id}
                                    &nbsp;·&nbsp;
                                    <i class="fa-regular fa-calendar"></i>
                                    <fmt:formatDate value="${req.createdAt}" pattern="dd/MM/yyyy"/>
                                </div>
                                <div class="wm-card-reason"><i class="fa-solid fa-circle-info"></i> ${req.reason}</div>
                                <div style="margin-top: 6px; display: flex; align-items: center; gap: 8px; flex-wrap: wrap;">
                                    <c:choose>
                                        <c:when test="${req.requestType == 'EXCHANGE'}">
                                            <span style="background: #e0f2fe; color: #0369a1; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;"><i class="fa-solid fa-arrows-rotate"></i> Đổi size</span>
                                            <span style="font-size: 12px; color: #475569;">Size yêu cầu: <b>${req.exchangeSize}</b></span>
                                        </c:when>
                                        <c:when test="${req.requestType == 'REFUND'}">
                                            <span style="background: #fee2e2; color: #b91c1c; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;"><i class="fa-solid fa-building-columns"></i> Hoàn tiền</span>
                                            <span style="font-size: 11px; color: #475569;" title="Ngân hàng: ${req.refundBankName} | STK: ${req.refundAccountNumber} | Chủ TK: ${req.refundAccountHolder}">
                                                TK: <b>${req.refundBankName}</b> (${req.refundAccountNumber})
                                            </span>
                                        </c:when>
                                    </c:choose>

                                    <%-- Return method badge --%>
                                    <c:choose>
                                        <c:when test="${req.returnMethod == 'SELF_SEND'}">
                                            <span style="background: #f3f4f6; color: #4b5563; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;" title="Khách tự gửi hàng về trụ sở shop"><i class="fa-solid fa-paper-plane"></i> Tự gửi về shop</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="background: #e6f7ff; color: #1890ff; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: 600; display: inline-flex; align-items: center; gap: 4px;" title="Shipper đến lấy tại: ${not empty req.pickupAddress ? req.pickupAddress : req.shippingAddress} | ĐT: ${not empty req.pickupPhone ? req.pickupPhone : req.phoneNumber}"><i class="fa-solid fa-truck-pickup"></i> Shipper đến lấy</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            <div class="wm-card-status">
                                <c:choose>
                                    <c:when test="${req.status == 'PENDING'}">
                                        <span class="wm-badge wm-badge--pending"><i class="fa-regular fa-clock"></i> Chờ xử lý</span>
                                    </c:when>
                                    <c:when test="${req.status == 'PROCESSING'}">
                                        <span class="wm-badge wm-badge--processing"><i class="fa-solid fa-spinner fa-spin"></i> Đang xử lý</span>
                                    </c:when>
                                    <c:when test="${req.status == 'COMPLETED'}">
                                        <span class="wm-badge wm-badge--done"><i class="fa-solid fa-circle-check"></i> Hoàn thành</span>
                                    </c:when>
                                    <c:when test="${req.status == 'REJECTED'}">
                                        <span class="wm-badge wm-badge--rejected"><i class="fa-solid fa-xmark"></i> Bị từ chối</span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- ---- Danh sách sản phẩm ĐỦ ĐIỀU KIỆN ---- -->
            <c:if test="${not empty eligibleWarrantyItems}">
                <div class="wm-group-label" style="margin-top:24px;"><i class="fa-solid fa-shield-check"></i> Có thể yêu cầu đổi trả</div>
                <div class="wm-list">
                    <c:forEach var="item" items="${eligibleWarrantyItems}">
                        <%
                            model.warranty.WarrantyRequest wReq = (model.warranty.WarrantyRequest) pageContext.getAttribute("item");
                            java.time.LocalDateTime startDt = wReq.getOrderDeliveredAt() != null
                                ? wReq.getOrderDeliveredAt().toLocalDateTime()
                                : wReq.getOrderCreatedAt().toLocalDateTime();
                            java.time.LocalDateTime endDt = startDt.plusDays(7);
                            java.time.LocalDateTime nowDt = java.time.LocalDateTime.now();
                            long daysLeft = java.time.temporal.ChronoUnit.DAYS.between(nowDt, endDt);
                            boolean isExp = daysLeft < 0;
                            int pct = isExp ? 100 : (int)(100 - (daysLeft * 100.0 / 7));
                            if (pct < 0) pct = 0; if (pct > 100) pct = 100;
                            // pick bar color
                            String barColor = daysLeft >= 4 ? "#27ae60" : (daysLeft >= 2 ? "#f39c12" : "#e74c3c");
                            pageContext.setAttribute("startDt", startDt);
                            pageContext.setAttribute("endDt", endDt);
                            pageContext.setAttribute("daysLeft", daysLeft);
                            pageContext.setAttribute("isExp", isExp);
                            pageContext.setAttribute("pct", pct);
                            pageContext.setAttribute("barColor", barColor);
                        %>
                        <div class="wm-card ${isExp ? 'wm-card--expired' : ''}">
                            <div class="wm-card-img">
                                <c:choose>
                                    <c:when test="${not empty item.productImageUrl && item.productImageUrl.startsWith('http')}">
                                        <img src="${item.productImageUrl}" alt="${item.productName}" />
                                    </c:when>
                                    <c:when test="${not empty item.productImageUrl}">
                                        <img src="${pageContext.request.contextPath}${item.productImageUrl}" alt="${item.productName}"
                                             onerror="this.src='${pageContext.request.contextPath}/assets/images/placeholder.png'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/placeholder.png" alt="${item.productName}" />
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${!isExp && daysLeft <= 2}">
                                    <span class="wm-card-urgent">Sắp hết!</span>
                                </c:if>
                            </div>
                            <div class="wm-card-body">
                                <div class="wm-card-name">${item.productName}</div>
                                <div class="wm-card-sub">
                                    <i class="fa-solid fa-bag-shopping"></i> Đơn hàng #${item.orderId}
                                </div>
                                <c:choose>
                                    <c:when test="${isExp}">
                                        <div class="wm-expired-label"><i class="fa-solid fa-circle-xmark"></i> Đã hết hạn đổi trả</div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="wm-deadline-info">
                                            <span class="wm-date-from">
                                                <fmt:parseDate value="${startDt}" pattern="yyyy-MM-dd'T'HH:mm" var="pStart" type="both"/>
                                                <i class="fa-regular fa-calendar-check"></i>
                                                <fmt:formatDate value="${pStart}" pattern="dd/MM/yyyy"/>
                                            </span>
                                            <i class="fa-solid fa-arrow-right wm-arrow"></i>
                                            <span class="wm-date-to">
                                                <fmt:parseDate value="${endDt}" pattern="yyyy-MM-dd'T'HH:mm" var="pEnd" type="both"/>
                                                <fmt:formatDate value="${pEnd}" pattern="dd/MM/yyyy"/>
                                            </span>
                                        </div>
                                        <div class="wm-timer-bar">
                                            <div class="wm-timer-fill" style="width:${pct}%;background:${barColor};"></div>
                                        </div>
                                        <div class="wm-days-left" style="color:${barColor};">
                                            <i class="fa-solid fa-hourglass-half"></i> Còn <strong>${daysLeft}</strong> ngày để đổi trả
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="wm-card-action">
                                <c:choose>
                                    <c:when test="${isExp}">
                                        <span class="wm-badge wm-badge--rejected"><i class="fa-solid fa-xmark"></i> Hết hạn</span>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="wm-btn-return"
                                            onclick="showWarrantyModal(${item.orderId}, ${item.productId},
                                                '${item.productName.replace("'","\\'")}',
                                                '${item.productImageUrl}',
                                                '<fmt:formatDate value="${pEnd}" pattern="dd/MM/yyyy"/>')">
                                            <i class="fa-solid fa-rotate"></i> Đổi trả
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <!-- Empty state -->
            <c:if test="${empty warrantyRequests && empty eligibleWarrantyItems}">
                <div class="wm-empty">
                    <i class="fa-solid fa-shield-halved"></i>
                    <h4>Chưa có sản phẩm nào</h4>
                    <p>Hoàn thành đơn hàng để có thể yêu cầu bảo hành hoặc đổi trả.</p>
                </div>
            </c:if>
        </section>



                </div>
            </div>
        </div>

        <!-- Logout Modal -->
        <div class="modal" id="logoutModal" style="display:none;">
            <div class="modal-content">
                <span class="close-btn" id="closeLogout">&times;</span>
                <h3 class="h3 modal-title">Xác nhận đăng xuất</h3>
                <p>Bạn có chắc chắn muốn đăng xuất khỏi hệ thống không?</p>
                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" id="cancelLogout">Không</button>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-confirm-logout">Có, đăng xuất</a>
                </div>
            </div>
        </div>

        <!-- Warranty/Return Modal -->
        <div class="modal" id="warrantyModal" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center;">
            <div class="modal-content" style="background: #fff; border-radius: 12px; max-width: 500px; width: 90%; box-shadow: 0 5px 20px rgba(0,0,0,0.15); padding: 0; overflow: hidden;">
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #f0f0f0; padding: 16px 20px;">
                    <h3 style="margin: 0; font-size: 16px; color: #1a1a2e; font-weight: 700; display:flex; align-items:center; gap:8px;">
                        <i class="fa-solid fa-rotate" style="color: #3498db;"></i> Yêu cầu đổi trả
                    </h3>
                    <span class="close-btn" style="cursor: pointer; font-size: 20px; color: #aaa;" onclick="document.getElementById('warrantyModal').style.display='none';">&times;</span>
                </div>
                
                <form action="${pageContext.request.contextPath}/warranty" method="post" id="warrantyForm" style="padding: 20px;">
                    <input type="hidden" name="action" value="submit_request"/>
                    <input type="hidden" name="orderId" id="warrantyOrderId" value=""/>
                    <input type="hidden" name="productId" id="warrantyProductId" value=""/>
                    
                    <div style="display:flex;gap:16px;background:#f8f9fa;padding:12px;border-radius:8px;margin-bottom:20px;border:1px solid #e9ecef;">
                        <img id="w-product-img" src="" style="width:60px;height:60px;border-radius:6px;object-fit:cover;background:#fff;">
                        <div>
                            <div id="w-product-name" style="font-size:13px;font-weight:700;color:#333;margin-bottom:6px;"></div>
                            <div id="w-product-expire" style="font-size:12px;color:#666;"><i class="fa-regular fa-calendar"></i> Hết hạn: <span></span></div>
                        </div>
                    </div>


                    <div style="margin-bottom: 16px;">
                        <label style="display:block;font-size:13px;font-weight:600;color:#333;margin-bottom:6px;"><span style="color:#e74c3c;">*</span> Loại yêu cầu</label>
                        <div style="display: flex; gap: 20px; align-items: center; background: #f8f9fa; padding: 10px 14px; border-radius: 6px; border: 1px solid #ddd;">
                            <label style="display: flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 600; color: #333; cursor: pointer; margin: 0;">
                                <input type="radio" name="requestType" value="EXCHANGE" checked onchange="toggleRequestFields(this.value)" style="accent-color: #c0392b;"> Đổi size sản phẩm
                            </label>
                            <label style="display: flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 600; color: #333; cursor: pointer; margin: 0;">
                                <input type="radio" name="requestType" value="REFUND" onchange="toggleRequestFields(this.value)" style="accent-color: #c0392b;"> Trả hàng & Hoàn tiền
                            </label>
                        </div>
                    </div>

                    <div id="exchangeFields" style="margin-bottom: 16px;">
                        <label style="display:block;font-size:13px;font-weight:600;color:#333;margin-bottom:6px;"><span style="color:#e74c3c;">*</span> Kích cỡ muốn đổi sang</label>
                        <input type="text" name="exchangeSize" id="w-exchange-size" placeholder="Nhập size bạn muốn đổi (ví dụ: 40, 41, 42...)" style="width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;font-family:inherit;font-size:13px;outline:none;">
                    </div>

                    <div id="refundFields" style="display: none; margin-bottom: 16px; background: #fff5f5; border: 1px solid #fee2e2; border-radius: 8px; padding: 14px;">
                        <div style="font-weight: 700; font-size: 13px; color: #c0392b; margin-bottom: 10px;"><i class="fa-solid fa-building-columns"></i> Thông tin nhận tiền hoàn</div>
                        <div style="margin-bottom: 10px;">
                            <label style="display:block;font-size:12px;font-weight:600;color:#555;margin-bottom:4px;"><span style="color:#e74c3c;">*</span> Tên ngân hàng</label>
                            <input type="text" name="refundBankName" id="w-refund-bank" placeholder="Ví dụ: Vietcombank, Techcombank..." style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;font-family:inherit;font-size:12px;outline:none;">
                        </div>
                        <div style="margin-bottom: 10px;">
                            <label style="display:block;font-size:12px;font-weight:600;color:#555;margin-bottom:4px;"><span style="color:#e74c3c;">*</span> Số tài khoản</label>
                            <input type="text" name="refundAccountNumber" id="w-refund-acc" placeholder="Nhập số tài khoản..." style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;font-family:inherit;font-size:12px;outline:none;">
                        </div>
                        <div>
                            <label style="display:block;font-size:12px;font-weight:600;color:#555;margin-bottom:4px;"><span style="color:#e74c3c;">*</span> Tên chủ tài khoản</label>
                            <input type="text" name="refundAccountHolder" id="w-refund-holder" placeholder="Nhập tên viết hoa không dấu..." style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;font-family:inherit;font-size:12px;outline:none;text-transform: uppercase;">
                        </div>
                    </div>

                    <div style="margin-bottom: 16px;">
                        <label style="display:block;font-size:13px;font-weight:600;color:#333;margin-bottom:6px;"><span style="color:#e74c3c;">*</span> Lý do đổi trả</label>
                        <select name="reason" required style="width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;font-family:inherit;font-size:13px;outline:none;">
                            <option value="">Chọn lý do...</option>
                            <option value="Sản phẩm bị lỗi kỹ thuật">Sản phẩm bị lỗi kỹ thuật</option>
                            <option value="Sản phẩm hư hỏng do vận chuyển">Sản phẩm hư hỏng do vận chuyển</option>
                            <option value="Giao sai sản phẩm / màu sắc / kích cỡ">Giao sai sản phẩm / màu sắc / kích cỡ</option>
                            <option value="Sai màu sắc">Sai màu sắc</option>
                            <option value="Lý do khác">Lý do khác</option>
                        </select>
                    </div>

                    <div style="margin-bottom: 16px;">
                        <label style="display:block;font-size:13px;font-weight:600;color:#333;margin-bottom:6px;"><span style="color:#e74c3c;">*</span> Mô tả chi tiết</label>
                        <textarea name="description" required placeholder="Mô tả chi tiết vấn đề bạn gặp phải với sản phẩm..." style="width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;font-family:inherit;font-size:13px;outline:none;min-height:80px;resize:vertical;"></textarea>
                    </div>

                    <div style="margin-bottom: 24px;">
                        <label style="display:block;font-size:13px;font-weight:600;color:#333;margin-bottom:6px;">Hình ảnh minh chứng (URL) <span style="color:#999;font-weight:400;">(tuỳ chọn)</span></label>
                        <input type="text" name="imageUrl" placeholder="Dán đường dẫn URL ảnh minh chứng..." style="width:100%;padding:10px;border:1px solid #ddd;border-radius:6px;font-family:inherit;font-size:13px;outline:none;" oninput="document.getElementById('w-img-preview').src=this.value; document.getElementById('w-img-preview').style.display='block';">
                        <img id="w-img-preview" src="" style="display:none;margin-top:10px;max-width:100px;border-radius:6px;border:1px solid #eee;" onerror="this.style.display='none'">
                    </div>

                    <div style="margin-bottom: 16px;">
                        <label style="display:block;font-size:13px;font-weight:600;color:#333;margin-bottom:6px;"><span style="color:#e74c3c;">*</span> Phương thức trả hàng / thu hồi</label>
                        <div style="display: flex; flex-direction: column; gap: 10px; background: #f8f9fa; padding: 12px; border-radius: 8px; border: 1px solid #ddd;">
                            <label style="display: flex; align-items: flex-start; gap: 8px; cursor: pointer; margin: 0; font-size: 13px; color: #333;">
                                <input type="radio" name="returnMethod" value="PICKUP" checked onchange="toggleReturnMethodFields(this.value)" style="accent-color: #c0392b; margin-top: 3px;">
                                <div>
                                    <strong>Shipper đến lấy hàng tận nơi</strong>
                                    <div style="font-size: 11px; color: #666; margin-top: 2px;">Shipper của chúng tôi sẽ liên hệ lấy hàng tại địa chỉ của bạn.</div>
                                </div>
                            </label>
                            
                            <label style="display: flex; align-items: flex-start; gap: 8px; cursor: pointer; margin: 0; font-size: 13px; color: #333; border-top: 1px solid #eee; padding-top: 10px;">
                                <input type="radio" name="returnMethod" value="SELF_SEND" onchange="toggleReturnMethodFields(this.value)" style="accent-color: #c0392b; margin-top: 3px;">
                                <div>
                                    <strong>Tự gửi hàng về trụ sở shop</strong>
                                    <div style="font-size: 11px; color: #666; margin-top: 2px;">Bạn tự gửi hàng qua bưu điện/ship về địa chỉ: <strong>136 Kim Giang, Hoàng Liệt, Hoàng Mai, Hà Nội</strong>.</div>
                                </div>
                            </label>
                        </div>
                    </div>

                    <div id="pickupFields" style="margin-bottom: 20px; background: #e6f7ff; border: 1px solid #91d5ff; border-radius: 8px; padding: 14px;">
                        <div style="font-weight: 700; font-size: 13px; color: #0050b3; margin-bottom: 10px;"><i class="fa-solid fa-truck-pickup"></i> Địa chỉ lấy hàng thu hồi</div>
                        <div style="margin-bottom: 10px;">
                            <label style="display:block;font-size:12px;font-weight:600;color:#555;margin-bottom:4px;"><span style="color:#e74c3c;">*</span> Số điện thoại liên hệ</label>
                            <input type="text" name="pickupPhone" id="w-pickup-phone" value="${sessionScope.currentUser.phoneNumber}" placeholder="Nhập SĐT để shipper gọi điện lấy hàng..." style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;font-family:inherit;font-size:12px;outline:none;">
                        </div>
                        <div>
                            <label style="display:block;font-size:12px;font-weight:600;color:#555;margin-bottom:4px;"><span style="color:#e74c3c;">*</span> Địa chỉ chi tiết</label>
                            <input type="text" name="pickupAddress" id="w-pickup-address" value="${sessionScope.currentUser.address}" placeholder="Nhập địa chỉ cụ thể của bạn..." style="width:100%;padding:8px;border:1px solid #ddd;border-radius:6px;font-family:inherit;font-size:12px;outline:none;">
                        </div>
                    </div>

                    <div style="display: flex; justify-content: flex-end; gap: 12px; border-top: 1px solid #f0f0f0; padding-top: 16px;">
                        <button type="button" class="btn" style="background: transparent; color: #666; border: 1px solid #ddd; padding: 8px 16px; border-radius:4px; cursor: pointer; font-weight: 600; font-size: 13px;" onclick="document.getElementById('warrantyModal').style.display='none';">Hủy bỏ</button>
                        <button type="submit" class="btn" style="background: #c0392b; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-weight: 600; font-size: 13px;"><i class="fa-solid fa-rotate"></i> Gửi yêu cầu</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function toggleRequestFields(type) {
                var exFields = document.getElementById('exchangeFields');
                var refFields = document.getElementById('refundFields');
                var sizeInput = document.getElementById('w-exchange-size');
                var bankInput = document.getElementById('w-refund-bank');
                var accInput = document.getElementById('w-refund-acc');
                var holderInput = document.getElementById('w-refund-holder');

                if (type === 'EXCHANGE') {
                    exFields.style.display = 'block';
                    refFields.style.display = 'none';
                    sizeInput.required = true;
                    bankInput.required = false;
                    accInput.required = false;
                    holderInput.required = false;
                } else {
                    exFields.style.display = 'none';
                    refFields.style.display = 'block';
                    sizeInput.required = false;
                    bankInput.required = true;
                    accInput.required = true;
                    holderInput.required = true;
                }
            }

            function toggleReturnMethodFields(method) {
                var pickupFields = document.getElementById('pickupFields');
                var phoneInput = document.getElementById('w-pickup-phone');
                var addressInput = document.getElementById('w-pickup-address');
                if (method === 'PICKUP') {
                    pickupFields.style.display = 'block';
                    phoneInput.required = true;
                    addressInput.required = true;
                } else {
                    pickupFields.style.display = 'none';
                    phoneInput.required = false;
                    addressInput.required = false;
                }
            }

            function showWarrantyModal(orderId, productId, productName, productImg, expireDate) {
                document.getElementById('warrantyOrderId').value = orderId;
                document.getElementById('warrantyProductId').value = productId;
                document.getElementById('w-product-name').innerText = productName;
                document.getElementById('w-product-img').src = productImg;
                document.getElementById('w-product-expire').querySelector('span').innerText = expireDate;
                document.getElementById('w-img-preview').style.display = 'none';
                document.getElementById('w-img-preview').src = '';
                document.getElementById('warrantyForm').reset();
                
                // Reset types to default EXCHANGE
                var radios = document.getElementsByName('requestType');
                for (var i = 0; i < radios.length; i++) {
                    if (radios[i].value === 'EXCHANGE') radios[i].checked = true;
                }
                toggleRequestFields('EXCHANGE');

                // Reset return method to default PICKUP
                var returnRadios = document.getElementsByName('returnMethod');
                for (var i = 0; i < returnRadios.length; i++) {
                    if (returnRadios[i].value === 'PICKUP') returnRadios[i].checked = true;
                }
                toggleReturnMethodFields('PICKUP');

                document.getElementById('warrantyModal').style.display = 'flex';
            }
        </script>

        <!-- Cancel Order Modal -->
        <div class="modal" id="cancelOrderModal" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center;">
            <div class="modal-content" style="background: #fff; padding: 25px; border-radius: 12px; max-width: 450px; width: 90%; box-shadow: 0 5px 20px rgba(0,0,0,0.15);">
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #f0f0f0; padding-bottom: 15px; margin-bottom: 15px;">
                    <h3 style="margin: 0; font-size: 18px; color: #1a1a2e; font-weight: 700;"><i class="fa-solid fa-circle-exclamation" style="color: #cf1322; margin-right: 8px;"></i>Hủy Đơn Hàng</h3>
                    <span class="close-btn" style="cursor: pointer; font-size: 24px; color: #aaa;" onclick="document.getElementById('cancelOrderModal').style.display='none';">&times;</span>
                </div>
                <p style="color: #555; font-size: 14px; margin-bottom: 15px;">Vui lòng cho biết lý do bạn muốn hủy đơn hàng này?</p>
                <form action="${pageContext.request.contextPath}/account" method="post" id="cancelOrderForm">
                    <input type="hidden" name="action" value="cancel-order"/>
                    <input type="hidden" name="orderId" id="cancelOrderId" value=""/>
                    
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



        <script>
            function showCancelModal(orderId) {
                document.getElementById('cancelOrderId').value = orderId;
                document.getElementById('cancelOrderModal').style.display = 'flex';
            }
        </script>



    </main>

    <jsp:include page="footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/script/reponsive.js"></script>
    <script src="${pageContext.request.contextPath}/assets/script/pageaccount.js"></script>
    <script src="${pageContext.request.contextPath}/assets/script/account.js"></script>

    <script>
        function copyVoucher(btn, code) {
            navigator.clipboard.writeText(code).then(function() {
                var originalText = btn.textContent;
                btn.textContent = 'Đã sao chép!';
                btn.style.background = '#27ae60';
                setTimeout(function() {
                    btn.textContent = originalText;
                    btn.style.background = '#ee4d2d';
                }, 1500);
            });
        }
    // Order Detail Modal functions
    function openOrderModal(orderId) {
        document.getElementById('od-modal-' + orderId).style.display = 'flex';
        document.body.style.overflow = 'hidden'; // Prevent background scroll
    }

    function closeOrderModal(orderId) {
        document.getElementById('od-modal-' + orderId).style.display = 'none';
        document.body.style.overflow = '';
    }

    // Close modal when clicking outside of it
    window.addEventListener('click', function(event) {
        if (event.target.classList.contains('od-modal-overlay')) {
            event.target.style.display = 'none';
            document.body.style.overflow = '';
        }
    });

</script>

<script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
<script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>

</body>
</html>
