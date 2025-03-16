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

 Date: 13/03/2025 14:45:38
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tr_bayar
-- ----------------------------
DROP TABLE IF EXISTS `tr_bayar`;
CREATE TABLE `tr_bayar`  (
  `id` bigint NULL DEFAULT NULL,
  `company_id` smallint NOT NULL,
  `tr_id` smallint NOT NULL,
  `tr_number` varchar(14) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `tr_date` date NOT NULL,
  `payment_type` smallint NOT NULL,
  `amount` decimal(18, 3) NULL DEFAULT NULL,
  `description` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  INDEX `idx_transfer`(`tr_id`, `tr_number`, `tr_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

SET FOREIGN_KEY_CHECKS = 1;
