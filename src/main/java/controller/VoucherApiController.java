package controller;

import com.google.gson.Gson;
import dao.CouponDao;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Coupon;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

@WebServlet("/api/vouchers")
public class VoucherApiController extends HttpServlet {

    private final CouponDao couponDao = new CouponDao();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");

        String productIdStr = req.getParameter("productId");
        int productId = 0;
        if (productIdStr != null && !productIdStr.isEmpty()) {
            try {
                productId = Integer.parseInt(productIdStr);
            } catch (NumberFormatException ignored) {}
        }

        List<Coupon> activeCoupons = couponDao.findAllActive();
        List<Map<String, Object>> result = new ArrayList<>();

        for (Coupon c : activeCoupons) {
            // Check if coupon is for specific products
            List<Integer> productIds = couponDao.getProductIdsByCouponId(c.getId());

            // If coupon has specific products, only include if our product is in the list
            // If coupon has no specific products (applies to all), always include
            if (!productIds.isEmpty() && productId > 0 && !productIds.contains(productId)) {
                continue;
            }

            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", c.getId());
            item.put("code", c.getCode());
            item.put("minOrderValue", c.getMinOrderValue());

            String desc;
            if ("PERCENTAGE".equals(c.getDiscountType())) {
                desc = "Giảm " + c.getDiscountValue().intValue() + "%";
                if (c.getMaxDiscountAmount() != null && c.getMaxDiscountAmount().compareTo(BigDecimal.ZERO) > 0) {
                    desc += " tối đa " + c.getMaxDiscountAmount().intValue() / 1000 + "k";
                }
            } else {
                desc = "Giảm " + c.getDiscountValue().intValue() / 1000 + "k";
            }
            item.put("description", desc);

            result.add(item);
        }

        resp.getWriter().write(gson.toJson(result));
    }
}
