-- 创建数据库
CREATE DATABASE IF NOT EXISTS note_app
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE note_app;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    username    VARCHAR(50)  NOT NULL UNIQUE COMMENT '用户名',
    password    VARCHAR(255) NOT NULL COMMENT '密码（BCrypt 加密）',
    email       VARCHAR(100) NOT NULL UNIQUE COMMENT '邮箱',
    avatar      VARCHAR(255) DEFAULT NULL COMMENT '头像路径',
    bio         VARCHAR(500) DEFAULT NULL COMMENT '个人简介',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 文件夹表（支持树形结构）
CREATE TABLE IF NOT EXISTS folders (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id     BIGINT       NOT NULL COMMENT '所属用户',
    parent_id   BIGINT       DEFAULT NULL COMMENT '父文件夹 ID',
    name        VARCHAR(100) NOT NULL COMMENT '文件夹名称',
    icon        VARCHAR(50)  DEFAULT 'folder' COMMENT '图标标识',
    sort_order  INT          DEFAULT 0 COMMENT '排序权重',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_id) REFERENCES folders(id) ON DELETE SET NULL,
    INDEX idx_user_parent (user_id, parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文件夹表';

-- 笔记表
CREATE TABLE IF NOT EXISTS notes (
    id              BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id         BIGINT       NOT NULL COMMENT '所属用户',
    folder_id       BIGINT       DEFAULT NULL COMMENT '所属文件夹',
    title           VARCHAR(255) NOT NULL DEFAULT '无标题' COMMENT '笔记标题',
    content         LONGTEXT COMMENT '笔记内容（Markdown 或 Editor.js JSON）',
    content_format  VARCHAR(20)  DEFAULT 'markdown' COMMENT '内容格式: markdown / editorjs',
    summary         VARCHAR(500) DEFAULT NULL COMMENT '笔记摘要',
    cover_image     VARCHAR(500) DEFAULT NULL COMMENT '封面图片 URL',
    is_pinned       TINYINT(1)   DEFAULT 0 COMMENT '是否置顶',
    is_favorite     TINYINT(1)   DEFAULT 0 COMMENT '是否收藏',
    word_count      INT          DEFAULT 0 COMMENT '字数统计',
    view_count      INT          DEFAULT 0 COMMENT '浏览次数',
    sort_order      INT          DEFAULT 0 COMMENT '排序权重',
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_folder_id (folder_id),
    INDEX idx_title (title),
    INDEX idx_pinned (user_id, is_pinned),
    INDEX idx_favorite (user_id, is_favorite),
    INDEX idx_updated (user_id, updated_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='笔记表';
-- 双向链接关系表
CREATE TABLE IF NOT EXISTS note_links (
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
CREATE TABLE IF NOT EXISTS attachments (
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
CREATE TABLE IF NOT EXISTS tags (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id     BIGINT      NOT NULL COMMENT '所属用户',
    name        VARCHAR(50) NOT NULL COMMENT '标签名',
    color       VARCHAR(20) DEFAULT '#6c757d' COMMENT '标签颜色',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_tag (user_id, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='标签表';

-- 笔记-标签关联表
CREATE TABLE IF NOT EXISTS note_tags (
    note_id BIGINT NOT NULL,
    tag_id  BIGINT NOT NULL,
    PRIMARY KEY (note_id, tag_id),
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id)  REFERENCES tags(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='笔记标签关联表';

-- 笔记版本历史表（简易版）
CREATE TABLE IF NOT EXISTS note_history (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT,
    note_id     BIGINT       NOT NULL COMMENT '所属笔记',
    user_id     BIGINT       NOT NULL COMMENT '操作用户',
    title       VARCHAR(255) NOT NULL COMMENT '历史标题',
    content     LONGTEXT COMMENT '历史内容',
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (note_id) REFERENCES notes(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id),
    INDEX idx_note_created (note_id, created_at DESC)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='笔记版本历史表';
