package fun.javierchen.ch12cart;

import fun.javierchen.ch12cart.model.Product;
import fun.javierchen.ch12cart.service.CartSupport;
import fun.javierchen.ch12cart.service.CatalogService;
import fun.javierchen.ch12cart.service.ShopViewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/cart/session-guard")
public class SessionGuardCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        boolean firstSubmit = CartSupport.markIfNewRequest(request.getSession(), "guard", request.getParameter("requestId"));
        Product product = CatalogService.findById(request.getParameter("productId"));

        if (!firstSubmit) {
            request.setAttribute("guardNotice", "检测到同一 requestId 已在当前 Session 中处理过，本次刷新触发的重复提交已被拦截。");
        } else if (product != null) {
            CartSupport.addProduct(request.getSession(), "guard", product);
            request.setAttribute("guardNotice", "商品已加入 Session 防重购物车。即使刷新导致浏览器重发 POST，相同 requestId 也不会再次入库。");
        } else {
            request.setAttribute("guardNotice", "未找到对应商品，未加入购物车。");
        }

        ShopViewService.populate(request, "guard");
        request.getRequestDispatcher("/WEB-INF/shop.jsp").forward(request, response);
    }
}