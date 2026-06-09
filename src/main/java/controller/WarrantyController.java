package controller;

import dao.warranty.WarrantyRequestDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.User;
import model.warranty.WarrantyRequest;

import java.io.IOException;

@WebServlet("/warranty")
public class WarrantyController extends HttpServlet {

    private final WarrantyRequestDao warrantyDao = new WarrantyRequestDao();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("currentUser");
        String action = req.getParameter("action");

        if ("submit_request".equals(action)) {
            try {
                int orderId = Integer.parseInt(req.getParameter("orderId"));
                int productId = Integer.parseInt(req.getParameter("productId"));
                String reason = req.getParameter("reason");
                String description = req.getParameter("description");
                String imageUrl = req.getParameter("imageUrl");

                String requestType = req.getParameter("requestType");
                if (requestType == null || requestType.trim().isEmpty()) {
                    requestType = "EXCHANGE";
                }
                String exchangeSize = req.getParameter("exchangeSize");
                String refundBankName = req.getParameter("refundBankName");
                String refundAccountNumber = req.getParameter("refundAccountNumber");
                String refundAccountHolder = req.getParameter("refundAccountHolder");

                String returnMethod = req.getParameter("returnMethod");
                if (returnMethod == null || returnMethod.trim().isEmpty()) {
                    returnMethod = "PICKUP";
                }
                String pickupAddress = req.getParameter("pickupAddress");
                String pickupPhone = req.getParameter("pickupPhone");

                WarrantyRequest request = new WarrantyRequest();
                request.setUserId(currentUser.getId());
                request.setOrderId(orderId);
                request.setProductId(productId);
                request.setReason(reason);
                request.setDescription(description);
                request.setImageUrl(imageUrl);
                request.setStatus("PENDING");
                request.setRequestType(requestType.trim());
                request.setReturnMethod(returnMethod.trim());

                if ("PICKUP".equals(returnMethod)) {
                    request.setPickupAddress(pickupAddress != null ? pickupAddress.trim() : null);
                    request.setPickupPhone(pickupPhone != null ? pickupPhone.trim() : null);
                }

                if ("EXCHANGE".equals(requestType)) {
                    request.setExchangeSize(exchangeSize != null ? exchangeSize.trim() : null);
                } else if ("REFUND".equals(requestType)) {
                    request.setRefundBankName(refundBankName != null ? refundBankName.trim() : null);
                    request.setRefundAccountNumber(refundAccountNumber != null ? refundAccountNumber.trim() : null);
                    request.setRefundAccountHolder(refundAccountHolder != null ? refundAccountHolder.trim() : null);
                }

                warrantyDao.insert(request);

                session.setAttribute("flashMsg", "Gửi yêu cầu bảo hành / đổi trả thành công. Chúng tôi sẽ sớm liên hệ lại với bạn.");
                session.setAttribute("flashType", "success");
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("flashMsg", "Có lỗi xảy ra khi gửi yêu cầu. Vui lòng thử lại.");
                session.setAttribute("flashType", "error");
            }
            resp.sendRedirect(req.getContextPath() + "/account#warranty");
        } else {
            resp.sendRedirect(req.getContextPath() + "/account#warranty");
        }
    }
}
