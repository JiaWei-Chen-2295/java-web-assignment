package fun.javierchen.ch14filter;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");

        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html><head><meta charset=\"UTF-8\"><title>注册结果</title>");
        out.println("<link rel=\"stylesheet\" href=\"css/claude-design.css\"></head>");
        out.println("<body class=\"theme-root\">");
        out.println("<main class=\"container\">");
        out.println("<section class=\"panel\">");
        out.println("<h2>RegisterServlet 注册结果</h2>");
        out.println("<p class=\"muted\">注册成功！欢迎你，" + nickname + "（用户名：" + username + "）</p>");
        out.println("<a class=\"btn\" href=\"register.jsp\">返回注册页</a>");
        out.println("</section></main></body></html>");
    }
}
