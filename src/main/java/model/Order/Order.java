package model.Order;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Order implements Serializable {

    private int id;
    private int user_id;
    private LocalDateTime created_at;

    private BigDecimal shipping_fee;
    private BigDecimal sub_total;
    private BigDecimal grand_total;

    private String shipping_address;
    private String phone_number;

    private String order_status;
    private String payment_method;
    private String payment_status;

    private String order_note;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return user_id;
    }

    public void setUserId(int user_id) {
        this.user_id = user_id;
    }

    public LocalDateTime getCreatedAt() {
        return created_at;
    }

    public void setCreatedAt(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    // Helper for JSP fmt:formatDate
    public java.util.Date getCreatedAtTimestamp() {
        return created_at == null ? null : java.sql.Timestamp.valueOf(created_at);
    }

    public BigDecimal getShippingFee() {
        return shipping_fee;
    }

    public void setShippingFee(BigDecimal shipping_fee) {
        this.shipping_fee = shipping_fee;
    }

    public BigDecimal getSubTotal() {
        return sub_total;
    }

    public void setSubTotal(BigDecimal sub_total) {
        this.sub_total = sub_total;
    }

    public BigDecimal getGrandTotal() {
        return grand_total;
    }

    public void setGrandTotal(BigDecimal grand_total) {
        this.grand_total = grand_total;
    }

    public String getShippingAddress() {
        return shipping_address;
    }

    public void setShippingAddress(String shipping_address) {
        this.shipping_address = shipping_address;
    }

    public String getPhoneNumber() {
        return phone_number;
    }

    public void setPhoneNumber(String phone_number) {
        this.phone_number = phone_number;
    }

    public String getOrderStatus() {
        return order_status;
    }

    public String getVietnameseStatus() {
        if (order_status == null) return "Không xác định";
        switch (order_status) {
            case "ORDER_PENDING": case "PENDING": case "UNPAID": return "Ch\u1edd x\u00e1c nh\u1eadn";
            case "ORDER_CONFIRMED": case "CONFIRMED": return "\u0110\u00e3 x\u00e1c nh\u1eadn";
            case "ORDER_PREPARING": return "\u0110ang chu\u1ea9n b\u1ecb h\u00e0ng";
            case "ORDER_SHIPPING": case "SHIPPING": return "\u0110ang giao h\u00e0ng";
            case "ORDER_DELIVERED": case "DELIVERED": return "\u0110\u00e3 giao h\u00e0ng";
            case "PENDING_COD": return "Ch\u1edd \u0111\u1ed1i so\u00e1t COD";
            case "RESCHEDULED": return "H\u1eb9n giao l\u1ea1i";
            case "RETURNING": return "\u0110ang ho\u00e0n h\u00e0ng";
            case "RETURNED": return "\u0110\u00e3 ho\u00e0n h\u00e0ng";
            case "RETURN_REJECTED": return "T\u1eeb ch\u1ed1i ho\u00e0n";
            case "ORDER_COMPLETED": case "COMPLETED": return "Ho\u00e0n th\u00e0nh";
            case "ORDER_CANCELLED": case "CANCELLED": return "\u0110\u00e3 hu\u1ef7";
            default: return order_status;
        }
    }

    public void setOrderStatus(String order_status) {
        this.order_status = order_status;
    }

    public String getPaymentMethod() {
        return payment_method;
    }

    public void setPaymentMethod(String payment_method) {
        this.payment_method = payment_method;
    }

    public String getPaymentStatus() {
        return payment_status;
    }

    public void setPaymentStatus(String payment_status) {
        this.payment_status = payment_status;
    }

    public String getOrderNote() {
        return order_note;
    }

    public void setOrderNote(String order_note) {
        this.order_note = order_note;
    }

    private String tracking_code;
    private String shipping_unit;
    private String processed_by;

    public String getTrackingCode() {
        return tracking_code;
    }

    public void setTrackingCode(String tracking_code) {
        this.tracking_code = tracking_code;
    }

    public String getShippingUnit() {
        return shipping_unit;
    }

    public void setShippingUnit(String shipping_unit) {
        this.shipping_unit = shipping_unit;
    }

    public String getProcessedBy() {
        return processed_by;
    }

    public void setProcessedBy(String processed_by) {
        this.processed_by = processed_by;
    }

    private Integer coupon_id;
    private BigDecimal discount_amount;
    private String cancel_reason;
    private String return_reason;
    private String rejection_reason;
    private boolean reviewed;

    public Integer getCouponId() {
        return coupon_id;
    }

    public void setCouponId(Integer coupon_id) {
        this.coupon_id = coupon_id;
    }

    public BigDecimal getDiscountAmount() {
        return discount_amount;
    }

    public void setDiscountAmount(BigDecimal discount_amount) {
        this.discount_amount = discount_amount;
    }

    public String getCancelReason() {
        return cancel_reason;
    }

    public void setCancelReason(String cancel_reason) {
        this.cancel_reason = cancel_reason;
    }

    public String getReturnReason() {
        return return_reason;
    }

    public void setReturnReason(String return_reason) {
        this.return_reason = return_reason;
    }

    public String getRejectionReason() {
        return rejection_reason;
    }

    public void setRejectionReason(String rejection_reason) {
        this.rejection_reason = rejection_reason;
    }

    public boolean isReviewed() {
        return reviewed;
    }

    public void setReviewed(boolean reviewed) {
        this.reviewed = reviewed;
    }

    private LocalDateTime cancelled_at;
    private LocalDateTime delivered_at;
    private LocalDateTime received_at;
    private Long shipper_id;

    public LocalDateTime getCancelledAt() {
        return cancelled_at;
    }

    public void setCancelledAt(LocalDateTime cancelled_at) {
        this.cancelled_at = cancelled_at;
    }

    public LocalDateTime getDeliveredAt() {
        return delivered_at;
    }

    public void setDeliveredAt(LocalDateTime delivered_at) {
        this.delivered_at = delivered_at;
    }

    public LocalDateTime getReceivedAt() {
        return received_at;
    }

    public void setReceivedAt(LocalDateTime received_at) {
        this.received_at = received_at;
    }

    public Long getShipperId() {
        return shipper_id;
    }

    public void setShipperId(Long shipper_id) {
        this.shipper_id = shipper_id;
    }

    // Helpers for JSP formatting
    public java.util.Date getCancelledAtTimestamp() {
        return cancelled_at == null ? null : java.sql.Timestamp.valueOf(cancelled_at);
    }
    public java.util.Date getDeliveredAtTimestamp() {
        return delivered_at == null ? null : java.sql.Timestamp.valueOf(delivered_at);
    }
    public java.util.Date getReceivedAtTimestamp() {
        return received_at == null ? null : java.sql.Timestamp.valueOf(received_at);
    }

    // List items for display
    private java.util.List<OrderDetailDTO> items;

    public java.util.List<OrderDetailDTO> getItems() {
        return items;
    }

    public void setItems(java.util.List<OrderDetailDTO> items) {
        this.items = items;
    }
}