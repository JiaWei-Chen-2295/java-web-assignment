package fun.javierchen.ch14filter;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class CircleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        String currentDate = LocalDate.now().toString();
        String currentDateTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        String filterTrace = (String) request.getAttribute("circleFilterTrace");
        @SuppressWarnings("unchecked")
        List<String> logs = (List<String>) getServletContext().getAttribute("circleFilterLogs");

        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><meta charset=\"UTF-8\"><title>CircleServlet</title><link rel=\"stylesheet\" href=\"css/claude-design.css\"></head>");
        out.println("<body class=\"theme-root\">");
        out.println("<main class=\"container\">");
        out.println("<section class=\"panel\">");
        out.println("<h2>CircleServlet 页面</h2>");
        out.println("<p class=\"muted\">当前日期：<b>" + currentDate + "</b></p>");
        out.println("<p class=\"muted\">当前日期时间：<b>" + currentDateTime + "</b></p>");
        out.println("<p class=\"muted\">当前过滤阶段：<b>" + (filterTrace == null ? "无" : filterTrace) + "</b></p>");
        out.println("<a class=\"btn\" href=\"index.jsp\">返回首页</a>");
        out.println("</section>");
        out.println("<section class=\"panel\">");
        out.println("<h3>CircleFilter 生命周期日志</h3>");
        out.println("<div class=\"log-box\">");
        if (logs == null || logs.isEmpty()) {
            out.println("<div class=\"log-line\">暂无日志</div>");
        } else {
            for (String log : logs) {
                out.println("<div class=\"log-line\">" + escape(log) + "</div>");
            }
        }
        out.println("</div>");
        out.println("</section>");
        out.println("</main>");
        out.println("</body>");
        out.println("</html>");
    }

    private String escape(String text) {
        if (text == null) {
            return "";
        }
        return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
