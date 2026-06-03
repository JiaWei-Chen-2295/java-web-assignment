package fun.javierchen.ch12cart.model;

import java.io.Serializable;

public class Product implements Serializable {
    private static final long serialVersionUID = 1L;

    private final String id;
    private final String series;
    private final String name;
    private final String subtitle;
    private final int price;
    private final String badge;
    private final String tone;

    public Product(String id, String series, String name, String subtitle, int price, String badge, String tone) {
        this.id = id;
        this.series = series;
        this.name = name;
        this.subtitle = subtitle;
        this.price = price;
        this.badge = badge;
        this.tone = tone;
    }

    public String getId() {
        return id;
    }

    public String getSeries() {
        return series;
    }

    public String getName() {
        return name;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public int getPrice() {
        return price;
    }

    public String getBadge() {
        return badge;
    }

    public String getTone() {
        return tone;
    }
}