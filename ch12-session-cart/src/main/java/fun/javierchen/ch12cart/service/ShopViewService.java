package fun.javierchen.ch12cart.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

public final class ShopViewService {
    private ShopViewService() {
    }

    public static void populate(HttpServletRequest request, String activeTab) {
        HttpSession session = request.getSession();

        request.setAttribute("products", CatalogService.getProducts());
        request.setAttribute("directItems", CartSupport.getItems(session, "direct"));
        request.setAttribute("directCount", CartSupport.getCount(session, "direct"));
        request.setAttribute("directTotal", CartSupport.getTotal(session, "direct"));

        request.setAttribute("redirectItems", CartSupport.getItems(session, "redirect"));
        request.setAttribute("redirectCount", CartSupport.getCount(session, "redirect"));
        request.setAttribute("redirectTotal", CartSupport.getTotal(session, "redirect"));

        request.setAttribute("guardItems", CartSupport.getItems(session, "guard"));
        request.setAttribute("guardCount", CartSupport.getCount(session, "guard"));
        request.setAttribute("guardTotal", CartSupport.getTotal(session, "guard"));

        request.setAttribute("sessionId", session.getId());
        request.setAttribute("activeTab", activeTab);
        request.setAttribute("guardFormTokens", createGuardTokens());

        moveFlash(session, request, "directNotice");
        moveFlash(session, request, "redirectNotice");
        moveFlash(session, request, "guardNotice");
    }

    public static void pushFlash(HttpSession session, String noticeKey, String message) {
        session.setAttribute(noticeKey, message);
    }

    private static void moveFlash(HttpSession session, HttpServletRequest request, String key) {
        Object message = session.getAttribute(key);
        if (message != null) {
            request.setAttribute(key, message.toString());
            session.removeAttribute(key);
        }
    }

    private static Map<String, String> createGuardTokens() {
        Map<String, String> tokens = new LinkedHashMap<>();
        CatalogService.getProducts().forEach(product -> tokens.put(product.getId(), UUID.randomUUID().toString()));
        return tokens;
    }
}