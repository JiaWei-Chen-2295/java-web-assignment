package fun.javierchen.ch09;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

/**
 * 用户注册处理
 * POST /register
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email    = req.getParameter("email");
        String phone    = req.getParameter("phone");

        // 基本校验
        if (username == null || username.isBlank()
                || password == null || password.isBlank()) {
            req.setAttribute("error", "用户名和密码不能为空");
            req.getRequestDispatcher("register.jsp").forward(req, resp);
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();

            // 查重
            ps = conn.prepareStatement("SELECT COUNT(*) FROM user WHERE username = ?");
            ps.setString(1, username.trim());
            ResultSet rs = ps.executeQuery();
            rs.next();
            if (rs.getInt(1) > 0) {
                req.setAttribute("error", "用户名已存在");
                req.getRequestDispatcher("register.jsp").forward(req, resp);
                return;
            }
            rs.close();
            ps.close();

            // 插入
            ps = conn.prepareStatement(
                    "INSERT INTO user (username, password, email, phone) VALUES (?, ?, ?, ?)");
            ps.setString(1, username.trim());
            ps.setString(2, password);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.executeUpdate();

            req.setAttribute("success", true);
            req.getRequestDispatcher("login.jsp").forward(req, resp);

        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "注册失败: " + e.getMessage());
            req.getRequestDispatcher("register.jsp").forward(req, resp);
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }
}
