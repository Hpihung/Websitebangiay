package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.CartItem;
import model.user.User;
import services.CartService;
import services.PromotionService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/cart")
public class CartViewController extends HttpServlet {

    private final CartService cartService = new CartService();
    private final PromotionService promotionService = new PromotionService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("currentUser");

        Map<String, CartItem> cart;

        if (user != null) {
            // Luôn reload từ DB để đảm bảo dữ liệu mới nhất
            cart = cartService.loadCartFromDB(user.getId());
            session.setAttribute("cart", cart);
        } else {
            @SuppressWarnings("unchecked")
            Map<String, CartItem> sessionCart =
                    (Map<String, CartItem>) session.getAttribute("cart");
            cart = (sessionCart != null) ? sessionCart : new LinkedHashMap<>();
        }

        BigDecimal subTotal = cartService.calculateTotal(cart);

        request.setAttribute("cartItems", cart.values());
        request.setAttribute("cartSubTotal", promotionService.formatVND(subTotal));
        // cartTotal = subtotal (phí ship tính ở checkout)
        request.setAttribute("cartTotal", promotionService.formatVND(subTotal));

        // Get product IDs that have specific vouchers
        dao.CouponDao couponDao = new dao.CouponDao();
        request.setAttribute("productIdsWithVouchers", couponDao.getProductIdsWithCoupons());

        request.getRequestDispatcher("/carts.jsp").forward(request, response);
    }
}
