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

 Date: 15/03/2026 20:40:43
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dim_db
-- ----------------------------
DROP TABLE IF EXISTS `dim_db`;
CREATE TABLE `dim_db`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `environment` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `updated_at` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_dim_db_environ_2b3491`(`environment` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = 'DIM数据库模型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of dim_db
-- ----------------------------
INSERT INTO `dim_db` VALUES (1, '开发环境', 'dev_password_123', '开发环境图数据库密码', '2026-03-15 19:45:32.653866', '2026-03-15 19:45:32.653866');
INSERT INTO `dim_db` VALUES (2, '测试环境', 'test_password_456', '测试环境图数据库密码', '2026-03-15 19:45:32.653866', '2026-03-15 19:45:32.653866');
INSERT INTO `dim_db` VALUES (3, '预发环境', 'staging_password_789', '预发环境图数据库密码', '2026-03-15 19:45:32.653866', '2026-03-15 19:45:32.653866');
INSERT INTO `dim_db` VALUES (4, '生产环境', 'prod_password_000', '生产环境图数据库密码', '2026-03-15 19:45:32.653866', '2026-03-15 19:45:32.653866');

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
INSERT INTO `operation_logs` VALUES (1, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:44.601314');
INSERT INTO `operation_logs` VALUES (2, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:44.709467');
INSERT INTO `operation_logs` VALUES (3, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:44.742981');
INSERT INTO `operation_logs` VALUES (4, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:44.775254');
INSERT INTO `operation_logs` VALUES (5, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:44.804918');
INSERT INTO `operation_logs` VALUES (6, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:44.834109');
INSERT INTO `operation_logs` VALUES (7, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:44.865377');
INSERT INTO `operation_logs` VALUES (8, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:44.897348');
INSERT INTO `operation_logs` VALUES (9, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:44.924374');
INSERT INTO `operation_logs` VALUES (10, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:44.959856');
INSERT INTO `operation_logs` VALUES (11, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:44.991196');
INSERT INTO `operation_logs` VALUES (12, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:45.017121');
INSERT INTO `operation_logs` VALUES (13, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:45.041216');
INSERT INTO `operation_logs` VALUES (14, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:45.062597');
INSERT INTO `operation_logs` VALUES (15, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:45.091746');
INSERT INTO `operation_logs` VALUES (16, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:45.108656');
INSERT INTO `operation_logs` VALUES (17, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:45.141712');
INSERT INTO `operation_logs` VALUES (18, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:45.175413');
INSERT INTO `operation_logs` VALUES (19, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:05:45.208429');
INSERT INTO `operation_logs` VALUES (20, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', NULL, '2026-03-15 20:18:29.224546');
INSERT INTO `operation_logs` VALUES (21, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', NULL, '2026-03-15 20:18:29.240748');
INSERT INTO `operation_logs` VALUES (22, '查询', '查询操作', '系统', 'failed', '/@vite/client', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 'HTTP 404', '2026-03-15 20:18:29.261511');
INSERT INTO `operation_logs` VALUES (23, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', NULL, '2026-03-15 20:29:46.938054');
INSERT INTO `operation_logs` VALUES (24, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', NULL, '2026-03-15 20:29:46.941673');
INSERT INTO `operation_logs` VALUES (25, '查询', '查询操作', '系统', 'failed', '/@vite/client', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) TraeCN/1.107.1 Chrome/142.0.7444.235 Electron/39.2.7 Safari/537.36', 'HTTP 404', '2026-03-15 20:29:46.955977');
INSERT INTO `operation_logs` VALUES (26, '用户', '用户登录', '系统', 'success', '/api/system/login', 'POST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:26.087315');
INSERT INTO `operation_logs` VALUES (27, '查询', '查询用户详情', '系统', 'success', '/api/system/users/me', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:26.105140');
INSERT INTO `operation_logs` VALUES (28, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:32:26.169097');
INSERT INTO `operation_logs` VALUES (29, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:26.195586');
INSERT INTO `operation_logs` VALUES (30, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:26.208027');
INSERT INTO `operation_logs` VALUES (31, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:26.212255');
INSERT INTO `operation_logs` VALUES (32, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:26.226359');
INSERT INTO `operation_logs` VALUES (33, '用户', '用户登录', '系统', 'success', '/api/system/login', 'POST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:36.654474');
INSERT INTO `operation_logs` VALUES (34, '查询', '查询用户详情', '系统', 'success', '/api/system/users/me', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:36.668688');
INSERT INTO `operation_logs` VALUES (35, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:36.733528');
INSERT INTO `operation_logs` VALUES (36, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:36.743207');
INSERT INTO `operation_logs` VALUES (37, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:36.747573');
INSERT INTO `operation_logs` VALUES (38, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:36.766265');
INSERT INTO `operation_logs` VALUES (39, '操作', '操作操作', '系统', 'success', '/api/system/users', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:39.893413');
INSERT INTO `operation_logs` VALUES (40, '操作', '操作操作', '系统', 'success', '/api/system/users', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:39.904403');
INSERT INTO `operation_logs` VALUES (41, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:39.924672');
INSERT INTO `operation_logs` VALUES (42, '操作', '操作操作', '系统', 'success', '/api/system/users', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:39.932130');
INSERT INTO `operation_logs` VALUES (43, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:39.934688');
INSERT INTO `operation_logs` VALUES (44, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:39.952112');
INSERT INTO `operation_logs` VALUES (45, '操作', '操作操作', '系统', 'success', '/api/role/users/1/roles', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:39.963792');
INSERT INTO `operation_logs` VALUES (46, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:39.965477');
INSERT INTO `operation_logs` VALUES (47, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:39.985879');
INSERT INTO `operation_logs` VALUES (48, '操作', '操作操作', '系统', 'success', '/api/role/users/2/roles', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:39.993684');
INSERT INTO `operation_logs` VALUES (49, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:40.006854');
INSERT INTO `operation_logs` VALUES (50, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:40.015522');
INSERT INTO `operation_logs` VALUES (51, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:40.031945');
INSERT INTO `operation_logs` VALUES (52, '操作', '操作操作', '系统', 'success', '/api/role/roles', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:41.173399');
INSERT INTO `operation_logs` VALUES (53, '操作', '操作操作', '系统', 'success', '/api/role/roles', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:41.173399');
INSERT INTO `operation_logs` VALUES (54, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:41.192819');
INSERT INTO `operation_logs` VALUES (55, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:41.212580');
INSERT INTO `operation_logs` VALUES (56, '操作', '操作操作', '系统', 'success', '/api/dtn/graph-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:43.214958');
INSERT INTO `operation_logs` VALUES (57, '操作', '操作操作', '系统', 'success', '/api/dtn/graph-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:43.214958');
INSERT INTO `operation_logs` VALUES (58, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:43.226209');
INSERT INTO `operation_logs` VALUES (59, '操作', '操作操作', '系统', 'success', '/api/dtn/graph-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:43.235532');
INSERT INTO `operation_logs` VALUES (60, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:43.237134');
INSERT INTO `operation_logs` VALUES (61, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:43.246924');
INSERT INTO `operation_logs` VALUES (62, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:43.256996');
INSERT INTO `operation_logs` VALUES (63, '操作', '操作操作', '系统', 'success', '/api/dtn/dim-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:44.372394');
INSERT INTO `operation_logs` VALUES (64, '操作', '操作操作', '系统', 'success', '/api/dtn/dim-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:44.373426');
INSERT INTO `operation_logs` VALUES (65, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:44.384788');
INSERT INTO `operation_logs` VALUES (66, '操作', '操作操作', '系统', 'success', '/api/dtn/dim-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:44.394071');
INSERT INTO `operation_logs` VALUES (67, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:44.398899');
INSERT INTO `operation_logs` VALUES (68, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:44.409436');
INSERT INTO `operation_logs` VALUES (69, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:44.422727');
INSERT INTO `operation_logs` VALUES (70, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:44.967206');
INSERT INTO `operation_logs` VALUES (71, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:44.982438');
INSERT INTO `operation_logs` VALUES (72, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:44.983021');
INSERT INTO `operation_logs` VALUES (73, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:44.997217');
INSERT INTO `operation_logs` VALUES (74, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:46.085537');
INSERT INTO `operation_logs` VALUES (75, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:46.096485');
INSERT INTO `operation_logs` VALUES (76, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:46.101131');
INSERT INTO `operation_logs` VALUES (77, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:46.113140');
INSERT INTO `operation_logs` VALUES (78, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:47.018782');
INSERT INTO `operation_logs` VALUES (79, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:47.034443');
INSERT INTO `operation_logs` VALUES (80, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:47.036915');
INSERT INTO `operation_logs` VALUES (81, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:47.050343');
INSERT INTO `operation_logs` VALUES (82, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:47.852529');
INSERT INTO `operation_logs` VALUES (83, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:47.861735');
INSERT INTO `operation_logs` VALUES (84, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:47.862751');
INSERT INTO `operation_logs` VALUES (85, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:47.873384');
INSERT INTO `operation_logs` VALUES (86, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:49.434461');
INSERT INTO `operation_logs` VALUES (87, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:49.444635');
INSERT INTO `operation_logs` VALUES (88, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:49.446155');
INSERT INTO `operation_logs` VALUES (89, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:49.458044');
INSERT INTO `operation_logs` VALUES (90, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:50.001763');
INSERT INTO `operation_logs` VALUES (91, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:50.012312');
INSERT INTO `operation_logs` VALUES (92, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:50.015347');
INSERT INTO `operation_logs` VALUES (93, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:50.025288');
INSERT INTO `operation_logs` VALUES (94, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:51.361867');
INSERT INTO `operation_logs` VALUES (95, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:51.372841');
INSERT INTO `operation_logs` VALUES (96, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:51.374415');
INSERT INTO `operation_logs` VALUES (97, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:51.385840');
INSERT INTO `operation_logs` VALUES (98, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:52.153987');
INSERT INTO `operation_logs` VALUES (99, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:52.162551');
INSERT INTO `operation_logs` VALUES (100, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:52.163063');
INSERT INTO `operation_logs` VALUES (101, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:52.172852');
INSERT INTO `operation_logs` VALUES (102, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:52.687433');
INSERT INTO `operation_logs` VALUES (103, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:52.697299');
INSERT INTO `operation_logs` VALUES (104, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:52.700423');
INSERT INTO `operation_logs` VALUES (105, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:52.709749');
INSERT INTO `operation_logs` VALUES (106, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:53.291750');
INSERT INTO `operation_logs` VALUES (107, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:53.305590');
INSERT INTO `operation_logs` VALUES (108, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:53.306701');
INSERT INTO `operation_logs` VALUES (109, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:53.319080');
INSERT INTO `operation_logs` VALUES (110, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:53.876395');
INSERT INTO `operation_logs` VALUES (111, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:53.897526');
INSERT INTO `operation_logs` VALUES (112, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:53.899598');
INSERT INTO `operation_logs` VALUES (113, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:53.915556');
INSERT INTO `operation_logs` VALUES (114, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:54.257529');
INSERT INTO `operation_logs` VALUES (115, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:54.265393');
INSERT INTO `operation_logs` VALUES (116, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:54.267442');
INSERT INTO `operation_logs` VALUES (117, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:54.276514');
INSERT INTO `operation_logs` VALUES (118, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:54.642315');
INSERT INTO `operation_logs` VALUES (119, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:54.655918');
INSERT INTO `operation_logs` VALUES (120, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:54.657432');
INSERT INTO `operation_logs` VALUES (121, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:54.667196');
INSERT INTO `operation_logs` VALUES (122, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:55.025490');
INSERT INTO `operation_logs` VALUES (123, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:55.035257');
INSERT INTO `operation_logs` VALUES (124, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:55.037104');
INSERT INTO `operation_logs` VALUES (125, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:55.051024');
INSERT INTO `operation_logs` VALUES (126, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:55.591952');
INSERT INTO `operation_logs` VALUES (127, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:55.601402');
INSERT INTO `operation_logs` VALUES (128, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:55.604083');
INSERT INTO `operation_logs` VALUES (129, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:55.611933');
INSERT INTO `operation_logs` VALUES (130, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:56.024866');
INSERT INTO `operation_logs` VALUES (131, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:56.032277');
INSERT INTO `operation_logs` VALUES (132, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:56.034103');
INSERT INTO `operation_logs` VALUES (133, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:56.045059');
INSERT INTO `operation_logs` VALUES (134, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:56.426667');
INSERT INTO `operation_logs` VALUES (135, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:56.437578');
INSERT INTO `operation_logs` VALUES (136, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:56.439780');
INSERT INTO `operation_logs` VALUES (137, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:56.449879');
INSERT INTO `operation_logs` VALUES (138, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:57.380525');
INSERT INTO `operation_logs` VALUES (139, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:57.395779');
INSERT INTO `operation_logs` VALUES (140, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:57.397387');
INSERT INTO `operation_logs` VALUES (141, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:57.415317');
INSERT INTO `operation_logs` VALUES (142, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:58.563368');
INSERT INTO `operation_logs` VALUES (143, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:58.580502');
INSERT INTO `operation_logs` VALUES (144, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:58.582931');
INSERT INTO `operation_logs` VALUES (145, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:58.594531');
INSERT INTO `operation_logs` VALUES (146, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:59.445483');
INSERT INTO `operation_logs` VALUES (147, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:59.458049');
INSERT INTO `operation_logs` VALUES (148, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:59.460933');
INSERT INTO `operation_logs` VALUES (149, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:59.470052');
INSERT INTO `operation_logs` VALUES (150, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:59.900461');
INSERT INTO `operation_logs` VALUES (151, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:59.915815');
INSERT INTO `operation_logs` VALUES (152, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:59.916949');
INSERT INTO `operation_logs` VALUES (153, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:32:59.929233');
INSERT INTO `operation_logs` VALUES (154, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:01.146669');
INSERT INTO `operation_logs` VALUES (155, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:01.157531');
INSERT INTO `operation_logs` VALUES (156, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:01.159569');
INSERT INTO `operation_logs` VALUES (157, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:01.172061');
INSERT INTO `operation_logs` VALUES (158, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:01.189222');
INSERT INTO `operation_logs` VALUES (159, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:01.261596');
INSERT INTO `operation_logs` VALUES (160, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:01.262649');
INSERT INTO `operation_logs` VALUES (161, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:01.282680');
INSERT INTO `operation_logs` VALUES (162, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:01.586703');
INSERT INTO `operation_logs` VALUES (163, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:01.604984');
INSERT INTO `operation_logs` VALUES (164, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:04.232631');
INSERT INTO `operation_logs` VALUES (165, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:04.244003');
INSERT INTO `operation_logs` VALUES (166, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:04.245596');
INSERT INTO `operation_logs` VALUES (167, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:04.255281');
INSERT INTO `operation_logs` VALUES (168, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:04.649803');
INSERT INTO `operation_logs` VALUES (169, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:04.658529');
INSERT INTO `operation_logs` VALUES (170, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:04.661150');
INSERT INTO `operation_logs` VALUES (171, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:04.670708');
INSERT INTO `operation_logs` VALUES (172, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:05.755889');
INSERT INTO `operation_logs` VALUES (173, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:05.767238');
INSERT INTO `operation_logs` VALUES (174, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:05.767754');
INSERT INTO `operation_logs` VALUES (175, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:05.780424');
INSERT INTO `operation_logs` VALUES (176, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:06.554759');
INSERT INTO `operation_logs` VALUES (177, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:06.562365');
INSERT INTO `operation_logs` VALUES (178, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:06.564568');
INSERT INTO `operation_logs` VALUES (179, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:06.579697');
INSERT INTO `operation_logs` VALUES (180, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:07.379056');
INSERT INTO `operation_logs` VALUES (181, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:07.389969');
INSERT INTO `operation_logs` VALUES (182, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:07.391483');
INSERT INTO `operation_logs` VALUES (183, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:07.401515');
INSERT INTO `operation_logs` VALUES (184, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:08.459608');
INSERT INTO `operation_logs` VALUES (185, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:08.471546');
INSERT INTO `operation_logs` VALUES (186, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:08.472638');
INSERT INTO `operation_logs` VALUES (187, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:08.485939');
INSERT INTO `operation_logs` VALUES (188, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:09.105521');
INSERT INTO `operation_logs` VALUES (189, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:09.116473');
INSERT INTO `operation_logs` VALUES (190, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:09.118038');
INSERT INTO `operation_logs` VALUES (191, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:09.128451');
INSERT INTO `operation_logs` VALUES (192, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:10.673036');
INSERT INTO `operation_logs` VALUES (193, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:10.682776');
INSERT INTO `operation_logs` VALUES (194, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:10.685523');
INSERT INTO `operation_logs` VALUES (195, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:10.696267');
INSERT INTO `operation_logs` VALUES (196, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:11.610117');
INSERT INTO `operation_logs` VALUES (197, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:11.623210');
INSERT INTO `operation_logs` VALUES (198, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:11.624738');
INSERT INTO `operation_logs` VALUES (199, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:11.635099');
INSERT INTO `operation_logs` VALUES (200, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:12.436069');
INSERT INTO `operation_logs` VALUES (201, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:12.448715');
INSERT INTO `operation_logs` VALUES (202, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:12.450801');
INSERT INTO `operation_logs` VALUES (203, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:12.470523');
INSERT INTO `operation_logs` VALUES (204, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:12.860394');
INSERT INTO `operation_logs` VALUES (205, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:12.869046');
INSERT INTO `operation_logs` VALUES (206, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:12.870100');
INSERT INTO `operation_logs` VALUES (207, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:12.880991');
INSERT INTO `operation_logs` VALUES (208, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:22.760893');
INSERT INTO `operation_logs` VALUES (209, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:22.766321');
INSERT INTO `operation_logs` VALUES (210, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:22.778714');
INSERT INTO `operation_logs` VALUES (211, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:33:22.793955');
INSERT INTO `operation_logs` VALUES (212, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:38.956462');
INSERT INTO `operation_logs` VALUES (213, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:38.967307');
INSERT INTO `operation_logs` VALUES (214, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:38.976987');
INSERT INTO `operation_logs` VALUES (215, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:38.987689');
INSERT INTO `operation_logs` VALUES (216, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:39.006449');
INSERT INTO `operation_logs` VALUES (217, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:39.024725');
INSERT INTO `operation_logs` VALUES (218, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:39.044015');
INSERT INTO `operation_logs` VALUES (219, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:39.067171');
INSERT INTO `operation_logs` VALUES (220, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:39.615855');
INSERT INTO `operation_logs` VALUES (221, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:39.632430');
INSERT INTO `operation_logs` VALUES (222, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:41.313348');
INSERT INTO `operation_logs` VALUES (223, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:41.324643');
INSERT INTO `operation_logs` VALUES (224, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:41.331327');
INSERT INTO `operation_logs` VALUES (225, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:41.349408');
INSERT INTO `operation_logs` VALUES (226, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:42.186246');
INSERT INTO `operation_logs` VALUES (227, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:42.201708');
INSERT INTO `operation_logs` VALUES (228, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:42.208052');
INSERT INTO `operation_logs` VALUES (229, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:35:42.229122');
INSERT INTO `operation_logs` VALUES (230, '查询', '查询操作', '系统', 'failed', '/favicon.ico', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', 'HTTP 404', '2026-03-15 20:35:56.044666');
INSERT INTO `operation_logs` VALUES (231, '用户', '用户登录', '系统', 'success', '/api/system/login', 'POST', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:07.519872');
INSERT INTO `operation_logs` VALUES (232, '查询', '查询用户详情', '系统', 'success', '/api/system/users/me', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:07.538133');
INSERT INTO `operation_logs` VALUES (233, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:07.711856');
INSERT INTO `operation_logs` VALUES (234, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:07.717564');
INSERT INTO `operation_logs` VALUES (235, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:07.769793');
INSERT INTO `operation_logs` VALUES (236, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:07.778024');
INSERT INTO `operation_logs` VALUES (237, '操作', '操作操作', '系统', 'success', '/api/dtn/graph-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.433279');
INSERT INTO `operation_logs` VALUES (238, '操作', '操作操作', '系统', 'success', '/api/dtn/graph-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.434851');
INSERT INTO `operation_logs` VALUES (239, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.445587');
INSERT INTO `operation_logs` VALUES (240, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.456761');
INSERT INTO `operation_logs` VALUES (241, '操作', '操作操作', '系统', 'success', '/api/dtn/graph-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.457869');
INSERT INTO `operation_logs` VALUES (242, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.472006');
INSERT INTO `operation_logs` VALUES (243, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.481016');
INSERT INTO `operation_logs` VALUES (244, '操作', '操作操作', '系统', 'success', '/api/dtn/dim-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.791127');
INSERT INTO `operation_logs` VALUES (245, '操作', '操作操作', '系统', 'success', '/api/dtn/dim-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.792252');
INSERT INTO `operation_logs` VALUES (246, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.805076');
INSERT INTO `operation_logs` VALUES (247, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.815120');
INSERT INTO `operation_logs` VALUES (248, '操作', '操作操作', '系统', 'success', '/api/dtn/dim-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.819988');
INSERT INTO `operation_logs` VALUES (249, '操作', '操作操作', '系统', 'success', '/api/dtn/dim-db', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.826840');
INSERT INTO `operation_logs` VALUES (250, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.832167');
INSERT INTO `operation_logs` VALUES (251, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:11.840762');
INSERT INTO `operation_logs` VALUES (252, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:12.879760');
INSERT INTO `operation_logs` VALUES (253, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:12.890496');
INSERT INTO `operation_logs` VALUES (254, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:12.893729');
INSERT INTO `operation_logs` VALUES (255, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:12.908966');
INSERT INTO `operation_logs` VALUES (256, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:13.981289');
INSERT INTO `operation_logs` VALUES (257, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:13.998614');
INSERT INTO `operation_logs` VALUES (258, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:14.005461');
INSERT INTO `operation_logs` VALUES (259, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:14.018967');
INSERT INTO `operation_logs` VALUES (260, '操作', '操作操作', '系统', 'success', '/api/system/users', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.476446');
INSERT INTO `operation_logs` VALUES (261, '操作', '操作操作', '系统', 'success', '/api/system/users', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.480037');
INSERT INTO `operation_logs` VALUES (262, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.492472');
INSERT INTO `operation_logs` VALUES (263, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.502457');
INSERT INTO `operation_logs` VALUES (264, '操作', '操作操作', '系统', 'success', '/api/system/users', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.507862');
INSERT INTO `operation_logs` VALUES (265, '操作', '操作操作', '系统', 'success', '/api/system/users', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.516427');
INSERT INTO `operation_logs` VALUES (266, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.521696');
INSERT INTO `operation_logs` VALUES (267, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.531779');
INSERT INTO `operation_logs` VALUES (268, '操作', '操作操作', '系统', 'success', '/api/role/users/1/roles', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.533306');
INSERT INTO `operation_logs` VALUES (269, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.555497');
INSERT INTO `operation_logs` VALUES (270, '操作', '操作操作', '系统', 'success', '/api/role/users/2/roles', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.567288');
INSERT INTO `operation_logs` VALUES (271, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.582362');
INSERT INTO `operation_logs` VALUES (272, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.598325');
INSERT INTO `operation_logs` VALUES (273, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.621455');
INSERT INTO `operation_logs` VALUES (274, '操作', '操作操作', '系统', 'success', '/api/role/roles', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.877727');
INSERT INTO `operation_logs` VALUES (275, '操作', '操作操作', '系统', 'success', '/api/role/roles', 'OPTIONS', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.877211');
INSERT INTO `operation_logs` VALUES (276, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.897854');
INSERT INTO `operation_logs` VALUES (277, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:16.914623');
INSERT INTO `operation_logs` VALUES (278, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:19.335045');
INSERT INTO `operation_logs` VALUES (279, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:19.347107');
INSERT INTO `operation_logs` VALUES (280, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:19.351483');
INSERT INTO `operation_logs` VALUES (281, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:36:19.363844');
INSERT INTO `operation_logs` VALUES (282, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:31.314221');
INSERT INTO `operation_logs` VALUES (283, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:31.318391');
INSERT INTO `operation_logs` VALUES (284, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/system-info', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:31.352397');
INSERT INTO `operation_logs` VALUES (285, '查询', '查询操作', '系统', 'success', '/api/common/dashboard/stats', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:31.360348');
INSERT INTO `operation_logs` VALUES (286, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:33.372744');
INSERT INTO `operation_logs` VALUES (287, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:33.383059');
INSERT INTO `operation_logs` VALUES (288, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:33.393938');
INSERT INTO `operation_logs` VALUES (289, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:33.405078');
INSERT INTO `operation_logs` VALUES (290, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:35.102438');
INSERT INTO `operation_logs` VALUES (291, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:35.112119');
INSERT INTO `operation_logs` VALUES (292, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:35.117603');
INSERT INTO `operation_logs` VALUES (293, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:35.127934');
INSERT INTO `operation_logs` VALUES (294, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:37.985455');
INSERT INTO `operation_logs` VALUES (295, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:37.993803');
INSERT INTO `operation_logs` VALUES (296, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:37.999661');
INSERT INTO `operation_logs` VALUES (297, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:38:38.008331');
INSERT INTO `operation_logs` VALUES (298, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:39:50.675968');
INSERT INTO `operation_logs` VALUES (299, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:39:50.687915');
INSERT INTO `operation_logs` VALUES (300, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:39:50.697449');
INSERT INTO `operation_logs` VALUES (301, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:39:50.707309');
INSERT INTO `operation_logs` VALUES (302, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:39:51.314058');
INSERT INTO `operation_logs` VALUES (303, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:39:51.324564');
INSERT INTO `operation_logs` VALUES (304, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:39:51.330535');
INSERT INTO `operation_logs` VALUES (305, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:39:51.342301');
INSERT INTO `operation_logs` VALUES (306, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:18.820742');
INSERT INTO `operation_logs` VALUES (307, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:18.831782');
INSERT INTO `operation_logs` VALUES (308, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:18.842885');
INSERT INTO `operation_logs` VALUES (309, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:18.857793');
INSERT INTO `operation_logs` VALUES (310, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:19.511563');
INSERT INTO `operation_logs` VALUES (311, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:19.522798');
INSERT INTO `operation_logs` VALUES (312, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:19.526913');
INSERT INTO `operation_logs` VALUES (313, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:19.536579');
INSERT INTO `operation_logs` VALUES (314, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:20.761292');
INSERT INTO `operation_logs` VALUES (315, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:20.771717');
INSERT INTO `operation_logs` VALUES (316, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:20.776526');
INSERT INTO `operation_logs` VALUES (317, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:20.788238');
INSERT INTO `operation_logs` VALUES (318, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:20.801523');
INSERT INTO `operation_logs` VALUES (319, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:20.821937');
INSERT INTO `operation_logs` VALUES (320, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:20.824124');
INSERT INTO `operation_logs` VALUES (321, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:20.847329');
INSERT INTO `operation_logs` VALUES (322, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:21.547623');
INSERT INTO `operation_logs` VALUES (323, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:21.567200');
INSERT INTO `operation_logs` VALUES (324, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:28.193239');
INSERT INTO `operation_logs` VALUES (325, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:28.203066');
INSERT INTO `operation_logs` VALUES (326, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:28.213796');
INSERT INTO `operation_logs` VALUES (327, '查询', '查询操作', '系统', 'success', '/api/dtn/graph-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:28.224609');
INSERT INTO `operation_logs` VALUES (328, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.255455');
INSERT INTO `operation_logs` VALUES (329, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.266222');
INSERT INTO `operation_logs` VALUES (330, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.271339');
INSERT INTO `operation_logs` VALUES (331, '查询', '查询操作', '系统', 'success', '/api/dtn/dim-db', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.282051');
INSERT INTO `operation_logs` VALUES (332, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.751473');
INSERT INTO `operation_logs` VALUES (333, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.761753');
INSERT INTO `operation_logs` VALUES (334, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.766667');
INSERT INTO `operation_logs` VALUES (335, '查询', '查询用户列表', '系统', 'success', '/api/system/users', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.778557');
INSERT INTO `operation_logs` VALUES (336, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.795078');
INSERT INTO `operation_logs` VALUES (337, '查询', '查询操作', '系统', 'success', '/api/role/users/1/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.818802');
INSERT INTO `operation_logs` VALUES (338, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.820390');
INSERT INTO `operation_logs` VALUES (339, '查询', '查询操作', '系统', 'success', '/api/role/users/2/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:29.841770');
INSERT INTO `operation_logs` VALUES (340, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:30.092612');
INSERT INTO `operation_logs` VALUES (341, '查询', '查询操作', '系统', 'success', '/api/role/roles', 'GET', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36', NULL, '2026-03-15 20:40:30.106358');

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
