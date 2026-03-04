package fun.javierchen;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class WelcomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String currentTime = LocalDateTime.now().format(
            DateTimeFormatter.ofPattern("yyyy年MM月dd日 HH:mm:ss")
        );

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>欢迎页面 - Servlet</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class=\"container\">");
        out.println("<h1>欢迎来到 Java Web 开发世界！</h1>");
        out.println("<p>学号：<span class=\"info\">2023154202</span></p>");
        out.println("<p>姓名：<span class=\"info\">陈佳玮</span></p>");
        out.println("<p>当前时间：<span class=\"info\">" + currentTime + "</span></p>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}
