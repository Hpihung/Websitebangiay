package model;

import java.time.LocalDateTime;

public class Review {
    private int id;
    private int userId;
    private int productId;
    private int orderId;
    private int rating;
    private String comment;
    private String imageUrl;
    private int sellerServiceRating;
    private int deliverySpeedRating;
    private int driverRating;
    private boolean isAnonymous;
    private LocalDateTime createdAt;
    private String userName;    // transient, from JOIN
    private String status;      // VISIBLE / HIDDEN
    private String productName; // transient, from JOIN
    private String adminReply;  // transient, from review_replies
    private LocalDateTime adminReplyAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getSellerServiceRating() { return sellerServiceRating; }
    public void setSellerServiceRating(int v) { this.sellerServiceRating = v; }

    public int getDeliverySpeedRating() { return deliverySpeedRating; }
    public void setDeliverySpeedRating(int v) { this.deliverySpeedRating = v; }

    public int getDriverRating() { return driverRating; }
    public void setDriverRating(int v) { this.driverRating = v; }

    public boolean isAnonymous() { return isAnonymous; }
    public void setAnonymous(boolean anonymous) { isAnonymous = anonymous; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public java.util.Date getCreatedAtTimestamp() {
        return createdAt == null ? null : java.sql.Timestamp.valueOf(createdAt);
    }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getStatus() { return status == null ? "VISIBLE" : status; }
    public void setStatus(String status) { this.status = status; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getAdminReply() { return adminReply; }
    public void setAdminReply(String adminReply) { this.adminReply = adminReply; }

    public LocalDateTime getAdminReplyAt() { return adminReplyAt; }
    public void setAdminReplyAt(LocalDateTime adminReplyAt) { this.adminReplyAt = adminReplyAt; }

    public java.util.Date getAdminReplyAtTimestamp() {
        return adminReplyAt == null ? null : java.sql.Timestamp.valueOf(adminReplyAt);
    }
}
