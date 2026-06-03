package fun.javierchen.ch19;

import fun.javierchen.ch19.dao.UserDao;
import fun.javierchen.ch19.entity.User;
import org.junit.jupiter.api.*;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * UserDao 增删改查完整测试
 *
 * ==================== IDEA Debug 指南 ====================
 *
 * 1. 运行单个测试方法：
 *    - 点击方法左边的绿色三角 ▶ 运行
 *    - 或右键方法名 -> Run
 *
 * 2. Debug 模式运行：
 *    - 点击方法左边的绿色虫子 🐛 Debug
 *    - 在 DAO 方法内部打断点（如 ps.executeUpdate() 那行）
 *    - F8 (Step Over) 逐行执行
 *    - F7 (Step Into) 进入方法内部
 *    - F9 (Resume) 继续执行到下一个断点
 *    - Watch 窗口添加表达式观察变量：sql, user, list 等
 *
 * 3. 推荐断点位置（在 UserDao.java 中）：
 *    - insert():     ps = conn.prepareStatement(sql, ...) 那行
 *    - findAll():    rs = ps.executeQuery() 那行
 *    - update():     ps.setInt(4, user.getId()) 那行
 *    - deleteById(): return ps.executeUpdate() 那行
 *
 * 4. 查看 SQL 执行详情：
 *    - IntelliJ Database 工具窗口 -> java_web -> users 表
 *    - 右键 -> Query Console 实时查看数据变化
 *
 * ============================================================
 *
 * 测试执行顺序：@Order 注解控制
 * 需要加 @TestMethodOrder(MethodOrderer.OrderAnnotation.class)
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class UserDaoTest {

    private static final UserDao userDao = new UserDao();

    // 用于跟踪测试间共享的 id
    private static int insertedId;

    // ==================== 增 (Create) ====================

    @Test
    @Order(1)
    @DisplayName("插入单个用户 - 返回自增 id")
    void testInsert() {
        User user = new User("赵六", "zhaoliu@example.com", 28);

        int id = userDao.insert(user);

        // 验证：id 应大于 0（插入成功）
        assertTrue(id > 0, "插入成功后应返回正整数 id，实际: " + id);
        insertedId = id;  // 保存供后续测试使用

        // 验证：能通过 id 查到这条记录
        User found = userDao.findById(id);
        assertNotNull(found, "插入后应能查到该记录");
        assertEquals("赵六", found.getName());
        assertEquals("zhaoliu@example.com", found.getEmail());
        assertEquals(28, found.getAge());
        assertNotNull(found.getCreated(), "created 字段应由数据库自动生成");

        System.out.println("✅ 插入成功，新 id = " + id);
        System.out.println("   查回数据: " + found);
    }

    @Test
    @Order(2)
    @DisplayName("批量插入用户 -演示 addBatch")
    void testBatchInsert() {
        List<User> users = List.of(
            new User("测试A", "testa@example.com", 20),
            new User("测试B", "testb@example.com", 25),
            new User("测试C", "testc@example.com", 35)
        );

        int[] results = userDao.batchInsert(users);

        // 验证：每条都影响 1 行
        assertEquals(3, results.length, "应返回 3 条执行结果");
        for (int i = 0; i < results.length; i++) {
            assertEquals(1, results[i], "第 " + (i + 1) + " 条应影响 1 行");
        }

        System.out.println("✅ 批量插入成功，共 " + results.length + " 条");
    }

    // ==================== 查 (Read) ====================

    @Test
    @Order(10)
    @DisplayName("按 id 查询 - 存在的记录")
    void testFindById_existing() {
        User user = userDao.findById(insertedId);

        assertNotNull(user, "应能查到刚插入的记录");
        assertEquals(insertedId, user.getId());
        assertEquals("赵六", user.getName());

        System.out.println("✅ 按 id 查询成功: " + user);
    }

    @Test
    @Order(11)
    @DisplayName("按 id 查询 - 不存在的记录返回 null")
    void testFindById_notExisting() {
        User user = userDao.findById(999999);

        assertNull(user, "查询不存在的 id 应返回 null");

        System.out.println("✅ 查询不存在的 id 正确返回 null");
    }

    @Test
    @Order(12)
    @DisplayName("查询所有用户 - 返回列表")
    void testFindAll() {
        List<User> list = userDao.findAll();

        assertNotNull(list, "返回值不应为 null");
        // 初始化脚本插了 3 条 + 本测试插了 1 条 + 批量 3 条 = 7 条
        assertTrue(list.size() >= 4, "至少应有 4 条记录，实际: " + list.size());

        // 验证按 id 排序
        for (int i = 1; i < list.size(); i++) {
            assertTrue(list.get(i).getId() > list.get(i - 1).getId(),
                "结果应按 id 升序排列");
        }

        System.out.println("✅ 查询所有用户，共 " + list.size() + " 条:");
        list.forEach(u -> System.out.println("   " + u));
    }

    @Test
    @Order(13)
    @DisplayName("按名字模糊搜索")
    void testFindByName() {
        List<User> list = userDao.findByName("测试");

        assertNotNull(list);
        // 批量插入了 测试A, 测试B, 测试C
        assertTrue(list.size() >= 3, "应找到至少 3 条 '测试' 开头的记录");

        // 验证每条结果的名字都包含 "测试"
        for (User u : list) {
            assertTrue(u.getName().contains("测试"),
                "搜索结果应包含关键字，实际: " + u.getName());
        }

        System.out.println("✅ 模糊搜索 '测试'，找到 " + list.size() + " 条:");
        list.forEach(u -> System.out.println("   " + u));
    }

    @Test
    @Order(14)
    @DisplayName("按年龄范围查询")
    void testFindByAgeRange() {
        List<User> list = userDao.findByAgeRange(25, 30);

        assertNotNull(list);
        for (User u : list) {
            assertTrue(u.getAge() >= 25 && u.getAge() <= 30,
                "年龄应在 [25,30] 范围内，实际: " + u.getAge());
        }

        System.out.println("✅ 年龄范围 [25,30] 查询，找到 " + list.size() + " 条:");
        list.forEach(u -> System.out.println("   " + u));
    }

    @Test
    @Order(15)
    @DisplayName("统计用户总数")
    void testCount() {
        int total = userDao.count();

        assertTrue(total >= 4, "总记录数应 >= 4，实际: " + total);

        System.out.println("✅ 用户总数: " + total);
    }

    // ==================== 改 (Update) ====================

    @Test
    @Order(20)
    @DisplayName("全量更新用户信息")
    void testUpdate() {
        // 先查出来
        User user = userDao.findById(insertedId);
        assertNotNull(user);

        // 修改字段
        user.setName("赵六（已修改）");
        user.setEmail("zhaoliu_updated@example.com");
        user.setAge(29);

        int rows = userDao.update(user);

        // 验证：影响 1 行
        assertEquals(1, rows, "应更新 1 行");

        // 验证：查回来确认更新生效
        User updated = userDao.findById(insertedId);
        assertNotNull(updated);
        assertEquals("赵六（已修改）", updated.getName());
        assertEquals("zhaoliu_updated@example.com", updated.getEmail());
        assertEquals(29, updated.getAge());

        System.out.println("✅ 全量更新成功: " + updated);
    }

    @Test
    @Order(21)
    @DisplayName("局部更新 - 只改 name，其他字段不变")
    void testUpdatePartial() {
        // 先查出当前状态
        User before = userDao.findById(insertedId);
        assertNotNull(before);
        String originalEmail = before.getEmail();
        int originalAge = before.getAge();

        // 只更新 name
        User patch = new User();
        patch.setId(insertedId);
        patch.setName("赵六（二次修改）");

        int rows = userDao.updatePartial(patch);
        assertEquals(1, rows, "应更新 1 行");

        // 验证：name 变了，email 和 age 没变
        User after = userDao.findById(insertedId);
        assertNotNull(after);
        assertEquals("赵六（二次修改）", after.getName(), "name 应已更新");
        assertEquals(originalEmail, after.getEmail(), "email 不应被修改");
        assertEquals(originalAge, after.getAge(), "age 不应被修改");

        System.out.println("✅ 局部更新成功: " + after);
    }

    // ==================== 删 (Delete) ====================

    @Test
    @Order(30)
    @DisplayName("按 id 删除用户")
    void testDeleteById() {
        // 先插入一条待删除的
        User temp = new User("待删除", "delete_me@example.com", 99);
        int tempId = userDao.insert(temp);
        assertTrue(tempId > 0, "待删除记录应插入成功");

        // 删除
        int rows = userDao.deleteById(tempId);
        assertEquals(1, rows, "应删除 1 行");

        // 验证：查不到了
        User deleted = userDao.findById(tempId);
        assertNull(deleted, "删除后不应再查到该记录");

        System.out.println("✅ 按 id 删除成功，已删除 id=" + tempId);
    }

    @Test
    @Order(31)
    @DisplayName("删除不存在的记录 - 返回 0")
    void testDeleteById_notExisting() {
        int rows = userDao.deleteById(999999);

        assertEquals(0, rows, "删除不存在的记录应返回 0");

        System.out.println("✅ 删除不存在的记录正确返回 0");
    }

    @Test
    @Order(32)
    @DisplayName("按名字模糊删除")
    void testDeleteByNameLike() {
        // 先插入一条带特定前缀的
        userDao.insert(new User("批量删除_X", "del@example.com", 10));
        userDao.insert(new User("批量删除_Y", "del2@example.com", 11));

        int rows = userDao.deleteByNameLike("批量删除");

        assertTrue(rows >= 2, "应至少删除 2 条，实际: " + rows);

        // 验证：模糊搜索不应再找到
        List<User> remaining = userDao.findByName("批量删除");
        assertEquals(0, remaining.size(), "删除后不应再有 '批量删除' 的记录");

        System.out.println("✅ 按名字模糊删除成功，共删除 " + rows + " 条");
    }

    // ==================== 清理 / 汇总 ====================

    @Test
    @Order(99)
    @DisplayName("最终数据快照 - 查看所有剩余记录")
    void testFinalSnapshot() {
        List<User> all = userDao.findAll();
        int total = userDao.count();

        assertEquals(all.size(), total, "findAll 和 count 结果应一致");

        System.out.println("\n========== 最终数据快照 ==========");
        System.out.println("总记录数: " + total);
        System.out.println("--------");
        all.forEach(u -> System.out.println(u));
        System.out.println("==================================\n");
    }
}
