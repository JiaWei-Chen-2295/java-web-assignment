package fun.javierchen.sessionprofile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet("/doLogin")
public class LoginServlet extends HttpServlet {

    // 模拟用户数据库
    private static final Map<String, String> USERS = new ConcurrentHashMap<>();

    static {
        USERS.put("admin", "123456");
        USERS.put("javierchen", "hello");
        USERS.put("demo", "demo");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String captchaInput = req.getParameter("captcha");

        HttpSession session = req.getSession();
        String captchaExpected = (String) session.getAttribute("captcha");

        // 验证码校验（忽略大小写）
        if (captchaExpected == null || captchaInput == null
                || !captchaExpected.equalsIgnoreCase(captchaInput.trim())) {
            req.setAttribute("error", "验证码错误");
            req.setAttribute("username", username);
            req.getRequestDispatcher("login-session.jsp").forward(req, resp);
            return;
        }

        // 清除已使用的验证码
        session.removeAttribute("captcha");

        // 用户名校验
        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            req.setAttribute("error", "用户名和密码不能为空");
            req.setAttribute("username", username);
            req.getRequestDispatcher("login-session.jsp").forward(req, resp);
            return;
        }

        String stored = USERS.get(username.trim());
        if (stored == null || !stored.equals(password)) {
            req.setAttribute("error", "用户名或密码错误");
            req.setAttribute("username", username);
            req.getRequestDispatcher("login-session.jsp").forward(req, resp);
            return;
        }

        // 登录成功，存入 session
        session.setAttribute("loginUser", username.trim());
        session.setAttribute("loginTime", java.time.LocalDateTime.now()
                .format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

        resp.sendRedirect("profile.jsp");
    }
}
