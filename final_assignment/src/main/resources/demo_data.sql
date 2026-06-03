-- =============================================================================
-- 演示数据：个人知识管理笔记（知识图谱可视化）
-- 账号: demo / demo123
-- 邮箱: demo@noteapp.local
-- 执行: mysql -u root -p note_app < src/main/resources/demo_data.sql
-- =============================================================================

USE note_app;
SET NAMES utf8mb4;

-- 清理旧演示账号（级联删除笔记、链接、文件夹、标签等）
DELETE FROM users WHERE username = 'demo';

-- 演示用户（密码 demo123，BCrypt）
INSERT INTO users (username, password, email, avatar, bio, created_at, updated_at)
VALUES (
    'demo',
    '$2b$10$fPfvqp3v53S68nviOPEX4./ODVtU1j0kqltbs5KvyiVTU82HgDn3.',
    'demo@noteapp.local',
    NULL,
    'Demo account for knowledge graph.',
    NOW(),
    NOW()
);

SET @uid = LAST_INSERT_ID();

-- -----------------------------------------------------------------------------
-- 文件夹
-- -----------------------------------------------------------------------------
INSERT INTO folders (user_id, parent_id, name, icon, sort_order) VALUES
(@uid, NULL, 'Java Web 学习', 'folder', 0);
SET @f_root = LAST_INSERT_ID();

INSERT INTO folders (user_id, parent_id, name, icon, sort_order) VALUES
(@uid, @f_root, '基础与协议', 'folder', 1),
(@uid, @f_root, '视图与 MVC', 'folder', 2),
(@uid, @f_root, '数据持久化', 'folder', 3),
(@uid, @f_root, '会话与安全', 'folder', 4),
(@uid, @f_root, '工程与部署', 'folder', 5),
(@uid, @f_root, '本笔记平台', 'book', 6);

SET @f_basic = @f_root + 1;
SET @f_view  = @f_root + 2;
SET @f_data  = @f_root + 3;
SET @f_sec   = @f_root + 4;
SET @f_ops   = @f_root + 5;
SET @f_app   = @f_root + 6;

-- -----------------------------------------------------------------------------
-- 标签
-- -----------------------------------------------------------------------------
INSERT INTO tags (user_id, name, color) VALUES
(@uid, '核心', '#7C3AED'),
(@uid, '实验', '#2563EB'),
(@uid, '安全', '#DC2626'),
(@uid, '图谱', '#059669'),
(@uid, '期末', '#D97706');

SET @tag_core = LAST_INSERT_ID();
SET @tag_lab  = @tag_core + 1;
SET @tag_sec  = @tag_core + 2;
SET @tag_graph = @tag_core + 3;
SET @tag_final = @tag_core + 4;

-- -----------------------------------------------------------------------------
-- 笔记（Markdown + [[双向链接]]，便于编辑页与图谱一致）
-- -----------------------------------------------------------------------------
INSERT INTO notes (user_id, folder_id, title, content, content_format, summary, is_pinned, is_favorite, word_count, view_count, sort_order) VALUES
(@uid, @f_root, 'Java Web 知识体系',
'# Java Web 知识体系\n\n本笔记是整张知识网络的**中心节点**，串联课程各模块。\n\n## 学习路径\n\n1. 先掌握 [[HTTP 协议基础]] 与 [[请求与响应对象]]\n2. 理解 [[Servlet 生命周期]] 与 [[Filter 过滤器链]]\n3. 学习 [[JSP 语法入门]]、[[EL 表达式语言]]、[[JSTL 标签库]]\n4. 数据层见 [[JDBC 数据库编程]] 与 [[MyBatis 持久层框架]]\n5. 会话与安全：[[HttpSession 会话机制]]、[[Web 登录鉴权方案]]\n6. 工程化：[[Maven 构建与依赖]]、[[Tomcat 部署运维]]\n7. 本项目的亮点：[[知识图谱可视化（本项目）]]\n\n> 打开左侧「知识图谱」可查看节点聚类与引用密度。',
'markdown', 'Java Web 全栈知识地图与推荐学习顺序', 1, 1, 280, 42, 0),

(@uid, @f_basic, 'HTTP 协议基础',
'# HTTP 协议基础\n\n无状态、请求/响应模型，是 Web 的基石。\n\n- 常见方法：GET、POST、PUT、DELETE\n- 状态码：2xx 成功、3xx 重定向、4xx 客户端错误、5xx 服务端错误\n- 与 [[请求与响应对象]] 在 Servlet 中的对应关系\n- 上层入口：[[Servlet 生命周期]]\n\n参见总览：[[Java Web 知识体系]]',
'markdown', 'HTTP 方法、状态码与 Web 通信模型', 0, 0, 120, 18, 1),

(@uid, @f_basic, 'Servlet 生命周期',
'# Servlet 生命周期\n\n`init` → `service` → `destroy`，由容器管理实例。\n\n- 一个请求对应一次 `service` 调用\n- 可配合 [[Filter 过滤器链]] 与 [[Listener 事件监听]]\n- 处理细节见 [[请求与响应对象]]\n- 架构模式：[[MVC 设计模式]]\n\n回到地图：[[Java Web 知识体系]]',
'markdown', 'Servlet 初始化、服务与销毁流程', 1, 0, 95, 25, 2),

(@uid, @f_basic, '请求与响应对象',
'# 请求与响应对象\n\n`HttpServletRequest` / `HttpServletResponse` 封装协议细节。\n\n- 参数、头信息、字符编码\n- 转发 `forward` 与重定向 `redirect`\n- 与 [[HTTP 协议基础]] 概念一一对应\n- 在 [[Servlet 生命周期]] 的 `service` 中使用\n- 上传场景：[[文件上传处理]]',
'markdown', 'Request/Response API 与转发重定向', 0, 0, 88, 12, 3),

(@uid, @f_view, 'JSP 语法入门',
'# JSP 语法入门\n\n在 HTML 中嵌入 Java 脚本，现已更多用 EL/JSTL 替代脚本段。\n\n- 脚本元素、表达式、声明\n- 与 [[JSP 指令与动作]] 配合\n- 视图层组合：[[EL 表达式语言]]、[[JSTL 标签库]]\n- 归入 [[MVC 设计模式]] 的 View 层\n\n总览：[[Java Web 知识体系]]',
'markdown', 'JSP 脚本元素与页面结构', 0, 0, 102, 9, 4),

(@uid, @f_view, 'JSP 指令与动作',
'# JSP 指令与动作\n\n- 指令：`<%@ page %>`, `include`, `taglib`\n- 动作：`<jsp:include>`, `<jsp:forward>`\n- 对比静态包含与 [[JSP 语法入门]] 中的动态包含\n\n相关：[[EL 表达式语言]]',
'markdown', 'page/include/taglib 与 jsp 标准动作', 0, 0, 76, 7, 5),

(@uid, @f_view, 'EL 表达式语言',
'# EL 表达式语言\n\n`${}` 访问域中属性，弱化 Java 脚本。\n\n- 隐式对象：`param`、`sessionScope` 等\n- 常与 [[JSTL 标签库]] 一起使用\n- 前置：[[JSP 语法入门]]\n- MVC 视图：[[MVC 设计模式]]',
'markdown', 'EL 隐式对象与表达式求值', 0, 0, 70, 11, 6),

(@uid, @f_view, 'JSTL 标签库',
'# JSTL 标签库\n\n核心、格式化、SQL（慎用）、XML、函数库。\n\n- `<c:if>`, `<c:forEach>` 最常用\n- 依赖 [[EL 表达式语言]]\n- 见 [[JSP 语法入门]]\n- 控制器仍由 [[Servlet 生命周期]] 承担',
'markdown', 'JSTL 核心标签与 EL 协作', 0, 0, 82, 8, 7),

(@uid, @f_view, 'MVC 设计模式',
'# MVC 设计模式\n\nModel（数据/业务）、View（JSP/模板）、Controller（Servlet）。\n\n- [[Servlet 生命周期]] 充当 Controller\n- [[JSP 语法入门]] / [[JSTL 标签库]] 充当 View\n- [[MyBatis 持久层框架]] 辅助 Model 持久化\n- 总览：[[Java Web 知识体系]]',
'markdown', 'MVC 三层职责划分与 Java Web 映射', 0, 1, 90, 15, 8),

(@uid, @f_data, 'JDBC 数据库编程',
'# JDBC 数据库编程\n\n`DriverManager` / `DataSource` → `Connection` → `Statement` → `ResultSet`。\n\n- 关注 SQL 注入与资源关闭\n- 框架演进：[[MyBatis 持久层框架]]\n- 回到 [[Java Web 知识体系]]',
'markdown', 'JDBC 连接、执行与结果集处理', 0, 0, 85, 14, 9),

(@uid, @f_data, 'MyBatis 持久层框架',
'# MyBatis 持久层框架\n\nORM 半自动框架：Mapper 接口 + XML/注解 SQL。\n\n- 对比 [[JDBC 数据库编程]] 的样板代码\n- 用于本项目的 DAO 层（见 [[知识图谱可视化（本项目）]]）\n- 配合 [[Maven 构建与依赖]] 管理依赖\n- 架构位置：[[MVC 设计模式]] 的 Model',
'markdown', 'MyBatis Mapper 与 SQL 映射', 1, 0, 98, 20, 10),

(@uid, @f_sec, 'HttpSession 会话机制',
'# HttpSession 会话机制\n\n服务器端会话，默认 Cookie 传递 `JSESSIONID`。\n\n- 与 [[Cookie 状态管理]] 对比\n- 登录态：[[Web 登录鉴权方案]]\n- 销毁与监听：[[Listener 事件监听]]\n- 总览：[[Java Web 知识体系]]',
'markdown', 'Session 创建、属性与失效', 0, 0, 88, 16, 11),

(@uid, @f_sec, 'Cookie 状态管理',
'# Cookie 状态管理\n\n客户端小型键值存储，可设 `maxAge`、`path`、`httpOnly`。\n\n- 与 [[HttpSession 会话机制]] 配合实现「记住我」\n- 安全注意：[[Web 登录鉴权方案]]\n- 过滤器可统一处理：[[Filter 过滤器链]]',
'markdown', 'Cookie 读写属性与安全属性', 0, 0, 72, 10, 12),

(@uid, @f_sec, 'Filter 过滤器链',
'# Filter 过滤器链\n\n请求进入 Servlet **之前/之后** 的横切逻辑。\n\n- 典型：编码、登录校验、日志\n- 衔接 [[Servlet 生命周期]]\n- 鉴权案例：[[Web 登录鉴权方案]]\n- 见 [[Java Web 知识体系]]',
'markdown', 'Filter 链顺序与登录编码示例', 0, 0, 80, 19, 13),

(@uid, @f_sec, 'Listener 事件监听',
'# Listener 事件监听\n\n监听 ServletContext、Session、Request 生命周期事件。\n\n- 在线人数统计、应用初始化\n- 与 [[HttpSession 会话机制]] 相关\n- 部署在 [[Tomcat 部署运维]] 容器内',
'markdown', 'Servlet 规范中的监听器类型', 0, 0, 65, 6, 14),

(@uid, @f_sec, 'Web 登录鉴权方案',
'# Web 登录鉴权方案\n\n表单登录 + Session/Cookie；Filter 拦截受保护资源。\n\n- 状态：[[HttpSession 会话机制]]、[[Cookie 状态管理]]\n- 横切：[[Filter 过滤器链]]\n- 持久化用户表：[[JDBC 数据库编程]] / [[MyBatis 持久层框架]]',
'markdown', '登录流程、Session 与 Filter 拦截', 0, 1, 92, 22, 15),

(@uid, @f_ops, 'Maven 构建与依赖',
'# Maven 构建与依赖\n\n`pom.xml` 管理坐标、打包为 WAR。\n\n- 部署目标：[[Tomcat 部署运维]]\n- 引入 [[MyBatis 持久层框架]]、MySQL 驱动等\n- 总览：[[Java Web 知识体系]]',
'markdown', 'Maven 坐标、生命周期与 WAR 打包', 0, 0, 68, 8, 16),

(@uid, @f_ops, 'Tomcat 部署运维',
'# Tomcat 部署运维\n\n将 WAR 放入 `webapps`，配置端口与数据源。\n\n- 构建产物来自 [[Maven 构建与依赖]]\n- 运行 [[Servlet 生命周期]] 与 [[JSP 语法入门]]\n- 本笔记应用同样部署在 Tomcat',
'markdown', 'Tomcat 目录结构、部署与端口配置', 0, 0, 74, 9, 17),

(@uid, @f_basic, '文件上传处理',
'# 文件上传处理\n\n`multipart/form-data` + `@MultipartConfig` 或 Apache Commons FileUpload。\n\n- 基于 [[请求与响应对象]] 读取 Part\n- Controller：[[Servlet 生命周期]]\n- 存储路径可在 [[Tomcat 部署运维]] 外置',
'markdown', 'multipart 解析与文件保存', 0, 0, 60, 5, 18),

(@uid, @f_app, '双向链接原理',
'# 双向链接原理\n\nObsidian / Roam 风格：笔记 A 引用 B 时，B 的「反向链接」自动可见。\n\n- 正文使用 [[Wikilink 维基链接]] 语法\n- 存储于 `note_links` 表\n- 可视化：[[知识图谱可视化（本项目）]]\n- 实现：[[MyBatis 持久层框架]] + [[Servlet 生命周期]]',
'markdown', '双向链接与反向链接的数据模型', 0, 1, 110, 28, 19),

(@uid, @f_app, 'Wikilink 维基链接',
'# Wikilink 维基链接\n\n支持 `[[标题]]`、`[[标题#id]]`、`[[#id]]`。\n\n- 保存时由 LinkParser 规范化\n- 图谱边来自解析结果写入 `note_links`\n- 详见 [[双向链接原理]] 与 [[知识图谱可视化（本项目）]]',
'markdown', '维基链接语法与解析规则', 0, 0, 85, 17, 20),

(@uid, @f_app, '知识图谱可视化（本项目）',
'# 知识图谱可视化（本项目）\n\nECharts 力导向图展示笔记节点与引用边。\n\n- 数据接口：`/api/graph`\n- 节点大小 ∝ 链接数；点击跳转编辑页\n- 依赖 [[双向链接原理]]、[[Wikilink 维基链接]]\n- 技术栈：[[MyBatis 持久层框架]]、[[Maven 构建与依赖]]、[[Tomcat 部署运维]]\n- 课程总览：[[Java Web 知识体系]]',
'markdown', '力导向知识图谱与 note_links 数据', 1, 1, 125, 35, 21);

-- -----------------------------------------------------------------------------
-- 笔记-标签关联
-- -----------------------------------------------------------------------------
INSERT INTO note_tags (note_id, tag_id)
SELECT n.id, @tag_core FROM notes n WHERE n.user_id = @uid AND n.title IN (
    'Java Web 知识体系', 'Servlet 生命周期', 'MVC 设计模式', 'MyBatis 持久层框架'
);
INSERT INTO note_tags (note_id, tag_id)
SELECT n.id, @tag_lab FROM notes n WHERE n.user_id = @uid AND n.title IN (
    'HTTP 协议基础', '请求与响应对象', '文件上传处理', 'JDBC 数据库编程'
);
INSERT INTO note_tags (note_id, tag_id)
SELECT n.id, @tag_sec FROM notes n WHERE n.user_id = @uid AND n.title IN (
    'HttpSession 会话机制', 'Cookie 状态管理', 'Filter 过滤器链', 'Web 登录鉴权方案'
);
INSERT INTO note_tags (note_id, tag_id)
SELECT n.id, @tag_graph FROM notes n WHERE n.user_id = @uid AND n.title IN (
    '双向链接原理', 'Wikilink 维基链接', '知识图谱可视化（本项目）'
);
INSERT INTO note_tags (note_id, tag_id)
SELECT n.id, @tag_final FROM notes n WHERE n.user_id = @uid;

-- -----------------------------------------------------------------------------
-- 双向链接（知识图谱边）— 形成多簇、有中心的网状结构
-- -----------------------------------------------------------------------------
INSERT INTO note_links (source_id, target_id)
SELECT s.id, t.id FROM notes s, notes t
WHERE s.user_id = @uid AND t.user_id = @uid
  AND s.title = 'Java Web 知识体系' AND t.title IN (
    'HTTP 协议基础', 'Servlet 生命周期', 'JSP 语法入门', 'JDBC 数据库编程',
    'HttpSession 会话机制', 'Filter 过滤器链', 'Maven 构建与依赖', 'Tomcat 部署运维',
    '知识图谱可视化（本项目）', 'MVC 设计模式', 'MyBatis 持久层框架'
);

INSERT INTO note_links (source_id, target_id)
SELECT s.id, t.id FROM notes s, notes t
WHERE s.user_id = @uid AND t.user_id = @uid
  AND (
    (s.title = 'HTTP 协议基础' AND t.title IN ('请求与响应对象', 'Servlet 生命周期', 'Java Web 知识体系'))
    OR (s.title = 'Servlet 生命周期' AND t.title IN ('Filter 过滤器链', 'Listener 事件监听', 'MVC 设计模式', '请求与响应对象', 'Java Web 知识体系', '文件上传处理'))
    OR (s.title = '请求与响应对象' AND t.title IN ('HTTP 协议基础', 'Servlet 生命周期', '文件上传处理'))
    OR (s.title = 'JSP 语法入门' AND t.title IN ('JSP 指令与动作', 'EL 表达式语言', 'JSTL 标签库', 'MVC 设计模式', 'Java Web 知识体系'))
    OR (s.title = 'JSP 指令与动作' AND t.title IN ('JSP 语法入门', 'EL 表达式语言'))
    OR (s.title = 'EL 表达式语言' AND t.title IN ('JSTL 标签库', 'JSP 语法入门', 'MVC 设计模式'))
    OR (s.title = 'JSTL 标签库' AND t.title IN ('EL 表达式语言', 'MVC 设计模式', 'JSP 语法入门', 'Servlet 生命周期'))
    OR (s.title = 'MVC 设计模式' AND t.title IN ('Servlet 生命周期', 'JSP 语法入门', 'MyBatis 持久层框架', 'Java Web 知识体系'))
    OR (s.title = 'JDBC 数据库编程' AND t.title IN ('MyBatis 持久层框架', 'Java Web 知识体系'))
    OR (s.title = 'MyBatis 持久层框架' AND t.title IN ('JDBC 数据库编程', '知识图谱可视化（本项目）', 'MVC 设计模式', 'Maven 构建与依赖'))
    OR (s.title = 'HttpSession 会话机制' AND t.title IN ('Cookie 状态管理', 'Web 登录鉴权方案', 'Listener 事件监听', 'Java Web 知识体系'))
    OR (s.title = 'Cookie 状态管理' AND t.title IN ('HttpSession 会话机制', 'Web 登录鉴权方案', 'Filter 过滤器链'))
    OR (s.title = 'Filter 过滤器链' AND t.title IN ('Servlet 生命周期', 'Web 登录鉴权方案', 'Java Web 知识体系'))
    OR (s.title = 'Listener 事件监听' AND t.title IN ('Servlet 生命周期', 'HttpSession 会话机制', 'Tomcat 部署运维'))
    OR (s.title = 'Web 登录鉴权方案' AND t.title IN ('HttpSession 会话机制', 'Cookie 状态管理', 'Filter 过滤器链', 'JDBC 数据库编程', 'MyBatis 持久层框架'))
    OR (s.title = 'Maven 构建与依赖' AND t.title IN ('Tomcat 部署运维', 'MyBatis 持久层框架', 'Java Web 知识体系'))
    OR (s.title = 'Tomcat 部署运维' AND t.title IN ('Maven 构建与依赖', 'Servlet 生命周期', 'Listener 事件监听'))
    OR (s.title = '文件上传处理' AND t.title IN ('请求与响应对象', 'Servlet 生命周期'))
    OR (s.title = '双向链接原理' AND t.title IN ('Wikilink 维基链接', '知识图谱可视化（本项目）', 'MyBatis 持久层框架'))
    OR (s.title = 'Wikilink 维基链接' AND t.title IN ('双向链接原理', '知识图谱可视化（本项目）'))
    OR (s.title = '知识图谱可视化（本项目）' AND t.title IN ('双向链接原理', 'Wikilink 维基链接', 'MyBatis 持久层框架', 'Java Web 知识体系', 'Maven 构建与依赖', 'Tomcat 部署运维'))
  );

-- 统计输出
SELECT '演示数据导入完成' AS message,
       (SELECT COUNT(*) FROM notes WHERE user_id = @uid) AS note_count,
       (SELECT COUNT(*) FROM note_links nl
        INNER JOIN notes n ON nl.source_id = n.id WHERE n.user_id = @uid) AS link_count,
       (SELECT COUNT(*) FROM folders WHERE user_id = @uid) AS folder_count,
       (SELECT COUNT(*) FROM tags WHERE user_id = @uid) AS tag_count;

SELECT username, email, bio FROM users WHERE id = @uid;
