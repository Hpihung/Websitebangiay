package DTO;

import model.user.CartItem;
import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * DTO lưu đơn hàng trong session
 */
public class SessionOrderDTO implements Serializable {

    private static int orderCounter = 0;

    private int id;
    private LocalDateTime createdAt;
    private BigDecimal subTotal;
    private BigDecimal shippingFee;
    private BigDecimal grandTotal;
    private String orderStatus;
    private String paymentStatus;
    private List<OrderItemDTO> items;

    public SessionOrderDTO() {
        this.id = ++orderCounter;
        this.createdAt = LocalDateTime.now();
        this.orderStatus = "NEW";
        this.paymentStatus = "UNPAID";
        this.items = new ArrayList<>();
    }

    /**
     * Tạo đơn hàng từ giỏ hàng trong session
     */
    public static SessionOrderDTO fromCart(Map<String, CartItem> cart) {
        SessionOrderDTO order = new SessionOrderDTO();

        BigDecimal subTotal = BigDecimal.ZERO;

        for (CartItem item : cart.values()) {
            OrderItemDTO orderItem = new OrderItemDTO();
            orderItem.setProductId(item.getProductId());
            orderItem.setProductName(item.getName());
            orderItem.setImageUrl(item.getImage());
            orderItem.setColorName(item.getColorName());
            orderItem.setSizeName(item.getSizeName());
            orderItem.setQuantity(item.getQuantity());

            // Parse giá từ String
            String priceStr = item.getFinalPrice().replaceAll("[^0-9]", "");
            BigDecimal unitPrice = new BigDecimal(priceStr);
            orderItem.setUnitPrice(unitPrice);
            orderItem.setSubtotal(unitPrice.multiply(BigDecimal.valueOf(item.getQuantity())));

            order.getItems().add(orderItem);
            subTotal = subTotal.add(orderItem.getSubtotal());
        }

        order.setSubTotal(subTotal);
        order.setShippingFee(BigDecimal.ZERO);
        order.setGrandTotal(subTotal);

        return order;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public BigDecimal getSubTotal() {
        return subTotal;
    }

    public void setSubTotal(BigDecimal subTotal) {
        this.subTotal = subTotal;
    }

    public BigDecimal getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(BigDecimal shippingFee) {
        this.shippingFee = shippingFee;
    }

    public BigDecimal getGrandTotal() {
        return grandTotal;
    }

    public void setGrandTotal(BigDecimal grandTotal) {
        this.grandTotal = grandTotal;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public List<OrderItemDTO> getItems() {
        return items;
    }

    public void setItems(List<OrderItemDTO> items) {
        this.items = items;
    }

    /**
     * Inner class cho sản phẩm trong đơn hàng
     */
    public static class OrderItemDTO implements Serializable {
        private int productId;
        private String productName;
        private String imageUrl;
        private String colorName;
        private String sizeName;
        private int quantity;
        private BigDecimal unitPrice;
        private BigDecimal subtotal;

        // Getters and Setters
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

        public BigDecimal getSubtotal() {
            return subtotal;
        }

        public void setSubtotal(BigDecimal subtotal) {
            this.subtotal = subtotal;
        }
    }
}
