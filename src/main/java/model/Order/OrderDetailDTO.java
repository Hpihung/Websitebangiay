package model.Order;

import java.math.BigDecimal;

public class OrderDetailDTO {
    private int productId;
    private String productName;
    private String imageUrl;
    private int colorId;
    private String colorName;
    private int sizeId;
    private String sizeName;
    private int quantity;
    private BigDecimal unitPrice;

    public OrderDetailDTO() {
    }

    public OrderDetailDTO(int productId, String productName, String imageUrl, int colorId, String colorName, int sizeId, String sizeName,
            int quantity, BigDecimal unitPrice) {
        this.productId = productId;
        this.productName = productName;
        this.imageUrl = imageUrl;
        this.colorId = colorId;
        this.colorName = colorName;
        this.sizeId = sizeId;
        this.sizeName = sizeName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getColorName() {
        return colorName;
    }

    public void setColorName(String colorName) {
        this.colorName = colorName;
    }

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }

    public int getColorId() {
        return colorId;
    }

    public void setColorId(int colorId) {
        this.colorId = colorId;
    }

    public int getSizeId() {
        return sizeId;
    }

    public void setSizeId(int sizeId) {
        this.sizeId = sizeId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
}
