package DTO;

import java.math.BigDecimal;

public class TopProductDTO {
    private int productId;
    private String name;
    private String image;
    private int totalSold;
    private BigDecimal totalRevenue;

    public TopProductDTO() {}

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public int getTotalSold() { return totalSold; }
    public void setTotalSold(int totalSold) { this.totalSold = totalSold; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
}
