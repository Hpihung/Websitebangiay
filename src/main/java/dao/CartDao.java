package dao;

import dao.JDBIConnector;
import model.user.CartRow;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

/**
 * DAO cho bảng cart — lưu giỏ hàng persistent theo user.
 */
public class CartDao {

    private final Jdbi jdbi;

    public CartDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    /**
     * Thêm hoặc cập nhật quantity item trong giỏ hàng DB.
     * Nếu đã tồn tại (UNIQUE key) → cộng thêm quantity.
     */
    public void upsertItem(int userId, int productId, int colorId, int sizeId, int qty) {
        String sql = """
                INSERT INTO cart (user_id, product_id, color_id, size_id, quantity)
                VALUES (:userId, :productId, :colorId, :sizeId, :qty)
                ON DUPLICATE KEY UPDATE quantity = quantity + :qty
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("userId", userId)
                .bind("productId", productId)
                .bind("colorId", colorId)
                .bind("sizeId", sizeId)
                .bind("qty", qty)
                .execute());
    }

    /**
     * Cập nhật quantity tuyệt đối (không cộng thêm).
     * Dùng khi user nhấn +/- trong giỏ hàng.
     */
    public void updateQuantity(int userId, int productId, int colorId, int sizeId, int qty) {
        String sql = """
                UPDATE cart
                SET quantity = :qty
                WHERE user_id  = :userId
                  AND product_id = :productId
                  AND color_id   = :colorId
                  AND size_id    = :sizeId
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("userId", userId)
                .bind("productId", productId)
                .bind("colorId", colorId)
                .bind("sizeId", sizeId)
                .bind("qty", qty)
                .execute());
    }

    /**
     * Xóa 1 item cụ thể khỏi giỏ hàng.
     * key format: "productId-colorId-sizeId"
     */
    public void removeItem(int userId, int productId, int colorId, int sizeId) {
        String sql = """
                DELETE FROM cart
                WHERE user_id  = :userId
                  AND product_id = :productId
                  AND color_id   = :colorId
                  AND size_id    = :sizeId
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("userId", userId)
                .bind("productId", productId)
                .bind("colorId", colorId)
                .bind("sizeId", sizeId)
                .execute());
    }

    /**
     * Xóa toàn bộ giỏ hàng của user — gọi sau khi checkout thành công.
     */
    public void clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = :userId";
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("userId", userId)
                .execute());
    }

    /**
     * Load toàn bộ cart rows từ DB theo user.
     */
    public List<CartRow> findByUser(int userId) {
        String sql = """
                SELECT id, user_id, product_id, color_id, size_id, quantity
                FROM cart
                WHERE user_id = :userId
                ORDER BY created_at ASC
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapToBean(CartRow.class)
                .list());
    }

    /**
     * Merge (upsert) 1 item từ session vào DB.
     * Nếu key đã tồn tại → cộng thêm qty.
     */
    public void mergeItem(int userId, int productId, int colorId, int sizeId, int qty) {
        upsertItem(userId, productId, colorId, sizeId, qty);
    }
}
