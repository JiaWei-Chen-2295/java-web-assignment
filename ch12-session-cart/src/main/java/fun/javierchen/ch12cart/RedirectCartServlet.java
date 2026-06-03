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

@WebServlet("/cart/redirect")
public class RedirectCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Product product = CatalogService.findById(request.getParameter("productId"));
        if (product != null) {
            CartSupport.addProduct(request.getSession(), "redirect", product);
            ShopViewService.pushFlash(request.getSession(), "redirectNotice",
                    "商品已加入 PRG 购物车。当前请求会重定向为 GET，刷新只会重放 GET 页面，不会重复提交商品。");
        } else {
            ShopViewService.pushFlash(request.getSession(), "redirectNotice", "未找到对应商品，未加入购物车。");
        }
        response.sendRedirect(request.getContextPath() + "/shop?tab=redirect");
    }
}