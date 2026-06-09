package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.user.User;
import services.CartService;
import services.UserServices;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private UserServices userService;
    private CartService  cartService;

    @Override
    public void init() {
        userService = new UserServices();
        cartService = new CartService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        // 1. Validate input
        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            req.setAttribute("error", "Vui lòng nhập email và mật khẩu");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // 2. Kiểm tra tài khoản chưa kích hoạt
        User u = userService.getUserDao().findByEmail(email);
        if (u != null && !u.isActive()) {
            req.setAttribute("error", "Tài khoản chưa được kích hoạt. Vui lòng kiểm tra email hoặc liên hệ admin.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // 3. Xác thực mật khẩu
        User user = userService.loginByEmail(email, password);
        if (user == null) {
            req.setAttribute("error", "Sai email hoặc mật khẩu");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        // 4. Tạo session
        HttpSession session = req.getSession(true);
        session.setAttribute("currentUser", user);
        session.setMaxInactiveInterval(30 * 60);

        // 5. Merge session cart vào DB cart (nếu có hàng chưa login)
        //    Sau đó reload cart từ DB → sync lại session
        cartService.mergeSessionCartToDB(session, user.getId());

        // 6. Redirect
        if ("ADMIN".equalsIgnoreCase(user.getRole())) {
            session.setAttribute("adminId", user.getId());
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else if ("SHIPPER".equalsIgnoreCase(user.getRole())) {
            session.setAttribute("shipperId", user.getId());
            resp.sendRedirect(req.getContextPath() + "/shipper/orders");
        } else {
            resp.sendRedirect(req.getContextPath() + "/menu");
        }
    }
}
