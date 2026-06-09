package model.product;

import java.io.Serializable;

public class Size implements Serializable {
    private int id;
    private String name;
    private int sort_order;
    private int stock;

    public Size() {
    }

    public Size(int id, String name, int sort_order) {
        this.id = id;
        this.name = name;
        this.sort_order = sort_order;
    }

    public Size(int id, String name, int sort_order, int stock) {
        this.id = id;
        this.name = name;
        this.sort_order = sort_order;
        this.stock = stock;
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

    public int getSortOrder() {
        return sort_order;
    }

    public void setSortOrder(int sort_order) {
        this.sort_order = sort_order;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }
}
