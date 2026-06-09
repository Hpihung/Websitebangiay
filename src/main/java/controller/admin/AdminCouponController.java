package controller.admin;

import dao.CouponDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Coupon;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet({ "/admin/coupons", "/admin/coupon/add", "/admin/coupon/edit", "/admin/coupon/delete", "/admin/coupon/save" })
public class AdminCouponController extends HttpServlet {
    private final CouponDao couponDao = new CouponDao();
    private final dao.Product.ProductDao productDao = new dao.Product.ProductDao();
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.endsWith("/admin/coupon/add")) {
            req.setAttribute("allProducts", productDao.findAllActive());
            req.setAttribute("contentPage", "/admin-views/admin-coupon-form.jsp");
            req.setAttribute("active", "admin/coupons");
        } else if (uri.endsWith("/admin/coupon/edit")) {
            int id = Integer.parseInt(req.getParameter("id"));
            couponDao.findById(id).ifPresent(c -> {
                req.setAttribute("coupon", c);
                req.setAttribute("selectedProductIds", couponDao.getProductIdsByCouponId(c.getId()));
            });
            req.setAttribute("allProducts", productDao.findAllActive());
            req.setAttribute("contentPage", "/admin-views/admin-coupon-form.jsp");
            req.setAttribute("active", "admin/coupons");
        } else if (uri.endsWith("/admin/coupon/delete")) {
            int id = Integer.parseInt(req.getParameter("id"));
            couponDao.deleteById(id);
            resp.sendRedirect(req.getContextPath() + "/admin/coupons");
            return;
        } else {
            java.util.List<Coupon> coupons = couponDao.findAll();
            java.util.Map<Integer, Integer> couponProductCounts = new java.util.HashMap<>();
            for (Coupon c : coupons) {
                couponProductCounts.put(c.getId(), couponDao.getProductIdsByCouponId(c.getId()).size());
            }
            req.setAttribute("coupons", coupons);
            req.setAttribute("couponProductCounts", couponProductCounts);
            req.setAttribute("contentPage", "/admin-views/admin-coupons.jsp");
            req.setAttribute("active", "admin/coupons");
        }

        req.getRequestDispatcher("/Admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.endsWith("/admin/coupon/save")) {
            Coupon coupon = new Coupon();
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                coupon.setId(Integer.parseInt(idStr));
            }

            coupon.setCode(req.getParameter("code"));
            coupon.setDiscountType(req.getParameter("discountType"));
            coupon.setDiscountValue(new BigDecimal(req.getParameter("discountValue")));
            
            String minOrder = req.getParameter("minOrderValue");
            coupon.setMinOrderValue(minOrder != null && !minOrder.isEmpty() ? new BigDecimal(minOrder) : BigDecimal.ZERO);
            
            String maxDiscount = req.getParameter("maxDiscountAmount");
            coupon.setMaxDiscountAmount(maxDiscount != null && !maxDiscount.isEmpty() ? new BigDecimal(maxDiscount) : null);
            
            String usageLimit = req.getParameter("usageLimit");
            coupon.setUsageLimit(usageLimit != null && !usageLimit.isEmpty() ? Integer.parseInt(usageLimit) : null);
            
            coupon.setStartDate(LocalDateTime.parse(req.getParameter("startDate"), formatter));
            coupon.setEndDate(LocalDateTime.parse(req.getParameter("endDate"), formatter));
            coupon.setActive(req.getParameter("active") != null);

            String[] productIdsArr = req.getParameterValues("productIds");
            java.util.List<Integer> productIds = null;
            if (productIdsArr != null) {
                productIds = java.util.Arrays.stream(productIdsArr)
                        .map(Integer::parseInt)
                        .toList();
            }

            int couponId;
            if (coupon.getId() > 0) {
                couponDao.update(coupon);
                couponId = coupon.getId();
            } else {
                couponId = couponDao.insert(coupon);
            }
            
            couponDao.setCouponProducts(couponId, productIds);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/coupons");
    }
}
