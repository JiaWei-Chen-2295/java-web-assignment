package fun.javierchen.ch14filter.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String role = authenticate(username, password);

        if (role == null) {
            System.out.println("[LoginServlet] 登录失败: username=" + username);
            response.sendRedirect("login.jsp?error=1");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("username", username);
        session.setAttribute("role", role);
        System.out.println("[LoginServlet] 登录成功: username=" + username + ", role=" + role);

        if ("admin".equals(role)) {
            response.sendRedirect("admin/admin.jsp");
        } else {
            response.sendRedirect("user/user.jsp");
        }
    }

    /**
     * 验证用户名密码，返回角色（admin/user），失败返回 null
     */
    private String authenticate(String username, String password) {
        if (username == null || password == null) return null;

        if ("admin".equals(username) && "123456".equals(password)) {
            return "admin";
        }
        if ("user".equals(username) && "123456".equals(password)) {
            return "user";
        }
        return null;
    }
}
