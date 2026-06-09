package services;

import dao.CouponDao;
import model.Coupon;

import java.math.BigDecimal;
import java.util.Optional;

public class CouponService {
    private final CouponDao couponDao = new CouponDao();

    public CouponResult applyCoupon(String code, java.util.Map<String, model.user.CartItem> cart) {
        Optional<Coupon> couponOpt = couponDao.findByCode(code);

        if (couponOpt.isEmpty()) {
            return CouponResult.error("Mã giảm giá không tồn tại hoặc đã bị vô hiệu hóa.");
        }

        Coupon coupon = couponOpt.get();

        if (!coupon.isStarted()) {
            return CouponResult.error("Chương trình giảm giá chưa bắt đầu.");
        }

        if (coupon.isExpired()) {
            return CouponResult.error("Mã giảm giá đã hết hạn.");
        }

        if (!coupon.hasRemainingUsage()) {
            return CouponResult.error("Mã giảm giá đã hết lượt sử dụng.");
        }

        java.util.List<Integer> restrictedProductIds = couponDao.getProductIdsByCouponId(coupon.getId());
        BigDecimal applicableTotal = BigDecimal.ZERO;
        boolean hasApplicableProduct = false;

        for (model.user.CartItem item : cart.values()) {
            if (restrictedProductIds.isEmpty() || restrictedProductIds.contains(item.getProductId())) {
                BigDecimal price = parsePrice(item.getFinalPrice());
                applicableTotal = applicableTotal.add(price.multiply(new BigDecimal(item.getQuantity())));
                hasApplicableProduct = true;
            }
        }

        if (!hasApplicableProduct) {
            return CouponResult.error("Mã giảm giá này không áp dụng cho các sản phẩm trong giỏ hàng của bạn.");
        }

        BigDecimal totalOrderValue = BigDecimal.ZERO;
        for (model.user.CartItem item : cart.values()) {
            totalOrderValue = totalOrderValue.add(parsePrice(item.getFinalPrice()).multiply(new BigDecimal(item.getQuantity())));
        }

        if (totalOrderValue.compareTo(coupon.getMinOrderValue()) < 0) {
            return CouponResult.error("Đơn hàng tối thiểu " + coupon.getMinOrderValue() + "₫ để áp dụng mã này.");
        }

        BigDecimal discountAmount = calculateDiscount(coupon, applicableTotal);
        return CouponResult.success(coupon, discountAmount);
    }

    private BigDecimal parsePrice(String priceStr) {
        try {
            // Remove non-digit characters except for maybe a decimal point if it exists
            String clean = priceStr.replaceAll("[^\\d]", "");
            return new BigDecimal(clean);
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    public CouponResult applyCoupon(String code, BigDecimal orderValue) {
        // Fallback or old method
        Optional<Coupon> couponOpt = couponDao.findByCode(code);
        if (couponOpt.isEmpty()) return CouponResult.error("Mã giảm giá không tồn tại.");
        Coupon coupon = couponOpt.get();
        
        // Basic checks... (keeping for compatibility if needed, but better to use the cart version)
        if (orderValue.compareTo(coupon.getMinOrderValue()) < 0) {
            return CouponResult.error("Đơn hàng tối thiểu " + coupon.getMinOrderValue() + "₫ để áp dụng mã này.");
        }
        return CouponResult.success(coupon, calculateDiscount(coupon, orderValue));
    }

    private BigDecimal calculateDiscount(Coupon coupon, BigDecimal orderValue) {
        BigDecimal discount;
        if ("PERCENTAGE".equals(coupon.getDiscountType())) {
            discount = orderValue.multiply(coupon.getDiscountValue().divide(new BigDecimal(100)));
            if (coupon.getMaxDiscountAmount() != null && discount.compareTo(coupon.getMaxDiscountAmount()) > 0) {
                discount = coupon.getMaxDiscountAmount();
            }
        } else {
            discount = coupon.getDiscountValue();
        }
        
        // Đảm bảo giảm giá không vượt quá giá trị đơn hàng
        if (discount.compareTo(orderValue) > 0) {
            discount = orderValue;
        }
        
        return discount;
    }

    public static class CouponResult {
        private boolean success;
        private String message;
        private Coupon coupon;
        private BigDecimal discountAmount;

        public static CouponResult error(String message) {
            CouponResult res = new CouponResult();
            res.success = false;
            res.message = message;
            return res;
        }

        public static CouponResult success(Coupon coupon, BigDecimal discountAmount) {
            CouponResult res = new CouponResult();
            res.success = true;
            res.coupon = coupon;
            res.discountAmount = discountAmount;
            res.message = "Áp dụng mã giảm giá thành công!";
            return res;
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public Coupon getCoupon() { return coupon; }
        public BigDecimal getDiscountAmount() { return discountAmount; }
    }
}
