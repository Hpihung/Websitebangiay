package model.warranty;

import java.sql.Timestamp;

public class WarrantyRequest {
    private int id;
    private int userId;
    private int orderId;
    private int productId;
    private String reason;
    private String description;
    private String imageUrl;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    private String requestType;
    private String exchangeSize;
    private String refundBankName;
    private String refundAccountNumber;
    private String refundAccountHolder;
    private String returnMethod;
    private String pickupAddress;
    private String pickupPhone;

    // DTO fields (joined from other tables)
    private String productName;
    private String productImageUrl;
    private String customerName;
    private String customerEmail;
    private Timestamp orderCreatedAt;
    private Timestamp orderDeliveredAt;
    private String shippingAddress;
    private String phoneNumber;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getRequestType() { return requestType; }
    public void setRequestType(String requestType) { this.requestType = requestType; }

    public String getExchangeSize() { return exchangeSize; }
    public void setExchangeSize(String exchangeSize) { this.exchangeSize = exchangeSize; }

    public String getRefundBankName() { return refundBankName; }
    public void setRefundBankName(String refundBankName) { this.refundBankName = refundBankName; }

    public String getRefundAccountNumber() { return refundAccountNumber; }
    public void setRefundAccountNumber(String refundAccountNumber) { this.refundAccountNumber = refundAccountNumber; }

    public String getRefundAccountHolder() { return refundAccountHolder; }
    public void setRefundAccountHolder(String refundAccountHolder) { this.refundAccountHolder = refundAccountHolder; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getProductImageUrl() { return productImageUrl; }
    public void setProductImageUrl(String productImageUrl) { this.productImageUrl = productImageUrl; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public Timestamp getOrderCreatedAt() { return orderCreatedAt; }
    public void setOrderCreatedAt(Timestamp orderCreatedAt) { this.orderCreatedAt = orderCreatedAt; }

    public Timestamp getOrderDeliveredAt() { return orderDeliveredAt; }
    public void setOrderDeliveredAt(Timestamp orderDeliveredAt) { this.orderDeliveredAt = orderDeliveredAt; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getReturnMethod() { return returnMethod; }
    public void setReturnMethod(String returnMethod) { this.returnMethod = returnMethod; }

    public String getPickupAddress() { return pickupAddress; }
    public void setPickupAddress(String pickupAddress) { this.pickupAddress = pickupAddress; }

    public String getPickupPhone() { return pickupPhone; }
    public void setPickupPhone(String pickupPhone) { this.pickupPhone = pickupPhone; }
}
