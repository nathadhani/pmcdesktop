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

 Date: 04/05/2025 21:14:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- View structure for v_st2
-- ----------------------------
DROP VIEW IF EXISTS `v_st2`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_st2` AS select `tr_header`.`company_id` AS `company_id`,year(`tr_header`.`tr_date`) AS `st_year`,month(`tr_header`.`tr_date`) AS `st_month`,`tr_detail`.`valas_id` AS `valas_id`,sum(if(((`tr_header`.`tr_id` = 1) and (`tr_header`.`status` = 3)),`tr_detail`.`qty`,0)) AS `qty_buy`,sum(if(((`tr_header`.`tr_id` = 2) and (`tr_header`.`status` = 3)),`tr_detail`.`qty`,0)) AS `qty_sale` from (`tr_detail` join `tr_header` on(((`tr_detail`.`tr_number` = `tr_header`.`tr_number`) and (`tr_detail`.`tr_id` = `tr_header`.`tr_id`)))) where ((`tr_header`.`status` = 3) and (`tr_detail`.`status` = 3)) group by `tr_header`.`company_id`,year(`tr_header`.`tr_date`),month(`tr_header`.`tr_date`),`tr_detail`.`valas_id`;

-- ----------------------------
-- View structure for v_st3
-- ----------------------------
DROP VIEW IF EXISTS `v_st3`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_st3` AS select `st_valas`.`company_id` AS `company_id`,`st_valas`.`valas_id` AS `valas_id`,`st_valas`.`st_year` AS `st_year`,`st_valas`.`st_month` AS `st_month`,if((`st_valas`.`qty_first` is null),0,`st_valas`.`qty_first`) AS `qty_first`,if((`v_st2`.`qty_buy` is null),0,`v_st2`.`qty_buy`) AS `qty_buy`,if((`v_st2`.`qty_sale` is null),0,`v_st2`.`qty_sale`) AS `qty_sale`,((if((`st_valas`.`qty_first` is null),0,`st_valas`.`qty_first`) + if((`v_st2`.`qty_buy` is null),0,`v_st2`.`qty_buy`)) - if((`v_st2`.`qty_sale` is null),0,`v_st2`.`qty_sale`)) AS `qty_last`,`m_valas`.`valas_code` AS `valas_code`,`m_valas`.`valas_name` AS `valas_name` from ((`st_valas` left join `v_st2` on(((`v_st2`.`st_year` = `st_valas`.`st_year`) and (`v_st2`.`st_month` = `st_valas`.`st_month`) and (`v_st2`.`valas_id` = `st_valas`.`valas_id`)))) left join `m_valas` on((`st_valas`.`valas_id` = `m_valas`.`id`)));

SET FOREIGN_KEY_CHECKS = 1;
