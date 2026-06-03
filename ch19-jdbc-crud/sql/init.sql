-- =============================================
-- JDBC 增删改查练习 - 建表脚本
-- 数据库: java_web
-- =============================================

USE java_web;

-- 如果表已存在则先删除，方便反复练习
DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id`      INT          NOT NULL AUTO_INCREMENT,
  `name`    VARCHAR(50)  NOT NULL,
  `email`   VARCHAR(100) NOT NULL,
  `age`     INT          DEFAULT NULL,
  `created` TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 插入几条测试数据
INSERT INTO `users` (`name`, `email`, `age`) VALUES
  ('张三', 'zhangsan@example.com', 25),
  ('李四', 'lisi@example.com', 30),
  ('王五', 'wangwu@example.com', 22);
