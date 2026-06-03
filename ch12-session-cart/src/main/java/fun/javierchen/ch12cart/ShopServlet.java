package fun.javierchen.ch12cart;

import fun.javierchen.ch12cart.service.ShopViewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/shop")
public class ShopServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ShopViewService.populate(request, request.getParameter("tab"));
        request.getRequestDispatcher("/WEB-INF/shop.jsp").forward(request, response);
    }
}