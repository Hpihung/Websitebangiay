package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.CartItem;
import services.CartService;
import services.CouponService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.Map;

@WebServlet("/coupon/apply")
public class CouponController extends HttpServlet {
    private final CouponService couponService = new CouponService();
    private final CartService cartService = new CartService();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String code = req.getParameter("code");
        HttpSession session = req.getSession();

        String mode = (String) session.getAttribute("checkoutMode");
        @SuppressWarnings("unchecked")
        Map<String, CartItem> cart;

        if ("BUY_NOW".equals(mode)) {
            cart = (Map<String, CartItem>) session.getAttribute("checkoutCart");
        } else {
            cart = (Map<String, CartItem>) session.getAttribute("cart");
        }

        if (cart == null || cart.isEmpty()) {
            sendError(resp, "Giỏ hàng trống.");
            return;
        }

        CouponService.CouponResult result = couponService.applyCoupon(code, cart);

        JsonObject jsonResponse = new JsonObject();
        if (result.isSuccess()) {
            jsonResponse.addProperty("success", true);
            jsonResponse.addProperty("message", result.getMessage());
            jsonResponse.addProperty("discountAmount", result.getDiscountAmount());

            BigDecimal subTotal = cartService.calculateTotal(cart);
            jsonResponse.addProperty("newTotal", subTotal.subtract(result.getDiscountAmount()));

            // Lưu vào session để dùng khi checkout
            session.setAttribute("appliedCoupon", result.getCoupon());
            session.setAttribute("discountAmount", result.getDiscountAmount());
        } else {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", result.getMessage());
        }

        resp.getWriter().write(gson.toJson(jsonResponse));
    }

    private void sendError(HttpServletResponse resp, String message) throws IOException {
        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("success", false);
        jsonResponse.addProperty("message", message);
        resp.getWriter().write(gson.toJson(jsonResponse));
    }
}
