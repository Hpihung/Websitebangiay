package controller.admin;

import dao.ReviewDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.user.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/reviews")
public class AdminReviewController extends HttpServlet {

    private final ReviewDao reviewDao = new ReviewDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword = req.getParameter("q");
        String starParam = req.getParameter("star");
        String statusFilter = req.getParameter("status");

        Integer star = null;
        try {
            if (starParam != null && !starParam.isBlank()) star = Integer.parseInt(starParam);
        } catch (NumberFormatException ignored) {}

        List<model.Review> reviews = reviewDao.getAllReviewsForAdmin(keyword, star, star, statusFilter);
        java.util.Map<String, Object> stats = reviewDao.getStats();

        req.setAttribute("reviews", reviews);
        req.setAttribute("stats", stats);
        req.setAttribute("keyword", keyword);
        req.setAttribute("starFilter", star);
        req.setAttribute("statusFilter", statusFilter);
        req.setAttribute("contentPage", "/admin-views/admin-reviews.jsp");
        req.setAttribute("active", "admin/reviews");

        req.getRequestDispatcher("/Admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        String idParam = req.getParameter("reviewId");
        if (idParam == null || idParam.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/admin/reviews");
            return;
        }

        int reviewId = Integer.parseInt(idParam);

        switch (action != null ? action : "") {
            case "hide":
                reviewDao.updateStatus(reviewId, "HIDDEN");
                break;
            case "show":
                reviewDao.updateStatus(reviewId, "VISIBLE");
                break;
            case "delete":
                reviewDao.deleteReview(reviewId);
                break;
            case "reply":
                String content = req.getParameter("replyContent");
                User admin = (User) req.getSession().getAttribute("adminUser");
                int adminId = admin != null ? admin.getId() : 0;
                if (content != null && !content.trim().isEmpty()) {
                    reviewDao.addAdminReply(reviewId, adminId, content.trim());
                }
                break;
            default:
                break;
        }

        // Preserve filters on redirect
        String q = req.getParameter("q");
        String star = req.getParameter("star");
        String status = req.getParameter("statusFilter");
        StringBuilder redirect = new StringBuilder(req.getContextPath() + "/admin/reviews?");
        if (q != null && !q.isBlank()) redirect.append("q=").append(java.net.URLEncoder.encode(q, "UTF-8")).append("&");
        if (star != null && !star.isBlank()) redirect.append("star=").append(star).append("&");
        if (status != null && !status.isBlank()) redirect.append("status=").append(status);

        resp.sendRedirect(redirect.toString());
    }
}
