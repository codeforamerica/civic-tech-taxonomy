-- --------------------------------------------------------
-- Server version:               10.3.23-MariaDB-cll-lve - MariaDB Server
-- Server OS:                    Linux
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


CREATE DATABASE IF NOT EXISTS `cfa_project_index` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `cfa_project_index`;


CREATE TABLE `taxonomy_synonyms` (
	`tag_id` VARCHAR(256) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`synonym` VARCHAR(256) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`tag_id`, `synonym`),
	CONSTRAINT `FK_taxonomy_synonyms_taxonomy_tags` FOREIGN KEY (`tag_id`) REFERENCES `taxonomy_tags` (`id`)
)
COLLATE='utf8mb4_unicode_ci' ENGINE=InnoDB;

CREATE TABLE `taxonomy_tags` (
	`id` VARCHAR(256) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`display_name` VARCHAR(256) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`category` VARCHAR(256) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`subcategory` VARCHAR(256) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	INDEX `id` (`id`),
	INDEX `category` (`category`),	
	INDEX `subcategory` (`subcategory`)	
)
COLLATE='utf8mb4_unicode_ci' ENGINE=InnoDB;


CREATE VIEW taxonomy_tags_synonyms AS select `a`.`id` AS `id`,`a`.`display_name` AS `display_name`,`a`.`category` AS `category`,`a`.`subcategory` AS `subcategory`,`b`.`tag_id` AS `tag_id`,`b`.`synonym` AS `synonym` from (`taxonomy_tags` `a` left join `taxonomy_synonyms` `b` on(`b`.`tag_id` = `a`.`id`));


/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
