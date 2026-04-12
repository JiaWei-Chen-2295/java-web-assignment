package fun.javierchen.ch09;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

/**
 * AJAX 用户名查重接口
 * GET /checkUsername?username=xxx
 * 返回 JSON: {"exists": true/false}
 */
@WebServlet("/checkUsername")
public class CheckUsernameServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        if (username == null || username.trim().isEmpty()) {
            out.print("{\"exists\":false}");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean exists = false;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT COUNT(*) FROM user WHERE username = ?");
            ps.setString(1, username.trim());
            rs = ps.executeQuery();
            if (rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }

        out.print("{\"exists\":" + exists + "}");
    }
}
