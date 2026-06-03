package fun.javierchen.ch12cart.service;

import fun.javierchen.ch12cart.model.CartItem;
import fun.javierchen.ch12cart.model.Product;
import jakarta.servlet.http.HttpSession;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

public final class CartSupport {
    private CartSupport() {
    }

    public static void addProduct(HttpSession session, String mode, Product product) {
        Map<String, CartItem> cart = getCart(session, mode);
        CartItem item = cart.get(product.getId());
        if (item == null) {
            cart.put(product.getId(), new CartItem(product));
        } else {
            item.increment();
        }
    }

    public static Collection<CartItem> getItems(HttpSession session, String mode) {
        return getCart(session, mode).values();
    }

    public static int getCount(HttpSession session, String mode) {
        int count = 0;
        for (CartItem item : getCart(session, mode).values()) {
            count += item.getQuantity();
        }
        return count;
    }

    public static int getTotal(HttpSession session, String mode) {
        int total = 0;
        for (CartItem item : getCart(session, mode).values()) {
            total += item.getSubtotal();
        }
        return total;
    }

    public static void clear(HttpSession session, String mode) {
        session.removeAttribute(cartKey(mode));
        if ("guard".equals(mode)) {
            session.removeAttribute(guardKey(mode));
        }
    }

    public static boolean markIfNewRequest(HttpSession session, String mode, String requestId) {
        if (requestId == null || requestId.isBlank()) {
            return false;
        }
        Set<String> used = getUsedRequests(session, mode);
        if (used.contains(requestId)) {
            return false;
        }
        used.add(requestId);
        return true;
    }

    @SuppressWarnings("unchecked")
    private static Map<String, CartItem> getCart(HttpSession session, String mode) {
        String key = cartKey(mode);
        Object value = session.getAttribute(key);
        if (value instanceof Map<?, ?> map) {
            return (Map<String, CartItem>) map;
        }
        Map<String, CartItem> cart = new LinkedHashMap<>();
        session.setAttribute(key, cart);
        return cart;
    }

    @SuppressWarnings("unchecked")
    private static Set<String> getUsedRequests(HttpSession session, String mode) {
        String key = guardKey(mode);
        Object value = session.getAttribute(key);
        if (value instanceof Set<?> set) {
            return (Set<String>) set;
        }
        Set<String> usedRequests = new LinkedHashSet<>();
        session.setAttribute(key, usedRequests);
        return usedRequests;
    }

    private static String cartKey(String mode) {
        return mode + "Cart";
    }

    private static String guardKey(String mode) {
        return mode + "UsedRequestIds";
    }
}