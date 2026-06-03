package fun.javierchen.ch19.dao;

import fun.javierchen.ch19.DBUtil;
import fun.javierchen.ch19.entity.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 用户 DAO - 完整的 JDBC 增删改查实现
 *
 * 每个方法都有详细的注释，方便 IDEA debug 跟踪：
 *   1. 打断点在方法入口
 *   2. Step Over (F8) 逐行执行
 *   3. Watch 窗口观察 sql / 参数 / 返回值
 */
public class UserDao {

    // ==================== 增 (Create) ====================

    /**
     * 插入单个用户，返回自增主键
     *
     * @return 新插入记录的 id，失败返回 -1
     */
    public int insert(User user) {
        String sql = "INSERT INTO users (name, email, age) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            // 第二个参数 RETURN_GENERATED_KEYS 表示要获取自增主键
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setInt(3, user.getAge());

            int rows = ps.executeUpdate();  // ← debug: 观察 affected rows
            if (rows > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);    // ← debug: 观察生成的 id
                }
            }
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    /**
     * 批量插入用户（演示 addBatch / executeBatch）
     *
     * @return 每条语句影响的行数数组
     */
    public int[] batchInsert(List<User> users) {
        String sql = "INSERT INTO users (name, email, age) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);

            for (User user : users) {
                ps.setString(1, user.getName());
                ps.setString(2, user.getEmail());
                ps.setInt(3, user.getAge());
                ps.addBatch();               // ← debug: 观察批次积累
            }

            return ps.executeBatch();        // ← debug: 观察批量执行结果
        } catch (SQLException e) {
            e.printStackTrace();
            return new int[0];
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    // ==================== 删 (Delete) ====================

    /**
     * 根据 id 删除用户
     *
     * @return 删除的行数（0 = 未找到）
     */
    public int deleteById(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            return ps.executeUpdate();       // ← debug: 观察 affected rows
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    /**
     * 根据名字模糊删除（演示 LIKE 用法）
     *
     * @return 删除的行数
     */
    public int deleteByNameLike(String keyword) {
        String sql = "DELETE FROM users WHERE name LIKE ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");

            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    // ==================== 改 (Update) ====================

    /**
     * 更新用户信息（根据 id 全量更新 name / email / age）
     *
     * @return 更新的行数
     */
    public int update(User user) {
        String sql = "UPDATE users SET name = ?, email = ?, age = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setInt(3, user.getAge());
            ps.setInt(4, user.getId());

            return ps.executeUpdate();       // ← debug: 观察 affected rows
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    /**
     * 局部更新（只更新非 null 的字段，演示动态 SQL 拼接）
     *
     * @return 更新的行数
     */
    public int updatePartial(User user) {
        StringBuilder sql = new StringBuilder("UPDATE users SET ");
        List<Object> params = new ArrayList<>();

        // 动态拼接 SET 子句：只更新传入了值的字段
        if (user.getName() != null) {
            sql.append("name = ?, ");
            params.add(user.getName());
        }
        if (user.getEmail() != null) {
            sql.append("email = ?, ");
            params.add(user.getEmail());
        }
        if (user.getAge() != null) {
            sql.append("age = ?, ");
            params.add(user.getAge());
        }

        // 移除末尾多余的 ", "
        sql.delete(sql.length() - 2, sql.length());
        sql.append(" WHERE id = ?");
        params.add(user.getId());

        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql.toString());

            // ← debug: 观察动态生成的 SQL 和参数列表
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            DBUtil.close(conn, ps);
        }
    }

    // ==================== 查 (Read) ====================

    /**
     * 根据 id 查询单个用户
     *
     * @return 用户对象，未找到返回 null
     */
    public User findById(int id) {
        String sql = "SELECT id, name, email, age, created FROM users WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            rs = ps.executeQuery();          // ← debug: 观察 ResultSet
            if (rs.next()) {
                return mapRow(rs);           // ← debug: 进入 mapRow 看字段映射
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    /**
     * 查询所有用户
     *
     * @return 用户列表（可能为空 List，不会返回 null）
     */
    public List<User> findAll() {
        String sql = "SELECT id, name, email, age, created FROM users ORDER BY id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<User> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {              // ← debug: 观察遍历过程
                list.add(mapRow(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            return list;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    /**
     * 按名字模糊搜索
     *
     * @return 匹配的用户列表
     */
    public List<User> findByName(String keyword) {
        String sql = "SELECT id, name, email, age, created FROM users WHERE name LIKE ? ORDER BY id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<User> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + keyword + "%");

            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            return list;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    /**
     * 按年龄范围查询（演示多条件查询）
     *
     * @param minAge 最小年龄（含），传 null 表示不限
     * @param maxAge 最大年龄（含），传 null 表示不限
     * @return 符合条件的用户列表
     */
    public List<User> findByAgeRange(Integer minAge, Integer maxAge) {
        StringBuilder sql = new StringBuilder("SELECT id, name, email, age, created FROM users WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (minAge != null) {
            sql.append(" AND age >= ?");
            params.add(minAge);
        }
        if (maxAge != null) {
            sql.append(" AND age <= ?");
            params.add(maxAge);
        }
        sql.append(" ORDER BY age");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<User> list = new ArrayList<>();
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            return list;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    /**
     * 统计用户总数（演示聚合函数）
     *
     * @return 总行数
     */
    public int count() {
        String sql = "SELECT COUNT(*) FROM users";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    // ==================== 工具方法 ====================

    /**
     * 将 ResultSet 当前行映射为 User 对象
     * 抽取公共方法，避免重复代码
     */
    private User mapRow(ResultSet rs) throws SQLException {
        return new User(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("email"),
            (Integer) rs.getObject("age"),   // getInt 不能处理 NULL，用 getObject 安全转换
            rs.getTimestamp("created")
        );
    }
}
