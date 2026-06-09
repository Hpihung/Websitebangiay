
package dao.Order;

import dao.JDBIConnector;
import model.Order.Order;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;

import java.math.BigDecimal;

import java.util.List;

public class OrderDao {

    private final Jdbi jdbi;

    public OrderDao() {
        jdbi = JDBIConnector.getJdbi();
    }

    public int insertOrder(Handle handle, int userId, BigDecimal subTotal, BigDecimal shippingFee,
            BigDecimal grandTotal, Integer couponId, BigDecimal discountAmount) {
        return handle.createUpdate("""
                    INSERT INTO orders
                    (user_id, sub_total, shipping_fee, grand_total, coupon_id, discount_amount,
                     order_status, payment_status)
                    VALUES
                    (:user_id, :sub_total, :shipping_fee, :grand_total, :coupon_id, :discount_amount,
                     'ORDER_PENDING', 'UNPAID')
                """)
                .bind("user_id", userId)
                .bind("sub_total", subTotal)
                .bind("shipping_fee", shippingFee)
                .bind("grand_total", grandTotal)
                .bind("coupon_id", couponId)
                .bind("discount_amount", discountAmount)
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one();
    }

    public List<Order> findWithFilter(Integer orderId, Integer userId, String status, String dateFilter) {
        StringBuilder sql = new StringBuilder("""
                SELECT
                    o.id,
                    o.user_id,
                    o.sub_total,
                    o.shipping_fee,
                    o.grand_total,
                    o.coupon_id,
                    o.discount_amount,
                    o.order_status,
                    o.payment_status,
                    o.payment_method,
                    o.shipping_address,
                    o.phone_number,
                    o.created_at,
                    o.tracking_code,
                    o.shipping_unit,
                    o.processed_by,
                    o.cancel_reason,
                    o.return_reason,
                    o.rejection_reason,
                    o.cancelled_at,
                    o.delivered_at,
                    o.received_at,
                    o.shipper_id,
                    o.reviewed
                FROM orders o
                WHERE 1 = 1
                """);

        if (orderId != null) {
            sql.append(" AND o.id = :orderId");
        }

        if (userId != null) {
            sql.append(" AND o.user_id = :userId");
        }

        if (status != null && !status.isEmpty()) {
            sql.append(" AND o.order_status = :status");
        }
        
        if ("today".equals(dateFilter)) {
            sql.append(" AND o.created_at >= CURDATE() AND o.created_at < CURDATE() + INTERVAL 1 DAY");
        } else if (dateFilter != null && dateFilter.matches("\\d{4}")) {
            sql.append(" AND YEAR(o.created_at) = :yearFilter");
        }

        sql.append(" ORDER BY o.created_at DESC");

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            if (orderId != null) {
                query.bind("orderId", orderId);
            }

            if (userId != null) {
                query.bind("userId", userId);
            }

            if (status != null && !status.isEmpty()) {
                query.bind("status", status.toUpperCase());
            }

            if (dateFilter != null && dateFilter.matches("\\d{4}")) {
                query.bind("yearFilter", Integer.parseInt(dateFilter));
            }

            return query
                    .mapToBean(Order.class)
                    .list();
        });
    }

    public List<Order> findAll() {
        String sql = """
                SELECT *
                FROM orders
                ORDER BY created_at DESC
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapToBean(Order.class)
                .list());
    }

    public BigDecimal totalRevenue() {
        String sql = """
                SELECT COALESCE(SUM(grand_total), 0)
                FROM orders
                WHERE order_status = 'ORDER_COMPLETED'
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(BigDecimal.class)
                .one());
    }

    public int todayOrders() {
        String sql = """
                SELECT COUNT(*)
                FROM orders
                WHERE created_at >= CURRENT_DATE
                  AND created_at < CURRENT_DATE + INTERVAL 1 DAY
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(Integer.class)
                .one());
    }

    public BigDecimal todayRevenue() {
        String sql = """
                    SELECT COALESCE(SUM(grand_total), 0)
                    FROM orders
                    WHERE order_status = 'ORDER_COMPLETED'
                      AND DATE(created_at) = CURRENT_DATE
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapTo(BigDecimal.class)
                .one());
    }

    public void updatePaymentStatus(int orderId, String paymentStatus) {
        String sql = """
                UPDATE orders
                SET payment_status = :paymentStatus
                WHERE id = :orderId
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("paymentStatus", paymentStatus)
                .bind("orderId", orderId)
                .execute());
    }

    public void updateStatus(int orderId, String newStatus, String trackingCode, String shippingUnit, String processedBy) {
        String sql = """
                UPDATE orders
                SET order_status = :status,
                    tracking_code = COALESCE(:trackingCode, tracking_code),
                    shipping_unit = COALESCE(:shippingUnit, shipping_unit),
                    processed_by = COALESCE(:processedBy, processed_by),
                    payment_status = CASE 
                        WHEN :status = 'COMPLETED' AND payment_method = 'COD' THEN 'PAID'
                        ELSE payment_status
                    END
                WHERE id = :orderId
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("status", newStatus)
                .bind("trackingCode", trackingCode)
                .bind("shippingUnit", shippingUnit)
                .bind("processedBy", processedBy)
                .bind("orderId", orderId)
                .execute());
    }

    public void cancelOrder(int orderId, String cancelReason, String processedBy) {
        String sql = """
                UPDATE orders
                SET order_status = 'ORDER_CANCELLED',
                    cancel_reason = :cancelReason,
                    processed_by = COALESCE(:processedBy, processed_by)
                WHERE id = :orderId
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("cancelReason", cancelReason)
                .bind("processedBy", processedBy)
                .bind("orderId", orderId)
                .execute());
    }

    /**
     * Customer requests a return within 7 days of receipt.
     * Sets status to RETURNING and saves the return reason.
     */
    public void returnOrder(int orderId, String returnReason, String processedBy) {
        String sql = """
                UPDATE orders
                SET order_status = 'RETURNING',
                    return_reason = :returnReason,
                    processed_by = COALESCE(:processedBy, processed_by)
                WHERE id = :orderId
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("returnReason", returnReason)
                .bind("processedBy", processedBy)
                .bind("orderId", orderId)
                .execute());
    }

    /**
     * Admin rejects a customer return request.
     * Sets status back to ORDER_COMPLETED and saves the rejection reason.
     */
    public void rejectReturn(int orderId, String rejectionReason, String processedBy) {
        String sql = """
                UPDATE orders
                SET order_status = 'RETURN_REJECTED',
                    rejection_reason = :rejectionReason,
                    processed_by = COALESCE(:processedBy, processed_by)
                WHERE id = :orderId
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("rejectionReason", rejectionReason)
                .bind("processedBy", processedBy)
                .bind("orderId", orderId)
                .execute());
    }

    public void confirmReceived(int orderId) {
        String sql = """
                UPDATE orders
                SET received_at = NOW()
                WHERE id = :orderId
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("orderId", orderId)
                .execute());
    }

    public void userConfirmReceived(int orderId, String newStatus, String trackingCode, String shippingUnit, String processedBy) {
        String sql = """
                UPDATE orders
                SET order_status = :status,
                    tracking_code = COALESCE(:trackingCode, tracking_code),
                    shipping_unit = COALESCE(:shippingUnit, shipping_unit),
                    processed_by = COALESCE(:processedBy, processed_by),
                    received_at = NOW(),
                    payment_status = CASE 
                        WHEN :status = 'COMPLETED' AND payment_method = 'COD' THEN 'PAID'
                        ELSE payment_status
                    END
                WHERE id = :orderId
                """;
        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("status", newStatus)
                .bind("trackingCode", trackingCode)
                .bind("shippingUnit", shippingUnit)
                .bind("processedBy", processedBy)
                .bind("orderId", orderId)
                .execute());
    }

    /**
     * Automatically scan and confirm orders delivered older than 3 days.
     * Transition unpaid COD orders to PENDING_COD, and online/paid orders to ORDER_COMPLETED.
     */
    public void autoConfirmDeliveredOrders() {
        String sqlCOD = """
                UPDATE orders
                SET order_status = 'PENDING_COD',
                    processed_by = 'System (Auto)'
                WHERE order_status IN ('DELIVERED', 'ORDER_DELIVERED')
                  AND payment_method = 'COD'
                  AND payment_status != 'PAID'
                  AND delivered_at <= NOW() - INTERVAL 3 DAY
                """;
        String sqlOther = """
                UPDATE orders
                SET order_status = 'ORDER_COMPLETED',
                    processed_by = 'System (Auto)',
                    received_at = COALESCE(received_at, NOW())
                WHERE order_status IN ('DELIVERED', 'ORDER_DELIVERED')
                  AND (payment_method != 'COD' OR payment_status = 'PAID')
                  AND delivered_at <= NOW() - INTERVAL 3 DAY
                """;
        String sqlAutoReceive = """
                UPDATE orders
                SET received_at = COALESCE(received_at, NOW())
                WHERE order_status IN ('ORDER_COMPLETED', 'COMPLETED')
                  AND received_at IS NULL
                  AND delivered_at <= NOW() - INTERVAL 3 DAY
                """;
        jdbi.useHandle(handle -> {
            handle.createUpdate(sqlCOD).execute();
            handle.createUpdate(sqlOther).execute();
            handle.createUpdate(sqlAutoReceive).execute();
        });
    }
}