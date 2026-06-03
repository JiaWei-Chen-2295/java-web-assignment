package fun.javierchen.ch14filter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/student")
public class StudentInfoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String welcomeMessage = (String) request.getAttribute("welcomeMessage");
        String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><meta charset=\"UTF-8\"><title>学生信息展示</title></head>");
        out.println("<body>");
        out.println("<h2>Servlet 页面</h2>");
        out.println("<p>学号姓名常量：<b>" + StudentConstants.STUDENT_INFO + "</b></p>");
        out.println("<p>过滤器欢迎语：<b>" + (welcomeMessage == null ? "未获取到" : welcomeMessage) + "</b></p>");
        out.println("<p>当前时间：<b>" + now + "</b></p>");
        out.println("<p>请求路径：<b>" + request.getRequestURI() + "</b></p>");
        out.println("</body>");
        out.println("</html>");
    }
}
