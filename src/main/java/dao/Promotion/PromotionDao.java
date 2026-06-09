package dao.Promotion;

import dao.JDBIConnector;
import model.Promotion.Promotion;
import org.jdbi.v3.core.Jdbi;

import java.util.Collections;
import java.util.List;

public class PromotionDao {

    private final Jdbi jdbi;

    public PromotionDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public List<Promotion> findAllActive() {

        String sql = """
            SELECT *
            FROM promotion
            WHERE is_active = 1
              AND (start_date IS NULL OR start_date <= :now)
              AND (end_date IS NULL OR end_date >= :now)
            ORDER BY start_date DESC
        """;

        try {
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("now", now)
                            .mapToBean(Promotion.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList(); // ✅ List → emptyList
        }
    }

    public List<Promotion> findPromotionForProduct(int productId) {

        String sql = """
        SELECT p.*
        FROM promotion p
        JOIN promotion_product pp
            ON p.id = pp.promotion_id
        JOIN product pr
            ON pr.id = pp.product_id
        WHERE pr.id = :productId
          AND pr.is_available = 1
          AND p.is_active = 1
          AND (p.start_date IS NULL OR p.start_date <= :now)
          AND (p.end_date IS NULL OR p.end_date >= :now)
        ORDER BY p.start_date DESC
    """;

        try {
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("productId", productId)
                            .bind("now", now)
                            .mapToBean(Promotion.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public List<Promotion> findAll() {
        String sql = """
            SELECT *
            FROM promotion
            ORDER BY id DESC
        """;
        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .mapToBean(Promotion.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public java.util.Optional<Promotion> findById(int id) {
        String sql = "SELECT * FROM promotion WHERE id = :id";
        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("id", id)
                            .mapToBean(Promotion.class)
                            .findFirst()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return java.util.Optional.empty();
        }
    }

    public int insert(Promotion promotion) {
        String sql = """
            INSERT INTO promotion (name, slug, discount_type, discount_value, start_date, end_date, is_active, is_flash_sale)
            VALUES (:name, :slug, :discountType, :discountValue, :startDate, :endDate, :isActive, :isFlashSale)
        """;
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("name", promotion.getName())
                        .bind("slug", promotion.getSlug())
                        .bind("discountType", promotion.getDiscountType())
                        .bind("discountValue", promotion.getDiscountValue())
                        .bind("startDate", promotion.getStartDate())
                        .bind("endDate", promotion.getEndDate())
                        .bind("isActive", promotion.isActive())
                        .bind("isFlashSale", promotion.isFlashSale() ? 1 : 0)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public void update(Promotion promotion) {
        String sql = """
            UPDATE promotion
            SET name = :name, slug = :slug, discount_type = :discountType, discount_value = :discountValue,
                start_date = :startDate, end_date = :endDate, is_active = :isActive, is_flash_sale = :isFlashSale
            WHERE id = :id
        """;
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("name", promotion.getName())
                        .bind("slug", promotion.getSlug())
                        .bind("discountType", promotion.getDiscountType())
                        .bind("discountValue", promotion.getDiscountValue())
                        .bind("startDate", promotion.getStartDate())
                        .bind("endDate", promotion.getEndDate())
                        .bind("isActive", promotion.isActive())
                        .bind("isFlashSale", promotion.isFlashSale() ? 1 : 0)
                        .bind("id", promotion.getId())
                        .execute()
        );
    }

    public void deleteById(int id) {
        jdbi.useHandle(handle -> {
            handle.createUpdate("DELETE FROM promotion_product WHERE promotion_id = :id")
                    .bind("id", id).execute();
            handle.createUpdate("DELETE FROM promotion WHERE id = :id")
                    .bind("id", id).execute();
        });
    }

    public List<Integer> getProductIdsByPromotionId(int promotionId) {
        String sql = "SELECT product_id FROM promotion_product WHERE promotion_id = :promotionId";
        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("promotionId", promotionId)
                            .mapTo(Integer.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public void setPromotionProducts(int promotionId, List<Integer> productIds) {
        jdbi.useTransaction(handle -> {
            handle.createUpdate("DELETE FROM promotion_product WHERE promotion_id = :promotionId")
                    .bind("promotionId", promotionId)
                    .execute();
            
            if (productIds != null && !productIds.isEmpty()) {
                var batch = handle.prepareBatch("INSERT INTO promotion_product (promotion_id, product_id) VALUES (:promotionId, :productId)");
                for (Integer productId : productIds) {
                    batch.bind("promotionId", promotionId)
                         .bind("productId", productId)
                         .add();
                }
                batch.execute();
            }
        });
    }

    public List<Promotion> findActiveFlashSales() {
        String sql = """
            SELECT *
            FROM promotion
            WHERE is_active = 1
              AND is_flash_sale = 1
              AND (start_date IS NULL OR start_date <= :now)
              AND (end_date IS NULL OR end_date >= :now)
            ORDER BY start_date DESC
        """;
        try {
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("now", now)
                            .mapToBean(Promotion.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

}
