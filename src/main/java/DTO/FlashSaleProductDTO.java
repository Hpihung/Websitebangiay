package DTO;

import java.io.Serializable;

public class FlashSaleProductDTO implements Serializable {
    private int id;
    private String name;
    private String price;
    private String finalPrice;
    private String discountValue;
    private String savings;
    private String mainImageUrl;
    private String colors;
    private String sizes;
    private int stock;
    private int totalStock;
    private String endDateStr;
    private boolean active;

    public FlashSaleProductDTO() {
    }

    public FlashSaleProductDTO(int id, String name, String price, String finalPrice, String discountValue, 
                               String savings, String mainImageUrl, String colors, String sizes, 
                               int stock, int totalStock, String endDateStr, boolean active) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.finalPrice = finalPrice;
        this.discountValue = discountValue;
        this.savings = savings;
        this.mainImageUrl = mainImageUrl;
        this.colors = colors;
        this.sizes = sizes;
        this.stock = stock;
        this.totalStock = totalStock;
        this.endDateStr = endDateStr;
        this.active = active;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(String finalPrice) {
        this.finalPrice = finalPrice;
    }

    public String getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(String discountValue) {
        this.discountValue = discountValue;
    }

    public String getSavings() {
        return savings;
    }

    public void setSavings(String savings) {
        this.savings = savings;
    }

    public String getMainImageUrl() {
        return mainImageUrl;
    }

    public void setMainImageUrl(String mainImageUrl) {
        this.mainImageUrl = mainImageUrl;
    }

    public String getColors() {
        return colors;
    }

    public void setColors(String colors) {
        this.colors = colors;
    }

    public String getSizes() {
        return sizes;
    }

    public void setSizes(String sizes) {
        this.sizes = sizes;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getTotalStock() {
        return totalStock;
    }

    public void setTotalStock(int totalStock) {
        this.totalStock = totalStock;
    }

    public String getEndDateStr() {
        return endDateStr;
    }

    public void setEndDateStr(String endDateStr) {
        this.endDateStr = endDateStr;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
