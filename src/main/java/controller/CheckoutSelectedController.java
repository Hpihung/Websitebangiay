package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.user.CartItem;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/checkout-selected")
public class CheckoutSelectedController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();

        @SuppressWarnings("unchecked")
        Map<String, CartItem> fullCart = (Map<String, CartItem>) session.getAttribute("cart");

        String[] selectedKeys = req.getParameterValues("selectedKeys");

        if (fullCart == null || selectedKeys == null || selectedKeys.length == 0) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Build a sub-cart with only the selected items
        Map<String, CartItem> checkoutCart = new LinkedHashMap<>();
        for (String key : selectedKeys) {
            CartItem item = fullCart.get(key);
            if (item != null) {
                checkoutCart.put(key, item);
            }
        }

        if (checkoutCart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        session.setAttribute("checkoutCart", checkoutCart);
        session.setAttribute("checkoutMode", "BUY_NOW");
        resp.sendRedirect(req.getContextPath() + "/pr-checkout");
    }
}
