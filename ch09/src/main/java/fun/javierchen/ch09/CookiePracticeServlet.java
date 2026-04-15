package fun.javierchen.ch09;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/cookie-practice")
public class CookiePracticeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/cookie.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");

        if ("setCookie".equals(action)) {
            String name = req.getParameter("cookieName");
            String value = req.getParameter("cookieValue");
            String maxAge = req.getParameter("maxAge");

            if (name != null && name.trim().length() > 0 && value != null) {
                Cookie cookie = new Cookie(name.trim(), value);
                if (maxAge != null && maxAge.trim().length() > 0) {
                    cookie.setMaxAge(Integer.parseInt(maxAge));
                }
                cookie.setPath("/");
                resp.addCookie(cookie);
                req.setAttribute("message", "Cookie已发送: " + name + " = " + value);
            }
        } else if ("readCookie".equals(action)) {
            req.setAttribute("showCookies", true);
        }

        req.getRequestDispatcher("/cookie.jsp").forward(req, resp);
    }
}