/*
 Navicat Premium Data Transfer

 Source Server         : mySQL
 Source Server Type    : MySQL
 Source Server Version : 80030
 Source Host           : localhost:3306
 Source Schema         : dbpos

 Target Server Type    : MySQL
 Target Server Version : 80030
 File Encoding         : 65001

 Date: 04/05/2025 21:14:47
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dttot
-- ----------------------------
DROP TABLE IF EXISTS `dttot`;
CREATE TABLE `dttot`  (
  `id` bigint NULL DEFAULT NULL,
  `nama` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL,
  `deskripsi` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL,
  `terduga` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL,
  `kode_densus` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL DEFAULT NULL,
  `tpt_lahir` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL,
  `tgl_lahir` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL,
  `warga_negara` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL,
  `alamat` longtext CHARACTER SET utf8mb3 COLLATE utf8mb3_unicode_ci NULL,
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` bigint NULL DEFAULT NULL,
  `updatedby` bigint NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of dttot
-- ----------------------------

-- ----------------------------
-- Table structure for kurs_bi
-- ----------------------------
DROP TABLE IF EXISTS `kurs_bi`;
CREATE TABLE `kurs_bi`  (
  `id` smallint NOT NULL,
  `valas_id` smallint NULL DEFAULT NULL,
  `kurs_year` decimal(4, 0) NULL DEFAULT NULL,
  `kurs_month` decimal(2, 0) NULL DEFAULT NULL,
  `middle_rate` decimal(12, 3) NULL DEFAULT 0.000,
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_rate`(`valas_id`, `kurs_year`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of kurs_bi
-- ----------------------------

-- ----------------------------
-- Table structure for kurs_daily
-- ----------------------------
DROP TABLE IF EXISTS `kurs_daily`;
CREATE TABLE `kurs_daily`  (
  `id` smallint NOT NULL,
  `valas_id` smallint NOT NULL,
  `rate_date` date NOT NULL,
  `rate_buy` decimal(12, 3) NULL DEFAULT 0.000,
  `difference_buy` decimal(12, 3) NULL DEFAULT 0.000,
  `rate_sale` decimal(12, 3) NULL DEFAULT 0.000,
  `difference_sale` decimal(12, 3) NULL DEFAULT 0.000,
  `price_buy_bot` decimal(12, 3) NULL DEFAULT 0.000,
  `price_buy_top` decimal(12, 3) NULL DEFAULT 0.000,
  `price_sale_bot` decimal(12, 3) NULL DEFAULT 0.000,
  `price_sale_top` decimal(12, 3) NULL DEFAULT 0.000,
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`, `valas_id`, `rate_date`) USING BTREE,
  INDEX `idx_rate`(`id`, `valas_id`, `rate_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of kurs_daily
-- ----------------------------
INSERT INTO `kurs_daily` VALUES (1, 1, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (2, 2, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (3, 3, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (4, 4, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (5, 5, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (6, 6, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (7, 7, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (8, 8, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (9, 9, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (10, 10, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (11, 11, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (12, 12, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (13, 13, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (14, 14, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (15, 15, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (16, 16, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (17, 17, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (18, 18, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (19, 19, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (20, 20, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (21, 21, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (22, 22, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (23, 23, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (24, 24, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (25, 25, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (26, 26, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (27, 27, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (28, 28, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (29, 29, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (30, 30, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (31, 31, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (32, 32, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (33, 33, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (34, 34, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (35, 35, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (36, 36, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (37, 37, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (38, 38, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (39, 39, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);
INSERT INTO `kurs_daily` VALUES (40, 40, '2025-05-04', 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, NULL, '2025-05-04 20:54:28', NULL, 1, NULL);

-- ----------------------------
-- Table structure for m_company
-- ----------------------------
DROP TABLE IF EXISTS `m_company`;
CREATE TABLE `m_company`  (
  `id` smallint NULL DEFAULT NULL,
  `company_name` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `company_address1` varchar(150) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `company_address2` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `company_phone` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `company_city` varchar(30) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `company_postcode` varchar(10) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `company_email` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `legal_gbi` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT '',
  `pjk_id` varchar(15) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of m_company
-- ----------------------------
INSERT INTO `m_company` VALUES (1, 'Money Changer', 'Jakarta', NULL, NULL, '', '12720', NULL, NULL, '', 1, '2025-03-13 19:54:00', NULL, 1, NULL);

-- ----------------------------
-- Table structure for m_customer
-- ----------------------------
DROP TABLE IF EXISTS `m_customer`;
CREATE TABLE `m_customer`  (
  `id` bigint NOT NULL,
  `company_id` smallint NULL DEFAULT NULL,
  `customer_type_id` smallint NULL DEFAULT NULL,
  `customer_code` varchar(12) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `customer_handphone` varchar(13) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '',
  `customer_phone` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '',
  `customer_name` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `customer_nick_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `customer_addres` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `rt_rw` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `village` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `sub_district` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `city` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `placeofbirth` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `bornday` date NULL DEFAULT NULL,
  `gender_id` smallint NULL DEFAULT NULL,
  `customer_data_id` smallint NULL DEFAULT NULL,
  `customer_data_number` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `nationality_id` smallint NULL DEFAULT NULL,
  `work_id` smallint NULL DEFAULT NULL,
  `customerprofil` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `kode_densus_dttot` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `customer1`(`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of m_customer
-- ----------------------------
INSERT INTO `m_customer` VALUES (1, 1, 1, '250411010001', '75O0YPVYM', '', 'GEDE', '', 'JAKARTA', '11/13', 'PELA MAMPANG', 'MAMPANG PRAPATAN IX', 'JAKARTA SELATAN', 'JAKARTA', '1997-01-22', 1, 1, '1234588000000001', 5, 2, '', NULL, 1, '2025-04-11 16:11:53', '2025-05-04 21:05:39', 2, 1);

-- ----------------------------
-- Table structure for m_customer_nationality
-- ----------------------------
DROP TABLE IF EXISTS `m_customer_nationality`;
CREATE TABLE `m_customer_nationality`  (
  `id` smallint NULL DEFAULT NULL,
  `nationality_name` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  UNIQUE INDEX `idx_country`(`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of m_customer_nationality
-- ----------------------------
INSERT INTO `m_customer_nationality` VALUES (1, 'Indonesia', 1, '2024-05-01 09:00:00', '2025-05-04 20:08:15', 1, 1);
INSERT INTO `m_customer_nationality` VALUES (2, 'JAPAN', 1, '2025-01-09 17:59:53', NULL, 2, NULL);
INSERT INTO `m_customer_nationality` VALUES (3, 'KOREA', 1, '2025-01-09 18:01:56', NULL, 2, NULL);
INSERT INTO `m_customer_nationality` VALUES (4, 'CHINA', 1, '2025-01-09 18:02:12', NULL, 2, NULL);
INSERT INTO `m_customer_nationality` VALUES (5, 'MALAYSIA', 1, '2025-01-13 13:50:30', NULL, 2, NULL);
INSERT INTO `m_customer_nationality` VALUES (6, 'INDIA', 1, '2025-01-13 13:50:52', NULL, 2, NULL);

-- ----------------------------
-- Table structure for m_customer_work
-- ----------------------------
DROP TABLE IF EXISTS `m_customer_work`;
CREATE TABLE `m_customer_work`  (
  `id` smallint NOT NULL,
  `work_name` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `category_id` smallint NULL DEFAULT NULL,
  `status` smallint NULL DEFAULT 0,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `customwork1`(`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of m_customer_work
-- ----------------------------
INSERT INTO `m_customer_work` VALUES (1, 'Ibu Rumah Tangga', 1, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (2, 'Korporasi', 1, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (3, 'Lainnya', 1, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (4, 'Pegawai Bank', 2, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (5, 'Pegawai BUMD', 3, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (6, 'Pegawai BUMN', 3, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (7, 'Pegawai KUPVA BB', 2, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (8, 'Pegawai Swasta', 1, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (9, 'Pengurus Parpol', 3, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (10, 'Pengusaha', 1, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (11, 'Pensiunan PNS', 3, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (12, 'PNS Aktif', 3, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (13, 'Profesional', 1, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (14, 'TKI / TKW', 1, 1, '2024-05-01 09:00:00', NULL, 1, NULL);
INSERT INTO `m_customer_work` VALUES (15, 'Yayasan/Pengurus Yayasan', 1, 1, '2024-05-01 09:00:00', NULL, 1, NULL);

-- ----------------------------
-- Table structure for m_transaction
-- ----------------------------
DROP TABLE IF EXISTS `m_transaction`;
CREATE TABLE `m_transaction`  (
  `id` smallint NOT NULL,
  `tr_date` date NULL DEFAULT NULL,
  `description` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT '',
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_transacstion`(`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of m_transaction
-- ----------------------------
INSERT INTO `m_transaction` VALUES (1, '2024-05-01', 'Transaksi Beli', 0, '2023-12-31 18:50:49', NULL, 1, NULL);
INSERT INTO `m_transaction` VALUES (2, '2024-05-01', 'Transaksi Jual', 0, '2023-12-31 18:50:49', NULL, 1, NULL);
INSERT INTO `m_transaction` VALUES (3, '2024-05-01', 'Transaksi Kas / Bank', 0, '2023-12-31 18:50:49', NULL, 1, NULL);

-- ----------------------------
-- Table structure for m_user
-- ----------------------------
DROP TABLE IF EXISTS `m_user`;
CREATE TABLE `m_user`  (
  `id` smallint NOT NULL,
  `company_id` smallint NOT NULL,
  `user_name` varchar(25) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `password` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `user_full_name` varchar(75) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `usergroup_id` smallint NOT NULL,
  `userlevel_id` smallint NOT NULL,
  `user_insert` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'Y',
  `user_update` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'Y',
  `user_delete` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'Y',
  `user_cancel` char(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT 'N',
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_user`(`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of m_user
-- ----------------------------
INSERT INTO `m_user` VALUES (1, 1, 'admin', '123', 'Admin', 1, 1, 'Y', 'Y', 'Y', 'Y', 1, '2025-01-19 09:00:00', NULL, NULL, NULL);
INSERT INTO `m_user` VALUES (2, 1, 'konter', '123', 'Konter', 2, 1, 'Y', 'Y', 'Y', 'Y', 1, '2025-01-19 09:00:00', NULL, NULL, NULL);
INSERT INTO `m_user` VALUES (3, 1, 'kasir', '123', 'Kasir', 3, 1, 'Y', 'Y', 'Y', 'Y', 1, '2025-01-19 09:00:00', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for m_valas
-- ----------------------------
DROP TABLE IF EXISTS `m_valas`;
CREATE TABLE `m_valas`  (
  `id` smallint NOT NULL,
  `valas_code` varchar(6) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `valas_name` varchar(35) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `valas1`(`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of m_valas
-- ----------------------------
INSERT INTO `m_valas` VALUES (1, 'AUD', 'Australia Dollar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (2, 'BND', 'Brunei Dollar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (3, 'CAD', 'Canada Dollar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (4, 'CHF', 'Swiss Franc', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (5, 'DKK', 'Denmark Krone', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (6, 'GBP', 'Pound Sterling Inggris', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (7, 'HKD', 'Hokong Dollar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (8, 'JPY', 'Jepang Yen', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (9, 'MYR', 'Malaysia Ringgit', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (10, 'NOK', 'Norwey Krone', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (11, 'NZD', 'New Zeland Dollar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (12, 'PGK', 'Papua Nugini Kina', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (13, 'PHP', 'Philipine Peso', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (14, 'SEK', 'Swedia Krona', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (15, 'SGD', 'Singapore Dollar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (16, 'THB', 'Thailand Bath', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (17, 'USD', 'AS Dollar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (18, 'EUR', 'Uni Eropa Euro', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (19, 'AED', 'Emirat Arab Dirham', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (20, 'BHD', 'Bahrain Dollar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (21, 'BRL', 'Brasil Reak', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (22, 'CLP', 'Chili Peso', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (23, 'CNY', 'China Yuan', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (24, 'CZK', 'Ceko Koruna', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (25, 'EGP', 'Mesir Pound', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (26, 'INR', 'India Ruppe', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (27, 'IRR', 'Iran Rial', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (28, 'KRW', 'Korea Won', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (29, 'KWD', 'Kwait Dinnar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (30, 'MXN', 'Meksiko Peso', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (31, 'OMR', 'Oman Rial', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (32, 'JOD', 'Yordania Dinar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (33, 'QAR', 'Qatar Real', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (34, 'RUB', 'Rusia Rubel', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (35, 'SAR', 'Saudi Real', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (36, 'SDD', 'Sudan Dinar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (37, 'TWD', 'Taiwan Dollar', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (38, 'VND', 'Vietnam Dong', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (39, 'YER', 'Yaman Rial', 1, '2025-01-18 18:23:59', NULL, 1, NULL);
INSERT INTO `m_valas` VALUES (40, 'ZAR', 'Afrika Selatan Rand', 1, '2025-01-18 18:23:59', NULL, 1, NULL);

-- ----------------------------
-- Table structure for st_valas
-- ----------------------------
DROP TABLE IF EXISTS `st_valas`;
CREATE TABLE `st_valas`  (
  `id` smallint NOT NULL,
  `company_id` smallint NOT NULL,
  `valas_id` smallint NOT NULL,
  `st_year` decimal(4, 0) NOT NULL,
  `st_month` decimal(2, 0) NOT NULL,
  `qty_first` decimal(12, 0) NULL DEFAULT 0,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  INDEX `idx_stvalas`(`valas_id`, `st_year`, `st_month`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of st_valas
-- ----------------------------
INSERT INTO `st_valas` VALUES (11, 1, 15, 2025, 4, 0, '2025-05-03 15:30:05', NULL, 0, NULL);
INSERT INTO `st_valas` VALUES (10, 1, 17, 2025, 4, 0, '2025-05-03 15:30:05', NULL, 0, NULL);
INSERT INTO `st_valas` VALUES (24, 1, 15, 2025, 5, 4000, '2025-05-04 20:48:06', NULL, 1, NULL);
INSERT INTO `st_valas` VALUES (25, 1, 17, 2025, 5, 2000, '2025-05-04 20:48:06', NULL, 1, NULL);
INSERT INTO `st_valas` VALUES (26, 1, 15, 2025, 6, 8000, '2025-05-04 20:48:06', NULL, 1, NULL);
INSERT INTO `st_valas` VALUES (27, 1, 17, 2025, 6, 8500, '2025-05-04 20:48:06', NULL, 1, NULL);

-- ----------------------------
-- Table structure for st_valas_avg
-- ----------------------------
DROP TABLE IF EXISTS `st_valas_avg`;
CREATE TABLE `st_valas_avg`  (
  `id` smallint NULL DEFAULT NULL,
  `company_id` smallint NULL DEFAULT NULL,
  `valas_id` smallint NULL DEFAULT NULL,
  `buy_number` varchar(9) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `st_date` date NULL DEFAULT NULL,
  `qty_buy` decimal(12, 0) NULL DEFAULT 0,
  `price_buy` decimal(12, 3) NULL DEFAULT 0.000,
  `total_buy` decimal(18, 3) NULL DEFAULT 0.000,
  `sale_number` varchar(9) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  `qty_sale` decimal(12, 0) NULL DEFAULT 0,
  `price_sale` decimal(12, 3) NULL DEFAULT 0.000,
  `total_sale` decimal(18, 3) NULL DEFAULT 0.000,
  `total_sale_average` decimal(18, 3) NULL DEFAULT 0.000,
  `st_last_qty` decimal(12, 3) NULL DEFAULT 0.000,
  `st_last_price` decimal(18, 3) NULL DEFAULT 0.000,
  `st_last_total` decimal(18, 3) NULL DEFAULT 0.000,
  `profit` decimal(18, 3) NULL DEFAULT 0.000,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  INDEX `idx_lr`(`id`, `buy_number`, `st_date`, `valas_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of st_valas_avg
-- ----------------------------
INSERT INTO `st_valas_avg` VALUES (1, 1, 15, '0001', '2025-04-30', 3000, 12100.000, 36300000.000, '', 0, 0.000, 0.000, 0.000, 3000.000, 12100.000, 36300000.000, 0.000, '2025-05-03 15:30:06', NULL, 0, NULL);
INSERT INTO `st_valas_avg` VALUES (1, 1, 17, '0001', '2025-04-30', 1000, 16500.000, 16500000.000, '', 0, 0.000, 0.000, 0.000, 1000.000, 16500.000, 16500000.000, 0.000, '2025-05-03 15:30:06', NULL, 0, NULL);
INSERT INTO `st_valas_avg` VALUES (1, 1, 15, '', '2025-05-01', 0, 0.000, 0.000, '', 0, 0.000, 0.000, 0.000, 3000.000, 12100.000, 36300000.000, 0.000, '2025-05-04 20:48:07', NULL, 1, NULL);
INSERT INTO `st_valas_avg` VALUES (1, 1, 17, '', '2025-05-01', 0, 0.000, 0.000, '', 0, 0.000, 0.000, 0.000, 1000.000, 16500.000, 16500000.000, 0.000, '2025-05-04 20:48:07', NULL, 1, NULL);
INSERT INTO `st_valas_avg` VALUES (1, 1, 17, '0001', '2025-05-04', 5000, 16400.000, 82000000.000, '', 0, 0.000, 0.000, 0.000, 6500.000, 16400.000, 106600000.000, 0.000, '2025-05-04 20:48:07', NULL, 1, NULL);
INSERT INTO `st_valas_avg` VALUES (1, 1, 15, '', '2025-05-03', 0, 0.000, 0.000, '', 0, 0.000, 0.000, 0.000, 3000.000, 12100.000, 36300000.000, 0.000, '2025-05-04 20:54:51', NULL, 1, NULL);
INSERT INTO `st_valas_avg` VALUES (1, 1, 17, '', '2025-05-03', 0, 0.000, 0.000, '', 0, 0.000, 0.000, 0.000, 1000.000, 16500.000, 16500000.000, 0.000, '2025-05-04 20:54:51', NULL, 1, NULL);
INSERT INTO `st_valas_avg` VALUES (2, 1, 15, '0001', '2025-05-03', 2000, 12300.000, 24600000.000, '', 0, 0.000, 0.000, 0.000, 5000.000, 12180.000, 60900000.000, 0.000, '2025-05-04 20:54:51', NULL, 1, NULL);
INSERT INTO `st_valas_avg` VALUES (2, 1, 17, '0001', '2025-05-03', 2000, 16300.000, 32600000.000, '', 0, 0.000, 0.000, 0.000, 3000.000, 16366.670, 49100010.000, 0.000, '2025-05-04 20:54:51', NULL, 1, NULL);
INSERT INTO `st_valas_avg` VALUES (3, 1, 17, '', '2025-05-03', 0, 0.000, 0.000, '0001', 500, 16600.000, 8300000.000, 8183335.000, 2500.000, 16366.670, 40916675.000, 116665.000, '2025-05-04 20:54:51', NULL, 1, NULL);

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

-- ----------------------------
-- Records of tr_bayar
-- ----------------------------
INSERT INTO `tr_bayar` VALUES (1, 1, 1, '25050301010001', '2025-04-30', 1, 81400000.000, 'Pembelian Valas                                                                                                                                       ', 3, '2025-05-03 23:30:41', NULL, 1, NULL);
INSERT INTO `tr_bayar` VALUES (2, 1, 1, '25050401010001', '2025-05-04', 1, 82000000.000, 'Pembelian Valas                                                                                                                                       ', 3, '2025-05-04 20:10:57', NULL, 1, NULL);

-- ----------------------------
-- Table structure for tr_detail
-- ----------------------------
DROP TABLE IF EXISTS `tr_detail`;
CREATE TABLE `tr_detail`  (
  `id` bigint NULL DEFAULT NULL,
  `company_id` smallint NULL DEFAULT NULL,
  `tr_id` smallint NULL DEFAULT NULL,
  `tr_number` varchar(14) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `tr_date` date NULL DEFAULT NULL,
  `valas_id` smallint NULL DEFAULT NULL,
  `qty` decimal(12, 3) NULL DEFAULT 0.000,
  `price` decimal(12, 3) NULL DEFAULT 0.000,
  `subtotal` decimal(18, 3) NULL DEFAULT 0.000,
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` bigint NULL DEFAULT NULL,
  `updatedby` bigint NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of tr_detail
-- ----------------------------
INSERT INTO `tr_detail` VALUES (1, 1, 1, '25050301010001', '2025-04-30', 17, 1000.000, 16500.000, 16500000.000, 3, '2025-05-03 10:34:57', NULL, 1, NULL);
INSERT INTO `tr_detail` VALUES (2, 1, 1, '25050301010001', '2025-04-30', 15, 3000.000, 12100.000, 36300000.000, 3, '2025-05-03 10:34:57', NULL, 1, NULL);
INSERT INTO `tr_detail` VALUES (3, 1, 2, '25050301020001', '2025-05-03', 17, 500.000, 16600.000, 8300000.000, 3, '2025-05-03 10:52:50', NULL, 1, NULL);
INSERT INTO `tr_detail` VALUES (4, 1, 1, '25050301010001', '2025-05-03', 17, 1000.000, 16300.000, 16300000.000, 3, '2025-05-03 23:28:56', NULL, 1, NULL);
INSERT INTO `tr_detail` VALUES (5, 1, 1, '25050301010001', '2025-05-03', 15, 1000.000, 12300.000, 12300000.000, 3, '2025-05-03 23:28:56', NULL, 1, NULL);
INSERT INTO `tr_detail` VALUES (6, 1, 1, '25050401010001', '2025-05-04', 17, 5000.000, 16400.000, 82000000.000, 3, '2025-05-04 20:10:38', NULL, 1, NULL);

-- ----------------------------
-- Table structure for tr_header
-- ----------------------------
DROP TABLE IF EXISTS `tr_header`;
CREATE TABLE `tr_header`  (
  `id` bigint NULL DEFAULT NULL,
  `company_id` smallint NULL DEFAULT NULL,
  `tr_id` smallint NULL DEFAULT NULL,
  `tr_number` varchar(14) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `tr_date` date NULL DEFAULT NULL,
  `customer_id` bigint NULL DEFAULT NULL,
  `relation_customer_id` bigint NULL DEFAULT NULL,
  `relation_description` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `customer_action_id` bigint NULL DEFAULT NULL,
  `sumber_dana` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `tujuan_transaksi` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `description` varchar(150) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `numberofcopies` decimal(8, 0) NULL DEFAULT NULL,
  `counter_id` smallint NULL DEFAULT NULL,
  `cashier_id` smallint NULL DEFAULT NULL,
  `status` smallint NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  INDEX `idx_trh`(`tr_id`, `tr_number`, `tr_date`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of tr_header
-- ----------------------------
INSERT INTO `tr_header` VALUES (1, 1, 1, '25050301010001', '2025-04-30', 1, NULL, NULL, 0, '', '', '', 1, 1, 3, 3, '2025-05-03 10:34:57', NULL, 1, NULL);
INSERT INTO `tr_header` VALUES (2, 1, 2, '25050301020001', '2025-05-03', 1, NULL, NULL, 0, '', '', '', 0, 1, 3, 3, '2025-05-03 10:52:50', NULL, 1, NULL);
INSERT INTO `tr_header` VALUES (3, 1, 1, '25050301010001', '2025-05-03', 1, NULL, NULL, 0, '', '', '', 1, 1, 3, 3, '2025-05-03 23:28:56', NULL, 1, NULL);
INSERT INTO `tr_header` VALUES (4, 1, 1, '25050401010001', '2025-05-04', 1, NULL, NULL, 0, '', '', '', 0, 1, 3, 3, '2025-05-04 20:10:38', NULL, 1, NULL);

SET FOREIGN_KEY_CHECKS = 1;
