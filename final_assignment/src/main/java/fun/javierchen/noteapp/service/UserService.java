package fun.javierchen.noteapp.service;

import fun.javierchen.noteapp.mapper.UserMapper;
import fun.javierchen.noteapp.model.entity.User;
import fun.javierchen.noteapp.util.DBUtil;
import fun.javierchen.noteapp.util.PasswordUtil;
import org.apache.ibatis.session.SqlSession;

public class UserService {

    public User register(String username, String password, String email) {
        SqlSession session = DBUtil.getSqlSession();
        try {
            UserMapper userMapper = session.getMapper(UserMapper.class);

            // check username uniqueness
            if (userMapper.selectByUsername(username) != null) {
                throw new RuntimeException("Username already exists: " + username);
            }

            // check email uniqueness
            if (userMapper.selectByEmail(email) != null) {
                throw new RuntimeException("Email already exists: " + email);
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(PasswordUtil.hash(password));
            user.setEmail(email);

            userMapper.insert(user);
            session.commit();
            return user;
        } catch (Exception e) {
            session.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public User login(String username, String password) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            UserMapper userMapper = session.getMapper(UserMapper.class);
            User user = userMapper.selectByUsername(username);
            if (user != null && PasswordUtil.verify(password, user.getPassword())) {
                return user;
            }
            return null;
        } finally {
            session.close();
        }
    }

    public User getUserById(Long id) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            UserMapper userMapper = session.getMapper(UserMapper.class);
            return userMapper.selectById(id);
        } finally {
            session.close();
        }
    }
}
