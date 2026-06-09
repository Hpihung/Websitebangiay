package controller.admin;

import dao.warranty.WarrantyRequestDao;
import dao.JDBIConnector;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.warranty.WarrantyRequest;
import services.EmailServices;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/warranty")
public class AdminWarrantyController extends HttpServlet {

    private final WarrantyRequestDao warrantyDao = new WarrantyRequestDao();
    private final EmailServices emailServices = new EmailServices();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        List<WarrantyRequest> requests = warrantyDao.findAll();
        req.setAttribute("requests", requests);

        req.setAttribute("active", "admin/warranty");
        req.setAttribute("contentPage", "admin-views/admin-warranty.jsp");
        req.getRequestDispatcher("/Admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/login");
            return;
        }

        String action = req.getParameter("action");
        if ("update_status".equals(action)) {
            try {
                int requestId = Integer.parseInt(req.getParameter("requestId"));
                String status = req.getParameter("status");

                // Get original request to check if status changed to COMPLETED/ACCEPTED
                WarrantyRequest original = warrantyDao.findById(requestId);

                warrantyDao.updateStatus(requestId, status);

                // Send email notification on status change
                boolean shouldSendEmail = ("COMPLETED".equals(status) || "REJECTED".equals(status))
                        && original != null
                        && !status.equals(original.getStatus());

                if (shouldSendEmail) {
                    boolean isCompleted = "COMPLETED".equals(status);

                    String subject = isCompleted
                            ? "✅ Yêu cầu đổi trả / bảo hành của bạn đã được chấp thuận"
                            : "❌ Yêu cầu đổi trả / bảo hành của bạn không được chấp thuận";

                    String statusBg = isCompleted ? "#27ae60" : "#e74c3c";
                    String statusText = isCompleted ? "HOÀN THÀNH" : "TỪ CHỐI";
                    String statusMsg = isCompleted
                            ? "Yêu cầu đổi trả / bảo hành của bạn đã được <b>chấp thuận và xử lý hoàn tất</b>. Chúng tôi sẽ sớm liên hệ để sắp xếp thu hồi và gửi sản phẩm thay thế (hoặc hoàn tiền) cho bạn."
                            : "Rất tiếc, yêu cầu đổi trả / bảo hành của bạn <b>không được chấp thuận</b>. Nếu bạn có thắc mắc, vui lòng liên hệ với chúng tôi để được hỗ trợ thêm.";

                    String shippingInfo = (original.getShippingAddress() != null
                            && !original.getShippingAddress().isEmpty())
                                    ? original.getShippingAddress()
                                    : "Không có thông tin";
                    String phoneInfo = (original.getPhoneNumber() != null && !original.getPhoneNumber().isEmpty())
                            ? original.getPhoneNumber()
                            : "Không có thông tin";
                    String descInfo = (original.getDescription() != null && !original.getDescription().isEmpty())
                            ? original.getDescription()
                            : "—";

                    String requestTypeInfo = "EXCHANGE".equals(original.getRequestType()) ? "Đổi size sản phẩm" : "Trả hàng & Hoàn tiền";
                    String extraInfoRow = "";
                    if ("EXCHANGE".equals(original.getRequestType())) {
                        extraInfoRow = "<tr style='border-bottom:1px solid #f0f0f0;'>" +
                                "<td style='padding:10px 12px;color:#6c757d;font-weight:600;'>Size muốn đổi</td>" +
                                "<td style='padding:10px 12px;color:#3b82f6;font-weight:700;'>" + (original.getExchangeSize() != null ? original.getExchangeSize() : "—") + "</td>" +
                                "</tr>";
                    } else if ("REFUND".equals(original.getRequestType())) {
                        extraInfoRow = "<tr style='border-bottom:1px solid #f0f0f0;'>" +
                                "<td style='padding:10px 12px;color:#6c757d;font-weight:600;'>Tài khoản hoàn tiền</td>" +
                                "<td style='padding:10px 12px;color:#333;'>" +
                                "Ngân hàng: <b>" + (original.getRefundBankName() != null ? original.getRefundBankName() : "—") + "</b><br>" +
                                "STK: <b>" + (original.getRefundAccountNumber() != null ? original.getRefundAccountNumber() : "—") + "</b><br>" +
                                "Chủ TK: <b>" + (original.getRefundAccountHolder() != null ? original.getRefundAccountHolder() : "—") + "</b>" +
                                "</td>" +
                                "</tr>";
                    }

                    String imgTag = (original.getProductImageUrl() != null && !original.getProductImageUrl().isEmpty())
                            ? "<img src='" + original.getProductImageUrl()
                                    + "' alt='Ảnh sản phẩm' style='width:80px;height:80px;object-fit:cover;border-radius:8px;border:1px solid #eee;margin-right:16px;vertical-align:middle;'>"
                            : "";

                    String content = "<div style='font-family:Arial,sans-serif;max-width:600px;margin:0 auto;color:#333;'>"
                            +

                            // Header
                            "<div style='background:linear-gradient(135deg,#1a1a2e,#2c3e50);padding:28px 32px;border-radius:12px 12px 0 0;text-align:center;'>"
                            +
                            "<h1 style='color:#fff;margin:0;font-size:22px;letter-spacing:0.5px;'>H&amp;M Sport Shoes</h1>"
                            +
                            "<p style='color:#adb5bd;margin:6px 0 0;font-size:13px;'>Thông báo yêu cầu bảo hành &amp; đổi trả</p>"
                            +
                            "</div>" +

                            // Status banner
                            "<div style='background:" + statusBg + ";padding:14px 32px;text-align:center;'>" +
                            "<span style='color:#fff;font-size:15px;font-weight:700;letter-spacing:1px;'>" + statusText
                            + "</span>" +
                            "</div>" +

                            // Body
                            "<div style='background:#fff;padding:28px 32px;border:1px solid #eaecf4;border-top:none;'>"
                            +
                            "<p style='font-size:15px;margin:0 0 16px;'>Xin chào <b>" + original.getCustomerName()
                            + "</b>,</p>" +
                            "<p style='color:#555;margin:0 0 24px;line-height:1.7;'>" + statusMsg + "</p>" +

                            // Product info card
                            "<div style='background:#f8f9fc;border:1px solid #e9ecef;border-radius:10px;padding:16px;margin-bottom:20px;display:flex;align-items:center;'>"
                            +
                            imgTag +
                            "<div style='display:inline-block;vertical-align:middle;'>" +
                            "<div style='font-size:15px;font-weight:700;color:#1a1a2e;margin-bottom:4px;'>"
                            + original.getProductName() + "</div>" +
                            "<div style='font-size:13px;color:#6c757d;'>Đơn hàng <b>#" + original.getOrderId()
                            + "</b></div>" +
                            "</div>" +
                            "</div>" +

                            // Detail table
                            "<table style='width:100%;border-collapse:collapse;font-size:14px;margin-bottom:20px;'>" +
                            "<tr style='border-bottom:1px solid #f0f0f0;'>" +
                            "<td style='padding:10px 12px;color:#6c757d;font-weight:600;width:40%;'>Loại yêu cầu</td>" +
                            "<td style='padding:10px 12px;color:#333;'>" + requestTypeInfo + "</td>" +
                            "</tr>" +
                            extraInfoRow +
                            "<tr style='border-bottom:1px solid #f0f0f0;background:#fafafa;'>" +
                            "<td style='padding:10px 12px;color:#6c757d;font-weight:600;'>Lý do đổi trả</td>"
                            +
                            "<td style='padding:10px 12px;color:#333;'>" + original.getReason() + "</td>" +
                            "</tr>" +
                            "<tr style='border-bottom:1px solid #f0f0f0;'>" +
                            "<td style='padding:10px 12px;color:#6c757d;font-weight:600;'>Mô tả chi tiết</td>" +
                            "<td style='padding:10px 12px;color:#333;'>" + descInfo + "</td>" +
                            "</tr>" +
                            "<tr style='border-bottom:1px solid #f0f0f0;background:#fafafa;'>" +
                            "<td style='padding:10px 12px;color:#6c757d;font-weight:600;'>Địa chỉ giao hàng</td>" +
                            "<td style='padding:10px 12px;color:#333;'>" + shippingInfo + "</td>" +
                            "</tr>" +
                            "<tr>" +
                            "<td style='padding:10px 12px;color:#6c757d;font-weight:600;'>Số điện thoại</td>" +
                            "<td style='padding:10px 12px;color:#333;'>" + phoneInfo + "</td>" +
                            "</tr>" +
                            "</table>" +

                            // Return address box (only for COMPLETED)
                            (isCompleted
                                    ? "<div style='background:#e8f5e9;border:1px solid #a5d6a7;border-radius:8px;padding:14px 16px;margin-bottom:20px;'>"
                                            +
                                            "<div style='font-size:13px;font-weight:700;color:#2e7d32;margin-bottom:6px;'><i>📦</i> Hướng dẫn gửi sản phẩm về shop</div>"
                                            +
                                            "<div style='font-size:13px;color:#388e3c;line-height:1.7;'>" +
                                            "Vui lòng đóng gói sản phẩm cẩn thận và gửi về địa chỉ:<br>" +
                                            "<b>H&amp;M Sport Shoes — 136 Đường Kim Giang, Phường Hoàng Liệt, Quận Hoàng Mai, Thành phố Hà Nội</b><br>"
                                            +
                                            "Ghi rõ: <b>Tên bạn + Số điện thoại + Mã đơn hàng #" + original.getOrderId()
                                            + "</b> trên bưu kiện.<br>" +
                                            ("SELF_SEND".equalsIgnoreCase(original.getReturnMethod())
                                                    ? "<b>Hình thức trả hàng:</b> Bạn chọn tự gửi sản phẩm về shop. Vui lòng gửi hàng sớm về địa chỉ trên."
                                                    : "<b>Hình thức trả hàng:</b> Shipper của chúng tôi sẽ liên hệ sắp xếp lịch lấy hàng tại địa chỉ của bạn.")
                                            +
                                            "</div>" +
                                            "</div>"
                                    : "")
                            +

                            // Contact note
                            "<div style='background:#fff8e6;border-left:4px solid #f39c12;padding:12px 16px;border-radius:0 6px 6px 0;margin-bottom:24px;font-size:13px;color:#555;'>"
                            +
                            "Nếu có bất kỳ thắc mắc nào, vui lòng liên hệ chúng tôi qua email này hoặc gọi hotline <b>1800-xxxx</b> (miễn phí). Đội ngũ hỗ trợ luôn sẵn sàng phục vụ bạn."
                            +
                            "</div>" +

                            "<p style='font-size:14px;margin:0;'>Trân trọng,<br><b>H&amp;M Sport Shoes Team</b></p>" +
                            "</div>" +

                            // Footer
                            "<div style='background:#f8f9fc;padding:16px 32px;text-align:center;border:1px solid #eaecf4;border-top:none;border-radius:0 0 12px 12px;'>"
                            +
                            "<p style='margin:0;font-size:12px;color:#adb5bd;'>© 2026 H&amp;M Sport Shoes · 136 Kim Giang, Hoàng Mai, Hà Nội</p>"
                            +
                            "</div>" +

                            "</div>";

                    emailServices.seend(original.getCustomerEmail(), subject, content);
                }

                // Create shipper pickup order when warranty is COMPLETED
                if ("COMPLETED".equals(status) && original != null && !"COMPLETED".equals(original.getStatus())) {
                    if (!"SELF_SEND".equalsIgnoreCase(original.getReturnMethod())) {
                        String pickupNote = "[BẢO HÀNH #" + requestId + "] Thu hồi sản phẩm: " + original.getProductName()
                                + " - Đơn hàng gốc #" + original.getOrderId();
                        // Fetch customer profile address/phone if shipping_address/pickup_address is null or empty
                        final String[] userProfile = {null, null}; // [address, phone]
                        try {
                            JDBIConnector.getJdbi().useHandle(handle -> {
                                java.util.Map<String, Object> uMap = handle.createQuery("SELECT address, phone_number FROM users WHERE id = :userId")
                                        .bind("userId", original.getUserId())
                                        .mapToMap()
                                        .findOne()
                                        .orElse(null);
                                if (uMap != null) {
                                    userProfile[0] = (String) uMap.get("address");
                                    userProfile[1] = (String) uMap.get("phone_number");
                                }
                            });
                        } catch (Exception ignored) {}

                        String pickupAddress = (original.getPickupAddress() != null && !original.getPickupAddress().isBlank())
                                ? original.getPickupAddress()
                                : ((original.getShippingAddress() != null && !original.getShippingAddress().isBlank())
                                        ? original.getShippingAddress()
                                        : ((userProfile[0] != null && !userProfile[0].isBlank()) ? userProfile[0] : "Địa chỉ theo đơn #" + original.getOrderId()));
                        String pickupPhone = (original.getPickupPhone() != null && !original.getPickupPhone().isBlank())
                                ? original.getPickupPhone()
                                : ((original.getPhoneNumber() != null && !original.getPhoneNumber().isBlank())
                                        ? original.getPhoneNumber()
                                        : ((userProfile[1] != null && !userProfile[1].isBlank()) ? userProfile[1] : ""));


                        // Get shipper_id from the original order
                        final Long[] shipperIdHolder = { null };
                        try {
                            JDBIConnector.getJdbi().useHandle(handle -> {
                                Long sid = handle.createQuery("SELECT shipper_id FROM orders WHERE id = :id")
                                        .bind("id", original.getOrderId())
                                        .mapTo(Long.class)
                                        .findOne()
                                        .orElse(null);
                                shipperIdHolder[0] = sid;
                            });
                        } catch (Exception ignored) {
                        }

                        try {
                            final Long assignedShipper = shipperIdHolder[0];
                            JDBIConnector.getJdbi().useHandle(handle -> handle.createUpdate(
                                    "INSERT INTO orders (user_id, shipping_address, phone_number, sub_total, shipping_fee, grand_total, "
                                            +
                                            "payment_method, payment_status, order_status, order_note, shipper_id, created_at) "
                                            +
                                            "VALUES (:userId, :address, :phone, 0, 0, 0, 'WARRANTY', 'PAID', 'ORDER_SHIPPING', :note, :shipperId, NOW())")
                                    .bind("userId", original.getUserId())
                                    .bind("address", pickupAddress)
                                    .bind("phone", pickupPhone)
                                    .bind("note", pickupNote)
                                    .bind("shipperId", assignedShipper)
                                    .execute());
                        } catch (Exception ex) {
                            ex.printStackTrace();
                        }
                    }
                }

                session.setAttribute("flashMsg", "Cập nhật trạng thái yêu cầu #" + requestId + " thành công!");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flashMsg", "Đã xảy ra lỗi khi cập nhật!");
            }
        }
        if ("XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))) {
            List<WarrantyRequest> requests = warrantyDao.findAll();
            req.setAttribute("requests", requests);
            req.setAttribute("active", "admin/warranty");
            req.setAttribute("contentPage", "admin-views/admin-warranty.jsp");
            req.getRequestDispatcher("/Admin.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/warranty");
    }
}
