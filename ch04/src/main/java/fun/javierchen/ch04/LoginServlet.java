package fun.javierchen.ch04;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class LoginServlet extends HttpServlet {

    // 设置用户信息（用户名：学号+姓名，密码）
    private static final String VALID_USERNAME = "2023154202陈佳玮";
    private static final String VALID_PASSWORD = "123456";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 验证用户名和密码
        if (VALID_USERNAME.equals(username) && VALID_PASSWORD.equals(password)) {
            // 登录成功，设置属性并转发到成功页面
            String currentTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            request.setAttribute("username", username);
            request.setAttribute("loginTime", currentTime);
            request.getRequestDispatcher("welcome.jsp").forward(request, response);
        } else {
            // 登录失败，转发到失败页面
            request.getRequestDispatcher("failure.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // GET请求重定向到登录页面
        response.sendRedirect("login.jsp");
    }
}
