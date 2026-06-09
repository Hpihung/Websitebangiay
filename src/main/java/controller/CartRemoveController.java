package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import services.CartService;

import java.io.IOException;

@WebServlet("/cart/remove")
public class CartRemoveController extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession();
        String key = req.getParameter("key");

        if (key != null) {
            // CartService tự xóa DB nếu user đã login
            cartService.removeFromCart(session, key);
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}
