<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style>
    .order-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; }
    .order-header h2 { font-weight: 800; font-size: 24px; color: var(--unity-black); margin: 0; }

    /* Filter Pill Styles */
    .filter-container { display: flex; gap: 16px; align-items: center; margin-bottom: 32px; flex-wrap: wrap; }
    .u-search {
        background: var(--white); border-radius: 12px; padding: 0 16px;
        display: flex; align-items: center; flex: 1; min-width: 200px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.02);
    }
    .u-search i { color: var(--unity-gray); margin-right: 12px; }
    .u-search input { border: none; background: transparent; padding: 14px 0; width: 100%; font-family: inherit; font-size: 14px; outline: none; }

    .u-select {
        background: var(--white); padding: 12px 16px; border-radius: 12px;
        border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.02);
        font-weight: 600; font-family: inherit; font-size: 14px; outline: none; cursor: pointer;
    }

    /* Table & Badges */
    .table-container { background: var(--white); border-radius: 24px; padding: 24px; box-shadow: 0 10px 40px rgba(0,0,0,0.02); }
    .order-table { width: 100%; border-collapse: collapse; }
    .order-table th { text-align: left; padding: 16px 20px; color: var(--unity-gray); font-weight: 600; font-size: 13px; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
    .order-table td { padding: 20px; border-bottom: 1px solid var(--border-color); vertical-align: middle; font-size: 14px; }
    
    .u-badge {
        padding: 6px 12px; border-radius: 8px; font-weight: 700; font-size: 12px;
        display: inline-flex; align-items: center; gap: 6px;
    }
    .badge-pending { background: rgba(255, 206, 115, 0.15); color: #FFB129; }
    .badge-confirmed { background: rgba(63, 140, 255, 0.15); color: var(--unity-blue); }
    .badge-shipping { background: rgba(255, 117, 76, 0.15); color: #FF754C; }
    .badge-completed { background: rgba(127, 186, 122, 0.15); color: var(--unity-green); }
    .badge-cancelled { background: rgba(128, 129, 145, 0.1); color: var(--unity-gray); }
    .badge-rescheduled { background: rgba(155, 89, 182, 0.12); color: #8e44ad; }
    .badge-returning { background: rgba(231, 76, 60, 0.12); color: #c0392b; }

    /* Modal */
    .modal-overlay {
        position: fixed; top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(17, 20, 45, 0.4); backdrop-filter: blur(8px);
        display: none; justify-content: center; align-items: center; z-index: 2000;
    }
    .modal-content {
        background: var(--white); width: 700px; max-height: 90vh; border-radius: 32px; padding: 40px;
        box-shadow: 0 40px 80px rgba(0,0,0,0.1); overflow-y: auto; position: relative;
    }

    .btn-action {
        width: 36px; height: 36px; border-radius: 10px; display: inline-flex; align-items: center; justify-content: center;
        background: var(--unity-bg); color: var(--unity-gray); transition: 0.2s; border: none; cursor: pointer; font-size: 16px;
    }
    .btn-action:hover { background: var(--unity-primary); color: #fff; }
    .btn-text {
        padding: 8px 16px; border-radius: 10px; font-weight: 700; font-size: 13px; border: none; cursor: pointer; transition: 0.2s;
    }
</style>

<div class="order-header">
    <h2>Quản lý đơn hàng</h2>
</div>

<div class="filter-container">
    <form method="get" action="${pageContext.request.contextPath}/admin/orders" style="display:contents;">
        <div class="u-search" style="max-width: 200px;">
            <i class="fa-solid fa-hashtag"></i>
            <input type="text" name="orderId" placeholder="Mã đơn..." value="${param.orderId}">
        </div>
        <div class="u-search" style="max-width: 200px;">
            <i class="fa-solid fa-user"></i>
            <input type="text" name="userId" placeholder="User ID..." value="${param.userId}">
        </div>
        <select name="status" class="u-select">
            <option value="">Tất cả trạng thái</option>
            <option value="ORDER_PENDING" ${param.status == 'ORDER_PENDING' ? 'selected' : ''}>Chờ xác nhận</option>
            <option value="ORDER_CONFIRMED" ${param.status == 'ORDER_CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
            <option value="ORDER_PREPARING" ${param.status == 'ORDER_PREPARING' ? 'selected' : ''}>Đang chuẩn bị hàng</option>
            <option value="ORDER_SHIPPING" ${param.status == 'ORDER_SHIPPING' ? 'selected' : ''}>Đang giao hàng</option>
            <option value="RESCHEDULED" ${param.status == 'RESCHEDULED' ? 'selected' : ''}>Hẹn giao lại</option>
            <option value="PENDING_COD" ${param.status == 'PENDING_COD' ? 'selected' : ''}>Chờ đối soát COD</option>
            <option value="ORDER_DELIVERED" ${param.status == 'ORDER_DELIVERED' ? 'selected' : ''}>Đã giao hàng</option>
            <option value="RETURNING" ${param.status == 'RETURNING' ? 'selected' : ''}>Đang hoàn hàng</option>
            <option value="RETURN_REJECTED" ${param.status == 'RETURN_REJECTED' ? 'selected' : ''}>Từ chối hoàn</option>
            <option value="RETURNED" ${param.status == 'RETURNED' ? 'selected' : ''}>Đã hoàn hàng</option>
            <option value="ORDER_COMPLETED" ${param.status == 'ORDER_COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
            <option value="ORDER_CANCELLED" ${param.status == 'ORDER_CANCELLED' ? 'selected' : ''}>Đã hủy</option>
        </select>
        <button type="submit" class="btn-text" style="background: var(--unity-primary); color: #fff;">Lọc dữ liệu</button>
    </form>
</div>

<div class="table-container">
    <table class="order-table">
        <thead>
            <tr>
                <th>Mã đơn</th>
                <th>Khách hàng</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Ngày đặt</th>
                <th style="text-align: right;">Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="order" items="${orders}">
                <tr>
                    <td style="font-weight: 700; color: var(--unity-gray);">#${order.id}</td>
                    <td>
                        <div style="font-weight: 600; color: var(--unity-black);">User #${order.userId}</div>
                    </td>
                    <td style="font-weight: 800; color: var(--unity-blue);">${order.grandTotal}₫</td>
                    <td>
                        <c:choose>
                            <c:when test="${order.orderStatus == 'ORDER_PENDING' || order.orderStatus == 'PENDING' || order.orderStatus == 'UNPAID'}">
                                <span class="u-badge badge-pending">● ${order.vietnameseStatus}</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'ORDER_CONFIRMED' || order.orderStatus == 'CONFIRMED'}">
                                <span class="u-badge badge-confirmed">● ${order.vietnameseStatus}</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'ORDER_PREPARING'}">
                                <span class="u-badge badge-confirmed" style="background: rgba(155, 89, 182, 0.15); color: #8e44ad;">● ${order.vietnameseStatus}</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'ORDER_SHIPPING' || order.orderStatus == 'SHIPPING'}">
                                <span class="u-badge badge-shipping">● ${order.vietnameseStatus}</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'RESCHEDULED'}">
                                <span class="u-badge badge-rescheduled">🔄 ${order.vietnameseStatus}</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'PENDING_COD'}">
                                <span class="u-badge badge-pending" style="background: rgba(243, 156, 18, 0.15); color: #f39c12;">💰 ${order.vietnameseStatus}</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'ORDER_DELIVERED' || order.orderStatus == 'DELIVERED'}">
                                <span class="u-badge badge-completed" style="background: rgba(52, 152, 219, 0.15); color: #2980b9;">● ${order.vietnameseStatus}</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'RETURNING'}">
                                <span class="u-badge badge-returning">📦 ${order.vietnameseStatus}</span>
                                <c:if test="${not empty order.returnReason}">
                                    <div style="font-size:11px;color:#c0392b;margin-top:3px;">Lý do: ${order.returnReason}</div>
                                </c:if>
                            </c:when>
                            <c:when test="${order.orderStatus == 'RETURN_REJECTED'}">
                                <span class="u-badge" style="background:rgba(142,68,173,0.12);color:#6c3483;">✗ Từ chối hoàn</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'RETURNED'}">
                                <span class="u-badge badge-cancelled" style="background: rgba(231,76,60,0.08); color: #c0392b;">📦 ${order.vietnameseStatus}</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'ORDER_COMPLETED' || order.orderStatus == 'COMPLETED'}">
                                <span class="u-badge badge-completed">● ${order.vietnameseStatus}</span>
                            </c:when>
                            <c:when test="${order.orderStatus == 'ORDER_CANCELLED' || order.orderStatus == 'CANCELLED'}">
                                <span class="u-badge badge-cancelled">● ${order.vietnameseStatus}</span>
                            </c:when>
                            <c:otherwise>
                                <span class="u-badge badge-cancelled">${order.vietnameseStatus}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td style="color: var(--unity-gray); font-weight: 500;">
                        <fmt:formatDate value="${order.createdAtTimestamp}" pattern="dd/MM/yyyy HH:mm" />
                    </td>
                    <td>
                        <div style="display: flex; gap: 8px; justify-content: flex-end;">
                            <a href="${pageContext.request.contextPath}/admin/orders?action=view&orderId=${order.id}" class="btn-action" title="Xem chi tiết">
                                <i class="fa-solid fa-eye"></i>
                            </a>
                            
                            <c:if test="${order.orderStatus == 'ORDER_PENDING' || order.orderStatus == 'PENDING' || order.orderStatus == 'UNPAID'}">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="updateStatus"><input type="hidden" name="orderId" value="${order.id}"><input type="hidden" name="newStatus" value="ORDER_CONFIRMED">
                                    <button type="submit" class="btn-action" style="color: var(--unity-green);" title="Xác nhận"><i class="fa-solid fa-check"></i></button>
                                </form>
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="updateStatus"><input type="hidden" name="orderId" value="${order.id}"><input type="hidden" name="newStatus" value="ORDER_CANCELLED">
                                    <button type="submit" class="btn-action" style="color: #FF7675;" title="Hủy" onclick="return confirm('Hủy đơn hàng này?')"><i class="fa-solid fa-xmark"></i></button>
                                </form>
                            </c:if>

                            <c:if test="${order.orderStatus == 'ORDER_CONFIRMED' || order.orderStatus == 'CONFIRMED'}">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="updateStatus"><input type="hidden" name="orderId" value="${order.id}"><input type="hidden" name="newStatus" value="ORDER_PREPARING">
                                    <button type="submit" class="btn-action" style="color: #8e44ad;" title="Chuẩn bị hàng"><i class="fa-solid fa-box"></i></button>
                                </form>
                            </c:if>

                            <c:if test="${order.orderStatus == 'ORDER_PREPARING'}">
                                <button type="button" class="btn-action" style="color: #FF754C;" onclick="openShippingModal(${order.id})" title="Giao hàng">
                                    <i class="fa-solid fa-truck-fast"></i>
                                </button>
                            </c:if>

                            <%-- Đang giao: Admin có thể điều chỉnh nếu cần (thường shipper làm trên app) --%>
                            <c:if test="${order.orderStatus == 'RESCHEDULED'}">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="updateStatus"><input type="hidden" name="orderId" value="${order.id}"><input type="hidden" name="newStatus" value="ORDER_SHIPPING">
                                    <button type="submit" class="btn-action" style="color: #FF754C;" title="Cho giao lại" onclick="return confirm('Xác nhận tiếp tục giao hàng?')"><i class="fa-solid fa-rotate-right"></i></button>
                                </form>
                            </c:if>

                            <c:if test="${order.orderStatus == 'PENDING_COD'}">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="confirm-cod"><input type="hidden" name="orderId" value="${order.id}">
                                    <button type="submit" class="btn-action" style="color: #f39c12;" title="Xác nhận Shipper đã chuyển COD về tài khoản" onclick="return confirm('Xác nhận Shipper đã chuyển COD về tài khoản?')"><i class="fa-solid fa-hand-holding-dollar"></i></button>
                                </form>
                            </c:if>

                            <c:if test="${order.orderStatus == 'ORDER_DELIVERED'}">
                                <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="updateStatus"><input type="hidden" name="orderId" value="${order.id}"><input type="hidden" name="newStatus" value="ORDER_COMPLETED">
                                    <button type="submit" class="btn-action" style="color: var(--unity-green);" title="Hoàn thành"><i class="fa-solid fa-flag-checkered"></i></button>
                                </form>
                            </c:if>

                            <c:if test="${order.orderStatus == 'RETURNING'}">
                                <div style="display:flex;flex-direction:column;align-items:flex-end;gap:6px;">
                                    <c:if test="${not empty order.returnReason}">
                                        <span style="font-size:11px;background:rgba(231,76,60,0.08);color:#c0392b;padding:3px 8px;border-radius:6px;max-width:200px;text-align:right;">
                                            <i class="fa-solid fa-circle-info"></i> Lý do: <strong>${order.returnReason}</strong>
                                        </span>
                                    </c:if>
                                    <div style="display:flex;gap:6px;">
                                        <form action="${pageContext.request.contextPath}/admin/orders" method="post" style="margin:0;">
                                            <input type="hidden" name="action" value="received-return"><input type="hidden" name="orderId" value="${order.id}">
                                            <button type="submit" class="btn-action" style="background:rgba(5,205,153,0.15);color:#027a5f;" title="Chấp nhận hoàn" onclick="return confirm('Xác nhận chấp nhận hoàn hàng?')"><i class="fa-solid fa-check"></i></button>
                                        </form>
                                        <button type="button" class="btn-action" style="background:rgba(142,68,173,0.1);color:#6c3483;" title="Từ chối hoàn" onclick="openRejectReturnModal(${order.id})"><i class="fa-solid fa-xmark"></i></button>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty orders}">
                <tr><td colspan="6" style="text-align: center; padding: 48px; color: var(--unity-gray); font-style: italic;">Không tìm thấy đơn hàng nào</td></tr>
            </c:if>
        </tbody>
    </table>
</div>

<%-- MODAL ORDER DETAIL --%>
<c:if test="${not empty selectedOrder}">
    <div class="modal-overlay" style="display: flex; z-index: 9999;">
        <div class="modal-content" style="width: 800px; padding: 0; overflow: hidden; background: #fff; border-radius: 12px; box-shadow: 0 10px 40px rgba(0,0,0,0.1);">
            
            <%-- Header --%>
            <div style="display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; border-bottom: 1px solid #f0f0f0;">
                <h3 style="margin:0; font-weight: 700; font-size: 16px; display: flex; align-items: center; gap: 8px;">
                    <i class="fa-solid fa-eye" style="color: #4318FF;"></i> Chi tiết đơn hàng #${selectedOrder.id}
                </h3>
                <a href="${pageContext.request.contextPath}/admin/orders" style="color: #999; font-size: 24px; text-decoration: none; line-height: 1;">&times;</a>
            </div>

            <div style="padding: 24px; max-height: 80vh; overflow-y: auto;">
                <%-- Thông tin đơn hàng --%>
                <div style="margin-bottom: 24px;">
                    <h4 style="font-size: 14px; font-weight: 700; color: #333; margin-bottom: 16px;">Thông tin đơn hàng</h4>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; border-bottom: 1px dashed #eee; padding-bottom: 24px;">
                        <div style="display: flex; gap: 8px; align-items: center;">
                            <span style="color: #666; font-size: 13px; width: 150px;">Mã đơn hàng:</span>
                            <span style="font-weight: 600; font-size: 13px; background: #f5f5f5; padding: 4px 10px; border-radius: 4px;">${selectedOrder.id}</span>
                        </div>
                        <div style="display: flex; gap: 8px; align-items: center;">
                            <span style="color: #666; font-size: 13px; width: 150px;">Ngày đặt:</span>
                            <span style="font-weight: 600; font-size: 13px;"><fmt:formatDate value="${selectedOrder.createdAtTimestamp}" pattern="dd/MM/yyyy HH:mm" /></span>
                        </div>
                        <div style="display: flex; gap: 8px; align-items: center;">
                            <span style="color: #666; font-size: 13px; width: 150px;">Trạng thái:</span>
                            <span class="u-badge badge-pending" style="font-size: 12px;">${selectedOrder.vietnameseStatus}</span>
                        </div>
                        <div style="display: flex; gap: 8px; align-items: center;">
                            <span style="color: #666; font-size: 13px; width: 150px;">Phương thức thanh toán:</span>
                            <span style="font-weight: 600; font-size: 12px; color: #4318FF; border: 1px solid rgba(67, 24, 255, 0.2); padding: 2px 8px; border-radius: 4px;">${selectedOrder.paymentMethod}</span>
                        </div>
                    </div>
                </div>

                <%-- Thông tin khách hàng --%>
                <div style="margin-bottom: 24px;">
                    <h4 style="font-size: 14px; font-weight: 700; color: #333; margin-bottom: 16px;">Thông tin khách hàng</h4>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; border-bottom: 1px dashed #eee; padding-bottom: 24px;">
                        <div style="display: flex; gap: 8px;">
                            <span style="color: #666; font-size: 13px; width: 150px;">Họ tên:</span>
                            <span style="font-weight: 600; font-size: 13px;">${selectedCustomer != null ? selectedCustomer.fullName : 'Chưa cập nhật'}</span>
                        </div>
                        <div style="display: flex; gap: 8px;">
                            <span style="color: #666; font-size: 13px; width: 150px;">Email:</span>
                            <span style="font-weight: 600; font-size: 13px;">${selectedCustomer != null ? selectedCustomer.email : 'Chưa cập nhật'}</span>
                        </div>
                        <div style="display: flex; gap: 8px; grid-column: 1 / -1;">
                            <span style="color: #666; font-size: 13px; width: 150px;">Số điện thoại:</span>
                            <span style="font-weight: 600; font-size: 13px;">${selectedOrder.phoneNumber}</span>
                        </div>
                        <div style="display: flex; gap: 8px; grid-column: 1 / -1;">
                            <span style="color: #666; font-size: 13px; width: 150px;">Địa chỉ giao hàng:</span>
                            <span style="font-weight: 600; font-size: 13px;">${selectedOrder.shippingAddress}</span>
                        </div>
                    </div>
                </div>

                <%-- Sản phẩm đặt hàng --%>
                <div style="margin-bottom: 24px;">
                    <h4 style="font-size: 14px; font-weight: 700; color: #333; margin-bottom: 16px;">Sản phẩm đặt hàng</h4>
                    <div style="display: flex; flex-direction: column; gap: 12px; border-bottom: 1px dashed #eee; padding-bottom: 24px;">
                        <c:forEach var="item" items="${selectedOrder.items}">
                            <div style="display: flex; align-items: center; justify-content: space-between; background: #fafafa; border-radius: 8px; padding: 12px 16px; border: 1px solid #f0f0f0;">
                                <div style="display: flex; align-items: center; gap: 16px;">
                                    <img src="${item.imageUrl}" style="width: 50px; height: 50px; border-radius: 6px; object-fit: cover;" onerror="this.src='https://placehold.co/100x100?text=Giay'">
                                    <div>
                                        <div style="font-size: 13px; font-weight: 600; color: #333; margin-bottom: 4px;">${item.productName}</div>
                                        <div style="font-size: 12px; color: #666;">Màu: ${item.colorName} | Size: ${item.sizeName}</div>
                                        <div style="font-size: 12px; color: #666; margin-top: 2px;">Số lượng: ${item.quantity} sản phẩm</div>
                                    </div>
                                </div>
                                <div style="font-size: 14px; font-weight: 700; color: #333;">
                                    <fmt:formatNumber value="${item.unitPrice}" type="number" /> ₫
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <%-- Tổng kết đơn hàng --%>
                <div>
                    <h4 style="font-size: 14px; font-weight: 700; color: #333; margin-bottom: 16px;">Tổng kết đơn hàng</h4>
                    <div style="display: flex; flex-direction: column; gap: 12px;">
                        <div style="display: flex; justify-content: space-between; font-size: 13px;">
                            <span style="color: #666; font-weight: 500;">Tổng tiền hàng:</span>
                            <span style="font-weight: 600; color: #333;"><fmt:formatNumber value="${selectedOrder.subTotal}" type="number" /> ₫</span>
                        </div>
                        <c:if test="${selectedOrder.discountAmount != null && selectedOrder.discountAmount > 0}">
                            <div style="display: flex; justify-content: space-between; font-size: 13px;">
                                <span style="color: #e74c3c; font-weight: 500;">Giảm giá:</span>
                                <span style="font-weight: 600; color: #e74c3c;">-<fmt:formatNumber value="${selectedOrder.discountAmount}" type="number" /> ₫</span>
                            </div>
                        </c:if>
                        <div style="display: flex; justify-content: space-between; font-size: 13px;">
                            <span style="color: #666; font-weight: 500;">Phí vận chuyển:</span>
                            <span style="font-weight: 600; color: #333;"><fmt:formatNumber value="${selectedOrder.shippingFee}" type="number" /> ₫</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 15px; margin-top: 12px; padding-top: 16px; border-top: 1px solid #eee;">
                            <span style="font-weight: 700; color: #333;">Thành tiền:</span>
                            <span style="font-weight: 800; color: #2ecc71; font-size: 18px;"><fmt:formatNumber value="${selectedOrder.grandTotal}" type="number" /> ₫</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</c:if>

<%-- SHIPPING MODAL --%>
<div id="shippingModal" class="modal-overlay">
    <div class="modal-content" style="width: 450px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
            <h3 style="margin:0; font-weight: 800;">Xác nhận giao hàng</h3>
            <button onclick="closeShippingModal()" style="border: none; background: transparent; font-size: 24px; cursor: pointer; color: var(--unity-gray);">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/orders" method="post">
            <input type="hidden" name="action" value="updateStatus"><input type="hidden" name="newStatus" value="ORDER_SHIPPING"><input type="hidden" name="orderId" id="shippingOrderId" value="">
            <input type="hidden" name="shippingUnit" value="Shipper của shop">
            <div style="margin-bottom: 24px;">
                <label style="display: block; font-size: 12px; font-weight: 700; color: var(--unity-gray); margin-bottom: 8px; text-transform: uppercase;">Nhân viên giao hàng</label>
                <select name="shipperId" required style="width: 100%; padding: 16px; background: var(--unity-bg); border: none; border-radius: 12px; font-family: inherit; font-weight: 600; outline: none;">
                    <option value="">-- Chọn nhân viên --</option>
                    <c:forEach var="shipper" items="${shippers}">
                        <option value="${shipper.id}">${shipper.fullName} - ${shipper.phoneNumber}</option>
                    </c:forEach>
                </select>
            </div>
            <div style="margin-bottom: 32px;">
                <label style="display: block; font-size: 12px; font-weight: 700; color: var(--unity-gray); margin-bottom: 8px; text-transform: uppercase;">Mã vận đơn</label>
                <input type="text" name="trackingCode" required style="width: 100%; padding: 16px; background: var(--unity-bg); border: none; border-radius: 12px; font-family: inherit; font-weight: 600; outline: none;">
            </div>
            <div style="display: flex; justify-content: flex-end; gap: 12px;">
                <button type="button" onclick="closeShippingModal()" class="btn-text" style="background: var(--unity-bg); color: var(--unity-gray);">Hủy</button>
                <button type="submit" class="btn-text" style="background: #FF754C; color: white;">Bắt đầu giao hàng</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openShippingModal(orderId) {
        document.getElementById('shippingOrderId').value = orderId;
        document.querySelector('input[name="shippingUnit"]').value = 'Shipper của shop';
        const randomNum = Math.floor(10000000 + Math.random() * 90000000);
        document.querySelector('input[name="trackingCode"]').value = 'SHOP' + orderId + randomNum;
        document.getElementById('shippingModal').style.display = 'flex';
    }
    function closeShippingModal() { document.getElementById('shippingModal').style.display = 'none'; }

    // Reject return modal
    function openRejectReturnModal(orderId) {
        document.getElementById('rejectReturnOrderId').value = orderId;
        document.getElementById('rejectReturnModal').style.display = 'flex';
    }
    function closeRejectReturnModal() {
        document.getElementById('rejectReturnModal').style.display = 'none';
    }
</script>

<%-- MODAL: Từ chối hoàn hàng --%>
<div id="rejectReturnModal" class="modal-overlay" style="display:none;">
    <div class="modal-content" style="width: 460px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
            <h3 style="margin:0; font-weight: 800; color:#6c3483;">❌ Từ chối hoàn hàng</h3>
            <button onclick="closeRejectReturnModal()" style="border:none;background:transparent;font-size:24px;cursor:pointer;color:var(--unity-gray);">&times;</button>
        </div>
        <p style="color:var(--unity-gray);font-size:14px;margin-bottom:20px;">Vui lòng nhập lý do từ chối. Khách hàng sẽ nhìn thấy lý do này.</p>
        <form action="${pageContext.request.contextPath}/admin/orders" method="post">
            <input type="hidden" name="action" value="reject-return">
            <input type="hidden" name="orderId" id="rejectReturnOrderId" value="">
            <div style="margin-bottom:20px;">
                <label style="display:block;font-size:12px;font-weight:700;color:var(--unity-gray);margin-bottom:8px;text-transform:uppercase;">Lý do từ chối</label>
                <textarea name="rejectionReason" required rows="4"
                    style="width:100%;padding:14px;background:var(--unity-bg);border:none;border-radius:12px;font-family:inherit;font-size:14px;outline:none;resize:vertical;box-sizing:border-box;"
                    placeholder="VD: Sản phẩm đã được sử dụng, không đủ điều kiện hoàn hàng..."></textarea>
            </div>
            <div style="display:flex;justify-content:flex-end;gap:12px;">
                <button type="button" onclick="closeRejectReturnModal()" class="btn-text" style="background:var(--unity-bg);color:var(--unity-gray);">Hủy</button>
                <button type="submit" class="btn-text" style="background:#6c3483;color:white;">Xác nhận Từ chối</button>
            </div>
        </form>
    </div>
</div>