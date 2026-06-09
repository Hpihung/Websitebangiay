package services;

import dao.CartDao;
import dao.CouponDao;
import dao.JDBIConnector;
import dao.Order.OrderDao;
import dao.Order.OrderDetailDao;
import dao.Product.ProductVariantDao;
import model.user.CartItem;
import org.jdbi.v3.core.Jdbi;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

public class CheckoutService {

    private final ProductVariantDao variantDao    = new ProductVariantDao();
    private final OrderDao          orderDao      = new OrderDao();
    private final OrderDetailDao    orderDetailDao = new OrderDetailDao();
    private final PromotionService  promotionService = new PromotionService();
    private final CartDao           cartDao       = new CartDao();
    private final Jdbi jdbi;

    public CheckoutService() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    private final CouponDao           couponDao     = new CouponDao();

    /**
     * Đặt hàng và xóa giỏ hàng khỏi DB.
     *
     * @param userId     ID người dùng
     * @param cart       Giỏ hàng
     * @param shippingFee Phí vận chuyển
     * @param couponId   ID của coupon áp dụng (nếu có)
     * @return orderId vừa tạo
     */
    public int placeOrder(int userId, Map<String, CartItem> cart, BigDecimal shippingFee, Integer couponId, BigDecimal discountAmount) {

        return jdbi.inTransaction(handle -> {

            // 0. Stock validation
            for (CartItem item : cart.values()) {
                int availableStock = variantDao.getStock(item.getProductId(), item.getColorId(), item.getSizeId());
                if (item.getQuantity() > availableStock) {
                    throw new RuntimeException("Sản phẩm '" + item.getName() + "' (Màu: " + item.getColorName() + ", Size: " + item.getSizeName() + ") chỉ còn " + availableStock + " sản phẩm trong kho. Vui lòng cập nhật số lượng.");
                }
            }

            BigDecimal subTotal = BigDecimal.ZERO;
            Map<String, BigDecimal> unitPrices = new HashMap<>();

            for (CartItem item : cart.values()) {
                BigDecimal unitPrice = promotionService.parsePrice(item.getFinalPrice());
                unitPrices.put(item.getKey(), unitPrice);
                subTotal = subTotal.add(unitPrice.multiply(BigDecimal.valueOf(item.getQuantity())));
            }

            BigDecimal grandTotal = subTotal.add(shippingFee).subtract(discountAmount != null ? discountAmount : BigDecimal.ZERO);
            if (grandTotal.compareTo(BigDecimal.ZERO) < 0) grandTotal = BigDecimal.ZERO;

            // 1. Tạo đơn hàng
            int orderId = orderDao.insertOrder(handle, userId, subTotal, shippingFee, grandTotal, couponId, discountAmount);

            // 2. Tạo chi tiết đơn hàng
            orderDetailDao.insertOrderDetails(handle, orderId, cart, unitPrices);

            // 3. (Đã chuyển sang trừ tồn kho khi Admin xác nhận đơn hàng)

            // 4. Ghi nhận sử dụng Coupon
            if (couponId != null && couponId > 0) {
                couponDao.incrementUsedCount(couponId);
                couponDao.recordUsage(couponId, userId, orderId);
            }

            // 5. Xóa các sản phẩm đã mua khỏi giỏ hàng trong DB
            for (CartItem item : cart.values()) {
                handle.createUpdate("DELETE FROM cart WHERE user_id = :userId AND product_id = :productId AND color_id = :colorId AND size_id = :sizeId")
                      .bind("userId", userId)
                      .bind("productId", item.getProductId())
                      .bind("colorId", item.getColorId())
                      .bind("sizeId", item.getSizeId())
                      .execute();
            }

            return orderId;
        });
    }
}