package DTO;

import java.io.Serializable;

public class ProductDTO implements Serializable {
    private int id;
    private String name;
    private String price;
    private String finalPrice;
    private String mainImageUrl;
    private String discountValue;
    private boolean isNew;
    private boolean isAvailable;

    public ProductDTO() {
    }

    public ProductDTO(int id, String name, String price, String finalPrice, String mainImageUrl, String dicountValue, boolean isNew, boolean isAvailable) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.finalPrice = finalPrice;
        this.mainImageUrl = mainImageUrl;
        this.discountValue = dicountValue;
        this.isNew= isNew;
        this.isAvailable = isAvailable;
    }

    public String getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(String dicountValue) {
        this.discountValue = dicountValue;
    }

    public String getMainImageUrl() {
        return mainImageUrl;
    }

    public void setMainImageUrl(String mainImageUrl) {
        this.mainImageUrl = mainImageUrl;
    }

    public String getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(String finalPrice) {
        this.finalPrice = finalPrice;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public boolean getIsNew() {
        return isNew;
    }

    public void setIsNew(boolean aNew) {
        isNew = aNew;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public boolean getAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }
}
