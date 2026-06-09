package controller.admin;

import dao.UserDao;
import dao.Order.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import services.admin.AdminService;
import services.admin.SettingService;
import dao.admin.AdminStatsDao;
import java.io.IOException;

@WebServlet({ "/admin/dashboard", "/admin/statistics", "/admin/setting" })
public class AdminDashboardController extends HttpServlet {
    private final UserDao userDao = new UserDao();
    private final OrderDao orderDao = new OrderDao();
    private final SettingService settingService = new SettingService();
    private final AdminService adminService = new AdminService();
    private final AdminStatsDao adminStatsDao = new AdminStatsDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();

        if (request.getRequestURI().contains("/admin/statistics")) {
            // Lấy năm mới nhất có dữ liệu, nếu không có thì lấy năm hiện tại
            int latestYear = adminStatsDao.getLatestOrderYear();
            String yearStr = request.getParameter("year");
            int year = latestYear;
            if (yearStr != null && !yearStr.isEmpty()) {
                try {
                    year = Integer.parseInt(yearStr);
                } catch (NumberFormatException e) {
                    year = latestYear;
                }
            }
            request.setAttribute("latestYear", latestYear);
            request.setAttribute("selectedYear", year);

            request.setAttribute("totalUsers", adminStatsDao.getTotalUsers(year, null));
            request.setAttribute("totalOrders", adminStatsDao.getTotalOrders(year, null));
            request.setAttribute("totalRevenue", adminStatsDao.getTotalRevenue(year, null));
            
            // Lấy dữ liệu cho biểu đồ và bảng (đã lọc theo năm)
            request.setAttribute("topProducts", adminStatsDao.getTop10Products(year, null));
            request.setAttribute("topCustomers", adminStatsDao.getTop5Customers(year, null));
            request.setAttribute("topStaff", adminStatsDao.getTopStaff());
            request.setAttribute("monthlyRevenue", adminStatsDao.getMonthlyRevenue(year));

            request.setAttribute("contentPage", "/admin-views/admin-statistics.jsp");
            request.setAttribute("active", "admin/statistics");

        } else if (request.getRequestURI().contains("/admin/setting")) {
            Integer adminId = (Integer) request.getSession().getAttribute("adminId");

            request.setAttribute("siteName", settingService.settingGet("site_name"));
            request.setAttribute("siteEmail", settingService.settingGet("site_email"));
            request.setAttribute("sitePhone", settingService.settingGet("site_phone"));
            request.setAttribute("siteAddress", settingService.settingGet("site_address"));

            request.setAttribute("newOrders", "true".equalsIgnoreCase(settingService.settingGet("notify_new_orders")));
            request.setAttribute("newSletterSignup",
                    Boolean.parseBoolean(settingService.settingGet("notify_newsletter")));

            request.setAttribute("adminUsername", adminService.adminGetUserName(adminId));

            request.setAttribute("contentPage", "/admin-setting.jsp");
            request.setAttribute("active", "admin/setting");
        } else {
            // Dashboard Overview
            request.setAttribute("todayOrders", orderDao.todayOrders());
            request.setAttribute("todayRevenue", orderDao.todayRevenue());
            request.setAttribute("newCustomers", userDao.todayCustomers());
            request.setAttribute("pendingCodCount", orderDao.findWithFilter(null, null, "PENDING_COD", null).size());
            
            int latestYear = adminStatsDao.getLatestOrderYear();
            String yearStr = request.getParameter("year");
            String monthStr = request.getParameter("month");
            int year = latestYear;
            Integer month = null;

            if (yearStr != null && !yearStr.isEmpty()) {
                try {
                    year = Integer.parseInt(yearStr);
                } catch (NumberFormatException e) {
                    year = latestYear;
                }
            }
            if (monthStr != null && !monthStr.isEmpty()) {
                try {
                    month = Integer.parseInt(monthStr);
                    if (month < 1 || month > 12) month = null;
                } catch (NumberFormatException e) {
                    month = null;
                }
            }

            request.setAttribute("latestYear", latestYear);
            request.setAttribute("selectedYear", year);
            request.setAttribute("selectedMonth", month);

            request.setAttribute("totalUsers", adminStatsDao.getTotalUsers(year, month));
            request.setAttribute("totalOrders", adminStatsDao.getTotalOrders(year, month));
            request.setAttribute("totalRevenue", adminStatsDao.getTotalRevenue(year, month));
            
            request.setAttribute("topProducts", adminStatsDao.getTop10Products(year, month));
            request.setAttribute("topCustomers", adminStatsDao.getTop5Customers(year, month));
            request.setAttribute("topStaff", adminStatsDao.getTopStaff());
            request.setAttribute("monthlyRevenue", adminStatsDao.getMonthlyRevenue(year));

            request.setAttribute("contentPage", "/admin-views/admin-dashboard.jsp");
            request.setAttribute("active", "admin/dashboard");
        }

        request.getRequestDispatcher("/Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        if (request.getRequestURI().contains("/admin/setting")) {
            String action = request.getParameter("action");

            if ("site".equals(action)) {
                settingService.settingSave("site_name", request.getParameter("siteName"));
                settingService.settingSave("site_email", request.getParameter("siteEmail"));
                settingService.settingSave("site_phone", request.getParameter("sitePhone"));
                settingService.settingSave("site_address", request.getParameter("siteAddress"));

            } else if ("notification".equals(action)) {
                settingService.settingSave("notify_new_orders",
                        String.valueOf(request.getParameter("newOrders") != null));
                settingService.settingSave("notify_newsletter",
                        String.valueOf(request.getParameter("newSletterSignup") != null));

            } else if ("account".equals(action)) {
                int adminId = (int) request.getSession().getAttribute("adminId");
                adminService.adminUpdateUserName(adminId, request.getParameter("adminUserName"));

                String adminPassword = request.getParameter("adminPassword");
                if (adminPassword != null && !adminPassword.isBlank()) {
                    adminService.adminUpdatePassword(adminId, adminPassword);
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/setting");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}
