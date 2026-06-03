-- ============================================================
-- NoteApp 数据库迁移脚本 v2.0
-- 从基础版升级到 Feishu 风格版（含文件夹、收藏、置顶等功能）
-- 适用于已有旧版数据库的增量升级
-- 执行前请备份数据库: mysqldump -u root -p note_app > backup.sql
-- ============================================================

USE note_app;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------
-- 1. 创建文件夹表（新增）
-- -----------------------------------------------------------
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

-- -----------------------------------------------------------
-- 2. 为 notes 表添加新字段（安全增量迁移）
-- -----------------------------------------------------------

-- 2.1 添加 folder_id 字段
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND COLUMN_NAME = 'folder_id');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE notes ADD COLUMN folder_id BIGINT DEFAULT NULL COMMENT ''所属文件夹'' AFTER user_id',
    'SELECT ''folder_id already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.2 添加 content_format 字段
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND COLUMN_NAME = 'content_format');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE notes ADD COLUMN content_format VARCHAR(20) DEFAULT ''markdown'' COMMENT ''内容格式: markdown / editorjs'' AFTER content',
    'SELECT ''content_format already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.3 添加 summary 字段
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND COLUMN_NAME = 'summary');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE notes ADD COLUMN summary VARCHAR(500) DEFAULT NULL COMMENT ''笔记摘要'' AFTER content_format',
    'SELECT ''summary already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.4 添加 cover_image 字段
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND COLUMN_NAME = 'cover_image');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE notes ADD COLUMN cover_image VARCHAR(500) DEFAULT NULL COMMENT ''封面图片 URL'' AFTER summary',
    'SELECT ''cover_image already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.5 添加 is_pinned 字段
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND COLUMN_NAME = 'is_pinned');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE notes ADD COLUMN is_pinned TINYINT(1) DEFAULT 0 COMMENT ''是否置顶'' AFTER cover_image',
    'SELECT ''is_pinned already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.6 添加 is_favorite 字段
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND COLUMN_NAME = 'is_favorite');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE notes ADD COLUMN is_favorite TINYINT(1) DEFAULT 0 COMMENT ''是否收藏'' AFTER is_pinned',
    'SELECT ''is_favorite already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.7 添加 word_count 字段
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND COLUMN_NAME = 'word_count');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE notes ADD COLUMN word_count INT DEFAULT 0 COMMENT ''字数统计'' AFTER is_favorite',
    'SELECT ''word_count already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.8 添加 view_count 字段
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND COLUMN_NAME = 'view_count');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE notes ADD COLUMN view_count INT DEFAULT 0 COMMENT ''浏览次数'' AFTER word_count',
    'SELECT ''view_count already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2.9 添加 sort_order 字段
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND COLUMN_NAME = 'sort_order');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE notes ADD COLUMN sort_order INT DEFAULT 0 COMMENT ''排序权重'' AFTER view_count',
    'SELECT ''sort_order already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- -----------------------------------------------------------
-- 3. 为 notes 表添加索引（忽略已存在的错误）
-- -----------------------------------------------------------

-- 添加 folder_id 外键（如果不存在）
SET @fk_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes'
    AND CONSTRAINT_TYPE = 'FOREIGN KEY' AND CONSTRAINT_NAME = 'fk_notes_folder');
SET @sql = IF(@fk_exists = 0,
    'ALTER TABLE notes ADD CONSTRAINT fk_notes_folder FOREIGN KEY (folder_id) REFERENCES folders(id) ON DELETE SET NULL',
    'SELECT ''fk_notes_folder already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加索引（使用 PROCEDURE 安全处理）
DROP PROCEDURE IF EXISTS add_index_if_not_exists;

DELIMITER //
CREATE PROCEDURE add_index_if_not_exists()
BEGIN
    -- idx_folder_id
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND INDEX_NAME = 'idx_folder_id') THEN
        ALTER TABLE notes ADD INDEX idx_folder_id (folder_id);
    END IF;

    -- idx_pinned
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND INDEX_NAME = 'idx_pinned') THEN
        ALTER TABLE notes ADD INDEX idx_pinned (user_id, is_pinned);
    END IF;

    -- idx_favorite
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND INDEX_NAME = 'idx_favorite') THEN
        ALTER TABLE notes ADD INDEX idx_favorite (user_id, is_favorite);
    END IF;

    -- idx_updated
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND INDEX_NAME = 'idx_updated') THEN
        ALTER TABLE notes ADD INDEX idx_updated (user_id, updated_at DESC);
    END IF;

    -- idx_title
    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.STATISTICS
        WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'notes' AND INDEX_NAME = 'idx_title') THEN
        ALTER TABLE notes ADD INDEX idx_title (title);
    END IF;
END //
DELIMITER ;

CALL add_index_if_not_exists();
DROP PROCEDURE IF EXISTS add_index_if_not_exists;

-- -----------------------------------------------------------
-- 4. 创建笔记版本历史表（新增）
-- -----------------------------------------------------------
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

-- -----------------------------------------------------------
-- 5. 为已有 notes 生成摘要和字数（回填数据）
-- -----------------------------------------------------------
UPDATE notes SET
    summary = LEFT(
        TRIM(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
            content, '#', ''), '*', ''), '`', ''), '[', ''), '>', '')
        ),
        200
    ),
    word_count = CHAR_LENGTH(content)
WHERE (summary IS NULL OR summary = '') AND content IS NOT NULL AND content != '';

-- 将旧的 Editor.js JSON 格式标记为 editorjs
UPDATE notes SET content_format = 'editorjs'
WHERE content IS NOT NULL AND content LIKE '{"blocks":%';

-- -----------------------------------------------------------
-- 6. 确保 users 表有 bio 和 avatar 字段（兼容旧表）
-- -----------------------------------------------------------
SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'users' AND COLUMN_NAME = 'avatar');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE users ADD COLUMN avatar VARCHAR(255) DEFAULT NULL COMMENT ''头像路径''',
    'SELECT ''users.avatar already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @col_exists = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'note_app' AND TABLE_NAME = 'users' AND COLUMN_NAME = 'bio');
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE users ADD COLUMN bio VARCHAR(500) DEFAULT NULL COMMENT ''个人简介''',
    'SELECT ''users.bio already exists''');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- -----------------------------------------------------------
-- 完成
-- -----------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 1;

SELECT '✅ 数据库迁移完成！NoteApp v2.0 升级成功。' AS migration_status;
