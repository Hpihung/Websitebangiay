package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.user.User;
import services.AccountServices;

import java.io.IOException;

@WebServlet("/account")
public class AccountController extends HttpServlet {

    private AccountServices accountServices;

    @Override
    public void init() {
        accountServices = new AccountServices();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = requireLogin(req, resp);
        if (currentUser == null)
            return;


        HttpSession session = req.getSession(false);
        Object flashMsg = session.getAttribute("flashMsg");
        Object flashType = session.getAttribute("flashType");
        if (flashMsg != null) {
            req.setAttribute("msg", flashMsg);
            req.setAttribute("msgType", flashType);
            session.removeAttribute("flashMsg");
            session.removeAttribute("flashType");
        }

        dao.Order.OrderDao orderDao = new dao.Order.OrderDao();
        orderDao.autoConfirmDeliveredOrders();

        java.util.List<model.Order.Order> orderHistory = accountServices.getOrderHistory(currentUser.getId());
        req.setAttribute("orderHistory", orderHistory);

        dao.CouponDao couponDao = new dao.CouponDao();
        java.util.List<model.Coupon> activeCoupons = couponDao.findAllActive();
        req.setAttribute("vouchers", activeCoupons);

        // Fetch Warranty data
        dao.warranty.WarrantyRequestDao warrantyDao = new dao.warranty.WarrantyRequestDao();
        req.setAttribute("eligibleWarrantyItems", warrantyDao.findEligibleItems(currentUser.getId()));
        req.setAttribute("warrantyRequests", warrantyDao.findByUserId(currentUser.getId()));

        req.getRequestDispatcher("/account.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        User currentUser = requireLogin(req, resp);
        if (currentUser == null)
            return;

        String action = safe(req.getParameter("action"));

        switch (action) {
            case "change-password" -> handlePasswordChange(req, resp, currentUser);
            case "update-profile" -> handleProfileUpdate(req, resp, currentUser);
            case "cancel-order" -> handleCancelOrder(req, resp, currentUser);
            case "complete-order", "confirm-received" -> handleCompleteOrder(req, resp, currentUser);
            case "return-order" -> handleReturnOrder(req, resp, currentUser);
            default -> resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void handleCancelOrder(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String cancelReason = req.getParameter("cancelReason");
            if (cancelReason == null || cancelReason.trim().isEmpty()) {
                cancelReason = "Người dùng hủy đơn";
            }
            dao.Order.OrderDao orderDao = new dao.Order.OrderDao();
            java.util.List<model.Order.Order> orders = orderDao.findWithFilter(orderId, currentUser.getId(), null, null);
            if (!orders.isEmpty()) {
                model.Order.Order order = orders.get(0);
                if ("PENDING".equals(order.getOrderStatus()) || "ORDER_PENDING".equals(order.getOrderStatus())) {
                    orderDao.cancelOrder(orderId, cancelReason, "User");
                    setFlash(req, "Hủy đơn hàng thành công!", "success");
                } else {
                    setFlash(req, "Không thể hủy đơn hàng ở trạng thái này.", "danger");
                }
            }
        } catch (Exception e) {
            setFlash(req, "Có lỗi xảy ra.", "danger");
        }
        resp.sendRedirect(req.getContextPath() + "/account#order-history");
    }

    private void handleCompleteOrder(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            dao.Order.OrderDao orderDao = new dao.Order.OrderDao();
            java.util.List<model.Order.Order> orders = orderDao.findWithFilter(orderId, currentUser.getId(), null, null);
            if (!orders.isEmpty()) {
                model.Order.Order order = orders.get(0);
                String st = order.getOrderStatus();
                if ("ORDER_COMPLETED".equals(st) || "COMPLETED".equals(st)) {
                    if (order.getReceivedAt() == null) {
                        orderDao.confirmReceived(orderId);
                        setFlash(req, "Cảm ơn bạn đã xác nhận nhận hàng!", "success");
                    } else {
                        setFlash(req, "Đơn hàng đã được xác nhận nhận hàng trước đó.", "warning");
                    }
                } else if ("SHIPPING".equals(st) || "ORDER_SHIPPING".equals(st) || "ORDER_DELIVERED".equals(st) || "DELIVERED".equals(st)) {
                    if ("COD".equals(order.getPaymentMethod()) && !"PAID".equals(order.getPaymentStatus())) {
                        orderDao.userConfirmReceived(orderId, "PENDING_COD", order.getTrackingCode(), order.getShippingUnit(), "User");
                        setFlash(req, "Cảm ơn bạn đã xác nhận nhận hàng! Đơn hàng đang chờ đối soát thanh toán.", "success");
                    } else {
                        orderDao.userConfirmReceived(orderId, "ORDER_COMPLETED", order.getTrackingCode(), order.getShippingUnit(), "User");
                        setFlash(req, "Cảm ơn bạn đã xác nhận nhận hàng!", "success");
                    }
                } else {
                    setFlash(req, "Trạng thái đơn hàng không hợp lệ.", "danger");
                }
            }
        } catch (Exception e) {
            setFlash(req, "Có lỗi xảy ra.", "danger");
        }
        resp.sendRedirect(req.getContextPath() + "/account#order-history");
    }

    private void handleReturnOrder(HttpServletRequest req, HttpServletResponse resp, User currentUser) throws IOException {
        try {
            int orderId = Integer.parseInt(req.getParameter("orderId"));
            String returnReason = req.getParameter("returnReason");
            if (returnReason == null || returnReason.trim().isEmpty()) {
                returnReason = "Khách yêu cầu hoàn hàng";
            }
            dao.Order.OrderDao orderDao = new dao.Order.OrderDao();
            java.util.List<model.Order.Order> orders = orderDao.findWithFilter(orderId, currentUser.getId(), null, null);
            if (!orders.isEmpty()) {
                model.Order.Order order = orders.get(0);
                String st = order.getOrderStatus();
                boolean allowedStatus = "ORDER_COMPLETED".equals(st) || "COMPLETED".equals(st)
                        || "ORDER_DELIVERED".equals(st) || "DELIVERED".equals(st);
                // Check 7-day window from receivedAt or deliveredAt
                boolean withinWindow = false;
                java.time.LocalDateTime ref = order.getReceivedAt() != null
                        ? order.getReceivedAt() : order.getDeliveredAt();
                if (ref != null) {
                    withinWindow = java.time.LocalDateTime.now().isBefore(ref.plusDays(7));
                } else {
                    withinWindow = true; // no timestamp -> allow
                }
                if (allowedStatus && withinWindow) {
                    orderDao.returnOrder(orderId, returnReason.trim(), "User");
                    setFlash(req, "Yêu cầu hoàn hàng đã được gửi! Chúng tôi sẽ liên hệ với bạn sớm nhất.", "success");
                } else if (!withinWindow) {
                    setFlash(req, "Đã quá 7 ngày kể từ khi nhận hàng, không thể hoàn đơn.", "danger");
                } else {
                    setFlash(req, "Trạng thái đơn hàng không hợp lệ để hoàn hàng.", "danger");
                }
            }
        } catch (Exception e) {
            setFlash(req, "Có lỗi xảy ra khi yêu cầu hoàn hàng.", "danger");
        }
        resp.sendRedirect(req.getContextPath() + "/account#order-history");
    }

    private void handleProfileUpdate(HttpServletRequest req, HttpServletResponse resp, User currentUser)
            throws IOException {

        String fullName = safe(req.getParameter("fullName"));
        String phoneNumber = safe(req.getParameter("phoneNumber"));
        String address = safe(req.getParameter("address"));

        if (fullName.isBlank()) {
            setFlash(req, "Họ tên không được để trống.", "danger");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        boolean success = accountServices.updateUserProfile(
                currentUser.getId(), fullName, phoneNumber, address);

        if (success) {

            currentUser.setFullName(fullName);
            currentUser.setPhoneNumber(phoneNumber);
            currentUser.setAddress(address);

            setFlash(req, "Cập nhật thông tin thành công!", "success");
        } else {
            setFlash(req, "Cập nhật thất bại. Vui lòng thử lại.", "danger");
        }

        resp.sendRedirect(req.getContextPath() + "/account");
    }

    private void handlePasswordChange(HttpServletRequest req, HttpServletResponse resp, User currentUser)
            throws IOException {

        String currentPassword = safe(req.getParameter("currentPassword"));
        String newPassword = safe(req.getParameter("newPassword"));
        String confirmPassword = safe(req.getParameter("confirmPassword"));

        if (currentPassword.isBlank() || newPassword.isBlank() || confirmPassword.isBlank()) {
            setFlash(req, "Vui lòng nhập đầy đủ thông tin mật khẩu.", "danger");
            resp.sendRedirect(req.getContextPath() + "/account");
            return;
        }

        String result = accountServices.changePassword(
                currentUser.getEmail(), currentPassword, newPassword, confirmPassword);

        if ("SUCCESS".equals(result)) {
            setFlash(req, "Đổi mật khẩu thành công!", "success");

        } else {
            setFlash(req, result, "danger");
        }

        resp.sendRedirect(req.getContextPath() + "/account");
    }

    private User requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return null;
        }
        Object u = session.getAttribute("currentUser");
        if (!(u instanceof User)) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return null;
        }
        return (User) u;
    }

    private void setFlash(HttpServletRequest req, String msg, String type) {
        HttpSession session = req.getSession();
        session.setAttribute("flashMsg", msg);
        session.setAttribute("flashType", type); // success | danger | warning | info
    }

    private String safe(String s) {
        return s == null ? "" : s.trim();
    }
}
