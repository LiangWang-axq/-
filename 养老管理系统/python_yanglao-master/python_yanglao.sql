/*
 Navicat Premium Data Transfer

 Source Server         : localhost连接
 Source Server Type    : MySQL
 Source Server Version : 50737
 Source Host           : localhost:3306
 Source Schema         : python_yanglao

 Target Server Type    : MySQL
 Target Server Version : 50737
 File Encoding         : 65001

 Date: 17/01/2024 19:10:54
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id`, `permission_id`) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id`, `codename`) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 81 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO `auth_permission` VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO `auth_permission` VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO `auth_permission` VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO `auth_permission` VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO `auth_permission` VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO `auth_permission` VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO `auth_permission` VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO `auth_permission` VALUES (25, 'Can add ad', 7, 'add_ad');
INSERT INTO `auth_permission` VALUES (26, 'Can change ad', 7, 'change_ad');
INSERT INTO `auth_permission` VALUES (27, 'Can delete ad', 7, 'delete_ad');
INSERT INTO `auth_permission` VALUES (28, 'Can view ad', 7, 'view_ad');
INSERT INTO `auth_permission` VALUES (29, 'Can add classification', 8, 'add_classification');
INSERT INTO `auth_permission` VALUES (30, 'Can change classification', 8, 'change_classification');
INSERT INTO `auth_permission` VALUES (31, 'Can delete classification', 8, 'delete_classification');
INSERT INTO `auth_permission` VALUES (32, 'Can view classification', 8, 'view_classification');
INSERT INTO `auth_permission` VALUES (33, 'Can add error log', 9, 'add_errorlog');
INSERT INTO `auth_permission` VALUES (34, 'Can change error log', 9, 'change_errorlog');
INSERT INTO `auth_permission` VALUES (35, 'Can delete error log', 9, 'delete_errorlog');
INSERT INTO `auth_permission` VALUES (36, 'Can view error log', 9, 'view_errorlog');
INSERT INTO `auth_permission` VALUES (37, 'Can add login log', 10, 'add_loginlog');
INSERT INTO `auth_permission` VALUES (38, 'Can change login log', 10, 'change_loginlog');
INSERT INTO `auth_permission` VALUES (39, 'Can delete login log', 10, 'delete_loginlog');
INSERT INTO `auth_permission` VALUES (40, 'Can view login log', 10, 'view_loginlog');
INSERT INTO `auth_permission` VALUES (41, 'Can add notice', 11, 'add_notice');
INSERT INTO `auth_permission` VALUES (42, 'Can change notice', 11, 'change_notice');
INSERT INTO `auth_permission` VALUES (43, 'Can delete notice', 11, 'delete_notice');
INSERT INTO `auth_permission` VALUES (44, 'Can view notice', 11, 'view_notice');
INSERT INTO `auth_permission` VALUES (45, 'Can add op log', 12, 'add_oplog');
INSERT INTO `auth_permission` VALUES (46, 'Can change op log', 12, 'change_oplog');
INSERT INTO `auth_permission` VALUES (47, 'Can delete op log', 12, 'delete_oplog');
INSERT INTO `auth_permission` VALUES (48, 'Can view op log', 12, 'view_oplog');
INSERT INTO `auth_permission` VALUES (49, 'Can add tag', 13, 'add_tag');
INSERT INTO `auth_permission` VALUES (50, 'Can change tag', 13, 'change_tag');
INSERT INTO `auth_permission` VALUES (51, 'Can delete tag', 13, 'delete_tag');
INSERT INTO `auth_permission` VALUES (52, 'Can view tag', 13, 'view_tag');
INSERT INTO `auth_permission` VALUES (53, 'Can add user', 14, 'add_user');
INSERT INTO `auth_permission` VALUES (54, 'Can change user', 14, 'change_user');
INSERT INTO `auth_permission` VALUES (55, 'Can delete user', 14, 'delete_user');
INSERT INTO `auth_permission` VALUES (56, 'Can view user', 14, 'view_user');
INSERT INTO `auth_permission` VALUES (57, 'Can add thing', 15, 'add_thing');
INSERT INTO `auth_permission` VALUES (58, 'Can change thing', 15, 'change_thing');
INSERT INTO `auth_permission` VALUES (59, 'Can delete thing', 15, 'delete_thing');
INSERT INTO `auth_permission` VALUES (60, 'Can view thing', 15, 'view_thing');
INSERT INTO `auth_permission` VALUES (61, 'Can add banner', 16, 'add_banner');
INSERT INTO `auth_permission` VALUES (62, 'Can change banner', 16, 'change_banner');
INSERT INTO `auth_permission` VALUES (63, 'Can delete banner', 16, 'delete_banner');
INSERT INTO `auth_permission` VALUES (64, 'Can view banner', 16, 'view_banner');
INSERT INTO `auth_permission` VALUES (65, 'Can add address', 17, 'add_address');
INSERT INTO `auth_permission` VALUES (66, 'Can change address', 17, 'change_address');
INSERT INTO `auth_permission` VALUES (67, 'Can delete address', 17, 'delete_address');
INSERT INTO `auth_permission` VALUES (68, 'Can view address', 17, 'view_address');
INSERT INTO `auth_permission` VALUES (69, 'Can add family', 18, 'add_family');
INSERT INTO `auth_permission` VALUES (70, 'Can change family', 18, 'change_family');
INSERT INTO `auth_permission` VALUES (71, 'Can delete family', 18, 'delete_family');
INSERT INTO `auth_permission` VALUES (72, 'Can view family', 18, 'view_family');
INSERT INTO `auth_permission` VALUES (73, 'Can add medical', 19, 'add_medical');
INSERT INTO `auth_permission` VALUES (74, 'Can change medical', 19, 'change_medical');
INSERT INTO `auth_permission` VALUES (75, 'Can delete medical', 19, 'delete_medical');
INSERT INTO `auth_permission` VALUES (76, 'Can view medical', 19, 'view_medical');
INSERT INTO `auth_permission` VALUES (77, 'Can add worker', 20, 'add_worker');
INSERT INTO `auth_permission` VALUES (78, 'Can change worker', 20, 'change_worker');
INSERT INTO `auth_permission` VALUES (79, 'Can delete worker', 20, 'delete_worker');
INSERT INTO `auth_permission` VALUES (80, 'Can view worker', 20, 'view_worker');

-- ----------------------------
-- Table structure for auth_user
-- ----------------------------
DROP TABLE IF EXISTS `auth_user`;
CREATE TABLE `auth_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_groups`;
CREATE TABLE `auth_user_groups`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_groups_user_id_group_id_94350c0c_uniq`(`user_id`, `group_id`) USING BTREE,
  INDEX `auth_user_groups_group_id_97559544_fk_auth_group_id`(`group_id`) USING BTREE,
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_groups
-- ----------------------------

-- ----------------------------
-- Table structure for auth_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_user_user_permissions`;
CREATE TABLE `auth_user_user_permissions`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq`(`user_id`, `permission_id`) USING BTREE,
  INDEX `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm`(`permission_id`) USING BTREE,
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_user_user_permissions
-- ----------------------------

-- ----------------------------
-- Table structure for b_ad
-- ----------------------------
DROP TABLE IF EXISTS `b_ad`;
CREATE TABLE `b_ad`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `image` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `link` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_ad
-- ----------------------------

-- ----------------------------
-- Table structure for b_address
-- ----------------------------
DROP TABLE IF EXISTS `b_address`;
CREATE TABLE `b_address`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `mobile` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `desc` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `default` tinyint(1) NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `user_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `b_address_user_id_a37a8d6a_fk_b_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `b_address_user_id_a37a8d6a_fk_b_user_id` FOREIGN KEY (`user_id`) REFERENCES `b_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_address
-- ----------------------------

-- ----------------------------
-- Table structure for b_banner
-- ----------------------------
DROP TABLE IF EXISTS `b_banner`;
CREATE TABLE `b_banner`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `image` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `thing_id` bigint(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `b_banner_thing_id_3f307d00_fk_b_thing_id`(`thing_id`) USING BTREE,
  CONSTRAINT `b_banner_thing_id_3f307d00_fk_b_thing_id` FOREIGN KEY (`thing_id`) REFERENCES `b_thing` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_banner
-- ----------------------------

-- ----------------------------
-- Table structure for b_classification
-- ----------------------------
DROP TABLE IF EXISTS `b_classification`;
CREATE TABLE `b_classification`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_classification
-- ----------------------------
INSERT INTO `b_classification` VALUES (1, '紫云楼202室', '2024-01-17 18:24:30.095044');
INSERT INTO `b_classification` VALUES (2, '清华园103室', '2024-01-17 18:24:47.913833');
INSERT INTO `b_classification` VALUES (3, '名士豪庭104室', '2024-01-17 18:25:13.220792');
INSERT INTO `b_classification` VALUES (4, '名士豪庭105室', '2024-01-17 18:25:27.495442');

-- ----------------------------
-- Table structure for b_error_log
-- ----------------------------
DROP TABLE IF EXISTS `b_error_log`;
CREATE TABLE `b_error_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `ip` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `method` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `content` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `log_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_error_log
-- ----------------------------

-- ----------------------------
-- Table structure for b_family
-- ----------------------------
DROP TABLE IF EXISTS `b_family`;
CREATE TABLE `b_family`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sex` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `age` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `oldperson` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `relation` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remark` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_family
-- ----------------------------

-- ----------------------------
-- Table structure for b_login_log
-- ----------------------------
DROP TABLE IF EXISTS `b_login_log`;
CREATE TABLE `b_login_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ip` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ua` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `log_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_login_log
-- ----------------------------
INSERT INTO `b_login_log` VALUES (1, 'admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', '2024-01-17 18:21:09.680087');
INSERT INTO `b_login_log` VALUES (2, 'admin123', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', '2024-01-17 18:59:39.308236');
INSERT INTO `b_login_log` VALUES (3, 'admin123', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', '2024-01-17 18:59:52.638050');
INSERT INTO `b_login_log` VALUES (4, 'admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', '2024-01-17 19:00:04.004606');
INSERT INTO `b_login_log` VALUES (5, 'admin', '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', '2024-01-17 19:03:35.189951');

-- ----------------------------
-- Table structure for b_medical
-- ----------------------------
DROP TABLE IF EXISTS `b_medical`;
CREATE TABLE `b_medical`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `medical_history` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `desc` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_medical
-- ----------------------------

-- ----------------------------
-- Table structure for b_notice
-- ----------------------------
DROP TABLE IF EXISTS `b_notice`;
CREATE TABLE `b_notice`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `content` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_notice
-- ----------------------------

-- ----------------------------
-- Table structure for b_op_log
-- ----------------------------
DROP TABLE IF EXISTS `b_op_log`;
CREATE TABLE `b_op_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `re_ip` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `re_time` datetime(6) NULL DEFAULT NULL,
  `re_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `re_method` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `re_content` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `access_time` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 302 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_op_log
-- ----------------------------
INSERT INTO `b_op_log` VALUES (1, '127.0.0.1', '2024-01-16 19:00:57.809994', '/', 'GET', NULL, '14');
INSERT INTO `b_op_log` VALUES (2, '127.0.0.1', '2024-01-17 18:16:31.495836', '/myapp/admin/classification/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (3, '127.0.0.1', '2024-01-17 18:16:31.499179', '/myapp/admin/classification/list', 'GET', NULL, '10');
INSERT INTO `b_op_log` VALUES (4, '127.0.0.1', '2024-01-17 18:16:31.517275', '/myapp/admin/classification/list', 'GET', NULL, '29');
INSERT INTO `b_op_log` VALUES (5, '127.0.0.1', '2024-01-17 18:19:12.965159', '/myapp/admin/tag/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (6, '127.0.0.1', '2024-01-17 18:19:12.966183', '/myapp/admin/tag/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (7, '127.0.0.1', '2024-01-17 18:19:12.981298', '/myapp/admin/tag/list', 'GET', NULL, '23');
INSERT INTO `b_op_log` VALUES (8, '127.0.0.1', '2024-01-17 18:19:14.890434', '/myapp/admin/park/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (9, '127.0.0.1', '2024-01-17 18:19:14.891497', '/myapp/admin/park/list', 'GET', NULL, '9');
INSERT INTO `b_op_log` VALUES (10, '127.0.0.1', '2024-01-17 18:19:14.928723', '/myapp/admin/park/list', 'GET', NULL, '20');
INSERT INTO `b_op_log` VALUES (11, '127.0.0.1', '2024-01-17 18:19:15.953239', '/myapp/admin/asset/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (12, '127.0.0.1', '2024-01-17 18:19:16.980618', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (13, '127.0.0.1', '2024-01-17 18:19:17.811872', '/myapp/admin/user/list', 'GET', NULL, '21');
INSERT INTO `b_op_log` VALUES (14, '127.0.0.1', '2024-01-17 18:19:34.706938', '/myapp/admin/user/create', 'POST', NULL, '36');
INSERT INTO `b_op_log` VALUES (15, '127.0.0.1', '2024-01-17 18:20:11.390157', '/myapp/admin/user/create', 'POST', NULL, '6');
INSERT INTO `b_op_log` VALUES (16, '127.0.0.1', '2024-01-17 18:20:36.451752', '/myapp/admin/user/create', 'POST', NULL, '4');
INSERT INTO `b_op_log` VALUES (17, '127.0.0.1', '2024-01-17 18:20:54.551413', '/myapp/admin/user/create', 'POST', NULL, '28');
INSERT INTO `b_op_log` VALUES (18, '127.0.0.1', '2024-01-17 18:20:54.594695', '/myapp/admin/user/list', 'GET', NULL, '21');
INSERT INTO `b_op_log` VALUES (19, '127.0.0.1', '2024-01-17 18:21:09.685094', '/myapp/admin/adminLogin', 'POST', NULL, '33');
INSERT INTO `b_op_log` VALUES (20, '127.0.0.1', '2024-01-17 18:21:09.796382', '/myapp/admin/tag/list', 'GET', NULL, '3');
INSERT INTO `b_op_log` VALUES (21, '127.0.0.1', '2024-01-17 18:21:09.798546', '/myapp/admin/tag/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (22, '127.0.0.1', '2024-01-17 18:21:09.800666', '/myapp/admin/tag/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (23, '127.0.0.1', '2024-01-17 18:21:11.289700', '/myapp/admin/user/list', 'GET', NULL, '22');
INSERT INTO `b_op_log` VALUES (24, '127.0.0.1', '2024-01-17 18:21:22.828213', '/myapp/admin/user/create', 'POST', NULL, '43');
INSERT INTO `b_op_log` VALUES (25, '127.0.0.1', '2024-01-17 18:21:22.873191', '/myapp/admin/user/list', 'GET', NULL, '23');
INSERT INTO `b_op_log` VALUES (26, '127.0.0.1', '2024-01-17 18:21:36.060100', '/myapp/admin/user/create', 'POST', NULL, '39');
INSERT INTO `b_op_log` VALUES (27, '127.0.0.1', '2024-01-17 18:21:36.108604', '/myapp/admin/user/list', 'GET', NULL, '29');
INSERT INTO `b_op_log` VALUES (28, '127.0.0.1', '2024-01-17 18:22:10.136319', '/myapp/admin/classification/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (29, '127.0.0.1', '2024-01-17 18:23:22.058906', '/myapp/admin/tag/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (30, '127.0.0.1', '2024-01-17 18:23:41.755781', '/myapp/admin/tag/list', 'GET', NULL, '23');
INSERT INTO `b_op_log` VALUES (31, '127.0.0.1', '2024-01-17 18:23:47.170691', '/myapp/admin/tag/create', 'POST', NULL, '27');
INSERT INTO `b_op_log` VALUES (32, '127.0.0.1', '2024-01-17 18:23:47.209706', '/myapp/admin/tag/list', 'GET', NULL, '27');
INSERT INTO `b_op_log` VALUES (33, '127.0.0.1', '2024-01-17 18:23:51.749635', '/myapp/admin/tag/create', 'POST', NULL, '28');
INSERT INTO `b_op_log` VALUES (34, '127.0.0.1', '2024-01-17 18:23:51.776659', '/myapp/admin/tag/list', 'GET', NULL, '15');
INSERT INTO `b_op_log` VALUES (35, '127.0.0.1', '2024-01-17 18:23:57.255267', '/myapp/admin/tag/create', 'POST', NULL, '35');
INSERT INTO `b_op_log` VALUES (36, '127.0.0.1', '2024-01-17 18:23:57.276269', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (37, '127.0.0.1', '2024-01-17 18:24:02.378463', '/myapp/admin/tag/create', 'POST', NULL, '11');
INSERT INTO `b_op_log` VALUES (38, '127.0.0.1', '2024-01-17 18:24:02.423455', '/myapp/admin/tag/list', 'GET', NULL, '30');
INSERT INTO `b_op_log` VALUES (39, '127.0.0.1', '2024-01-17 18:24:06.152213', '/myapp/admin/tag/create', 'POST', NULL, '27');
INSERT INTO `b_op_log` VALUES (40, '127.0.0.1', '2024-01-17 18:24:06.187728', '/myapp/admin/tag/list', 'GET', NULL, '20');
INSERT INTO `b_op_log` VALUES (41, '127.0.0.1', '2024-01-17 18:24:08.912338', '/myapp/admin/classification/list', 'GET', NULL, '30');
INSERT INTO `b_op_log` VALUES (42, '127.0.0.1', '2024-01-17 18:24:30.098031', '/myapp/admin/classification/create', 'POST', NULL, '11');
INSERT INTO `b_op_log` VALUES (43, '127.0.0.1', '2024-01-17 18:24:30.114560', '/myapp/admin/classification/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (44, '127.0.0.1', '2024-01-17 18:24:47.917836', '/myapp/admin/classification/create', 'POST', NULL, '31');
INSERT INTO `b_op_log` VALUES (45, '127.0.0.1', '2024-01-17 18:24:47.936348', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (46, '127.0.0.1', '2024-01-17 18:25:13.225803', '/myapp/admin/classification/create', 'POST', NULL, '29');
INSERT INTO `b_op_log` VALUES (47, '127.0.0.1', '2024-01-17 18:25:13.240793', '/myapp/admin/classification/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (48, '127.0.0.1', '2024-01-17 18:25:27.500451', '/myapp/admin/classification/create', 'POST', NULL, '30');
INSERT INTO `b_op_log` VALUES (49, '127.0.0.1', '2024-01-17 18:25:27.538451', '/myapp/admin/classification/list', 'GET', NULL, '22');
INSERT INTO `b_op_log` VALUES (50, '127.0.0.1', '2024-01-17 18:25:31.394347', '/myapp/admin/classification/update', 'POST', NULL, '21');
INSERT INTO `b_op_log` VALUES (51, '127.0.0.1', '2024-01-17 18:25:31.409522', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (52, '127.0.0.1', '2024-01-17 18:25:35.466938', '/myapp/admin/classification/update', 'POST', NULL, '10');
INSERT INTO `b_op_log` VALUES (53, '127.0.0.1', '2024-01-17 18:25:35.484939', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (54, '127.0.0.1', '2024-01-17 18:26:01.898549', '/myapp/admin/classification/list', 'GET', NULL, '25');
INSERT INTO `b_op_log` VALUES (55, '127.0.0.1', '2024-01-17 18:26:15.553730', '/myapp/admin/asset/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (56, '127.0.0.1', '2024-01-17 18:26:17.398194', '/myapp/admin/classification/list', 'GET', NULL, '24');
INSERT INTO `b_op_log` VALUES (57, '127.0.0.1', '2024-01-17 18:27:40.420767', '/myapp/admin/classification/list', 'GET', NULL, '17');
INSERT INTO `b_op_log` VALUES (58, '127.0.0.1', '2024-01-17 18:27:42.097468', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (59, '127.0.0.1', '2024-01-17 18:27:42.099467', '/myapp/admin/tag/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (60, '127.0.0.1', '2024-01-17 18:27:42.108476', '/myapp/admin/tag/list', 'GET', NULL, '15');
INSERT INTO `b_op_log` VALUES (61, '127.0.0.1', '2024-01-17 18:33:49.468203', '/myapp/admin/tag/list', 'GET', NULL, '3');
INSERT INTO `b_op_log` VALUES (62, '127.0.0.1', '2024-01-17 18:33:49.468203', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (63, '127.0.0.1', '2024-01-17 18:33:49.469238', '/myapp/admin/tag/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (64, '127.0.0.1', '2024-01-17 18:34:34.804854', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (65, '127.0.0.1', '2024-01-17 18:34:34.806386', '/myapp/admin/classification/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (66, '127.0.0.1', '2024-01-17 18:34:34.808899', '/myapp/admin/classification/list', 'GET', NULL, '9');
INSERT INTO `b_op_log` VALUES (67, '127.0.0.1', '2024-01-17 18:34:35.496786', '/myapp/admin/classification/list', 'GET', NULL, '26');
INSERT INTO `b_op_log` VALUES (68, '127.0.0.1', '2024-01-17 18:34:36.073419', '/myapp/admin/classification/list', 'GET', NULL, '1');
INSERT INTO `b_op_log` VALUES (69, '127.0.0.1', '2024-01-17 18:34:36.075976', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (70, '127.0.0.1', '2024-01-17 18:34:36.087152', '/myapp/admin/classification/list', 'GET', NULL, '16');
INSERT INTO `b_op_log` VALUES (71, '127.0.0.1', '2024-01-17 18:35:04.633297', '/myapp/admin/thing/create', 'POST', NULL, '12');
INSERT INTO `b_op_log` VALUES (72, '127.0.0.1', '2024-01-17 18:35:04.675955', '/myapp/admin/thing/list', 'GET', NULL, '24');
INSERT INTO `b_op_log` VALUES (73, '127.0.0.1', '2024-01-17 18:35:11.023144', '/myapp/admin/thing/update', 'POST', NULL, '31');
INSERT INTO `b_op_log` VALUES (74, '127.0.0.1', '2024-01-17 18:35:11.066021', '/myapp/admin/thing/list', 'GET', NULL, '27');
INSERT INTO `b_op_log` VALUES (75, '127.0.0.1', '2024-01-17 18:35:35.801357', '/myapp/admin/thing/create', 'POST', NULL, '11');
INSERT INTO `b_op_log` VALUES (76, '127.0.0.1', '2024-01-17 18:35:35.847906', '/myapp/admin/thing/list', 'GET', NULL, '29');
INSERT INTO `b_op_log` VALUES (77, '127.0.0.1', '2024-01-17 18:36:03.474562', '/myapp/admin/thing/create', 'POST', NULL, '37');
INSERT INTO `b_op_log` VALUES (78, '127.0.0.1', '2024-01-17 18:36:03.497544', '/myapp/admin/thing/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (79, '127.0.0.1', '2024-01-17 18:36:19.211213', '/myapp/admin/thing/create', 'POST', NULL, '33');
INSERT INTO `b_op_log` VALUES (80, '127.0.0.1', '2024-01-17 18:36:19.246894', '/myapp/admin/thing/list', 'GET', NULL, '17');
INSERT INTO `b_op_log` VALUES (81, '127.0.0.1', '2024-01-17 18:36:39.347398', '/myapp/admin/thing/create', 'POST', NULL, '18');
INSERT INTO `b_op_log` VALUES (82, '127.0.0.1', '2024-01-17 18:36:39.393375', '/myapp/admin/thing/list', 'GET', NULL, '24');
INSERT INTO `b_op_log` VALUES (83, '127.0.0.1', '2024-01-17 18:36:46.180169', '/myapp/admin/thing/update', 'POST', NULL, '40');
INSERT INTO `b_op_log` VALUES (84, '127.0.0.1', '2024-01-17 18:36:46.226681', '/myapp/admin/thing/list', 'GET', NULL, '25');
INSERT INTO `b_op_log` VALUES (85, '127.0.0.1', '2024-01-17 18:39:54.885009', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (86, '127.0.0.1', '2024-01-17 18:39:54.887114', '/myapp/admin/tag/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (87, '127.0.0.1', '2024-01-17 18:39:54.888367', '/myapp/admin/tag/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (88, '127.0.0.1', '2024-01-17 18:41:47.100814', '/myapp/admin/worker/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (89, '127.0.0.1', '2024-01-17 18:41:47.108816', '/myapp/admin/worker/list', 'GET', NULL, '12');
INSERT INTO `b_op_log` VALUES (90, '127.0.0.1', '2024-01-17 18:41:47.112806', '/myapp/admin/worker/list', 'GET', NULL, '9');
INSERT INTO `b_op_log` VALUES (91, '127.0.0.1', '2024-01-17 18:41:48.231759', '/myapp/admin/tag/list', 'GET', NULL, '12');
INSERT INTO `b_op_log` VALUES (92, '127.0.0.1', '2024-01-17 18:41:48.233759', '/myapp/admin/tag/list', 'GET', NULL, '15');
INSERT INTO `b_op_log` VALUES (93, '127.0.0.1', '2024-01-17 18:41:48.235750', '/myapp/admin/tag/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (94, '127.0.0.1', '2024-01-17 18:41:49.417102', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (95, '127.0.0.1', '2024-01-17 18:41:49.419091', '/myapp/admin/classification/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (96, '127.0.0.1', '2024-01-17 18:41:49.425100', '/myapp/admin/classification/list', 'GET', NULL, '12');
INSERT INTO `b_op_log` VALUES (97, '127.0.0.1', '2024-01-17 18:41:50.127344', '/myapp/admin/tag/list', 'GET', NULL, '11');
INSERT INTO `b_op_log` VALUES (98, '127.0.0.1', '2024-01-17 18:41:50.129673', '/myapp/admin/tag/list', 'GET', NULL, '14');
INSERT INTO `b_op_log` VALUES (99, '127.0.0.1', '2024-01-17 18:41:50.130194', '/myapp/admin/tag/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (100, '127.0.0.1', '2024-01-17 18:43:09.484122', '/myapp/admin/worker/create', 'POST', NULL, '4');
INSERT INTO `b_op_log` VALUES (101, '127.0.0.1', '2024-01-17 18:43:15.796167', '/myapp/admin/worker/create', 'POST', NULL, '3');
INSERT INTO `b_op_log` VALUES (102, '127.0.0.1', '2024-01-17 18:44:54.816039', '/myapp/admin/worker/create', 'POST', NULL, '24');
INSERT INTO `b_op_log` VALUES (103, '127.0.0.1', '2024-01-17 18:44:54.855938', '/myapp/admin/worker/list', 'GET', NULL, '22');
INSERT INTO `b_op_log` VALUES (104, '127.0.0.1', '2024-01-17 18:45:39.175634', '/myapp/admin/worker/create', 'POST', NULL, '28');
INSERT INTO `b_op_log` VALUES (105, '127.0.0.1', '2024-01-17 18:45:39.219042', '/myapp/admin/worker/list', 'GET', NULL, '27');
INSERT INTO `b_op_log` VALUES (106, '127.0.0.1', '2024-01-17 18:46:00.468274', '/myapp/admin/worker/create', 'POST', NULL, '30');
INSERT INTO `b_op_log` VALUES (107, '127.0.0.1', '2024-01-17 18:46:00.505691', '/myapp/admin/worker/list', 'GET', NULL, '23');
INSERT INTO `b_op_log` VALUES (108, '127.0.0.1', '2024-01-17 18:46:07.205818', '/myapp/admin/worker/create', 'POST', NULL, '29');
INSERT INTO `b_op_log` VALUES (109, '127.0.0.1', '2024-01-17 18:46:07.244651', '/myapp/admin/worker/list', 'GET', NULL, '21');
INSERT INTO `b_op_log` VALUES (110, '127.0.0.1', '2024-01-17 18:46:10.451498', '/myapp/admin/worker/update', 'POST', NULL, '34');
INSERT INTO `b_op_log` VALUES (111, '127.0.0.1', '2024-01-17 18:46:10.491166', '/myapp/admin/worker/list', 'GET', NULL, '24');
INSERT INTO `b_op_log` VALUES (112, '127.0.0.1', '2024-01-17 18:46:13.140886', '/myapp/admin/worker/delete', 'POST', NULL, '32');
INSERT INTO `b_op_log` VALUES (113, '127.0.0.1', '2024-01-17 18:46:13.172015', '/myapp/admin/worker/list', 'GET', NULL, '19');
INSERT INTO `b_op_log` VALUES (114, '127.0.0.1', '2024-01-17 18:46:15.993703', '/myapp/admin/worker/list', 'GET', NULL, '3');
INSERT INTO `b_op_log` VALUES (115, '127.0.0.1', '2024-01-17 18:46:18.634430', '/myapp/admin/classification/list', 'GET', NULL, '14');
INSERT INTO `b_op_log` VALUES (116, '127.0.0.1', '2024-01-17 18:46:19.304426', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (117, '127.0.0.1', '2024-01-17 18:46:19.307421', '/myapp/admin/tag/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (118, '127.0.0.1', '2024-01-17 18:46:19.310432', '/myapp/admin/tag/list', 'GET', NULL, '10');
INSERT INTO `b_op_log` VALUES (119, '127.0.0.1', '2024-01-17 18:46:20.104253', '/myapp/admin/classification/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (120, '127.0.0.1', '2024-01-17 18:46:20.102252', '/myapp/admin/classification/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (121, '127.0.0.1', '2024-01-17 18:46:20.109635', '/myapp/admin/classification/list', 'GET', NULL, '13');
INSERT INTO `b_op_log` VALUES (122, '127.0.0.1', '2024-01-17 18:46:24.250269', '/myapp/admin/thing/list', 'GET', NULL, '19');
INSERT INTO `b_op_log` VALUES (123, '127.0.0.1', '2024-01-17 18:46:25.320673', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (124, '127.0.0.1', '2024-01-17 18:46:25.322673', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (125, '127.0.0.1', '2024-01-17 18:46:25.323671', '/myapp/admin/tag/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (126, '127.0.0.1', '2024-01-17 18:46:36.928176', '/myapp/admin/tag/list', 'GET', NULL, '9');
INSERT INTO `b_op_log` VALUES (127, '127.0.0.1', '2024-01-17 18:46:36.941352', '/myapp/admin/tag/list', 'GET', NULL, '21');
INSERT INTO `b_op_log` VALUES (128, '127.0.0.1', '2024-01-17 18:46:36.943342', '/myapp/admin/tag/list', 'GET', NULL, '23');
INSERT INTO `b_op_log` VALUES (129, '127.0.0.1', '2024-01-17 18:46:39.088346', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (130, '127.0.0.1', '2024-01-17 18:46:39.090750', '/myapp/admin/tag/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (131, '127.0.0.1', '2024-01-17 18:46:39.092842', '/myapp/admin/tag/list', 'GET', NULL, '9');
INSERT INTO `b_op_log` VALUES (132, '127.0.0.1', '2024-01-17 18:47:59.703559', '/myapp/admin/classification/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (133, '127.0.0.1', '2024-01-17 18:47:59.708557', '/myapp/admin/classification/list', 'GET', NULL, '10');
INSERT INTO `b_op_log` VALUES (134, '127.0.0.1', '2024-01-17 18:47:59.714559', '/myapp/admin/classification/list', 'GET', NULL, '16');
INSERT INTO `b_op_log` VALUES (135, '127.0.0.1', '2024-01-17 18:50:23.549873', '/myapp/admin/classification/list', 'GET', NULL, '3');
INSERT INTO `b_op_log` VALUES (136, '127.0.0.1', '2024-01-17 18:50:23.553294', '/myapp/admin/classification/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (137, '127.0.0.1', '2024-01-17 18:50:23.574844', '/myapp/admin/classification/list', 'GET', NULL, '27');
INSERT INTO `b_op_log` VALUES (138, '127.0.0.1', '2024-01-17 18:50:24.214321', '/myapp/admin/family/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (139, '127.0.0.1', '2024-01-17 18:51:37.825839', '/myapp/admin/family/create', 'POST', NULL, '14');
INSERT INTO `b_op_log` VALUES (140, '127.0.0.1', '2024-01-17 18:51:37.863964', '/myapp/admin/family/list', 'GET', NULL, '25');
INSERT INTO `b_op_log` VALUES (141, '127.0.0.1', '2024-01-17 18:52:01.778907', '/myapp/admin/family/create', 'POST', NULL, '28');
INSERT INTO `b_op_log` VALUES (142, '127.0.0.1', '2024-01-17 18:52:01.822690', '/myapp/admin/family/list', 'GET', NULL, '30');
INSERT INTO `b_op_log` VALUES (143, '127.0.0.1', '2024-01-17 18:52:09.087998', '/myapp/admin/family/create', 'POST', NULL, '36');
INSERT INTO `b_op_log` VALUES (144, '127.0.0.1', '2024-01-17 18:52:09.131504', '/myapp/admin/family/list', 'GET', NULL, '29');
INSERT INTO `b_op_log` VALUES (145, '127.0.0.1', '2024-01-17 18:52:11.833892', '/myapp/admin/family/update', 'POST', NULL, '47');
INSERT INTO `b_op_log` VALUES (146, '127.0.0.1', '2024-01-17 18:52:11.874900', '/myapp/admin/family/list', 'GET', NULL, '24');
INSERT INTO `b_op_log` VALUES (147, '127.0.0.1', '2024-01-17 18:52:15.344105', '/myapp/admin/family/delete', 'POST', NULL, '42');
INSERT INTO `b_op_log` VALUES (148, '127.0.0.1', '2024-01-17 18:52:15.374105', '/myapp/admin/family/list', 'GET', NULL, '17');
INSERT INTO `b_op_log` VALUES (149, '127.0.0.1', '2024-01-17 18:52:16.837212', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (150, '127.0.0.1', '2024-01-17 18:52:16.841210', '/myapp/admin/tag/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (151, '127.0.0.1', '2024-01-17 18:52:16.852219', '/myapp/admin/tag/list', 'GET', NULL, '18');
INSERT INTO `b_op_log` VALUES (152, '127.0.0.1', '2024-01-17 18:53:59.455390', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (153, '127.0.0.1', '2024-01-17 18:53:59.458383', '/myapp/admin/tag/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (154, '127.0.0.1', '2024-01-17 18:53:59.460383', '/myapp/admin/tag/list', 'GET', NULL, '11');
INSERT INTO `b_op_log` VALUES (155, '127.0.0.1', '2024-01-17 18:56:13.679602', '/myapp/admin/tag/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (156, '127.0.0.1', '2024-01-17 18:56:13.678601', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (157, '127.0.0.1', '2024-01-17 18:56:13.688578', '/myapp/admin/tag/list', 'GET', NULL, '15');
INSERT INTO `b_op_log` VALUES (158, '127.0.0.1', '2024-01-17 18:56:15.083582', '/myapp/admin/medical/list', 'GET', NULL, '1');
INSERT INTO `b_op_log` VALUES (159, '127.0.0.1', '2024-01-17 18:56:15.087441', '/myapp/admin/medical/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (160, '127.0.0.1', '2024-01-17 18:56:15.093943', '/myapp/admin/medical/list', 'GET', NULL, '10');
INSERT INTO `b_op_log` VALUES (161, '127.0.0.1', '2024-01-17 18:56:41.263436', '/myapp/admin/medical/create', 'POST', NULL, '25');
INSERT INTO `b_op_log` VALUES (162, '127.0.0.1', '2024-01-17 18:56:41.282561', '/myapp/admin/medical/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (163, '127.0.0.1', '2024-01-17 18:57:01.877229', '/myapp/admin/medical/create', 'POST', NULL, '36');
INSERT INTO `b_op_log` VALUES (164, '127.0.0.1', '2024-01-17 18:57:01.896230', '/myapp/admin/medical/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (165, '127.0.0.1', '2024-01-17 18:57:18.980348', '/myapp/admin/medical/create', 'POST', NULL, '36');
INSERT INTO `b_op_log` VALUES (166, '127.0.0.1', '2024-01-17 18:57:19.021369', '/myapp/admin/medical/list', 'GET', NULL, '23');
INSERT INTO `b_op_log` VALUES (167, '127.0.0.1', '2024-01-17 18:57:25.563403', '/myapp/admin/medical/update', 'POST', NULL, '26');
INSERT INTO `b_op_log` VALUES (168, '127.0.0.1', '2024-01-17 18:57:25.602392', '/myapp/admin/medical/list', 'GET', NULL, '20');
INSERT INTO `b_op_log` VALUES (169, '127.0.0.1', '2024-01-17 18:57:28.997825', '/myapp/admin/medical/create', 'POST', NULL, '40');
INSERT INTO `b_op_log` VALUES (170, '127.0.0.1', '2024-01-17 18:57:29.044818', '/myapp/admin/medical/list', 'GET', NULL, '21');
INSERT INTO `b_op_log` VALUES (171, '127.0.0.1', '2024-01-17 18:57:30.828631', '/myapp/admin/medical/delete', 'POST', NULL, '32');
INSERT INTO `b_op_log` VALUES (172, '127.0.0.1', '2024-01-17 18:57:30.866177', '/myapp/admin/medical/list', 'GET', NULL, '25');
INSERT INTO `b_op_log` VALUES (173, '127.0.0.1', '2024-01-17 18:57:32.134000', '/myapp/admin/tag/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (174, '127.0.0.1', '2024-01-17 18:57:32.139997', '/myapp/admin/tag/list', 'GET', NULL, '12');
INSERT INTO `b_op_log` VALUES (175, '127.0.0.1', '2024-01-17 18:57:32.148996', '/myapp/admin/tag/list', 'GET', NULL, '21');
INSERT INTO `b_op_log` VALUES (176, '127.0.0.1', '2024-01-17 18:57:35.547725', '/myapp/admin/classification/list', 'GET', NULL, '3');
INSERT INTO `b_op_log` VALUES (177, '127.0.0.1', '2024-01-17 18:57:35.549713', '/myapp/admin/classification/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (178, '127.0.0.1', '2024-01-17 18:57:35.551714', '/myapp/admin/classification/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (179, '127.0.0.1', '2024-01-17 18:57:36.604354', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (180, '127.0.0.1', '2024-01-17 18:57:36.617362', '/myapp/admin/tag/list', 'GET', NULL, '17');
INSERT INTO `b_op_log` VALUES (181, '127.0.0.1', '2024-01-17 18:57:36.626353', '/myapp/admin/tag/list', 'GET', NULL, '26');
INSERT INTO `b_op_log` VALUES (182, '127.0.0.1', '2024-01-17 18:57:41.861068', '/myapp/admin/tag/list', 'GET', NULL, '3');
INSERT INTO `b_op_log` VALUES (183, '127.0.0.1', '2024-01-17 18:58:09.982313', '/myapp/admin/tag/update', 'POST', NULL, '29');
INSERT INTO `b_op_log` VALUES (184, '127.0.0.1', '2024-01-17 18:58:10.020834', '/myapp/admin/tag/list', 'GET', NULL, '21');
INSERT INTO `b_op_log` VALUES (185, '127.0.0.1', '2024-01-17 18:58:29.209762', '/myapp/admin/tag/update', 'POST', NULL, '34');
INSERT INTO `b_op_log` VALUES (186, '127.0.0.1', '2024-01-17 18:58:29.247294', '/myapp/admin/tag/list', 'GET', NULL, '19');
INSERT INTO `b_op_log` VALUES (187, '127.0.0.1', '2024-01-17 18:58:40.864888', '/myapp/admin/tag/update', 'POST', NULL, '24');
INSERT INTO `b_op_log` VALUES (188, '127.0.0.1', '2024-01-17 18:58:40.903050', '/myapp/admin/tag/list', 'GET', NULL, '22');
INSERT INTO `b_op_log` VALUES (189, '127.0.0.1', '2024-01-17 18:58:53.290997', '/myapp/admin/tag/update', 'POST', NULL, '30');
INSERT INTO `b_op_log` VALUES (190, '127.0.0.1', '2024-01-17 18:58:53.332681', '/myapp/admin/tag/list', 'GET', NULL, '24');
INSERT INTO `b_op_log` VALUES (191, '127.0.0.1', '2024-01-17 18:58:55.701506', '/myapp/admin/tag/delete', 'POST', NULL, '32');
INSERT INTO `b_op_log` VALUES (192, '127.0.0.1', '2024-01-17 18:58:55.747961', '/myapp/admin/tag/list', 'GET', NULL, '29');
INSERT INTO `b_op_log` VALUES (193, '127.0.0.1', '2024-01-17 18:58:58.680293', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (194, '127.0.0.1', '2024-01-17 18:58:59.942369', '/myapp/admin/tag/list', 'GET', NULL, '24');
INSERT INTO `b_op_log` VALUES (195, '127.0.0.1', '2024-01-17 18:59:00.467939', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (196, '127.0.0.1', '2024-01-17 18:59:00.470171', '/myapp/admin/classification/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (197, '127.0.0.1', '2024-01-17 18:59:00.473854', '/myapp/admin/classification/list', 'GET', NULL, '9');
INSERT INTO `b_op_log` VALUES (198, '127.0.0.1', '2024-01-17 18:59:01.691386', '/myapp/admin/family/list', 'GET', NULL, '24');
INSERT INTO `b_op_log` VALUES (199, '127.0.0.1', '2024-01-17 18:59:02.322132', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (200, '127.0.0.1', '2024-01-17 18:59:02.326133', '/myapp/admin/tag/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (201, '127.0.0.1', '2024-01-17 18:59:02.347123', '/myapp/admin/tag/list', 'GET', NULL, '30');
INSERT INTO `b_op_log` VALUES (202, '127.0.0.1', '2024-01-17 18:59:03.157239', '/myapp/admin/classification/list', 'GET', NULL, '27');
INSERT INTO `b_op_log` VALUES (203, '127.0.0.1', '2024-01-17 18:59:04.254770', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (204, '127.0.0.1', '2024-01-17 18:59:04.257733', '/myapp/admin/tag/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (205, '127.0.0.1', '2024-01-17 18:59:04.263380', '/myapp/admin/tag/list', 'GET', NULL, '14');
INSERT INTO `b_op_log` VALUES (206, '127.0.0.1', '2024-01-17 18:59:06.118600', '/myapp/admin/tag/list', 'GET', NULL, '16');
INSERT INTO `b_op_log` VALUES (207, '127.0.0.1', '2024-01-17 18:59:06.653288', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (208, '127.0.0.1', '2024-01-17 18:59:07.599581', '/myapp/admin/user/list', 'GET', NULL, '25');
INSERT INTO `b_op_log` VALUES (209, '127.0.0.1', '2024-01-17 18:59:09.413434', '/myapp/admin/overview/sysInfo', 'GET', NULL, '1057');
INSERT INTO `b_op_log` VALUES (210, '127.0.0.1', '2024-01-17 18:59:10.279132', '/myapp/admin/loginLog/list', 'GET', NULL, '29');
INSERT INTO `b_op_log` VALUES (211, '127.0.0.1', '2024-01-17 18:59:11.648447', '/myapp/admin/opLog/list', 'GET', NULL, '20');
INSERT INTO `b_op_log` VALUES (212, '127.0.0.1', '2024-01-17 18:59:12.830454', '/myapp/admin/errorLog/list', 'GET', NULL, '29');
INSERT INTO `b_op_log` VALUES (213, '127.0.0.1', '2024-01-17 18:59:14.434374', '/myapp/admin/loginLog/list', 'GET', NULL, '21');
INSERT INTO `b_op_log` VALUES (214, '127.0.0.1', '2024-01-17 18:59:16.768763', '/myapp/admin/opLog/list', 'GET', NULL, '12');
INSERT INTO `b_op_log` VALUES (215, '127.0.0.1', '2024-01-17 18:59:19.395506', '/myapp/admin/classification/list', 'GET', NULL, '24');
INSERT INTO `b_op_log` VALUES (216, '127.0.0.1', '2024-01-17 18:59:34.381689', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (217, '127.0.0.1', '2024-01-17 18:59:35.320138', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (218, '127.0.0.1', '2024-01-17 18:59:35.322125', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (219, '127.0.0.1', '2024-01-17 18:59:35.331924', '/myapp/admin/tag/list', 'GET', NULL, '15');
INSERT INTO `b_op_log` VALUES (220, '127.0.0.1', '2024-01-17 18:59:39.315243', '/myapp/admin/adminLogin', 'POST', NULL, '48');
INSERT INTO `b_op_log` VALUES (221, '127.0.0.1', '2024-01-17 18:59:39.394848', '/myapp/admin/tag/list', 'GET', NULL, '2');
INSERT INTO `b_op_log` VALUES (222, '127.0.0.1', '2024-01-17 18:59:39.396831', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (223, '127.0.0.1', '2024-01-17 18:59:39.404878', '/myapp/admin/tag/list', 'GET', NULL, '12');
INSERT INTO `b_op_log` VALUES (224, '127.0.0.1', '2024-01-17 18:59:52.646067', '/myapp/admin/adminLogin', 'POST', NULL, '44');
INSERT INTO `b_op_log` VALUES (225, '127.0.0.1', '2024-01-17 18:59:52.724569', '/myapp/admin/tag/list', 'GET', NULL, '10');
INSERT INTO `b_op_log` VALUES (226, '127.0.0.1', '2024-01-17 18:59:52.726570', '/myapp/admin/tag/list', 'GET', NULL, '13');
INSERT INTO `b_op_log` VALUES (227, '127.0.0.1', '2024-01-17 18:59:52.728570', '/myapp/admin/tag/list', 'GET', NULL, '14');
INSERT INTO `b_op_log` VALUES (228, '127.0.0.1', '2024-01-17 18:59:54.858909', '/myapp/admin/thing/update', 'POST', NULL, '9');
INSERT INTO `b_op_log` VALUES (229, '127.0.0.1', '2024-01-17 18:59:56.700986', '/myapp/admin/classification/list', 'GET', NULL, '27');
INSERT INTO `b_op_log` VALUES (230, '127.0.0.1', '2024-01-17 18:59:58.902280', '/myapp/admin/classification/delete', 'POST', NULL, '26');
INSERT INTO `b_op_log` VALUES (231, '127.0.0.1', '2024-01-17 19:00:00.068226', '/myapp/admin/tag/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (232, '127.0.0.1', '2024-01-17 19:00:00.071226', '/myapp/admin/tag/list', 'GET', NULL, '9');
INSERT INTO `b_op_log` VALUES (233, '127.0.0.1', '2024-01-17 19:00:00.083235', '/myapp/admin/tag/list', 'GET', NULL, '21');
INSERT INTO `b_op_log` VALUES (234, '127.0.0.1', '2024-01-17 19:00:04.012598', '/myapp/admin/adminLogin', 'POST', NULL, '42');
INSERT INTO `b_op_log` VALUES (235, '127.0.0.1', '2024-01-17 19:00:04.089228', '/myapp/admin/tag/list', 'GET', NULL, '11');
INSERT INTO `b_op_log` VALUES (236, '127.0.0.1', '2024-01-17 19:00:04.094228', '/myapp/admin/tag/list', 'GET', NULL, '15');
INSERT INTO `b_op_log` VALUES (237, '127.0.0.1', '2024-01-17 19:00:04.102227', '/myapp/admin/tag/list', 'GET', NULL, '25');
INSERT INTO `b_op_log` VALUES (238, '127.0.0.1', '2024-01-17 19:00:05.786150', '/myapp/admin/classification/list', 'GET', NULL, '14');
INSERT INTO `b_op_log` VALUES (239, '127.0.0.1', '2024-01-17 19:00:06.562198', '/myapp/admin/classification/list', 'GET', NULL, '11');
INSERT INTO `b_op_log` VALUES (240, '127.0.0.1', '2024-01-17 19:00:06.570844', '/myapp/admin/classification/list', 'GET', NULL, '21');
INSERT INTO `b_op_log` VALUES (241, '127.0.0.1', '2024-01-17 19:00:06.574587', '/myapp/admin/classification/list', 'GET', NULL, '24');
INSERT INTO `b_op_log` VALUES (242, '127.0.0.1', '2024-01-17 19:00:22.750903', '/myapp/admin/thing/update', 'POST', NULL, '26');
INSERT INTO `b_op_log` VALUES (243, '127.0.0.1', '2024-01-17 19:00:22.792915', '/myapp/admin/thing/list', 'GET', NULL, '21');
INSERT INTO `b_op_log` VALUES (244, '127.0.0.1', '2024-01-17 19:00:27.126198', '/myapp/admin/thing/update', 'POST', NULL, '47');
INSERT INTO `b_op_log` VALUES (245, '127.0.0.1', '2024-01-17 19:00:27.187199', '/myapp/admin/thing/list', 'GET', NULL, '35');
INSERT INTO `b_op_log` VALUES (246, '127.0.0.1', '2024-01-17 19:00:35.056363', '/myapp/admin/thing/update', 'POST', NULL, '44');
INSERT INTO `b_op_log` VALUES (247, '127.0.0.1', '2024-01-17 19:00:35.089887', '/myapp/admin/thing/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (248, '127.0.0.1', '2024-01-17 19:00:37.348944', '/myapp/admin/classification/list', 'GET', NULL, '28');
INSERT INTO `b_op_log` VALUES (249, '127.0.0.1', '2024-01-17 19:00:38.373151', '/myapp/admin/tag/list', 'GET', NULL, '3');
INSERT INTO `b_op_log` VALUES (250, '127.0.0.1', '2024-01-17 19:00:38.394378', '/myapp/admin/tag/list', 'GET', NULL, '23');
INSERT INTO `b_op_log` VALUES (251, '127.0.0.1', '2024-01-17 19:00:38.396377', '/myapp/admin/tag/list', 'GET', NULL, '26');
INSERT INTO `b_op_log` VALUES (252, '127.0.0.1', '2024-01-17 19:00:39.193759', '/myapp/admin/family/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (253, '127.0.0.1', '2024-01-17 19:00:40.201886', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (254, '127.0.0.1', '2024-01-17 19:00:40.218980', '/myapp/admin/tag/list', 'GET', NULL, '22');
INSERT INTO `b_op_log` VALUES (255, '127.0.0.1', '2024-01-17 19:00:40.232982', '/myapp/admin/tag/list', 'GET', NULL, '35');
INSERT INTO `b_op_log` VALUES (256, '127.0.0.1', '2024-01-17 19:00:40.840645', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (257, '127.0.0.1', '2024-01-17 19:00:41.669922', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (258, '127.0.0.1', '2024-01-17 19:00:41.673487', '/myapp/admin/tag/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (259, '127.0.0.1', '2024-01-17 19:00:41.676812', '/myapp/admin/tag/list', 'GET', NULL, '10');
INSERT INTO `b_op_log` VALUES (260, '127.0.0.1', '2024-01-17 19:00:42.479384', '/myapp/admin/family/list', 'GET', NULL, '25');
INSERT INTO `b_op_log` VALUES (261, '127.0.0.1', '2024-01-17 19:00:43.865571', '/myapp/admin/classification/list', 'GET', NULL, '19');
INSERT INTO `b_op_log` VALUES (262, '127.0.0.1', '2024-01-17 19:00:44.812525', '/myapp/admin/classification/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (263, '127.0.0.1', '2024-01-17 19:00:44.814457', '/myapp/admin/classification/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (264, '127.0.0.1', '2024-01-17 19:00:44.816558', '/myapp/admin/classification/list', 'GET', NULL, '9');
INSERT INTO `b_op_log` VALUES (265, '127.0.0.1', '2024-01-17 19:01:43.129548', '/myapp/admin/tag/list', 'GET', NULL, '2');
INSERT INTO `b_op_log` VALUES (266, '127.0.0.1', '2024-01-17 19:01:43.132559', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (267, '127.0.0.1', '2024-01-17 19:01:43.153548', '/myapp/admin/tag/list', 'GET', NULL, '26');
INSERT INTO `b_op_log` VALUES (268, '127.0.0.1', '2024-01-17 19:02:05.836193', '/myapp/admin/classification/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (269, '127.0.0.1', '2024-01-17 19:02:05.838461', '/myapp/admin/classification/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (270, '127.0.0.1', '2024-01-17 19:02:05.840525', '/myapp/admin/classification/list', 'GET', NULL, '9');
INSERT INTO `b_op_log` VALUES (271, '127.0.0.1', '2024-01-17 19:02:07.570025', '/myapp/admin/classification/list', 'GET', NULL, '28');
INSERT INTO `b_op_log` VALUES (272, '127.0.0.1', '2024-01-17 19:02:08.571994', '/myapp/admin/family/list', 'GET', NULL, '14');
INSERT INTO `b_op_log` VALUES (273, '127.0.0.1', '2024-01-17 19:02:52.503649', '/myapp/admin/family/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (274, '127.0.0.1', '2024-01-17 19:02:54.483602', '/myapp/admin/tag/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (275, '127.0.0.1', '2024-01-17 19:02:54.482603', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (276, '127.0.0.1', '2024-01-17 19:02:54.485602', '/myapp/admin/tag/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (277, '127.0.0.1', '2024-01-17 19:02:55.359691', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (278, '127.0.0.1', '2024-01-17 19:02:55.361683', '/myapp/admin/tag/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (279, '127.0.0.1', '2024-01-17 19:02:55.362692', '/myapp/admin/tag/list', 'GET', NULL, '9');
INSERT INTO `b_op_log` VALUES (280, '127.0.0.1', '2024-01-17 19:03:24.916921', '/myapp/admin/classification/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (281, '127.0.0.1', '2024-01-17 19:03:24.918921', '/myapp/admin/classification/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (282, '127.0.0.1', '2024-01-17 19:03:24.921152', '/myapp/admin/classification/list', 'GET', NULL, '10');
INSERT INTO `b_op_log` VALUES (283, '127.0.0.1', '2024-01-17 19:03:27.432352', '/myapp/admin/classification/list', 'GET', NULL, '24');
INSERT INTO `b_op_log` VALUES (284, '127.0.0.1', '2024-01-17 19:03:28.959404', '/myapp/admin/tag/list', 'GET', NULL, '3');
INSERT INTO `b_op_log` VALUES (285, '127.0.0.1', '2024-01-17 19:03:28.961404', '/myapp/admin/tag/list', 'GET', NULL, '5');
INSERT INTO `b_op_log` VALUES (286, '127.0.0.1', '2024-01-17 19:03:28.963947', '/myapp/admin/tag/list', 'GET', NULL, '8');
INSERT INTO `b_op_log` VALUES (287, '127.0.0.1', '2024-01-17 19:03:29.840317', '/myapp/admin/family/list', 'GET', NULL, '17');
INSERT INTO `b_op_log` VALUES (288, '127.0.0.1', '2024-01-17 19:03:31.680885', '/myapp/admin/family/list', 'GET', NULL, '3');
INSERT INTO `b_op_log` VALUES (289, '127.0.0.1', '2024-01-17 19:03:32.250073', '/myapp/admin/classification/list', 'GET', NULL, '10');
INSERT INTO `b_op_log` VALUES (290, '127.0.0.1', '2024-01-17 19:03:32.252486', '/myapp/admin/classification/list', 'GET', NULL, '13');
INSERT INTO `b_op_log` VALUES (291, '127.0.0.1', '2024-01-17 19:03:32.262333', '/myapp/admin/classification/list', 'GET', NULL, '23');
INSERT INTO `b_op_log` VALUES (292, '127.0.0.1', '2024-01-17 19:03:35.194950', '/myapp/admin/adminLogin', 'POST', NULL, '41');
INSERT INTO `b_op_log` VALUES (293, '127.0.0.1', '2024-01-17 19:03:35.276464', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (294, '127.0.0.1', '2024-01-17 19:03:35.277482', '/myapp/admin/tag/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (295, '127.0.0.1', '2024-01-17 19:03:35.288454', '/myapp/admin/tag/list', 'GET', NULL, '16');
INSERT INTO `b_op_log` VALUES (296, '127.0.0.1', '2024-01-17 19:03:40.913026', '/myapp/admin/opLog/list', 'GET', NULL, '15');
INSERT INTO `b_op_log` VALUES (297, '127.0.0.1', '2024-01-17 19:04:05.107048', '/myapp/admin/loginLog/list', 'GET', NULL, '6');
INSERT INTO `b_op_log` VALUES (298, '127.0.0.1', '2024-01-17 19:04:05.738457', '/myapp/admin/opLog/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (299, '127.0.0.1', '2024-01-17 19:04:10.147123', '/myapp/admin/tag/list', 'GET', NULL, '4');
INSERT INTO `b_op_log` VALUES (300, '127.0.0.1', '2024-01-17 19:04:10.151074', '/myapp/admin/tag/list', 'GET', NULL, '7');
INSERT INTO `b_op_log` VALUES (301, '127.0.0.1', '2024-01-17 19:04:10.159112', '/myapp/admin/tag/list', 'GET', NULL, '15');

-- ----------------------------
-- Table structure for b_tag
-- ----------------------------
DROP TABLE IF EXISTS `b_tag`;
CREATE TABLE `b_tag`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_tag
-- ----------------------------

-- ----------------------------
-- Table structure for b_thing
-- ----------------------------
DROP TABLE IF EXISTS `b_thing`;
CREATE TABLE `b_thing`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `status` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `classification_id` bigint(20) NULL DEFAULT NULL,
  `remark` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `title` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `mobile` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `address` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `age` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sex` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `b_thing_classification_id_47675ac4_fk_b_classification_id`(`classification_id`) USING BTREE,
  CONSTRAINT `b_thing_classification_id_47675ac4_fk_b_classification_id` FOREIGN KEY (`classification_id`) REFERENCES `b_classification` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_thing
-- ----------------------------

-- ----------------------------
-- Table structure for b_user
-- ----------------------------
DROP TABLE IF EXISTS `b_user`;
CREATE TABLE `b_user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `role` varchar(2) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `nickname` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `avatar` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `mobile` varchar(13) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gender` varchar(1) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `description` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  `score` int(11) NULL DEFAULT NULL,
  `push_email` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `push_switch` tinyint(1) NULL DEFAULT NULL,
  `admin_token` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `token` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_user
-- ----------------------------

-- ----------------------------
-- Table structure for b_worker
-- ----------------------------
DROP TABLE IF EXISTS `b_worker`;
CREATE TABLE `b_worker`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `sex` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `age` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `skill` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remark` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `create_time` datetime(6) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of b_worker
-- ----------------------------

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `content_type_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id`) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_auth_user_id`(`user_id`) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label`, `model`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'auth', 'user');
INSERT INTO `django_content_type` VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (7, 'myapp', 'ad');
INSERT INTO `django_content_type` VALUES (17, 'myapp', 'address');
INSERT INTO `django_content_type` VALUES (16, 'myapp', 'banner');
INSERT INTO `django_content_type` VALUES (8, 'myapp', 'classification');
INSERT INTO `django_content_type` VALUES (9, 'myapp', 'errorlog');
INSERT INTO `django_content_type` VALUES (18, 'myapp', 'family');
INSERT INTO `django_content_type` VALUES (10, 'myapp', 'loginlog');
INSERT INTO `django_content_type` VALUES (19, 'myapp', 'medical');
INSERT INTO `django_content_type` VALUES (11, 'myapp', 'notice');
INSERT INTO `django_content_type` VALUES (12, 'myapp', 'oplog');
INSERT INTO `django_content_type` VALUES (13, 'myapp', 'tag');
INSERT INTO `django_content_type` VALUES (15, 'myapp', 'thing');
INSERT INTO `django_content_type` VALUES (14, 'myapp', 'user');
INSERT INTO `django_content_type` VALUES (20, 'myapp', 'worker');
INSERT INTO `django_content_type` VALUES (6, 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2024-01-16 18:59:20.852254');
INSERT INTO `django_migrations` VALUES (2, 'auth', '0001_initial', '2024-01-16 18:59:21.099073');
INSERT INTO `django_migrations` VALUES (3, 'admin', '0001_initial', '2024-01-16 18:59:21.161163');
INSERT INTO `django_migrations` VALUES (4, 'admin', '0002_logentry_remove_auto_add', '2024-01-16 18:59:21.168164');
INSERT INTO `django_migrations` VALUES (5, 'admin', '0003_logentry_add_action_flag_choices', '2024-01-16 18:59:21.175163');
INSERT INTO `django_migrations` VALUES (6, 'contenttypes', '0002_remove_content_type_name', '2024-01-16 18:59:21.239931');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0002_alter_permission_name_max_length', '2024-01-16 18:59:21.283414');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0003_alter_user_email_max_length', '2024-01-16 18:59:21.325893');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0004_alter_user_username_opts', '2024-01-16 18:59:21.332895');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0005_alter_user_last_login_null', '2024-01-16 18:59:21.369285');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0006_require_contenttypes_0002', '2024-01-16 18:59:21.372276');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0007_alter_validators_add_error_messages', '2024-01-16 18:59:21.378276');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0008_alter_user_username_max_length', '2024-01-16 18:59:21.426249');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0009_alter_user_last_name_max_length', '2024-01-16 18:59:21.469514');
INSERT INTO `django_migrations` VALUES (15, 'auth', '0010_alter_group_name_max_length', '2024-01-16 18:59:21.514514');
INSERT INTO `django_migrations` VALUES (16, 'auth', '0011_update_proxy_permissions', '2024-01-16 18:59:21.523534');
INSERT INTO `django_migrations` VALUES (17, 'auth', '0012_alter_user_first_name_max_length', '2024-01-16 18:59:21.571243');
INSERT INTO `django_migrations` VALUES (18, 'myapp', '0001_initial', '2024-01-16 18:59:22.268995');
INSERT INTO `django_migrations` VALUES (19, 'myapp', '0002_auto_20230526_2255', '2024-01-16 18:59:22.370835');
INSERT INTO `django_migrations` VALUES (20, 'myapp', '0003_auto_20230527_1411', '2024-01-16 18:59:22.480842');
INSERT INTO `django_migrations` VALUES (21, 'myapp', '0004_thing_raw', '2024-01-16 18:59:22.533749');
INSERT INTO `django_migrations` VALUES (22, 'myapp', '0005_auto_20230808_1739', '2024-01-16 18:59:23.030126');
INSERT INTO `django_migrations` VALUES (23, 'myapp', '0006_thing_remark', '2024-01-16 18:59:23.064544');
INSERT INTO `django_migrations` VALUES (24, 'myapp', '0007_auto_20230809_1840', '2024-01-16 18:59:23.366318');
INSERT INTO `django_migrations` VALUES (25, 'myapp', '0008_auto_20230810_1836', '2024-01-16 18:59:23.460000');
INSERT INTO `django_migrations` VALUES (26, 'myapp', '0009_auto_20240115_1002', '2024-01-16 18:59:24.132281');
INSERT INTO `django_migrations` VALUES (27, 'myapp', '0010_park_create_time', '2024-01-16 18:59:24.173821');
INSERT INTO `django_migrations` VALUES (28, 'myapp', '0011_auto_20240116_1859', '2024-01-16 18:59:24.414839');
INSERT INTO `django_migrations` VALUES (29, 'sessions', '0001_initial', '2024-01-16 18:59:24.453988');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
