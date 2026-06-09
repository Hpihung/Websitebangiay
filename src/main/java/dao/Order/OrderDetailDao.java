package dao.Order;

import dao.JDBIConnector;
import model.Order.OrderDetailDTO;
import model.user.CartItem;
import org.jdbi.v3.core.Handle;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public class OrderDetailDao {

    public void insertOrderDetails(
            Handle handle,
            int orderId,
            Map<String, CartItem> cart,
            Map<String, BigDecimal> unitPrices) {
        for (CartItem item : cart.values()) {

            BigDecimal unitPrice = unitPrices.get(item.getKey());
            BigDecimal subtotal = unitPrice.multiply(BigDecimal.valueOf(item.getQuantity()));

            handle.createUpdate("""
                        INSERT INTO order_detail
                        (order_id, product_id, color_id, size_id,
                         quantity, unit_price, subtotal)
                        VALUES
                        (:order_id, :product_id, :color_id, :size_id,
                         :quantity, :unit_price, :subtotal)
                    """)
                    .bind("order_id", orderId)
                    .bind("product_id", item.getProductId())
                    .bind("color_id", item.getColorId())
                    .bind("size_id", item.getSizeId())
                    .bind("quantity", item.getQuantity())
                    .bind("unit_price", unitPrice)
                    .bind("subtotal", subtotal)
                    .execute();
        }
    }

    public List<OrderDetailDTO> findByOrderId(int orderId) {
        String sql = """
                    SELECT
                        od.product_id,
                        p.name as productName,
                        od.color_id as colorId,
                        c.name as colorName,
                        od.size_id as sizeId,
                        s.name as sizeName,
                        od.quantity,
                        od.unit_price as unitPrice,
                        (SELECT img_url FROM product_main_img pi WHERE pi.product_id = p.id LIMIT 1) as imageUrl
                    FROM order_detail od
                    JOIN product p ON od.product_id = p.id
                    LEFT JOIN color c ON od.color_id = c.id
                    LEFT JOIN size s ON od.size_id = s.id
                    WHERE od.order_id = :orderId
                """;

        return JDBIConnector.getJdbi().withHandle(handle -> handle.createQuery(sql)
                .bind("orderId", orderId)
                .mapToBean(OrderDetailDTO.class)
                .list());
    }

    /**
     * Count total quantity sold for a product across all non-cancelled orders.
     */
    public int countSoldByProduct(int productId) {
        String sql = """
            SELECT COALESCE(SUM(od.quantity), 0)
            FROM order_detail od
            JOIN orders o ON od.order_id = o.id
            WHERE od.product_id = :productId
              AND o.order_status NOT IN ('ORDER_CANCELLED', 'RETURNING', 'RETURNED')
        """;
        try {
            return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                    .bind("productId", productId)
                    .mapTo(Integer.class)
                    .one()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}