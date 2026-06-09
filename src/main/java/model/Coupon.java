package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Coupon {
    private int id;
    private String code;
    private String discountType; // PERCENTAGE, FIXED_AMOUNT
    private BigDecimal discountValue;
    private BigDecimal minOrderValue;
    private BigDecimal maxDiscountAmount;
    private Integer usageLimit;
    private int usedCount;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private boolean active;
    private LocalDateTime createdAt;

    public String getStartDateStr() {
        return startDate != null ? startDate.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")) : "";
    }

    public String getEndDateStr() {
        return endDate != null ? endDate.format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm")) : "";
    }

    public java.util.Date getEndDateTimestamp() {
        return endDate != null ? java.sql.Timestamp.valueOf(endDate) : null;
    }

    public Coupon() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }
    public BigDecimal getDiscountValue() { return discountValue; }
    public void setDiscountValue(BigDecimal discountValue) { this.discountValue = discountValue; }
    public BigDecimal getMinOrderValue() { return minOrderValue; }
    public void setMinOrderValue(BigDecimal minOrderValue) { this.minOrderValue = minOrderValue; }
    public BigDecimal getMaxDiscountAmount() { return maxDiscountAmount; }
    public void setMaxDiscountAmount(BigDecimal maxDiscountAmount) { this.maxDiscountAmount = maxDiscountAmount; }
    public Integer getUsageLimit() { return usageLimit; }
    public void setUsageLimit(Integer usageLimit) { this.usageLimit = usageLimit; }
    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }
    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }
    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
    // Alias for JDBI: column "is_active" → camelCase "isActive" → setIsActive()
    public void setIsActive(boolean active) { this.active = active; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public boolean isExpired() {
        return LocalDateTime.now().isAfter(endDate);
    }

    public boolean isStarted() {
        return LocalDateTime.now().isAfter(startDate);
    }

    public boolean hasRemainingUsage() {
        return usageLimit == null || usedCount < usageLimit;
    }
}
