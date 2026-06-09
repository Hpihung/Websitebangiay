package controller;

import dao.Order.OrderDao;
import dao.Order.OrderDetailDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order.Order;
import utils.vnpay.VNPayConfig;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/vnpay_return")
public class VNPayReturnController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements();) {
            String rawName = params.nextElement();
            String fieldName = URLEncoder.encode(rawName, StandardCharsets.US_ASCII.toString());
            String rawValue = req.getParameter(rawName);
            if (rawValue != null && !rawValue.isEmpty()) {
                String fieldValue = URLEncoder.encode(rawValue, StandardCharsets.US_ASCII.toString());
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = req.getParameter("vnp_SecureHash");
        if (fields.containsKey("vnp_SecureHashType")) {
            fields.remove("vnp_SecureHashType");
        }
        if (fields.containsKey("vnp_SecureHash")) {
            fields.remove("vnp_SecureHash");
        }

        String signValue = VNPayConfig.hashAllFields(fields);

        String vnp_TxnRef = req.getParameter("vnp_TxnRef");
        int orderId = -1;
        try {
            if (vnp_TxnRef != null && vnp_TxnRef.contains("_")) {
                orderId = Integer.parseInt(vnp_TxnRef.split("_")[0]);
            }
        } catch (NumberFormatException e) {
            // log error
        }

        if (signValue.equals(vnp_SecureHash)) {
            if ("00".equals(req.getParameter("vnp_TransactionStatus"))) {
                if (orderId != -1) {
                    orderDao.updatePaymentStatus(orderId, "PAID");
                    req.getSession().setAttribute("allowedOrderId", orderId);
                }
                resp.sendRedirect(req.getContextPath() + "/order-success?orderId=" + orderId);
            } else {
                if (orderId != -1) {
                    orderDao.updatePaymentStatus(orderId, "CANCELLED"); // Hoặc có thể giữ là UNPAID
                }
                req.setAttribute("errorMessage", "Thanh toán thất bại hoặc đã bị hủy.");
                req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
            }
        } else {
            req.setAttribute("errorMessage", "Chữ ký không hợp lệ, phát hiện can thiệp dữ liệu!");
            req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
        }
    }
}
