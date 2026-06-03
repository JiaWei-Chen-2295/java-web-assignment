package fun.javierchen.ch19;

import java.sql.*;

/**
 * JDBC 工具类 - 数据库连接与资源关闭
 * 复用 ch18 的连接配置（java_web 库）
 */
public class DBUtil {

    private static final String URL = "jdbc:mysql://localhost:3306/java_web?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "cjw2295cjw";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL 驱动加载失败", e);
        }
    }

    /**
     * 获取数据库连接
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    /**
     * 关闭资源（按 rs -> stmt -> conn 顺序）
     */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
        try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }

    /**
     * 关闭资源（无 ResultSet）
     */
    public static void close(Connection conn, Statement stmt) {
        close(conn, stmt, null);
    }
}
