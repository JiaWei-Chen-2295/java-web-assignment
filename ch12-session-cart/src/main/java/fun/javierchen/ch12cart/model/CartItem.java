package fun.javierchen.ch12cart.model;

import java.io.Serializable;

public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private final String productId;
    private final String productName;
    private final int unitPrice;
    private int quantity;

    public CartItem(Product product) {
        this.productId = product.getId();
        this.productName = product.getName();
        this.unitPrice = product.getPrice();
        this.quantity = 1;
    }

    public String getProductId() {
        return productId;
    }

    public String getProductName() {
        return productName;
    }

    public int getUnitPrice() {
        return unitPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public int getSubtotal() {
        return unitPrice * quantity;
    }

    public void increment() {
        quantity++;
    }
}