package fun.javierchen.ch17elbean;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/header")
public class HeaderServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 设置几个 Cookie 用于演示
        Cookie userCookie = new Cookie("user", "JiaWeiChen");
        userCookie.setMaxAge(3600);
        Cookie themeCookie = new Cookie("theme", "dark");
        themeCookie.setMaxAge(3600);
        Cookie langCookie = new Cookie("lang", "zh-CN");
        langCookie.setMaxAge(3600);

        resp.addCookie(userCookie);
        resp.addCookie(themeCookie);
        resp.addCookie(langCookie);

        req.getRequestDispatcher("header.jsp").forward(req, resp);
    }
}
