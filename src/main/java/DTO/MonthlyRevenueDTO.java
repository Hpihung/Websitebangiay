package DTO;

import java.math.BigDecimal;

public class MonthlyRevenueDTO {
    private int month;
    private int year;
    private BigDecimal totalRevenue;
    private int orderCount;

    public MonthlyRevenueDTO() {}

    public int getMonth() { return month; }
    public void setMonth(int month) { this.month = month; }
    public int getYear() { return year; }
    public void setYear(int year) { this.year = year; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
    public int getOrderCount() { return orderCount; }
    public void setOrderCount(int orderCount) { this.orderCount = orderCount; }
}
