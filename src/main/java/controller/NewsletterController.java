package controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dao.admin.user.NewsletterDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.user.Newsletter;

import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/newsletter")
public class NewsletterController extends HttpServlet {
    private final NewsletterDao newsletterDao = new NewsletterDao();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        JsonObject jsonResponse = new JsonObject();

        if (email == null || email.trim().isEmpty()) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Vui lòng nhập địa chỉ email.");
            resp.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        email = email.trim();
        // Validate email format
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Định dạng email không hợp lệ.");
            resp.getWriter().write(gson.toJson(jsonResponse));
            return;
        }

        try {
            Newsletter existing = newsletterDao.findByEmail(email);
            if (existing != null) {
                if (existing.isActive()) {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Email này đã đăng ký nhận tin từ trước.");
                } else {
                    existing.setActive(true);
                    existing.setSubscribedAt(LocalDateTime.now());
                    boolean updated = newsletterDao.update(existing);
                    if (updated) {
                        jsonResponse.addProperty("success", true);
                        jsonResponse.addProperty("message", "Đăng ký nhận tin lại thành công!");
                    } else {
                        jsonResponse.addProperty("success", false);
                        jsonResponse.addProperty("message", "Không thể cập nhật đăng ký. Vui lòng thử lại.");
                    }
                }
            } else {
                Newsletter newSub = new Newsletter();
                newSub.setEmail(email);
                newSub.setActive(true);
                newSub.setSubscribedAt(LocalDateTime.now());
                boolean inserted = newsletterDao.insert(newSub);
                if (inserted) {
                    jsonResponse.addProperty("success", true);
                    jsonResponse.addProperty("message", "Đăng ký nhận tin thành công! Cảm ơn bạn.");
                } else {
                    jsonResponse.addProperty("success", false);
                    jsonResponse.addProperty("message", "Không thể lưu đăng ký. Vui lòng thử lại.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.addProperty("success", false);
            jsonResponse.addProperty("message", "Lỗi kết nối cơ sở dữ liệu: " + e.getMessage());
        }

        resp.getWriter().write(gson.toJson(jsonResponse));
    }
}
