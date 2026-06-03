-- 创建数据库（如不存在）
CREATE DATABASE IF NOT EXISTS login_keeper DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE login_keeper;

-- 用户表
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id`       INT          NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50)  NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  `email`    VARCHAR(100) DEFAULT NULL,
  `phone`    VARCHAR(20)  DEFAULT NULL,
  `created`  TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 插入测试数据
INSERT INTO `user` (`username`, `password`, `email`, `phone`) VALUES
('admin', '123456', 'admin@example.com', '13800000000'),
('test',  '123456', 'test@example.com',  '13900000000');
