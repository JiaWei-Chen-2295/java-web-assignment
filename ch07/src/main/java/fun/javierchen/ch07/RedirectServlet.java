package fun.javierchen.ch07;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * RedirectServlet - 根据浏览器类型重定向到不同页面
 */
public class RedirectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userAgent = request.getHeader("User-Agent");
        String targetPage;

        if (userAgent == null) {
            targetPage = "unknown.jsp";
        } else if (userAgent.contains("Edg")) {
            // Edge 浏览器的 User-Agent 包含 "Edg"
            targetPage = "edge.jsp";
        } else if (userAgent.contains("Firefox")) {
            // Firefox 浏览器
            targetPage = "firefox.jsp";
        } else if (userAgent.contains("Chrome")) {
            // Chrome 浏览器（注意要在Edge之后判断，因为Edge也包含Chrome）
            targetPage = "chrome.jsp";
        } else {
            targetPage = "unknown.jsp";
        }

        // 重定向到对应页面
        response.sendRedirect(request.getContextPath() + "/" + targetPage);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
