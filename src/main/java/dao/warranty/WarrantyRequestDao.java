package dao.warranty;

import dao.JDBIConnector;
import model.warranty.WarrantyRequest;

import java.sql.Timestamp;
import java.util.List;

public class WarrantyRequestDao {


    public int insert(WarrantyRequest request) {
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createUpdate("INSERT INTO warranty_requests (user_id, order_id, product_id, reason, description, image_url, request_type, exchange_size, refund_bank_name, refund_account_number, refund_account_holder, return_method, pickup_address, pickup_phone) " +
                                "VALUES (:userId, :orderId, :productId, :reason, :description, :imageUrl, :requestType, :exchangeSize, :refundBankName, :refundAccountNumber, :refundAccountHolder, :returnMethod, :pickupAddress, :pickupPhone)")
                        .bindBean(request)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one()
        );
    }

    public List<WarrantyRequest> findByUserId(int userId) {
        String sql = "SELECT w.*, p.name as productName, (SELECT img_url FROM product_main_img pi WHERE pi.product_id = p.id LIMIT 1) as productImageUrl " +
                     "FROM warranty_requests w " +
                     "JOIN product p ON w.product_id = p.id " +
                     "WHERE w.user_id = :userId ORDER BY w.created_at DESC";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .map((rs, ctx) -> {
                            WarrantyRequest req = new WarrantyRequest();
                            req.setId(rs.getInt("id"));
                            req.setUserId(rs.getInt("user_id"));
                            req.setOrderId(rs.getInt("order_id"));
                            req.setProductId(rs.getInt("product_id"));
                            req.setReason(rs.getString("reason"));
                            req.setDescription(rs.getString("description"));
                            req.setImageUrl(rs.getString("image_url"));
                            req.setStatus(rs.getString("status"));
                            req.setCreatedAt(rs.getTimestamp("created_at"));
                            req.setUpdatedAt(rs.getTimestamp("updated_at"));
                            req.setRequestType(rs.getString("request_type"));
                            req.setExchangeSize(rs.getString("exchange_size"));
                            req.setRefundBankName(rs.getString("refund_bank_name"));
                            req.setRefundAccountNumber(rs.getString("refund_account_number"));
                            req.setRefundAccountHolder(rs.getString("refund_account_holder"));
                            req.setReturnMethod(rs.getString("return_method"));
                            req.setPickupAddress(rs.getString("pickup_address"));
                            req.setPickupPhone(rs.getString("pickup_phone"));
                            req.setProductName(rs.getString("productName"));
                            req.setProductImageUrl(rs.getString("productImageUrl"));
                            return req;
                        }).list()
        );
    }

    public List<WarrantyRequest> findAll() {
        String sql = "SELECT w.*, p.name as productName, (SELECT img_url FROM product_main_img pi WHERE pi.product_id = p.id LIMIT 1) as productImageUrl, " +
                     "u.full_name as customerName, u.email as customerEmail, " +
                     "o.created_at as orderCreatedAt, o.delivered_at as orderDeliveredAt, " +
                     "o.shipping_address as shippingAddress, o.phone_number as phoneNumber " +
                     "FROM warranty_requests w " +
                     "JOIN product p ON w.product_id = p.id " +
                     "JOIN users u ON w.user_id = u.id " +
                     "JOIN orders o ON w.order_id = o.id " +
                     "ORDER BY w.created_at DESC";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .map((rs, ctx) -> {
                            WarrantyRequest req = new WarrantyRequest();
                            req.setId(rs.getInt("id"));
                            req.setUserId(rs.getInt("user_id"));
                            req.setOrderId(rs.getInt("order_id"));
                            req.setProductId(rs.getInt("product_id"));
                            req.setReason(rs.getString("reason"));
                            req.setDescription(rs.getString("description"));
                            req.setImageUrl(rs.getString("image_url"));
                            req.setStatus(rs.getString("status"));
                            req.setCreatedAt(rs.getTimestamp("created_at"));
                            req.setUpdatedAt(rs.getTimestamp("updated_at"));
                            req.setRequestType(rs.getString("request_type"));
                            req.setExchangeSize(rs.getString("exchange_size"));
                            req.setRefundBankName(rs.getString("refund_bank_name"));
                            req.setRefundAccountNumber(rs.getString("refund_account_number"));
                            req.setRefundAccountHolder(rs.getString("refund_account_holder"));
                            req.setReturnMethod(rs.getString("return_method"));
                            req.setPickupAddress(rs.getString("pickup_address"));
                            req.setPickupPhone(rs.getString("pickup_phone"));
                            req.setProductName(rs.getString("productName"));
                            req.setProductImageUrl(rs.getString("productImageUrl"));
                            req.setCustomerName(rs.getString("customerName"));
                            req.setCustomerEmail(rs.getString("customerEmail"));
                            req.setOrderCreatedAt(rs.getTimestamp("orderCreatedAt"));
                            Timestamp deliveredTs = rs.getTimestamp("orderDeliveredAt");
                            req.setOrderDeliveredAt(deliveredTs != null ? deliveredTs : rs.getTimestamp("orderCreatedAt"));
                            req.setShippingAddress(rs.getString("shippingAddress"));
                            req.setPhoneNumber(rs.getString("phoneNumber"));
                            return req;
                        }).list()
        );
    }

    public void updateStatus(int id, String status) {
        JDBIConnector.getJdbi().useHandle(handle ->
                handle.createUpdate("UPDATE warranty_requests SET status = :status WHERE id = :id")
                        .bind("status", status)
                        .bind("id", id)
                        .execute()
        );
    }

    public WarrantyRequest findById(int id) {
        String sql = "SELECT w.*, p.name as productName, (SELECT img_url FROM product_main_img pi WHERE pi.product_id = p.id LIMIT 1) as productImageUrl, " +
                     "u.full_name as customerName, u.email as customerEmail, " +
                     "o.created_at as orderCreatedAt, o.delivered_at as orderDeliveredAt, " +
                     "o.shipping_address as shippingAddress, o.phone_number as phoneNumber " +
                     "FROM warranty_requests w " +
                     "JOIN product p ON w.product_id = p.id " +
                     "JOIN users u ON w.user_id = u.id " +
                     "JOIN orders o ON w.order_id = o.id " +
                     "WHERE w.id = :id";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .map((rs, ctx) -> {
                            WarrantyRequest req = new WarrantyRequest();
                            req.setId(rs.getInt("id"));
                            req.setUserId(rs.getInt("user_id"));
                            req.setOrderId(rs.getInt("order_id"));
                            req.setProductId(rs.getInt("product_id"));
                            req.setReason(rs.getString("reason"));
                            req.setDescription(rs.getString("description"));
                            req.setImageUrl(rs.getString("image_url"));
                            req.setStatus(rs.getString("status"));
                            req.setCreatedAt(rs.getTimestamp("created_at"));
                            req.setUpdatedAt(rs.getTimestamp("updated_at"));
                            req.setRequestType(rs.getString("request_type"));
                            req.setExchangeSize(rs.getString("exchange_size"));
                            req.setRefundBankName(rs.getString("refund_bank_name"));
                            req.setRefundAccountNumber(rs.getString("refund_account_number"));
                            req.setRefundAccountHolder(rs.getString("refund_account_holder"));
                            req.setReturnMethod(rs.getString("return_method"));
                            req.setPickupAddress(rs.getString("pickup_address"));
                            req.setPickupPhone(rs.getString("pickup_phone"));
                            req.setProductName(rs.getString("productName"));
                            req.setProductImageUrl(rs.getString("productImageUrl"));
                            req.setCustomerName(rs.getString("customerName"));
                            req.setCustomerEmail(rs.getString("customerEmail"));
                            req.setOrderCreatedAt(rs.getTimestamp("orderCreatedAt"));
                            Timestamp deliveredTs2 = rs.getTimestamp("orderDeliveredAt");
                            req.setOrderDeliveredAt(deliveredTs2 != null ? deliveredTs2 : rs.getTimestamp("orderCreatedAt"));
                            req.setShippingAddress(rs.getString("shippingAddress"));
                            req.setPhoneNumber(rs.getString("phoneNumber"));
                            return req;
                        }).findOne().orElse(null)
        );
    }

    public List<WarrantyRequest> findEligibleItems(int userId) {
        String sql = "SELECT od.product_id, od.order_id, p.name as productName, (SELECT img_url FROM product_main_img pi WHERE pi.product_id = p.id LIMIT 1) as productImageUrl, " +
                     "o.created_at as orderCreatedAt, o.delivered_at as orderDeliveredAt " +
                     "FROM order_detail od " +
                     "JOIN orders o ON od.order_id = o.id " +
                     "JOIN product p ON od.product_id = p.id " +
                     "WHERE o.user_id = :userId AND o.order_status IN ('COMPLETED', 'ORDER_COMPLETED') " +
                     "AND od.product_id NOT IN (SELECT product_id FROM warranty_requests WHERE user_id = :userId AND order_id = o.id) " +
                     "ORDER BY o.created_at DESC";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .map((rs, ctx) -> {
                            WarrantyRequest req = new WarrantyRequest();
                            req.setOrderId(rs.getInt("order_id"));
                            req.setProductId(rs.getInt("product_id"));
                            req.setProductName(rs.getString("productName"));
                            req.setProductImageUrl(rs.getString("productImageUrl"));
                            req.setOrderCreatedAt(rs.getTimestamp("orderCreatedAt"));
                            Timestamp deliveredTs3 = rs.getTimestamp("orderDeliveredAt");
                            req.setOrderDeliveredAt(deliveredTs3 != null ? deliveredTs3 : rs.getTimestamp("orderCreatedAt"));
                            return req;
                        }).list()
        );
    }
}
