package controller.admin;

import dao.BannerDao;
import dao.CouponDao;
import dao.JDBIConnector;
import dao.admin.user.CollectionDao;
import dao.admin.user.NewsletterDao;
import dao.admin.user.NewsletterScheduleDao;
import DTO.ProductDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Banner;
import model.Coupon;
import model.Collection.Collection;
import model.user.Newsletter;
import model.user.NewsletterSchedule;
import services.EmailServices;
import services.ProductService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet({ "/admin/banners", "/admin/collections", "/admin/newsletter" })
public class AdminMarketingController extends HttpServlet {
    private final BannerDao bannerDao = new BannerDao();
    private final CollectionDao collectionDao = new CollectionDao();
    private final NewsletterDao newsletterDao = new NewsletterDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();

        if (uri.endsWith("/admin/collections")) {
            String name = request.getParameter("name");
            String ruleSet = request.getParameter("ruleSet");

            List<Collection> collections = (name != null || ruleSet != null)
                    ? collectionDao.filter(name, ruleSet)
                    : collectionDao.findAll();

            String editId = request.getParameter("edit");
            Collection collection;
            if (editId != null) {
                collection = collectionDao.findById(Integer.parseInt(editId));
            } else {
                collection = new Collection();
                collection.setActive(true);
            }

            request.setAttribute("collection", collection);
            request.setAttribute("collections", collections);
            request.setAttribute("contentPage", "/admin-views/admin-collections.jsp");
            request.setAttribute("active", "admin/collections");

        } else if (uri.endsWith("/admin/newsletter")) {
            ensureScheduleTableExists();

            String email = request.getParameter("email");
            String status = request.getParameter("status");

            List<Newsletter> newsletters = (email != null || status != null)
                    ? newsletterDao.filter(email, status)
                    : newsletterDao.findAll();

            ProductService productService = new ProductService();
            CouponDao couponDao = new CouponDao();
            NewsletterScheduleDao scheduleDao = new NewsletterScheduleDao();

            List<ProductDTO> promoProducts = productService.findTopCheapestProductsInPromotion(3);
            List<ProductDTO> newProducts = productService.getNewestProducts(4);
            List<ProductDTO> allActiveProducts = productService.getProductsForNewsletter();
            List<Coupon> activeCoupons = couponDao.findAllActive();
            List<NewsletterSchedule> schedules = scheduleDao.findAll();

            request.setAttribute("newsletters", newsletters);
            request.setAttribute("promoProducts", promoProducts);
            request.setAttribute("newProducts", newProducts);
            request.setAttribute("allActiveProducts", allActiveProducts);
            request.setAttribute("activeCoupons", activeCoupons);
            request.setAttribute("schedules", schedules);
            request.setAttribute("contentPage", "/admin-views/admin-newsletter.jsp");
            request.setAttribute("active", "admin/newsletter");

        } else {
            List<Banner> banners = bannerDao.findAll();

            String editId = request.getParameter("edit");
            Banner banner;

            if (editId != null) {
                banner = bannerDao.findById(Integer.parseInt(editId));
            } else {
                banner = new Banner();
                banner.setActive(true);
            }

            request.setAttribute("banner", banner);
            request.setAttribute("banners", banners);
            request.setAttribute("contentPage", "/admin-views/admin-banners.jsp");
            request.setAttribute("active", "admin/banners");
        }
        request.getRequestDispatcher("/Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        if (uri.endsWith("/admin/collections")) {
            // DELETE
            String deleteId = request.getParameter("deleteId");
            if (deleteId != null && !deleteId.isBlank()) {
                collectionDao.delete(Integer.parseInt(deleteId));
                response.sendRedirect(request.getContextPath() + "/admin/collections");
                return;
            }

            // INSERT / UPDATE
            String idParam = request.getParameter("id");
            String name = request.getParameter("name");
            String slug = request.getParameter("slug");
            String ruleSet = request.getParameter("ruleSet");
            boolean active = request.getParameter("active") != null; // checkbox

            Collection collection = new Collection();
            if (idParam != null && !idParam.isBlank() && !"0".equals(idParam)) {
                collection = collectionDao.findById(Integer.parseInt(idParam));
            }

            if (collection != null) {
                collection.setName(name);
                collection.setSlug(slug);
                collection.setRuleSetType(ruleSet);
                collection.setActive(active);

                if (collection.getId() > 0) {
                    collectionDao.update(collection);
                } else {
                    collectionDao.insert(collection);
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/collections");

        } else if (uri.endsWith("/admin/newsletter")) {
            String scheduleAction = request.getParameter("scheduleAction");
            if ("save".equals(scheduleAction)) {
                String sId = request.getParameter("scheduleId");
                String sName = request.getParameter("scheduleName");
                String sTime = request.getParameter("scheduleTime");
                String sStatus = request.getParameter("scheduleStatus");

                NewsletterSchedule schedule = new NewsletterSchedule();
                if (sId != null && !sId.isBlank() && !"0".equals(sId)) {
                    schedule.setId(Integer.parseInt(sId));
                }
                schedule.setName(sName);
                schedule.setScheduledAt(sTime);
                schedule.setStatus(sStatus);

                NewsletterScheduleDao scheduleDao = new NewsletterScheduleDao();
                if (schedule.getId() > 0) {
                    scheduleDao.update(schedule);
                } else {
                    scheduleDao.insert(schedule);
                }
                response.sendRedirect(request.getContextPath() + "/admin/newsletter");
                return;
            } else if ("delete".equals(scheduleAction)) {
                String sId = request.getParameter("scheduleId");
                if (sId != null && !sId.isBlank()) {
                    NewsletterScheduleDao scheduleDao = new NewsletterScheduleDao();
                    scheduleDao.delete(Integer.parseInt(sId));
                }
                response.sendRedirect(request.getContextPath() + "/admin/newsletter");
                return;
            }

            String deleteId = request.getParameter("deleteId");
            String toggleId = request.getParameter("toggleId");
            String sendNews = request.getParameter("sendNews");

            if (deleteId != null && !deleteId.isBlank()) {
                newsletterDao.delete(Integer.parseInt(deleteId));
            } else if (toggleId != null && !toggleId.isBlank()) {
                newsletterDao.toggleActive(Integer.parseInt(toggleId));
            } else if (sendNews != null && !sendNews.isBlank()) {
                String subject = request.getParameter("subject");
                String content = request.getParameter("content");
                if (subject != null && !subject.isBlank() && content != null && !content.isBlank()) {
                    List<Newsletter> activeSubscribers = newsletterDao.filter(null, "active");
                    // Convert relative image src to absolute so email looks like preview
                    String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
                    String absoluteContent = content.replaceAll("src=\"/", "src=\"" + baseUrl + "/");
                    new Thread(() -> {
                        EmailServices emailServices = new EmailServices();
                        for (Newsletter sub : activeSubscribers) {
                            if (sub.isActive()) {
                                emailServices.seend(sub.getEmail(), subject, absoluteContent);
                            }
                        }
                    }).start();
                    if ("true".equals(request.getParameter("ajax"))) {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        response.getWriter().write("{\"success\":true, \"message\":\"Bản tin đang được gửi tới " + activeSubscribers.size() + " người đăng ký trong tiến trình chạy ngầm!\"}");
                        return;
                    }
                    HttpSession session = request.getSession();
                    session.setAttribute("successMessage", "Đang tiến hành gửi bản tin cho " + activeSubscribers.size() + " người đăng ký trong tiến trình chạy ngầm!");
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/newsletter");
        } else {
            // DELETE
            String deleteId = request.getParameter("delete");
            if (deleteId != null) {
                bannerDao.delete(Integer.parseInt(deleteId));
                response.sendRedirect(request.getContextPath() + "/admin/banners");
                return;
            }
            // ADD / UPDATE
            Banner banner = new Banner();

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                banner.setId(Integer.parseInt(idParam));
            }

            banner.setTitle(request.getParameter("title"));
            banner.setImgUrl(request.getParameter("imgUrl"));
            banner.setLinkUrl(request.getParameter("linkUrl"));
            banner.setPosition(request.getParameter("position"));
            banner.setSortOrder(Integer.parseInt(request.getParameter("sortOrder")));
            banner.setActive(Boolean.parseBoolean(request.getParameter("active")));

            String start = request.getParameter("startDate");
            String end = request.getParameter("endDate");

            if (start != null && !start.isEmpty()) {
                banner.setStartDate(LocalDateTime.parse(start));
            }
            if (end != null && !end.isEmpty()) {
                banner.setEndDate(LocalDateTime.parse(end));
            }

            if (banner.getId() > 0) {
                bannerDao.update(banner);
            } else {
                bannerDao.insert(banner);
            }
             response.sendRedirect(request.getContextPath() + "/admin/banners");
        }
    }

    private void ensureScheduleTableExists() {
        JDBIConnector.getJdbi().useHandle(handle -> {
            handle.execute("""
                CREATE TABLE IF NOT EXISTS newsletter_schedules (
                    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(255) NOT NULL,
                    scheduled_at VARCHAR(100) NOT NULL,
                    status VARCHAR(50) NOT NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                ) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci;
            """);

            Integer count = handle.createQuery("SELECT COUNT(*) FROM newsletter_schedules").mapTo(Integer.class).one();
            if (count == 0) {
                handle.execute("INSERT INTO newsletter_schedules (name, scheduled_at, status) VALUES ('Flash Sale Tháng 6', '15/06 - 09:00 SA', 'PENDING')");
                handle.execute("INSERT INTO newsletter_schedules (name, scheduled_at, status) VALUES ('Summer Collection', '22/06 - 07:00 SA', 'DRAFT')");
                handle.execute("INSERT INTO newsletter_schedules (name, scheduled_at, status) VALUES ('Nhắc nhở giỏ hàng', 'Hàng ngày - 10:00 SA', 'AUTO')");
                handle.execute("INSERT INTO newsletter_schedules (name, scheduled_at, status) VALUES ('Ưu Đãi Thành Viên', '01/07 - 08:00 SA', 'SCHEDULED')");
            }
        });
    }
}
