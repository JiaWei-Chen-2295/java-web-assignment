package fun.javierchen.ch12cart.service;

import fun.javierchen.ch12cart.model.Product;

import java.util.List;

public final class CatalogService {
    private static final List<Product> PRODUCTS = List.of(
            new Product("tee-shadow", "GRAPHIC TEE", "Shadow Signal Tee", "重磅纯棉 / 碳黑街头版型", 699, "NEW DROP", "mono"),
            new Product("shirt-grid", "OVERSHIRT", "Grid Noise Shirt", "落肩格纹 / 轻工装层次", 899, "LIMITED", "sand"),
            new Product("hoodie-scan", "HOODIE", "Scanline Hoodie", "毛圈卫衣 / 正面大字图形", 1099, "HOT", "red"),
            new Product("pants-lab", "UTILITY PANTS", "Lab Motion Pants", "机能抽绳 / 都市机动廓形", 959, "RESTOCK", "ink")
    );

    private CatalogService() {
    }

    public static List<Product> getProducts() {
        return PRODUCTS;
    }

    public static Product findById(String id) {
        for (Product product : PRODUCTS) {
            if (product.getId().equals(id)) {
                return product;
            }
        }
        return null;
    }
}