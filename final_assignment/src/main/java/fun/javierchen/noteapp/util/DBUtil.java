package fun.javierchen.noteapp.util;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import java.io.IOException;
import java.io.InputStream;

/**
 * MyBatis SqlSession 工具类
 */
public class DBUtil {

    private static final SqlSessionFactory sqlSessionFactory;

    static {
        try {
            String resource = "mybatis-config.xml";
            InputStream inputStream = Resources.getResourceAsStream(resource);
            sqlSessionFactory = new SqlSessionFactoryBuilder().build(inputStream);
        } catch (IOException e) {
            throw new RuntimeException("初始化 SqlSessionFactory 失败", e);
        }
    }

    /**
     * 获取 SqlSession（需手动关闭）
     */
    public static SqlSession getSqlSession() {
        return sqlSessionFactory.openSession();
    }

    /**
     * 获取自动提交的 SqlSession
     */
    public static SqlSession getAutoCommitSqlSession() {
        return sqlSessionFactory.openSession(true);
    }
}
