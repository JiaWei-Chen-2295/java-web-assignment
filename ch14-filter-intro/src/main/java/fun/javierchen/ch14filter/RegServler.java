package fun.javierchen.ch14filter;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

public class RegServler extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");

        String message;
        if (isBlank(username) || isBlank(nickname) || isBlank(password)) {
            message = "注册失败：用户名、昵称、密码均不能为空。";
        } else if (password.length() < 6) {
            message = "注册失败：密码长度至少 6 位。";
        } else {
            message = "注册成功，欢迎你：" + nickname + "（用户名：" + username + "）";
        }

        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><meta charset=\"UTF-8\"><title>注册结果</title><link rel=\"stylesheet\" href=\"css/claude-design.css\"></head>");
        out.println("<body class=\"theme-root\">");
        out.println("<main class=\"container\">");
        out.println("<section class=\"panel\">");
        out.println("<h2>RegServler 注册验证结果</h2>");
        out.println("<p class=\"muted\">" + message + "</p>");
        out.println("<a class=\"btn\" href=\"register.html\">返回注册页</a>");
        out.println("</section>");
        out.println("</main>");
        out.println("</body>");
        out.println("</html>");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
