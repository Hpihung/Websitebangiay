package model.user;

/**
 * Raw row từ bảng cart trong DB.
 * Dùng để load giỏ hàng theo user_id.
 */
public class CartRow {
    private int id;
    private int user_id;
    private int product_id;
    private int color_id;
    private int size_id;
    private int quantity;

    public CartRow() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUser_id() { return user_id; }
    public void setUser_id(int user_id) { this.user_id = user_id; }

    public int getProduct_id() { return product_id; }
    public void setProduct_id(int product_id) { this.product_id = product_id; }

    public int getColor_id() { return color_id; }
    public void setColor_id(int color_id) { this.color_id = color_id; }

    public int getSize_id() { return size_id; }
    public void setSize_id(int size_id) { this.size_id = size_id; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
}
