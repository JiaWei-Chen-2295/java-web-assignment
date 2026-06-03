package fun.javierchen.ch18;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/users")
public class UserListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Map<String, Object>> userList = new ArrayList<>();
        String error = null;

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT id, name, email, age, created FROM users ORDER BY id");
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                row.put("id", rs.getInt("id"));
                row.put("name", rs.getString("name"));
                row.put("email", rs.getString("email"));
                row.put("age", rs.getInt("age"));
                row.put("created", rs.getTimestamp("created"));
                userList.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            error = "数据库查询失败: " + e.getMessage();
        } finally {
            DBUtil.close(conn, ps, rs);
        }

        req.setAttribute("userList", userList);
        req.setAttribute("error", error);
        req.getRequestDispatcher("/index.jsp").forward(req, resp);
    }
}
