package dao;

import model.Coupon;
import org.jdbi.v3.core.Jdbi;

import java.util.List;
import java.util.Optional;

public class CouponDao {
    private final Jdbi jdbi;

    public CouponDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public Optional<Coupon> findByCode(String code) {
        String sql = "SELECT * FROM coupons WHERE code = :code AND is_active = 1";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("code", code)
                .mapToBean(Coupon.class)
                .findOne());
    }

    public Optional<Coupon> findById(int id) {
        String sql = "SELECT * FROM coupons WHERE id = :id";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .mapToBean(Coupon.class)
                .findOne());
    }

    public int insert(Coupon coupon) {
        String sql = """
            INSERT INTO coupons (code, discount_type, discount_value, min_order_value, 
                                max_discount_amount, usage_limit, start_date, end_date, is_active)
            VALUES (:code, :discountType, :discountValue, :minOrderValue, 
                    :maxDiscountAmount, :usageLimit, :startDate, :endDate, :active)
        """;
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bindBean(coupon)
                .executeAndReturnGeneratedKeys("id")
                .mapTo(int.class)
                .one());
    }

    public int update(Coupon coupon) {
        String sql = """
            UPDATE coupons SET 
                code = :code, 
                discount_type = :discountType, 
                discount_value = :discountValue, 
                min_order_value = :minOrderValue, 
                max_discount_amount = :maxDiscountAmount, 
                usage_limit = :usageLimit, 
                start_date = :startDate, 
                end_date = :endDate, 
                is_active = :active
            WHERE id = :id
        """;
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bindBean(coupon)
                .execute());
    }

    public boolean deleteById(int id) {
        String sql = "DELETE FROM coupons WHERE id = :id";
        return jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("id", id)
                .execute()) > 0;
    }

    public void incrementUsedCount(int couponId) {
        String sql = "UPDATE coupons SET used_count = used_count + 1 WHERE id = :id";
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("id", couponId)
                .execute());
    }

    public void recordUsage(int couponId, int userId, int orderId) {
        String sql = "INSERT INTO coupon_usages (coupon_id, user_id, order_id) VALUES (:couponId, :userId, :orderId)";
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("couponId", couponId)
                .bind("userId", userId)
                .bind("orderId", orderId)
                .execute());
    }

    public List<Coupon> findAll() {
        String sql = "SELECT * FROM coupons ORDER BY created_at DESC";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapToBean(Coupon.class)
                .list());
    }

    public List<Coupon> findAllActive() {
        String sql = "SELECT * FROM coupons WHERE is_active = 1 AND end_date > :now ORDER BY created_at DESC";
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("now", now)
                .mapToBean(Coupon.class)
                .list());
    }

    public List<Integer> getProductIdsByCouponId(int couponId) {
        String sql = "SELECT product_id FROM coupon_products WHERE coupon_id = :couponId";
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("couponId", couponId)
                .mapTo(int.class)
                .list());
    }

    public void setCouponProducts(int couponId, List<Integer> productIds) {
        jdbi.useHandle(handle -> {
            handle.createUpdate("DELETE FROM coupon_products WHERE coupon_id = :couponId")
                    .bind("couponId", couponId)
                    .execute();
            if (productIds != null && !productIds.isEmpty()) {
                var preparedBatch = handle.prepareBatch("INSERT INTO coupon_products (coupon_id, product_id) VALUES (:couponId, :productId)");
                for (int pid : productIds) {
                    preparedBatch.bind("couponId", couponId)
                            .bind("productId", pid)
                            .add();
                }
                preparedBatch.execute();
            }
        });
    }

    /**
     * Returns set of product IDs that have at least one active, product-specific coupon.
     */
    public java.util.Set<Integer> getProductIdsWithCoupons() {
        String sql = """
            SELECT DISTINCT cp.product_id 
            FROM coupon_products cp
            JOIN coupons c ON c.id = cp.coupon_id
            WHERE c.is_active = 1 AND c.end_date > :now
        """;
        java.time.LocalDateTime now = java.time.LocalDateTime.now();
        List<Integer> list = jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("now", now)
                .mapTo(int.class)
                .list());
        return new java.util.HashSet<>(list);
    }
}
