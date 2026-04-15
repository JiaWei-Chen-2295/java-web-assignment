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

@WebServlet("/sendCookieServlet")
public class SendCookieServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String studentId = req.getParameter("studentId");
        String password = req.getParameter("password");

        User user = MockDatabase.findUserByStudentId(studentId);

        if (user == null || !user.getPassword().equals(password)) {
            req.setAttribute("error", "学号或密码不正确");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        // Login success - set cookies for 5 minutes
        Cookie idCookie = new Cookie("user_id", studentId);
        Cookie nameCookie = new Cookie("user_name", URLEncoder.encode(user.getName(), StandardCharsets.UTF_8));
        
        idCookie.setMaxAge(5 * 60); // 300 seconds
        nameCookie.setMaxAge(5 * 60);
        
        resp.addCookie(idCookie);
        resp.addCookie(nameCookie);

        resp.sendRedirect("welcome.jsp");
    }
}
