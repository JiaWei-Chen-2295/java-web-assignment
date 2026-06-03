# PRD — 个人知识管理笔记应用

> **文档版本**: v1.1
> **创建日期**: 2026-06-02
> **项目性质**: 学习练手项目
> **技术栈**: 传统 Java Web（Servlet + JSP + MySQL + Tomcat）

---

## 一、项目概述

### 1.1 项目背景

在信息爆炸的时代，个人知识管理变得越来越重要。传统笔记应用以线性方式组织内容，难以表达知识之间的关联关系。本项目旨在打造一款支持**双向链接**和**知识图谱**的个人笔记应用，帮助用户构建结构化的知识网络。

### 1.2 产品定位

面向个人用户的**本地优先 + 云同步**知识管理工具，核心特色是双向链接和可视化知识图谱，类似 Obsidian 的产品理念，采用传统 Java Web（Servlet + JSP）技术栈实现。

### 1.3 目标用户

- 个人学习者、知识工作者
- 需要整理和关联大量信息的用户
- 偏好本地存储、关注数据隐私的用户

### 1.4 项目目标

| 目标 | 说明 |
|------|------|
| 学习目标 | 掌握 Java Web 全栈开发，包括前后端交互、数据库设计、文件上传等 |
| 产品目标 | 实现一个可用的个人笔记工具，支持双向链接和知识图谱可视化 |
| 技术目标 | 完成 WAR 包部署到 Tomcat 的完整流程 |

---

## 二、市场调研

### 2.1 主流笔记应用功能对比

| 功能 | Notion | Obsidian | Evernote | OneNote | Logseq |
|------|--------|----------|----------|---------|--------|
| 双向链接 | ✅ | ✅ | ❌ | ❌ | ✅ |
| 本地存储 | ❌ | ✅ | ❌ | ✅ | ✅ |
| 知识图谱 | ❌ | ✅ | ❌ | ❌ | ✅ |
| Markdown | ✅ | ✅ | 部分 | ❌ | ✅ |
| 数据库功能 | ✅ | 插件 | ❌ | ❌ | ❌ |
| 插件生态 | 中等 | 丰富 | 有限 | 有限 | 丰富 |
| AI 功能 | ✅ Copilot | 插件 | ✅ | ✅ | 插件 |
| 免费使用 | 部分 | 个人免费 | 有限 | 免费 | 免费 |

### 2.2 2026 年行业趋势

- **AI 深度集成**：各大笔记应用纷纷加入 AI 总结、写作辅助、智能搜索功能
- **知识连接**：双向链接、知识图谱已成标配，从"线性笔记"转向"网状知识管理"
- **数据主权**：本地优先（Local-first）理念持续升温，用户对数据所有权和隐私关注度提升
- **国产笔记崛起**：飞书文档、语雀、思源笔记、FlowUs 在国内市场表现活跃

### 2.3 竞品分析总结

| 竞品 | 优势 | 劣势 | 本项目借鉴 |
|------|------|------|-----------|
| Obsidian | 本地优先、插件丰富、图谱强大 | 无协作、学习曲线陡 | 双向链接机制、图谱可视化方案 |
| Notion | 协作强、数据库功能、模板丰富 | 云端依赖、大文档卡顿 | 块编辑器交互设计 |
| Logseq | 开源、大纲式、内置闪卡 | 移动端不成熟、生态小 | 块级引用、开源思路 |
| 思源笔记 | 本地优先、完全开源、中文友好 | 用户量小、社区小 | 本地存储架构设计 |

---

## 三、技术选型

### 3.1 技术栈总览

```
┌─────────────────────────────────────────────────┐
│                    用户浏览器                      │
├─────────────────────────────────────────────────┤
│  前端层                                          │
│  ├── 模板引擎: JSP + JSTL（服务端渲染）            │
│  ├── 块编辑器: Editor.js                          │
│  ├── 知识图谱: ECharts                            │
│  ├── 交互增强: 原生 JavaScript / jQuery            │
│  └── 样式: Bootstrap 5 + 自定义 CSS               │
├─────────────────────────────────────────────────┤
│  服务层                                          │
│  ├── 容器: Apache Tomcat 9/10                     │
│  ├── 框架: 原生 Servlet（javax.servlet.http）     │
│  ├── 构建: Maven                                  │
│  ├── 打包: WAR                                    │
│  └── 认证: Session + Filter                       │
├─────────────────────────────────────────────────┤
│  数据层                                          │
│  ├── 数据库: MySQL 8.0                            │
│  ├── 数据访问: JDBC + MyBatis                     │
│  ├── 连接池: HikariCP / Druid                     │
│  └── 文件存储: 本地文件系统（服务器磁盘）            │
└─────────────────────────────────────────────────┘
```

### 3.2 技术选型理由

| 层级 | 选型 | 理由 |
|------|------|------|
| 前端渲染 | JSP + JSTL | Java Web 原生模板技术，Tomcat 原生支持，无需额外依赖 |
| 块编辑器 | Editor.js | 开源块编辑器，输出 JSON 格式便于存储，支持插件扩展 |
| 知识图谱 | ECharts | 百度开源图表库，关系图开箱即用，中文文档完善，上手简单 |
| 样式框架 | Bootstrap 5 | 成熟的响应式 UI 框架，快速搭建页面 |
| 后端框架 | 原生 Servlet | Tomcat 原生支持，无框架依赖，学习 Java Web 底层原理 |
| 构建工具 | Maven | Java 生态标准构建工具，依赖管理成熟 |
| 数据库 | MySQL 8.0 | 最流行的关系型数据库，生态成熟，学习资源丰富 |
| 数据访问 | JDBC + MyBatis | JDBC 夯实基础，MyBatis 简化复杂 SQL 映射 |
| 连接池 | HikariCP / Druid | 高性能连接池，避免频繁创建销毁连接 |
| 文件存储 | 本地文件系统 | 最简单的实现方式，练手项目首选 |

---

## 四、功能需求

### 4.1 功能优先级矩阵

| 优先级 | 功能模块 | 说明 |
|--------|---------|------|
| **P0** | 笔记编辑 | 块编辑器、Markdown 支持、多媒体嵌入 |
| **P0** | 双向链接 | `[[链接]]` 语法、反向引用面板 |
| **P0** | 知识图谱 | D3.js/ECharts 可视化、交互式探索 |
| **P0** | 用户体系 | 注册、登录、登出、数据隔离 |
| **P0** | 多媒体管理 | 图片/附件上传、本地存储、元信息管理 |
| **P1** | 笔记分类 | 文件夹、标签体系 |
| **P1** | 全文搜索 | 标题和内容搜索 |
| **P1** | 笔记导出 | Markdown / PDF 导出 |
| **P2** | 云同步 | 本地优先 + 服务端同步机制 |
| **P2** | 版本历史 | 笔记修改历史记录与回滚 |
| **P3** | AI 集成 | AI 总结、写作辅助、智能搜索 |

---

### 4.2 P0 功能详细设计

#### 4.2.1 笔记编辑模块

**功能描述**: 基于 Editor.js 实现块编辑器，支持多种内容块类型。

**支持的块类型**:

| 块类型 | 说明 | 优先级 |
|--------|------|--------|
| Paragraph | 普通段落文本 | P0 |
| Header | H1-H6 标题 | P0 |
| List | 有序/无序列表 | P0 |
| Checklist | 待办清单 | P0 |
| Code | 代码块（语法高亮） | P0 |
| Image | 图片嵌入 | P0 |
| Quote | 引用块 | P1 |
| Table | 表格 | P1 |
| Delimiter | 分割线 | P1 |
| Embed | 嵌入外部内容 | P2 |

**编辑器交互流程**:

```
用户打开笔记
    │
    ▼
加载 Editor.js 初始化
    │
    ▼
从服务端获取笔记内容（JSON 格式）
    │
    ▼
Editor.js 渲染为可编辑块
    │
    ▼
用户编辑内容（自动保存 / 手动保存）
    │
    ▼
Editor.js 输出 JSON → 发送到服务端
    │
    ▼
服务端存储到数据库
```

**数据格式**:

```json
{
  "time": 1685700000000,
  "blocks": [
    {
      "type": "header",
      "data": { "text": "笔记标题", "level": 1 }
    },
    {
      "type": "paragraph",
      "data": { "text": "这是一段内容，包含[[双向链接]]。" }
    },
    {
      "type": "image",
      "data": { "file": { "url": "/uploads/img/xxx.jpg" } }
    }
  ],
  "version": "2.28.0"
}
```

---

#### 4.2.2 双向链接模块

**功能描述**: 支持 `[[笔记标题]]` 语法创建笔记间的双向关联，并提供反向引用面板。

**核心机制**:

```
┌──────────────┐         ┌──────────────┐
│   笔记 A      │         │   笔记 B      │
│              │  ──────► │              │
│ 内容引用     │         │ 被引用       │
│ [[笔记B]]    │  ◄────── │              │
└──────────────┘         └──────────────┘
        │                        │
        └────────┬───────────────┘
                 │
        ┌────────▼────────┐
        │   note_links    │
        │  表记录关联关系   │
        └─────────────────┘
```

**链接解析流程**:

1. 用户在编辑器中输入 `[[关键词]]`
2. 前端触发搜索提示（AJAX 查询匹配笔记标题）
3. 用户选择目标笔记，插入链接
4. 保存时，后端解析内容中的 `[[...]]` 标记
5. 维护 `note_links` 关联表（source_id → target_id）

**反向引用面板**:

```
┌─────────────────────────────────────┐
│  📄 当前笔记：机器学习入门            │
│  ─────────────────────────────────  │
│  笔记内容...                         │
│  ─────────────────────────────────  │
│  🔗 被以下笔记引用（3）：             │
│  ├── 📄 深度学习总结                  │
│  ├── 📄 Python 学习笔记              │
│  └── 📄 2026 学习计划                │
└─────────────────────────────────────┘
```

**前端实现要点**:

```javascript
// 双向链接语法解析
function parseWikiLinks(content) {
    const regex = /\[\[(.+?)\]\]/g;
    return content.replace(regex, (match, title) => {
        return `<a class="wiki-link" data-target="${title}">${title}</a>`;
    });
}

// 输入联想搜索
function onLinkInput(keyword) {
    fetch(`/api/notes/search?keyword=${keyword}`)
        .then(res => res.json())
        .then(notes => showSuggestionDropdown(notes));
}
```

---

#### 4.2.3 知识图谱模块

**功能描述**: 可视化展示笔记之间的链接关系网络，支持交互式探索。

**图谱要素**:

| 要素 | 说明 |
|------|------|
| 节点 | 每个笔记为一个节点，大小按链接数加权 |
| 边 | 笔记间的链接关系为边 |
| 颜色 | 可按标签/分类着色 |
| 交互 | 点击节点跳转笔记、悬停预览、缩放、拖拽 |

**图谱数据接口**:

```
GET /api/graph

Response:
{
  "nodes": [
    { "id": 1, "title": "机器学习入门", "links": 5, "tag": "AI" },
    { "id": 2, "title": "深度学习总结", "links": 3, "tag": "AI" },
    { "id": 3, "title": "Python 学习", "links": 4, "tag": "编程" }
  ],
  "edges": [
    { "source": 1, "target": 2 },
    { "source": 1, "target": 3 },
    { "source": 2, "target": 3 }
  ]
}
```

**ECharts 实现方案（推荐）**:

```javascript
// ECharts 关系图配置
const option = {
    series: [{
        type: 'graph',
        layout: 'force',
        roam: true,
        draggable: true,
        label: { show: true },
        force: { repulsion: 200, edgeLength: 150 },
        data: nodes.map(n => ({
            name: n.title,
            symbolSize: Math.sqrt(n.links) * 10,
            category: n.tag
        })),
        links: edges.map(e => ({
            source: nodes[e.source].title,
            target: nodes[e.target].title
        }))
    }]
};
```

**D3.js 力导向图方案**:

```javascript
// D3.js 力导向图
const simulation = d3.forceSimulation(nodes)
    .force('link', d3.forceLink(edges).id(d => d.id).distance(150))
    .force('charge', d3.forceManyBody().strength(-300))
    .force('center', d3.forceCenter(width / 2, height / 2));
```

**图谱页面交互设计**:

```
┌─────────────────────────────────────────────────┐
│  🕸️ 知识图谱                          [筛选] [全屏] │
├─────────────────────────────────────────────────┤
│                                                 │
│         ○ 深度学习                               │
│        / \                                      │
│       /   \                                     │
│  ○ Python ──── ○ 机器学习入门                    │
│       \       /                                 │
│        \     /                                  │
│     ○ 数据分析  ○ 神经网络                       │
│                                                 │
├─────────────────────────────────────────────────┤
│  📊 统计: 12 个笔记 | 18 条链接 | 3 个分类        │
└─────────────────────────────────────────────────┘
```

---

#### 4.2.4 用户体系模块

**功能描述**: 支持多用户注册、登录，实现数据隔离。

**用户表设计**:

```sql
CREATE TABLE users (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,  -- BCrypt 加密
    email       VARCHAR(100) NOT NULL UNIQUE,
    avatar      VARCHAR(255) DEFAULT NULL,
    created_at  DATETIME     DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**认证流程**:

```
┌──────────┐   POST /user/login   ┌──────────────┐
│  登录页面  │ ──────────────────►  │ UserServlet   │
│  (JSP)    │                      │ doPost()      │
└──────────┘                      └──────┬───────┘
      ▲                                  │
      │                           ┌──────▼───────┐
      │                           │ UserService   │
      │                           │ 密码比对       │
      │                           │ (BCrypt)      │
      │                           └──────┬───────┘
      │                                  │
      │     成功: HttpSession.setAttribute│  失败: 设置错误信息
      │     重定向到 /note/list           │  转发回 login.jsp
      │◄──────────────────────────────────┘
```

**数据隔离**: 所有笔记查询均带 `user_id` 条件，确保用户只能访问自己的数据。

---

#### 4.2.5 多媒体管理模块

**功能描述**: 支持图片、附件的上传和管理，存储在本地文件系统。

**存储路径规划**:

```
/uploads/
├── {user_id}/
│   ├── images/
│   │   ├── 20260602_xxxxxx.jpg
│   │   └── 20260602_xxxxxx.png
│   └── attachments/
│       ├── 20260602_xxxxxx.pdf
│       └── 20260602_xxxxxx.zip
```

**附件表设计**:

```sql
CREATE TABLE attachments (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    note_id     BIGINT       NOT NULL,
    user_id     BIGINT       NOT NULL,
    file_name   VARCHAR(255) NOT NULL,  -- 原始文件名
    file_path   VARCHAR(500) NOT NULL,  -- 存储路径
    file_type   VARCHAR(50)  NOT NULL,  -- MIME 类型
    file_size   BIGINT       NOT NULL,  -- 文件大小（字节）
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**上传流程**:

```
用户拖拽/选择文件
    │
    ▼
前端校验（文件类型、大小限制）
    │
    ▼
FormData 提交到 POST /api/upload
    │
    ▼
服务端校验 → 生成唯一文件名 → 保存到磁盘
    │
    ▼
写入 attachments 表 → 返回文件 URL
    │
    ▼
编辑器插入图片/附件块
```

---

### 4.3 P1 功能概述

#### 4.3.1 笔记分类

- **文件夹**: 树形目录结构，支持嵌套
- **标签**: 多标签体系，支持标签筛选和聚合

#### 4.3.2 全文搜索

- 基于 SQL `LIKE` 的简单搜索（MVP 阶段）
- 后续可引入 Elasticsearch 提升搜索质量

#### 4.3.3 笔记导出

- 导出为 Markdown 文件（保留格式）
- 导出为 PDF（适合打印和分享）

---

## 五、数据库设计

### 5.1 ER 图

```
┌─────────────┐       ┌─────────────┐       ┌──────────────┐
│    users     │       │    notes     │       │  note_links   │
├─────────────┤       ├─────────────┤       ├──────────────┤
│ id (PK)      │◄──┐  │ id (PK)      │◄──┐  │ id (PK)       │
│ username     │   │  │ user_id (FK) │───┘  │ source_id(FK) │──┐
│ password     │   │  │ title        │      │ target_id(FK) │──┤
│ email        │   │  │ content      │      │ created_at    │  │
│ avatar       │   │  │ created_at   │      └──────────────┘  │
│ created_at   │   │  │ updated_at   │                         │
│ updated_at   │   │  └─────────────┘                         │
└─────────────┘   │         │                                  │
                   │         │ 1:N                              │
                   │  ┌──────▼──────┐                          │
                   │  │ attachments │                          │
                   │  ├────────────┤                          │
                   │  │ id (PK)     │                          │
                   │  │ note_id(FK)─┼──────────────────────────┘
                   │  │ user_id(FK)─┘
                   │  │ file_name   │
                   │  │ file_path   │
                   │  │ file_type   │
                   │  │ file_size   │
                   │  │ created_at  │
                   │  └────────────┘
                   │
                   │  ┌────────────┐
                   │  │   tags     │
                   │  ├────────────┤
                   │  │ id (PK)    │
                   └──│ user_id(FK)│
                      │ name       │
                      │ color      │
                      │ created_at │
                      └────────────┘
                           │
                           │ M:N
                      ┌────▼─────┐
                      │note_tags │
                      ├──────────┤
                      │ note_id  │
                      │ tag_id   │
                      └──────────┘
```

### 5.2 完整建表 SQL

```sql
-- 创建数据库
CREATE DATABASE IF NOT EXISTS note_app
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE note_app;

-- 用户表
CREATE TABLE users (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    username    VARCHAR(50)  NOT NULL UNIQUE COMMENT '用户名',
    password    VARCHAR(255) NOT NULL COMMENT '密码（BCrypt 加密）',
    email       VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    avatar      VARCHAR(255) DEFAULT NULL COMMENT '头像路径',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 笔记表
CREATE TABLE notes (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id     BIGINT       NOT NULL COMMENT '所属用户',
    title       VARCHAR(255) NOT NULL DEFAULT '无标题' COMMENT '笔记标题',
    content     LONGTEXT COMMENT 'Editor.js JSON 内容',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_title (title)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='笔记表';

-- 双向链接关系表
CREATE TABLE note_links (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    source_id   BIGINT NOT NULL COMMENT '引用方笔记 ID',
    target_id   BIGINT NOT NULL COMMENT '被引用笔记 ID',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_id) REFERENCES notes(id) ON DELETE CASCADE,
    FOREIGN KEY (target_id) REFERENCES notes(id) ON DELETE CASCADE,
    UNIQUE KEY uk_link (source_id, target_id),
    INDEX idx_target (target_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='双向链接关系表';

-- 附件表
CREATE TABLE attachments (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    note_id     BIGINT       NOT NULL COMMENT '关联笔记',
    user_id     BIGINT       NOT NULL COMMENT '所属用户',
    file_name   VARCHAR(255) NOT NULL COMMENT '原始文件名',
    file_path   VARCHAR(500) NOT NULL COMMENT '服务器存储路径',
    file_type   VARCHAR(50)  NOT NULL COMMENT 'MIME 类型',
    file_size   BIGINT       NOT NULL COMMENT '文件大小（字节）',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_note (note_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='附件表';

-- 标签表
CREATE TABLE tags (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id     BIGINT      NOT NULL COMMENT '所属用户',
    name        VARCHAR(50) NOT NULL COMMENT '标签名',
    color       VARCHAR(20) DEFAULT '#6c757d' COMMENT '标签颜色',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_tag (user_id, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签表';

-- 笔记-标签关联表
CREATE TABLE note_tags (
    note_id BIGINT NOT NULL,
    tag_id  BIGINT NOT NULL,
    PRIMARY KEY (note_id, tag_id),
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id)  REFERENCES tags(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='笔记标签关联表';
```

### 5.3 数据库连接配置（db.properties）

```properties
# MySQL 连接配置
jdbc.driver=com.mysql.cj.jdbc.Driver
jdbc.url=jdbc:mysql://localhost:3306/note_app?useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=utf8mb4
jdbc.username=root
jdbc.password=your_password

# HikariCP 连接池配置
dataSource.maximumPoolSize=10
dataSource.minimumIdle=5
dataSource.connectionTimeout=30000
dataSource.idleTimeout=600000
```

---

## 六、接口设计

> 所有 Servlet 统一使用 `@WebServlet` 注解或 `web.xml` 配置映射。
> API 接口返回 JSON（`application/json`），页面接口转发 JSP 视图。

### 6.1 用户相关（UserServlet）

| 方法 | URL Pattern | 说明 |
|------|-------------|------|
| GET | `/user/register` | 转发注册页面（register.jsp） |
| POST | `/user/register` | 处理注册表单提交，重定向到登录页 |
| GET | `/user/login` | 转发登录页面（login.jsp） |
| POST | `/user/login` | 处理登录表单，成功创建 Session 并重定向首页 |
| GET | `/user/logout` | 销毁 Session，重定向到登录页 |

### 6.2 笔记相关（NoteServlet）

| 方法 | URL Pattern | 说明 |
|------|-------------|------|
| GET | `/note/list` | 转发笔记列表页（note-list.jsp） |
| GET | `/note/edit?id={id}` | 转发笔记编辑页（note-editor.jsp） |
| POST | `/api/note/create` | 创建笔记，返回 JSON `{id, title}` |
| POST | `/api/note/update` | 更新笔记，接收 JSON body |
| POST | `/api/note/delete` | 删除笔记，接收 `{id}` |
| GET | `/api/note/search?keyword=xxx` | 搜索笔记，返回 JSON 数组（用于双向链接联想） |

### 6.3 双向链接 / 知识图谱（GraphServlet）

| 方法 | URL Pattern | 说明 |
|------|-------------|------|
| GET | `/api/note/backlinks?id={id}` | 获取反向引用列表，返回 JSON |
| GET | `/api/graph` | 获取知识图谱数据（nodes + edges），返回 JSON |
| GET | `/graph` | 转发知识图谱页面（graph.jsp） |

### 6.4 文件上传（UploadServlet）

| 方法 | URL Pattern | 说明 |
|------|-------------|------|
| POST | `/api/upload/image` | 上传图片，返回 JSON `{url, fileName}` |
| POST | `/api/upload/attachment` | 上传附件，返回 JSON `{url, fileName, fileSize}` |
| GET | `/uploads/*` | 静态文件访问（Tomcat 虚拟目录映射） |

### 6.5 Servlet 配置示例（web.xml）

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         version="4.0">

    <!-- 编码过滤器 -->
    <filter>
        <filter-name>EncodingFilter</filter-name>
        <filter-class>com.noteapp.filter.EncodingFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>EncodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>

    <!-- 登录校验过滤器 -->
    <filter>
        <filter-name>LoginFilter</filter-name>
        <filter-class>com.noteapp.filter.LoginFilter</filter-class>
    </filter>
    <filter-mapping>
        <filter-name>LoginFilter</filter-name>
        <url-pattern>/note/*</url-pattern>
        <url-pattern>/api/*</url-pattern>
        <url-pattern>/graph</url-pattern>
    </filter-mapping>

    <!-- 用户 Servlet -->
    <servlet>
        <servlet-name>UserServlet</servlet-name>
        <servlet-class>com.noteapp.servlet.UserServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>UserServlet</servlet-name>
        <url-pattern>/user/*</url-pattern>
    </servlet-mapping>

    <!-- 笔记 Servlet -->
    <servlet>
        <servlet-name>NoteServlet</servlet-name>
        <servlet-class>com.noteapp.servlet.NoteServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>NoteServlet</servlet-name>
        <url-pattern>/note/*</url-pattern>
        <url-pattern>/api/note/*</url-pattern>
    </servlet-mapping>

    <!-- 图谱 Servlet -->
    <servlet>
        <servlet-name>GraphServlet</servlet-name>
        <servlet-class>com.noteapp.servlet.GraphServlet</servlet-class>
    </servlet>
    <servlet-mapping>
        <servlet-name>GraphServlet</servlet-name>
        <url-pattern>/graph</url-pattern>
        <url-pattern>/api/graph</url-pattern>
        <url-pattern>/api/note/backlinks</url-pattern>
    </servlet-mapping>

    <!-- 上传 Servlet -->
    <servlet>
        <servlet-name>UploadServlet</servlet-name>
        <servlet-class>com.noteapp.servlet.UploadServlet</servlet-class>
        <multipart-config>
            <max-file-size>20971520</max-file-size>       <!-- 20MB -->
            <max-request-size>52428800</max-request-size>  <!-- 50MB -->
        </multipart-config>
    </servlet>
    <servlet-mapping>
        <servlet-name>UploadServlet</servlet-name>
        <url-pattern>/api/upload/*</url-pattern>
    </servlet-mapping>

</web-app>
```

---

## 七、页面设计

### 7.1 页面列表

| 页面 | 路径 | 说明 |
|------|------|------|
| 首页/笔记列表 | `/notes` | 左侧目录树 + 右侧笔记列表 |
| 笔记编辑页 | `/notes/{id}` | 左侧目录 + 中间编辑器 + 右侧反向引用面板 |
| 知识图谱页 | `/graph` | 全屏图谱可视化 |
| 登录页 | `/login` | 登录表单 |
| 注册页 | `/register` | 注册表单 |

### 7.2 笔记编辑页布局

```
┌──────────────────────────────────────────────────────────┐
│  📝 NoteApp     [笔记列表] [知识图谱]        👤 用户名 ▼  │
├────────┬─────────────────────────────────┬───────────────┤
│        │                                 │               │
│  📂    │  📄 机器学习入门                 │  🔗 反向引用   │
│  目录   │  ─────────────────────────────  │               │
│        │                                 │  📄 深度学习   │
│  ├ AI  │  [块编辑器区域]                  │  总结          │
│  │ ├ 机器学习入门                        │               │
│  │ └ 深度学习                            │  📄 Python    │
│  ├ 编程 │                                 │  学习笔记      │
│  │ └ Python                             │               │
│  └ 随笔 │                                 │  📄 2026      │
│        │                                 │  学习计划      │
│        │                                 │               │
├────────┴─────────────────────────────────┴───────────────┤
│  已保存 · 最后编辑于 14:32                                 │
└──────────────────────────────────────────────────────────┘
```

### 7.3 知识图谱页布局

```
┌──────────────────────────────────────────────────────────┐
│  🕸️ 知识图谱            [标签筛选▼] [搜索笔记]  [全屏]    │
├──────────────────────────────────────────────────────────┤
│                                                          │
│                                                          │
│              ○ 深度学习                                   │
│             /|\                                           │
│            / | \                                          │
│   ○ Python   |   ○ 机器学习入门                           │
│       \     |    /                                        │
│        \    |   /                                         │
│     ○ 数据分析 ○ 神经网络                                 │
│              |                                            │
│         ○ 线性代数                                        │
│                                                          │
│                                                          │
├──────────────────────────────────────────────────────────┤
│  📊 12 个笔记 · 18 条链接 · 3 个分类     [点击节点查看详情] │
└──────────────────────────────────────────────────────────┘
```

---

## 八、非功能需求

### 8.1 性能要求

| 指标 | 目标 |
|------|------|
| 页面加载时间 | < 2 秒 |
| 笔记保存响应 | < 500ms |
| 图谱渲染（100节点） | < 1 秒 |
| 文件上传（10MB） | < 5 秒 |

### 8.2 安全要求

| 措施 | 说明 |
|------|------|
| 密码加密 | BCrypt 哈希存储 |
| SQL 注入防护 | PreparedStatement / MyBatis 参数化查询 |
| XSS 防护 | JSTL `<c:out>` 自动转义 + 前端输入过滤 |
| 文件上传校验 | 文件类型白名单、大小限制（单文件 ≤ 20MB） |
| 数据隔离 | 所有查询强制带 user_id 条件 |
| CSRF 防护 | Servlet Filter + 自定义 Token 校验 |

### 8.3 兼容性

| 浏览器 | 支持版本 |
|--------|---------|
| Chrome | 最近 2 个版本 |
| Firefox | 最近 2 个版本 |
| Edge | 最近 2 个版本 |
| Safari | 最近 2 个版本 |

---

## 九、项目结构

```
note-app/
├── pom.xml
├── README.md
├── src/
│   ├── main/
│   │   ├── java/com/noteapp/
│   │   │   ├── servlet/                          # Servlet 控制器
│   │   │   │   ├── NoteServlet.java              # 笔记 CRUD + 页面渲染
│   │   │   │   ├── UserServlet.java              # 用户注册/登录/登出
│   │   │   │   ├── GraphServlet.java             # 知识图谱数据 API
│   │   │   │   └── UploadServlet.java            # 文件上传 API
│   │   │   ├── filter/                           # Servlet 过滤器
│   │   │   │   ├── LoginFilter.java              # 登录校验过滤器
│   │   │   │   ├── EncodingFilter.java           # UTF-8 编码过滤器
│   │   │   │   └── CORSFilter.java               # 跨域过滤器（API 用）
│   │   │   ├── service/                          # 业务逻辑层
│   │   │   │   ├── NoteService.java
│   │   │   │   ├── UserService.java
│   │   │   │   ├── LinkService.java
│   │   │   │   └── FileService.java
│   │   │   ├── dao/                              # 数据访问层
│   │   │   │   ├── NoteDao.java                  # JDBC 实现
│   │   │   │   ├── UserDao.java
│   │   │   │   ├── LinkDao.java
│   │   │   │   └── AttachmentDao.java
│   │   │   ├── mapper/                           # MyBatis Mapper 接口
│   │   │   │   ├── NoteMapper.java
│   │   │   │   ├── UserMapper.java
│   │   │   │   ├── LinkMapper.java
│   │   │   │   └── AttachmentMapper.java
│   │   │   ├── model/                            # 实体与数据对象
│   │   │   │   ├── entity/
│   │   │   │   │   ├── User.java
│   │   │   │   │   ├── Note.java
│   │   │   │   │   ├── NoteLink.java
│   │   │   │   │   ├── Tag.java
│   │   │   │   │   └── Attachment.java
│   │   │   │   ├── dto/
│   │   │   │   │   ├── GraphData.java            # 图谱数据 DTO
│   │   │   │   │   ├── BacklinkDTO.java          # 反向引用 DTO
│   │   │   │   │   └── SearchResult.java         # 搜索结果 DTO
│   │   │   │   └── vo/
│   │   │   │       └── NoteVO.java               # 视图对象
│   │   │   └── util/                             # 工具类
│   │   │       ├── DBUtil.java                   # 数据库连接工具
│   │   │       ├── LinkParser.java               # 双向链接解析
│   │   │       ├── FileUtil.java                 # 文件工具
│   │   │       ├── JsonUtil.java                 # JSON 序列化工具
│   │   │       └── PasswordUtil.java             # 密码加密
│   │   ├── resources/
│   │   │   ├── mapper/                           # MyBatis SQL 映射
│   │   │   │   ├── NoteMapper.xml
│   │   │   │   ├── UserMapper.xml
│   │   │   │   ├── LinkMapper.xml
│   │   │   │   └── AttachmentMapper.xml
│   │   │   ├── mybatis-config.xml                # MyBatis 核心配置
│   │   │   ├── db.properties                     # 数据库连接配置
│   │   │   └── schema.sql                        # 建表脚本
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   ├── web.xml                       # Servlet 映射配置
│   │       │   └── views/                        # JSP 视图页面
│   │       │       ├── common/
│   │       │       │   ├── header.jsp            # 公共头部
│   │       │       │   ├── footer.jsp            # 公共底部
│   │       │       │   └── sidebar.jsp           # 侧边栏
│   │       │       ├── note-list.jsp             # 笔记列表
│   │       │       ├── note-editor.jsp           # 笔记编辑器
│   │       │       ├── graph.jsp                 # 知识图谱
│   │       │       ├── login.jsp                 # 登录
│   │       │       └── register.jsp              # 注册
│   │       └── static/
│   │           ├── css/
│   │           │   ├── style.css
│   │           │   └── editor.css
│   │           ├── js/
│   │           │   ├── editor-init.js            # Editor.js 初始化
│   │           │   ├── link-parser.js            # 双向链接解析
│   │           │   ├── graph.js                  # 知识图谱渲染
│   │           │   └── upload.js                 # 文件上传
│   │           ├── lib/                          # 第三方库
│   │           │   ├── editorjs/
│   │           │   ├── echarts/
│   │           │   └── bootstrap/
│   │           └── uploads/                      # 用户上传文件目录
│   └── test/
│       └── java/com/noteapp/
│           ├── service/
│           │   ├── NoteServiceTest.java
│           │   └── LinkServiceTest.java
│           └── util/
│               └── LinkParserTest.java
└── docs/
    └── PRD.md                                    # 本文档
```

---

## 十、开发计划

### 10.1 阶段规划

| 阶段 | 周期 | 内容 | 产出 |
|------|------|------|------|
| **Phase 1** | 第 1 周 | 项目搭建 + 用户体系 | 可登录注册的基础框架 |
| **Phase 2** | 第 2 周 | 笔记 CRUD + Editor.js 集成 | 可创建和编辑笔记 |
| **Phase 3** | 第 3 周 | 双向链接 + 反向引用 | 笔记间可关联、查看引用 |
| **Phase 4** | 第 4 周 | 知识图谱 + 多媒体上传 | 图谱可视化、文件上传 |
| **Phase 5** | 第 5 周 | 标签分类 + 搜索 + 优化 | 完善功能、修复 Bug |
| **Phase 6** | 第 6 周 | 测试 + 部署 + 文档 | WAR 包部署到 Tomcat |

### 10.2 里程碑

| 里程碑 | 验收标准 |
|--------|---------|
| M1 - 基础框架 | 用户可注册登录，看到空白笔记列表 |
| M2 - 笔记编辑 | 可创建、编辑、删除笔记，支持块编辑 |
| M3 - 知识关联 | 双向链接可用，图谱正确展示笔记关系 |
| M4 - 完整功能 | 多媒体上传、标签、搜索均可用 |
| M5 - 上线部署 | WAR 包部署到 Tomcat，完整可用 |

---

## 十一、风险与应对

| 风险 | 概率 | 影响 | 应对措施 |
|------|------|------|---------|
| Editor.js 与 JSP 集成困难 | 中 | 高 | 前期做技术验证，Editor.js 通过 CDN 引入，与 JSP 无耦合 |
| Servlet 手动路由维护成本 | 中 | 中 | 统一 URL 命名规范，Servlet 内用 `getPathInfo()` 分发子路由 |
| 双向链接解析性能问题 | 低 | 中 | 笔记量小时无影响，后期可加缓存 |
| 知识图谱大数据量卡顿 | 低 | 中 | 限制图谱节点数（最多 500），分页加载 |
| 文件上传安全漏洞 | 中 | 高 | 严格校验文件类型、重命名文件、限制大小 |
| MySQL 连接泄露 | 低 | 高 | 使用 HikariCP 连接池，确保 Connection 在 finally 中关闭 |

---

## 十二、参考资料

### 竞品与行业

- [7 Best Note-Taking Apps in 2026 - AIToolPick](https://aitoolpick.org/blog/best-note-taking-apps-2026/)
- [Best Note-Taking Apps in 2026: Notion vs Obsidian vs OneNote](https://startupgeek.org/best-note-taking-apps-in-2026-notion-vs-obsidian-vs-onenote/)
- [协同办公笔记软件综合评测 - 知乎](https://zhuanlan.zhihu.com/p/498709185)

### 技术文档

- [Editor.js 官方文档](https://editorjs.io/)
- [ECharts 关系图文档](https://echarts.apache.org/zh/option.html#series-graph)
- [JSP 官方规范](https://javaee.github.io/tutorial/jsp.html)
- [JSTL 标签库](https://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/)
- [Servlet 4.0 规范](https://javaee.github.io/tutorial/servlets.html)
- [MyBatis 官方文档](https://mybatis.org/mybatis-3/zh/index.html)
- [MySQL 8.0 参考手册](https://dev.mysql.com/doc/refman/8.0/en/)
- [Tomcat 9 文档](https://tomcat.apache.org/tomcat-9.0-doc/)

---

> **文档维护**: 本文档随项目迭代持续更新，最新版本以仓库中的 `PRD.md` 为准。
