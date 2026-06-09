package controller.admin;

import dao.UserDao;
import dao.WishlistDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.user.User;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet({ "/admin/accounts", "/admin/wishlist" })
public class AdminUserController extends HttpServlet {
    private final UserDao userDao = new UserDao();
    private final WishlistDao wishlistDao = new WishlistDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();

        if (uri.endsWith("/admin/wishlist")) {
            // Load wishlist data
            request.setAttribute("wishlists", wishlistDao.findAll());
            request.setAttribute("contentPage", "/admin-wishlist.jsp");
            request.setAttribute("active", "admin/wishlist");
        } else {
            // DELETE BUTTON
            String deleteId = request.getParameter("delete");
            if (deleteId != null) {
                try {
                    userDao.delete(Integer.parseInt(deleteId));
                } catch (NumberFormatException ignored) {
                }
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }

            // EDIT BUTTON (load user into form)
            User user;
            String editId = request.getParameter("user");

            if (editId != null) {
                try {
                    user = userDao.findById(Integer.parseInt(editId));
                    if (user == null) {
                        response.sendRedirect(request.getContextPath() + "/admin/accounts");
                        return;
                    }
                } catch (NumberFormatException ignored) {
                    response.sendRedirect(request.getContextPath() + "/admin/accounts");
                    return;
                }
            } else {
                user = null;
            }

            // load list
            String dateFilter = request.getParameter("date");
            request.setAttribute("user", user);
            
            if (dateFilter != null && !dateFilter.isBlank()) {
                request.setAttribute("users", userDao.findWithFilter(dateFilter));
            } else {
                request.setAttribute("users", userDao.findAll());
            }
            
            request.setAttribute("contentPage", "/admin-views/admin-accounts.jsp");
            request.setAttribute("active", "admin/accounts");
        }
        request.getRequestDispatcher("/Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        if (uri.endsWith("/admin/wishlist")) {
            response.sendRedirect(request.getContextPath() + "/admin/wishlist");
            return;
        }

        // Handle account CRUD
        String id = request.getParameter("id");
        boolean isCreate = (id == null || id.isEmpty());

        User u;
        if (isCreate) {
            u = new User();
            u.setCreatedAt(LocalDateTime.now());
            u.setIsActive(true);
        } else {
            try {
                u = userDao.findById(Integer.parseInt(id));
                if (u == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/accounts");
                    return;
                }
            } catch (NumberFormatException ignored) {
                response.sendRedirect(request.getContextPath() + "/admin/accounts");
                return;
            }
        }

        u.setFullName(request.getParameter("full_name"));
        u.setPhoneNumber(request.getParameter("phone_number"));
        u.setAddress(request.getParameter("address"));
        u.setEmail(request.getParameter("email"));

        u.setIsActive(Boolean.parseBoolean(request.getParameter("is_active")));

        String role = request.getParameter("role");
        if (role != null) {
            role = role.trim().toUpperCase();
        }
        if (!"ADMIN".equals(role) && !"USER".equals(role) && !"SHIPPER".equals(role)) {
            role = "USER";
        }
        u.setRole(role);

        String rawPassword = request.getParameter("password");
        if (rawPassword != null && !rawPassword.isBlank()) {
            u.setPasswordHash(BCrypt.hashpw(rawPassword, BCrypt.gensalt()));
        }

        if (isCreate) {
            userDao.insertUser(u);
        } else {
            userDao.update(u);
        }

        response.sendRedirect(request.getContextPath() + "/admin/accounts");
    }
}
