package fun.auth;

import java.util.HashMap;
import java.util.Map;

public class MockDatabase {
    private static Map<String, User> users = new HashMap<>();

    static {
        // Mock data initialization
        users.put("2024001", new User("2024001", "张三", "123456"));
    }

    public static User findUserByStudentId(String studentId) {
        return users.get(studentId);
    }

    public static void addUser(User user) {
        users.put(user.getStudentId(), user);
    }

    public static boolean exists(String studentId) {
        return users.containsKey(studentId);
    }
}
