package fun.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/registerServlet")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String studentId = req.getParameter("studentId");
        String name = req.getParameter("name");
        String password = req.getParameter("password");

        if (studentId == null || name == null || password == null || studentId.isEmpty() || name.isEmpty() || password.isEmpty()) {
            req.setAttribute("error", "所有字段均为必填项");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        if (MockDatabase.exists(studentId)) {
            req.setAttribute("error", "该学号已注册");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        User newUser = new User(studentId, name, password);
        MockDatabase.addUser(newUser);

        // 注册成功，根据要求进入5分钟免登录页面 (设置Cookie)
        Cookie idCookie = new Cookie("user_id", studentId);
        Cookie nameCookie = new Cookie("user_name", URLEncoder.encode(name, StandardCharsets.UTF_8));
        
        idCookie.setMaxAge(5 * 60); // 5 minutes
        nameCookie.setMaxAge(5 * 60);
        
        resp.addCookie(idCookie);
        resp.addCookie(nameCookie);

        resp.sendRedirect("welcome.jsp");
    }
}
