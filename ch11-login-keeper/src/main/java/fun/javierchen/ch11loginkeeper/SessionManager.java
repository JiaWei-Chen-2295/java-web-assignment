package fun.javierchen.ch11loginkeeper;

import jakarta.enterprise.context.ApplicationScoped;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@ApplicationScoped
public class SessionManager {
    private static final SessionManager instance = new SessionManager();
    public static SessionManager getInstance() { return instance; }

    // Key: Session ID, Value: UserInfo
    private final Map<String, UserInfo> sessionUserMap = new ConcurrentHashMap<>();
    
    public SessionManager() {
    }

    public void register(String username, String password) {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("INSERT INTO user (username, password) VALUES (?, ?)");
            ps.setString(1, username);
            ps.setString(2, password);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new RuntimeException("Register failed", e);
        } finally {
            DBUtil.close(conn, ps, null);
        }
    }

    public boolean validate(String username, String password) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT * FROM user WHERE username = ? AND password = ?");
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBUtil.close(conn, ps, rs);
        }
    }

    public boolean isUserRegistered(String username) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement("SELECT COUNT(*) FROM user WHERE username = ?");
            ps.setString(1, username);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, ps, rs);
        }
        return false;
    }

    public void login(String sessionId, String username) {
        sessionUserMap.put(sessionId, new UserInfo(username));
    }

    public void logout(String sessionId) {
        sessionUserMap.remove(sessionId);
    }

    public UserInfo getUserInfo(String sessionId) {
        return sessionUserMap.get(sessionId);
    }

    public String getUsername(String sessionId) {
        UserInfo userInfo = sessionUserMap.get(sessionId);
        return userInfo != null ? userInfo.getUsername() : null;
    }

    public Map<String, UserInfo> getActiveSessions() {
        return sessionUserMap;
    }
}
