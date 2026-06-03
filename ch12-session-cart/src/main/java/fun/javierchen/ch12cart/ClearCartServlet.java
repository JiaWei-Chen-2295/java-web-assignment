package fun.javierchen.ch12cart;

import fun.javierchen.ch12cart.service.CartSupport;
import fun.javierchen.ch12cart.service.ShopViewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/cart/clear")
public class ClearCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mode = request.getParameter("mode");
        if (mode == null || mode.isBlank()) {
            mode = "direct";
        }

        CartSupport.clear(request.getSession(), mode);
        ShopViewService.pushFlash(request.getSession(), mode + "Notice", "已清空当前实验区购物车，方便重新演示刷新行为。");
        response.sendRedirect(request.getContextPath() + "/shop?tab=" + mode);
    }
}