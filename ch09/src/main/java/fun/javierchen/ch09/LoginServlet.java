package fun.javierchen.ch09;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

/**
 * 用户登录处理
 * POST /login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.isBlank()
                || password == null || password.isBlank()) {
            req.setAttribute("error", "用户名和密码不能为空");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(
                    "SELECT * FROM user WHERE username = ? AND password = ?");
            ps.setString(1, username.trim());
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                // 登录成功
                HttpSession session = req.getSession();
                session.setAttribute("loginUser", username.trim());
                resp.sendRedirect("welcome.jsp");
            } else {
                req.setAttribute("error", "用户名或密码错误");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "登录失败: " + e.getMessage());
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }
}
