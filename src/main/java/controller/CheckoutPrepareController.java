package controller;

import dao.Product.ProductVariantDao;
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
import java.util.Map;

@WebServlet("/pr-checkout")
public class CheckoutPrepareController extends HttpServlet {

    private final ProductVariantDao variantDao = new ProductVariantDao();
    private final CartService cartService = new CartService();
    private final PromotionService promotionService =new PromotionService();


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) {
            req.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("errorMessage");
        }
        String mode = (String) session.getAttribute("checkoutMode");

        User user = (User) session.getAttribute("currentUser");

        if (user != null) {
            req.setAttribute("currentUser", user);
        }

        Map<String, CartItem> checkoutCart;

        if ("BUY_NOW".equals(mode)) {
            checkoutCart = (Map<String, CartItem>) session.getAttribute("checkoutCart");
        } else {
            checkoutCart = (Map<String, CartItem>) session.getAttribute("cart");
        }

        if (checkoutCart == null || checkoutCart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        BigDecimal subTotalR =
                cartService.calculateTotal(checkoutCart);

        BigDecimal shippingFeeR = BigDecimal.ZERO;
        if (user != null && user.getAddress() != null && !user.getAddress().isBlank()) {
            String addressLower = user.getAddress().toLowerCase();
            if (addressLower.contains("hà nội") || addressLower.contains("ha noi")) {
                if (addressLower.contains("hoàng mai") || addressLower.contains("hoang mai")) {
                    shippingFeeR = BigDecimal.valueOf(15000);
                } else {
                    shippingFeeR = BigDecimal.valueOf(30000);
                }
            } else {
                shippingFeeR = BigDecimal.valueOf(50000);
            }
        }
        session.setAttribute("shippingFeeRaw", shippingFeeR);

        BigDecimal discountAmountR = (BigDecimal) session.getAttribute("discountAmount");
        if (discountAmountR == null) discountAmountR = BigDecimal.ZERO;

        BigDecimal grandTotalR =
                subTotalR.add(shippingFeeR).subtract(discountAmountR);

        String subTotal =
                promotionService.formatVND(subTotalR);
        String shippingFee =
                promotionService.formatVND(shippingFeeR);
        String grandTotal =
                promotionService.formatVND(grandTotalR);
        String discountAmountStr = (discountAmountR.compareTo(BigDecimal.ZERO) > 0)
                ? promotionService.formatVND(discountAmountR) : null;


        req.setAttribute("cart", checkoutCart);
        req.setAttribute("subTotal", subTotal);
        req.setAttribute("shippingFee", shippingFee);
        req.setAttribute("grandTotal", grandTotal);
        req.setAttribute("discountAmountStr", discountAmountStr);
        
        req.setAttribute("subTotalRaw", subTotalR);
        req.setAttribute("discountAmountRaw", discountAmountR);
        
        dao.CouponDao couponDao = new dao.CouponDao();
        req.setAttribute("activeCoupons", couponDao.findAllActive());

        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }
}

