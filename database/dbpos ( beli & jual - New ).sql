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

 Date: 13/03/2025 14:45:23
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
INSERT INTO `m_customer_nationality` VALUES (1, 'Indonesia', 1, '2024-05-01 09:00:00', NULL, 1, NULL);
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
INSERT INTO `m_user` VALUES (2, 1, 'konter', '123', 'Kasir', 2, 1, 'Y', 'Y', 'Y', 'Y', 1, '2025-01-19 09:00:00', NULL, NULL, NULL);
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
  `qty_alocation` decimal(12, 0) NULL DEFAULT NULL,
  `created` datetime NULL DEFAULT NULL,
  `updated` datetime NULL DEFAULT NULL,
  `createdby` smallint NULL DEFAULT NULL,
  `updatedby` smallint NULL DEFAULT NULL,
  INDEX `idx_stvalas`(`valas_id`, `st_year`, `st_month`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of st_valas
-- ----------------------------

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

-- ----------------------------
-- View structure for v_st2
-- ----------------------------
DROP VIEW IF EXISTS `v_st2`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_st2` AS select `tr_header`.`company_id` AS `company_id`,year(`tr_header`.`tr_date`) AS `st_year`,month(`tr_header`.`tr_date`) AS `st_month`,`tr_detail`.`valas_id` AS `valas_id`,sum(if(((`tr_header`.`tr_id` = 1) and (`tr_header`.`status` = 3)),`tr_detail`.`qty`,0)) AS `qty_buy`,sum(if(((`tr_header`.`tr_id` = 2) and (`tr_header`.`status` = 3)),`tr_detail`.`qty`,0)) AS `qty_sale` from (`tr_detail` join `tr_header` on(((`tr_detail`.`tr_number` = `tr_header`.`tr_number`) and (`tr_detail`.`tr_id` = `tr_header`.`tr_id`)))) where ((`tr_header`.`status` = 3) and (`tr_detail`.`status` = 3)) group by `tr_header`.`company_id`,year(`tr_header`.`tr_date`),month(`tr_header`.`tr_date`),`tr_detail`.`valas_id`;

-- ----------------------------
-- View structure for v_st3
-- ----------------------------
DROP VIEW IF EXISTS `v_st3`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_st3` AS select `st_valas`.`company_id` AS `company_id`,`st_valas`.`valas_id` AS `valas_id`,`st_valas`.`st_year` AS `st_year`,`st_valas`.`st_month` AS `st_month`,if((`st_valas`.`qty_first` is null),0,`st_valas`.`qty_first`) AS `qty_first`,if((`st_valas`.`qty_alocation` is null),0,`st_valas`.`qty_alocation`) AS `qty_alocation`,if((`v_st2`.`qty_buy` is null),0,`v_st2`.`qty_buy`) AS `qty_buy`,if((`v_st2`.`qty_sale` is null),0,`v_st2`.`qty_sale`) AS `qty_sale`,(((if((`st_valas`.`qty_first` is null),0,`st_valas`.`qty_first`) + if((`v_st2`.`qty_buy` is null),0,`v_st2`.`qty_buy`)) - if((`v_st2`.`qty_sale` is null),0,`v_st2`.`qty_sale`)) - if((`st_valas`.`qty_alocation` is null),0,`st_valas`.`qty_alocation`)) AS `qty_last`,`m_valas`.`valas_code` AS `valas_code`,`m_valas`.`valas_name` AS `valas_name` from ((`st_valas` left join `v_st2` on(((`v_st2`.`st_year` = `st_valas`.`st_year`) and (`v_st2`.`st_month` = `st_valas`.`st_month`) and (`v_st2`.`valas_id` = `st_valas`.`valas_id`)))) left join `m_valas` on((`st_valas`.`valas_id` = `m_valas`.`id`)));

SET FOREIGN_KEY_CHECKS = 1;
