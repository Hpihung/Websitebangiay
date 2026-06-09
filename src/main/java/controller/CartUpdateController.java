package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.CartService;

import java.io.IOException;

@WebServlet("/cart/update")
public class CartUpdateController extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession();
        String key    = req.getParameter("key");
        String action = req.getParameter("action");

        if (key == null || action == null) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // CartService tự sync DB nếu user đã login
        cartService.updateQuantity(session, key, action);

        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
