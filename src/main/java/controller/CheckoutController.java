package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.CartItem;
import model.user.User;
import services.CheckoutService;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;

import utils.vnpay.VNPayConfig;
import services.CartService;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private final CheckoutService checkoutService = new CheckoutService();
    private final CartService     cartService     = new CartService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String mode = (String) session.getAttribute("checkoutMode");
        @SuppressWarnings("unchecked")
        Map<String, CartItem> cart;

        if ("BUY_NOW".equals(mode)) {
            cart = (Map<String, CartItem>) session.getAttribute("checkoutCart");
        } else {
            cart = (Map<String, CartItem>) session.getAttribute("cart");
        }

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String address = req.getParameter("address");
        BigDecimal shippingFee = BigDecimal.valueOf(50000);
        if (address != null) {
            String addressLower = address.toLowerCase();
            if (addressLower.contains("hà nội") || addressLower.contains("ha noi")) {
                if (addressLower.contains("hoàng mai") || addressLower.contains("hoang mai")) {
                    shippingFee = BigDecimal.valueOf(15000);
                } else {
                    shippingFee = BigDecimal.valueOf(30000);
                }
            }
        }

        model.Coupon appliedCoupon = (model.Coupon) session.getAttribute("appliedCoupon");
        BigDecimal discountAmount = (BigDecimal) session.getAttribute("discountAmount");
        if (discountAmount == null) discountAmount = BigDecimal.ZERO;

        String paymentMethod = req.getParameter("paymentMethod");
        if (paymentMethod == null) paymentMethod = "COD";

        try {
            Integer couponId = (appliedCoupon != null) ? appliedCoupon.getId() : null;
            int orderId = checkoutService.placeOrder(user.getId(), cart, shippingFee, couponId, discountAmount);

            // Cập nhật các trường thông tin bổ sung (vì CheckoutService cũ không có)
            String phone = req.getParameter("phone");
            String note = req.getParameter("note");
            final String finalPaymentMethod = paymentMethod;
            dao.JDBIConnector.getJdbi().useHandle(handle -> {
                handle.createUpdate("UPDATE orders SET payment_method = :pm, shipping_address = :addr, phone_number = :phone, order_note = :note WHERE id = :oid")
                        .bind("pm", finalPaymentMethod)
                        .bind("addr", address)
                        .bind("phone", phone)
                        .bind("note", note)
                        .bind("oid", orderId)
                        .execute();
            });

            // Xóa session sau checkout
            if ("BUY_NOW".equals(mode)) {
                session.removeAttribute("checkoutCart");
                session.removeAttribute("checkoutMode");
            } else {
                session.removeAttribute("cart");
            }
            session.removeAttribute("shippingFeeRaw");
            session.removeAttribute("appliedCoupon");
            session.removeAttribute("discountAmount");

            // Đồng bộ lại giỏ hàng trong session từ DB
            if (user != null) {
                Map<String, CartItem> dbCart = cartService.loadCartFromDB(user.getId());
                session.setAttribute("cart", dbCart);
            }

            if ("VNPAY".equals(paymentMethod)) {
                long amountInVND = cartService.calculateTotal(cart).add(shippingFee).longValue();
                long amount = amountInVND * 100;
                String vnp_TxnRef = orderId + "_" + VNPayConfig.getRandomNumber(4);

                Map<String, String> vnp_Params = new HashMap<>();
                vnp_Params.put("vnp_Version",   VNPayConfig.vnp_Version);
                vnp_Params.put("vnp_Command",   VNPayConfig.vnp_Command);
                vnp_Params.put("vnp_TmnCode",   VNPayConfig.vnp_TmnCode);
                vnp_Params.put("vnp_Amount",    String.valueOf(amount));
                vnp_Params.put("vnp_CurrCode",  "VND");
                vnp_Params.put("vnp_TxnRef",    vnp_TxnRef);
                vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang:" + orderId);
                vnp_Params.put("vnp_OrderType", "other");
                vnp_Params.put("vnp_Locale",    "vn");

                String baseUrl = req.getScheme() + "://" + req.getServerName()
                        + ":" + req.getServerPort() + req.getContextPath();
                vnp_Params.put("vnp_ReturnUrl", baseUrl + "/vnpay_return");
                vnp_Params.put("vnp_IpAddr",    VNPayConfig.getIpAddress(req));

                Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
                SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
                String vnp_CreateDate = formatter.format(cld.getTime());
                vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
                cld.add(Calendar.MINUTE, 15);
                vnp_Params.put("vnp_ExpireDate", formatter.format(cld.getTime()));

                java.util.List<String> fieldNames = new java.util.ArrayList<>(vnp_Params.keySet());
                java.util.Collections.sort(fieldNames);
                StringBuilder hashData = new StringBuilder();
                StringBuilder query    = new StringBuilder();
                java.util.Iterator<String> itr = fieldNames.iterator();
                while (itr.hasNext()) {
                    String fieldName  = itr.next();
                    String fieldValue = vnp_Params.get(fieldName);
                    if (fieldValue != null && fieldValue.length() > 0) {
                        hashData.append(fieldName).append('=')
                                .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                        query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()))
                                .append('=')
                                .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                        if (itr.hasNext()) { query.append('&'); hashData.append('&'); }
                    }
                }
                String queryUrl       = query.toString();
                String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
                queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
                String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + queryUrl;

                resp.sendRedirect(paymentUrl);
                return;
            }

            session.setAttribute("lastOrderId", orderId);
            resp.sendRedirect(req.getContextPath() + "/order-success?orderId=" + orderId);

        } catch (RuntimeException e) {
            session.setAttribute("errorMessage", e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/pr-checkout");
        }
    }
}
