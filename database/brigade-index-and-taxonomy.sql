-- --------------------------------------------------------
-- Host:                         digitalright.org
-- Server version:               10.3.23-MariaDB-cll-lve - MariaDB Server
-- Server OS:                    Linux
-- HeidiSQL Version:             9.5.0.5196
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


CREATE DATABASE IF NOT EXISTS `project_index` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;
USE `project_idex`;


CREATE TABLE IF NOT EXISTS `cfa_skills` (
  `skill_id` int(11) DEFAULT NULL,
  `skill_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `country` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `continent` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitude` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `longitude` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  KEY `id` (`id`),
  KEY `city` (`city`),
  KEY `state` (`state`),
  KEY `country` (`country`)
) ENGINE=InnoDB AUTO_INCREMENT=184 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `organizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(70) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=221 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `organizations_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  KEY `id` (`id`,`organization_id`,`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=216 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `organizations_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) DEFAULT NULL,
  `tag_id` int(11) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=462 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `periods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_pushed_within` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_pushed_within_num` int(11) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Map the last_pushed_within periods to ordered numbers so we can filter by "age"';


CREATE TABLE IF NOT EXISTS `programming_languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `programming_language` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='To hold values like Java, Javascript, Python, React, Node, SQL, etc...\r\nItems can be added during data insertion';


CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `link_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `code_url` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_pushed_within` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `organization_id` int(11) DEFAULT NULL,
  `toml` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'link to toml file for verification',
  `update_timestamp` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  KEY `id` (`id`),
  KEY `organization_id` (`organization_id`),
  KEY `last_pushed_within` (`last_pushed_within`)
) ENGINE=InnoDB AUTO_INCREMENT=7039 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `projects_programming_languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `progr_lang_id` int(11) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Populate this and programming_languages table.\r\nDuring projects data population: Grab programming language from Github but also convert some topics into prog_lang (instead of inserting a project topic "Java", insert it as language)';


CREATE TABLE IF NOT EXISTS `projects_topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `topic_id` int(11) DEFAULT NULL,
  KEY `id` (`id`,`project_id`,`topic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5394 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE IF NOT EXISTS `projects_topics_copy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `topic_id` int(11) DEFAULT NULL,
  KEY `id` (`id`,`project_id`,`topic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13584 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;


CREATE TABLE IF NOT EXISTS `states_regions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state_name` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` char(2) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `region` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'like North East',
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='To hold state abbreviations and their region (like North East, North West, etc.)';


CREATE TABLE IF NOT EXISTS `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Organization tags';


CREATE TABLE IF NOT EXISTS `topics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  KEY `id` (`id`,`topic`)
) ENGINE=InnoDB AUTO_INCREMENT=1430 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC COMMENT='Project topics';


CREATE TABLE IF NOT EXISTS `topics_synonyms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic` varchar(70) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `synonym` varchar(70) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `synonym_2` varchar(70) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'geo, technology',
  KEY `id` (`id`),
  KEY `topic` (`topic`,`synonym`,`synonym_2`)
) ENGINE=InnoDB AUTO_INCREMENT=1402 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `brigades_topics` (
	`id` INT(11) NOT NULL,
	`name` VARCHAR(70) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`type` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`website` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`topic` VARCHAR(30) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`project_name` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;


-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `organizations_last_pushed_within` (
	`id` INT(11) NOT NULL,
	`name` VARCHAR(70) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`website` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`last_pushed` INT(11) NULL,
	`last_pushed_within` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;


-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `organizations_projects_count` (
	`id` INT(11) NOT NULL,
	`name` VARCHAR(70) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`website` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`proj_count` BIGINT(21) NOT NULL,
	`city` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`state` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`country` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`continent` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;


-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `projects_last_pushed_within` (
	`id` INT(11) NOT NULL,
	`name` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`description` LONGTEXT NULL COLLATE 'utf8mb4_unicode_ci',
	`link_url` VARCHAR(200) NULL COLLATE 'utf8mb4_unicode_ci',
	`code_url` VARCHAR(200) NULL COLLATE 'utf8mb4_unicode_ci',
	`last_pushed_within` VARCHAR(30) NULL COLLATE 'utf8mb4_unicode_ci',
	`organization_id` INT(11) NULL,
	`update_timestamp` TIMESTAMP NOT NULL,
	`last_pushed_within_2` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`last_pushed_within_num` INT(11) NULL
) ENGINE=MyISAM;

-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `projects_organizations_locations` (
	`project_id` INT(11) NOT NULL,
	`proj_name` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`description` LONGTEXT NULL COLLATE 'utf8mb4_unicode_ci',
	`code_url` VARCHAR(200) NULL COLLATE 'utf8mb4_unicode_ci',
	`link_url` VARCHAR(200) NULL COLLATE 'utf8mb4_unicode_ci',
	`last_pushed_within` VARCHAR(30) NULL COLLATE 'utf8mb4_unicode_ci',
	`last_pushed_within_num` INT(11) NULL,
	`org_id` INT(11) NOT NULL,
	`org_name` VARCHAR(70) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`type` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`website` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`city` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`state` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`country` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`continent` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`latitude` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci',
	`longitude` VARCHAR(50) NULL COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;


-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `taxonomy_view` (
	`synonym_2` VARCHAR(70) NULL COLLATE 'utf8mb4_unicode_ci',
	`synonym` VARCHAR(70) NULL COLLATE 'utf8mb4_unicode_ci',
	`count` BIGINT(21) NOT NULL
) ENGINE=MyISAM;


-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `taxonomy_view_2` (
	`synonym_2` VARCHAR(70) NULL COLLATE 'utf8mb4_unicode_ci',
	`synonym` VARCHAR(70) NULL COLLATE 'utf8mb4_unicode_ci',
	`type` VARCHAR(50) NULL COMMENT 'geo, technology' COLLATE 'utf8mb4_unicode_ci',
	`topic` VARCHAR(30) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`count` BIGINT(21) NOT NULL
) ENGINE=MyISAM;


-- Creating temporary table to overcome VIEW dependency errors
CREATE TABLE `topics_synonyms_view` (
	`id` INT(11) NOT NULL,
	`topic` VARCHAR(30) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`synonym` VARCHAR(70) NULL COLLATE 'utf8mb4_unicode_ci',
	`synonym_2` VARCHAR(70) NULL COLLATE 'utf8mb4_unicode_ci',
	`type` VARCHAR(50) NULL COMMENT 'geo, technology' COLLATE 'utf8mb4_unicode_ci'
) ENGINE=MyISAM;


-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `brigades_topics`;
CREATE ALGORITHM=UNDEFINED DEFINER=`giova63_cfa_gio`@`pool-100-8-118-234.nwrknj.fios.verizon.net` SQL SECURITY DEFINER VIEW `brigades_topics` AS select `a`.`id` AS `id`,`a`.`name` AS `name`,`a`.`type` AS `type`,`a`.`website` AS `website`,`d`.`topic` AS `topic`,`b`.`name` AS `project_name` from (((`organizations` `a` join `projects` `b`) join `projects_topics` `c`) join `topics` `d`) where `a`.`id` = `b`.`organization_id` and `c`.`project_id` = `b`.`id` and `d`.`id` = `c`.`topic_id`;


-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `organizations_last_pushed_within`;
CREATE ALGORITHM=UNDEFINED DEFINER=`giova63_cfa_gio`@`pool-100-8-118-234.nwrknj.fios.verizon.net` SQL SECURITY DEFINER VIEW `organizations_last_pushed_within` AS select `b`.`id` AS `id`,`b`.`name` AS `name`,`b`.`website` AS `website`,min(`a`.`last_pushed_within_num`) AS `last_pushed`,(select `p`.`last_pushed_within` from `periods` `p` where `p`.`last_pushed_within_num` = min(`a`.`last_pushed_within_num`)) AS `last_pushed_within` from (`projects_last_pushed_within` `a` join `organizations` `b` on(`b`.`id` = `a`.`organization_id`)) group by `b`.`id`;


-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `organizations_projects_count`;
CREATE ALGORITHM=UNDEFINED DEFINER=`giova63_cfa_gio`@`pool-100-8-118-234.nwrknj.fios.verizon.net` SQL SECURITY DEFINER VIEW `organizations_projects_count` AS select `a`.`id` AS `id`,`a`.`name` AS `name`,`a`.`website` AS `website`,count(0) AS `proj_count`,`c`.`city` AS `city`,`c`.`state` AS `state`,`c`.`country` AS `country`,`c`.`continent` AS `continent` from (((`organizations` `a` join `projects` `b`) join `locations` `c`) join `organizations_locations` `d`) where `b`.`organization_id` = `a`.`id` and `d`.`organization_id` = `a`.`id` and `c`.`id` = `d`.`location_id` group by `b`.`organization_id`;


-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `projects_last_pushed_within`;
CREATE ALGORITHM=UNDEFINED DEFINER=`giova63_cfa_gio`@`pool-100-8-118-234.nwrknj.fios.verizon.net` SQL SECURITY DEFINER VIEW `projects_last_pushed_within` AS select `a`.`id` AS `id`,`a`.`name` AS `name`,`a`.`description` AS `description`,`a`.`link_url` AS `link_url`,`a`.`code_url` AS `code_url`,`a`.`last_pushed_within` AS `last_pushed_within`,`a`.`organization_id` AS `organization_id`,`a`.`update_timestamp` AS `update_timestamp`,`b`.`last_pushed_within` AS `last_pushed_within_2`,`b`.`last_pushed_within_num` AS `last_pushed_within_num` from (`projects` `a` left join `periods` `b` on(`a`.`last_pushed_within` = `b`.`last_pushed_within`));


-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `projects_organizations_locations`;
CREATE ALGORITHM=UNDEFINED DEFINER=`giova63_cfa_gio`@`pool-100-8-118-234.nwrknj.fios.verizon.net` SQL SECURITY DEFINER VIEW `projects_organizations_locations` AS select `a`.`id` AS `project_id`,`a`.`name` AS `proj_name`,`a`.`description` AS `description`,`a`.`code_url` AS `code_url`,`a`.`link_url` AS `link_url`,`a`.`last_pushed_within` AS `last_pushed_within`,`e`.`last_pushed_within_num` AS `last_pushed_within_num`,`b`.`id` AS `org_id`,`b`.`name` AS `org_name`,`b`.`type` AS `type`,`b`.`website` AS `website`,`d`.`city` AS `city`,`d`.`state` AS `state`,`d`.`country` AS `country`,`d`.`continent` AS `continent`,`d`.`latitude` AS `latitude`,`d`.`longitude` AS `longitude` from ((((`projects` `a` join `organizations` `b` on(`a`.`organization_id` = `b`.`id`)) join `organizations_locations` `c` on(`c`.`organization_id` = `b`.`id`)) join `locations` `d` on(`d`.`id` = `c`.`location_id`)) left join `periods` `e` on(`e`.`last_pushed_within` = `a`.`last_pushed_within`));


-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `taxonomy_view`;
CREATE ALGORITHM=UNDEFINED DEFINER=`giova63_cfa_gio`@`pool-100-8-118-234.nwrknj.fios.verizon.net` SQL SECURITY DEFINER VIEW `taxonomy_view` AS select `a`.`synonym_2` AS `synonym_2`,`a`.`synonym` AS `synonym`,count(distinct `b`.`project_id`) AS `count` from (`topics_synonyms_view` `a` join `projects_topics` `b`) where 1 = 1 and `b`.`topic_id` = `a`.`id` group by `a`.`synonym_2`,`a`.`synonym`;


-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `taxonomy_view_2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`giova63_cfa_gio`@`pool-100-8-118-234.nwrknj.fios.verizon.net` SQL SECURITY DEFINER VIEW `taxonomy_view_2` AS select `a`.`synonym_2` AS `synonym_2`,`a`.`synonym` AS `synonym`,`a`.`type` AS `type`,`a`.`topic` AS `topic`,count(0) AS `count` from (`topics_synonyms_view` `a` join `projects_topics` `b`) where `b`.`topic_id` = `a`.`id` group by `b`.`topic_id`;


-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `topics_synonyms_view`;
CREATE ALGORITHM=UNDEFINED DEFINER=`giova63_cfa_gio`@`pool-100-8-118-234.nwrknj.fios.verizon.net` SQL SECURITY DEFINER VIEW `topics_synonyms_view` AS select `a`.`id` AS `id`,`a`.`topic` AS `topic`,`b`.`synonym` AS `synonym`,`b`.`synonym_2` AS `synonym_2`,`b`.`type` AS `type` from (`topics` `a` join `topics_synonyms` `b`) where `a`.`topic` = `b`.`topic`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
