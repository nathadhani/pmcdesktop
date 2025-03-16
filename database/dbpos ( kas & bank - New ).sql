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

 Date: 13/03/2025 14:44:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for cba
-- ----------------------------
DROP TABLE IF EXISTS `cba`;
CREATE TABLE `cba`  (
  `id` smallint NOT NULL,
  `cba_tr_id` smallint NOT NULL,
  `cba_code` varchar(4) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `cba_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `cba_bank_account_number` varchar(25) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `cba_bank_account_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `status` smallint NOT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_finacc`(`id`, `cba_tr_id`, `cba_code`, `cba_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of cba
-- ----------------------------
INSERT INTO `cba` VALUES (1, 3, '3001', 'Kas', '', '', 1, '2025-03-08 22:28:04', '2025-03-09 06:46:27', 1, 1);
INSERT INTO `cba` VALUES (2, 4, '4001', 'BCA', '', '', 1, '2025-03-08 22:28:04', '2025-03-09 03:07:45', 1, 1);

-- ----------------------------
-- Table structure for cba_pos
-- ----------------------------
DROP TABLE IF EXISTS `cba_pos`;
CREATE TABLE `cba_pos`  (
  `id` smallint NOT NULL,
  `cba_pos_code` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `cba_pos_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `status` smallint NOT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  INDEX `idx_finpos`(`id`, `cba_pos_code`, `cba_pos_name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of cba_pos
-- ----------------------------
INSERT INTO `cba_pos` VALUES (1, 'MP001', 'Modal', 1, '2025-03-09 07:25:24', '2025-03-09 20:46:53', 1, 0);
INSERT INTO `cba_pos` VALUES (2, 'MP002', 'Penerimaan Kas', 1, '2025-03-09 07:33:22', '2025-03-09 07:34:17', 1, 1);
INSERT INTO `cba_pos` VALUES (3, 'MP003', 'Pengeluaran Kas', 1, '2025-03-09 07:33:43', '2025-03-09 07:34:26', 1, 1);
INSERT INTO `cba_pos` VALUES (4, 'MP004', 'Penerimaan Bank', 1, '2025-03-09 07:34:43', NULL, 1, NULL);
INSERT INTO `cba_pos` VALUES (5, 'MP005', 'Pengeluaran Bank', 1, '2025-03-09 07:34:59', NULL, 1, NULL);

-- ----------------------------
-- Table structure for cba_saldo
-- ----------------------------
DROP TABLE IF EXISTS `cba_saldo`;
CREATE TABLE `cba_saldo`  (
  `id` bigint NOT NULL,
  `company_id` smallint NOT NULL,
  `cba_id` smallint NOT NULL,
  `cbas_date` date NOT NULL,
  `cbas_in` decimal(18, 2) NULL DEFAULT 0.00,
  `cbas_out` decimal(18, 2) NULL DEFAULT 0.00,
  `cbas_saldo` decimal(18, 2) NULL DEFAULT 0.00,
  `status` smallint NOT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  INDEX `idx_finsal`(`id`, `cba_id`, `cbas_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of cba_saldo
-- ----------------------------

-- ----------------------------
-- Table structure for cba_td
-- ----------------------------
DROP TABLE IF EXISTS `cba_td`;
CREATE TABLE `cba_td`  (
  `id` bigint NOT NULL,
  `company_id` smallint NOT NULL,
  `cba_id` smallint NOT NULL,
  `cba_pos_id` smallint NOT NULL,
  `cba_tr_number` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `cba_tr_date` date NOT NULL,
  `cba_td_description` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `amount_in` decimal(18, 2) NOT NULL DEFAULT 0.00,
  `amount_out` decimal(18, 2) NOT NULL DEFAULT 0.00,
  `status` smallint NOT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  INDEX `idx_findtl`(`id`, `cba_pos_id`, `cba_tr_date`, `cba_tr_number`, `cba_td_description`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of cba_td
-- ----------------------------

-- ----------------------------
-- Table structure for cba_th
-- ----------------------------
DROP TABLE IF EXISTS `cba_th`;
CREATE TABLE `cba_th`  (
  `id` bigint NOT NULL,
  `company_id` smallint NOT NULL,
  `cba_id` smallint NOT NULL,
  `cba_pos_id` smallint NOT NULL,
  `cba_tr_number` varchar(16) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `cba_tr_date` date NOT NULL,
  `cba_th_description` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `tr_buysell_tr_id` smallint NULL DEFAULT NULL,
  `tr_buysell_tr_number` varchar(14) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `tr_buysell_tr_date` date NULL DEFAULT NULL,
  `tr_buysell_paymen_type` smallint NULL DEFAULT NULL,
  `status` smallint NOT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  INDEX `idx_fintrs`(`id`, `cba_tr_number`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of cba_th
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
