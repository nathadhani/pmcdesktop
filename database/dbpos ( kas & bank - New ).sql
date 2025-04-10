/*
 Navicat Premium Data Transfer

 Source Server         : MYSQL
 Source Server Type    : MySQL
 Source Server Version : 80030
 Source Host           : localhost:3306
 Source Schema         : dbpos

 Target Server Type    : MySQL
 Target Server Version : 80030
 File Encoding         : 65001

 Date: 10/04/2025 16:58:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cb
-- ----------------------------
DROP TABLE IF EXISTS `cb`;
CREATE TABLE `cb`  (
  `id` smallint NOT NULL,
  `company_id` bigint NOT NULL,
  `tr_id` smallint NOT NULL,
  `cb_code` varchar(8) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `cb_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `description` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of cb
-- ----------------------------
INSERT INTO `cb` VALUES (1, 1, 3, '01030001', 'Kas', '', 1, '2025-03-08 22:28:04', '2025-03-22 09:12:01', 1, 3);
INSERT INTO `cb` VALUES (2, 1, 4, '01040001', 'Bank', ' ', 1, '2025-03-08 22:28:04', '2025-04-05 11:14:45', 1, 3);

-- ----------------------------
-- Table structure for cb_detail
-- ----------------------------
DROP TABLE IF EXISTS `cb_detail`;
CREATE TABLE `cb_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `header_id` bigint NOT NULL,
  `description` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `amount` decimal(18, 2) NOT NULL DEFAULT 0.00,
  `status` smallint NOT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of cb_detail
-- ----------------------------

-- ----------------------------
-- Table structure for cb_header
-- ----------------------------
DROP TABLE IF EXISTS `cb_header`;
CREATE TABLE `cb_header`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `company_id` bigint NOT NULL,
  `cb_id` smallint NOT NULL,
  `cb_pos_id` smallint NOT NULL,
  `tr_date` date NOT NULL,
  `tr_number` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `reason_cancel` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `buysell_id` bigint NULL DEFAULT NULL,
  `buysell_payment_type` smallint NULL DEFAULT NULL,
  `status` smallint NOT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of cb_header
-- ----------------------------

-- ----------------------------
-- Table structure for cb_pos
-- ----------------------------
DROP TABLE IF EXISTS `cb_pos`;
CREATE TABLE `cb_pos`  (
  `id` smallint NOT NULL,
  `cb_id` smallint NOT NULL,
  `cb_pos_code` varchar(6) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `cb_pos_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `cb_pos_in_out` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `buysell_tr_id` smallint NULL DEFAULT NULL,
  `status` smallint NOT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of cb_pos
-- ----------------------------
INSERT INTO `cb_pos` VALUES (1, 1, 'MP0001', 'Modal Kas', 'I', NULL, 1, '2025-03-08 22:28:04', '2025-03-25 13:27:21', 3, 3);
INSERT INTO `cb_pos` VALUES (2, 1, 'MP0002', 'Penerimaan Kas', 'I', NULL, 1, '2025-03-08 22:28:04', NULL, 3, NULL);
INSERT INTO `cb_pos` VALUES (3, 1, 'MP0003', 'Pengeluaran Kas', 'O', NULL, 1, '2025-03-08 22:28:04', NULL, 3, NULL);
INSERT INTO `cb_pos` VALUES (4, 1, 'MP0004', 'Pembelian Valas', 'O', 1, 1, '2025-03-08 22:28:04', NULL, 3, NULL);
INSERT INTO `cb_pos` VALUES (5, 1, 'MP0005', 'Penjualan Valas', 'I', 2, 1, '2025-03-08 22:28:04', NULL, 3, NULL);
INSERT INTO `cb_pos` VALUES (6, 2, 'MP0008', 'Modal Bank', 'I', NULL, 1, '2025-03-08 22:28:04', NULL, 3, NULL);
INSERT INTO `cb_pos` VALUES (7, 2, 'MP0009', 'Penerimaan Bank', 'I', NULL, 1, '2025-03-08 22:28:04', NULL, 3, NULL);
INSERT INTO `cb_pos` VALUES (8, 2, 'MP0010', 'Pengeluaran Bank', 'O', NULL, 1, '2025-03-08 22:28:04', NULL, 3, NULL);
INSERT INTO `cb_pos` VALUES (9, 2, 'MP0011', 'Pembelian Valas', 'O', 1, 1, '2025-03-08 22:28:04', NULL, 3, NULL);
INSERT INTO `cb_pos` VALUES (10, 2, 'MP0012', 'Penjualan Valas', 'I', 2, 1, '2025-03-08 22:28:04', NULL, 3, NULL);

-- ----------------------------
-- Table structure for cb_saldo
-- ----------------------------
DROP TABLE IF EXISTS `cb_saldo`;
CREATE TABLE `cb_saldo`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `company_id` smallint NOT NULL,
  `cb_id` smallint NOT NULL,
  `cbs_date` date NOT NULL,
  `cbs_year` decimal(4, 0) NULL DEFAULT NULL,
  `cbs_month` decimal(2, 0) NULL DEFAULT NULL,
  `cbs_in` decimal(18, 2) NULL DEFAULT 0.00,
  `cbs_out` decimal(18, 2) NULL DEFAULT 0.00,
  `cbs_saldo` decimal(18, 2) NULL DEFAULT 0.00,
  `status` smallint NOT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 481 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of cb_saldo
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
