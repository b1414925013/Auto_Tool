/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306_root_root
 Source Server Type    : MySQL
 Source Server Version : 80036
 Source Host           : 127.0.0.1:3306
 Source Schema         : auto_tool

 Target Server Type    : MySQL
 Target Server Version : 80036
 File Encoding         : 65001

 Date: 15/03/2026 19:46:14
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for graph_db
-- ----------------------------
DROP TABLE IF EXISTS `graph_db`;
CREATE TABLE `graph_db`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `environment` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_graph_db_environ_2632ad`(`environment` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '图数据库密码模型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of graph_db
-- ----------------------------
INSERT INTO `graph_db` VALUES (1, '开发环境', 'dev_password_123', '开发环境图数据库密码', '2026-03-15 19:45:32.653866', '2026-03-15 19:45:32.653866');
INSERT INTO `graph_db` VALUES (2, '测试环境', 'test_password_456', '测试环境图数据库密码', '2026-03-15 19:45:32.653866', '2026-03-15 19:45:32.653866');
INSERT INTO `graph_db` VALUES (3, '预发环境', 'staging_password_789', '预发环境图数据库密码', '2026-03-15 19:45:32.653866', '2026-03-15 19:45:32.653866');
INSERT INTO `graph_db` VALUES (4, '生产环境', 'prod_password_000', '生产环境图数据库密码', '2026-03-15 19:45:32.653866', '2026-03-15 19:45:32.653866');

-- ----------------------------
-- Table structure for operation_logs
-- ----------------------------
DROP TABLE IF EXISTS `operation_logs`;
CREATE TABLE `operation_logs`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `operation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `operation_desc` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'success',
  `request_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `error_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_operation_l_operati_a5c5c0`(`operation_type` ASC) USING BTREE,
  INDEX `idx_operation_l_usernam_5399e9`(`username` ASC) USING BTREE,
  INDEX `idx_operation_l_created_de1446`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志模型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_logs
-- ----------------------------

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE,
  UNIQUE INDEX `code`(`code` ASC) USING BTREE,
  INDEX `idx_sys_role_name_616e55`(`name` ASC) USING BTREE,
  INDEX `idx_sys_role_code_6edd9d`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色模型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'super_admin', '拥有所有权限', '2026-03-15 11:41:25.564883', '2026-03-15 11:41:25.564883');
INSERT INTO `sys_role` VALUES (2, '普通管理员', 'admin', '拥有管理权限', '2026-03-15 11:41:25.570208', '2026-03-15 11:41:25.570208');
INSERT INTO `sys_role` VALUES (3, '普通用户', 'normal_user', '拥有基础权限', '2026-03-15 11:41:25.576628', '2026-03-15 11:41:25.576628');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  INDEX `idx_sys_user_usernam_29caba`(`username` ASC) USING BTREE,
  INDEX `idx_sys_user_email_451315`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户模型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'super_admin', 'super_admin@example.com', '$2b$12$Jl5xQPsCcxu5BfI/MLLDAuy2rD8aywy2DZzNSe4NbBCjHWi3NIuOu', '超级管理员', '2026-03-15 11:41:25.583627', '2026-03-15 11:41:25.583627');
INSERT INTO `sys_user` VALUES (2, 'user', 'user@example.com', '$2b$12$Jl5xQPsCcxu5BfI/MLLDAuy2rD8aywy2DZzNSe4NbBCjHWi3NIuOu', '普通用户', '2026-03-15 11:41:25.593240', '2026-03-15 11:41:25.593240');

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `role_id` int NOT NULL,
  `user_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uid_sys_user_ro_user_id_48d541`(`user_id` ASC, `role_id` ASC) USING BTREE,
  INDEX `fk_sys_user_sys_role_4cdf1232`(`role_id` ASC) USING BTREE,
  CONSTRAINT `fk_sys_user_sys_role_4cdf1232` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_sys_user_sys_user_cef66251` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, '2026-03-15 11:41:25.588843', 1, 1);
INSERT INTO `sys_user_role` VALUES (2, '2026-03-15 11:41:25.598431', 3, 2);

SET FOREIGN_KEY_CHECKS = 1;
