package controller.admin;

import dao.Promotion.PromotionDao;
import dao.Product.ProductDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Promotion.Promotion;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet({ "/admin/promotions", "/admin/promotion/add", "/admin/promotion/edit", "/admin/promotion/delete", "/admin/promotion/save" })
public class AdminPromotionController extends HttpServlet {
    private final PromotionDao promotionDao = new PromotionDao();
    private final ProductDao productDao = new ProductDao();
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.endsWith("/admin/promotion/add")) {
            req.setAttribute("allProducts", productDao.findAllActive());
            req.setAttribute("contentPage", "/admin-views/admin-promotion-form.jsp");
            req.setAttribute("active", "admin/promotions");
        } else if (uri.endsWith("/admin/promotion/edit")) {
            int id = Integer.parseInt(req.getParameter("id"));
            promotionDao.findById(id).ifPresent(p -> {
                req.setAttribute("promotion", p);
                req.setAttribute("selectedProductIds", promotionDao.getProductIdsByPromotionId(p.getId()));
            });
            req.setAttribute("allProducts", productDao.findAllActive());
            req.setAttribute("contentPage", "/admin-views/admin-promotion-form.jsp");
            req.setAttribute("active", "admin/promotions");
        } else if (uri.endsWith("/admin/promotion/delete")) {
            int id = Integer.parseInt(req.getParameter("id"));
            promotionDao.deleteById(id);
            resp.sendRedirect(req.getContextPath() + "/admin/promotions");
            return;
        } else {
            java.util.List<Promotion> promotions = promotionDao.findAll();
            java.util.Map<Integer, Integer> promotionProductCounts = new java.util.HashMap<>();
            for (Promotion p : promotions) {
                promotionProductCounts.put(p.getId(), promotionDao.getProductIdsByPromotionId(p.getId()).size());
            }
            
            // Calculate stats
            int totalPromotions = promotions.size();
            long activePromotions = promotions.stream().filter(p -> p.isActive() && (p.getStartDate() == null || p.getStartDate().isBefore(LocalDateTime.now())) && (p.getEndDate() == null || p.getEndDate().isAfter(LocalDateTime.now()))).count();
            long upcomingPromotions = promotions.stream().filter(p -> p.isActive() && p.getStartDate() != null && p.getStartDate().isAfter(LocalDateTime.now())).count();
            long endedPromotions = promotions.stream().filter(p -> !p.isActive() || (p.getEndDate() != null && p.getEndDate().isBefore(LocalDateTime.now()))).count();
            
            req.setAttribute("promotions", promotions);
            req.setAttribute("promotionProductCounts", promotionProductCounts);
            req.setAttribute("totalPromotions", totalPromotions);
            req.setAttribute("activePromotions", activePromotions);
            req.setAttribute("upcomingPromotions", upcomingPromotions);
            req.setAttribute("endedPromotions", endedPromotions);
            req.setAttribute("allProducts", productDao.findAllActive());
            
            req.setAttribute("contentPage", "/admin-views/admin-promotions.jsp");
            req.setAttribute("active", "admin/promotions");
        }

        req.getRequestDispatcher("/Admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        if (uri.endsWith("/admin/promotion/save")) {
            Promotion promotion = new Promotion();
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                promotion.setId(Integer.parseInt(idStr));
            }

            promotion.setName(req.getParameter("name"));
            promotion.setSlug(req.getParameter("slug"));
            promotion.setDiscountType(req.getParameter("discountType"));
            promotion.setDiscountValue(new BigDecimal(req.getParameter("discountValue")));
            
            String startDateStr = req.getParameter("startDate");
            if (startDateStr != null && !startDateStr.isEmpty()) {
                promotion.setStartDate(LocalDateTime.parse(startDateStr, formatter));
            }
            
            String endDateStr = req.getParameter("endDate");
            if (endDateStr != null && !endDateStr.isEmpty()) {
                promotion.setEndDate(LocalDateTime.parse(endDateStr, formatter));
            }
            
            promotion.setActive(req.getParameter("active") != null);
            promotion.setFlashSale(req.getParameter("isFlashSale") != null || req.getParameter("is_flash_sale") != null);

            String[] productIdsArr = req.getParameterValues("productIds");
            java.util.List<Integer> productIds = null;
            if (productIdsArr != null) {
                productIds = java.util.Arrays.stream(productIdsArr)
                        .map(Integer::parseInt)
                        .toList();
            }

            int promotionId;
            if (promotion.getId() > 0) {
                promotionDao.update(promotion);
                promotionId = promotion.getId();
            } else {
                promotionId = promotionDao.insert(promotion);
            }
            
            promotionDao.setPromotionProducts(promotionId, productIds);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/promotions");
    }
}
