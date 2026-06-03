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

@WebServlet("/cart/direct")
public class DirectCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Product product = CatalogService.findById(request.getParameter("productId"));
        if (product != null) {
            CartSupport.addProduct(request.getSession(), "direct", product);
            request.setAttribute("directNotice", "商品已加入直接提交购物车。刷新当前页面时，浏览器会再次提交同一笔 POST，因此数量会继续增加。\n");
        } else {
            request.setAttribute("directNotice", "未找到对应商品，未加入购物车。");
        }

        ShopViewService.populate(request, "direct");
        request.getRequestDispatcher("/WEB-INF/shop.jsp").forward(request, response);
    }
}