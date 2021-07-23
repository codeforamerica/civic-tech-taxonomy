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


CREATE OR REPLACE VIEW taxonomy_tags_synonyms AS select `a`.`id` AS `id`,`a`.`display_name` AS `display_name`,`a`.`category` AS `category`,`a`.`subcategory` AS `subcategory`,`b`.`tag_id` AS `tag_id`,`b`.`synonym` AS `synonym` from (`taxonomy_tags` `a` left join `taxonomy_synonyms` `b` on(`b`.`tag_id` = `a`.`id`));

CREATE OR REPLACE VIEW projects_topics_view AS select `a`.`topic` AS `topic`,`b`.`id` AS `project_id`,`b`.`name` AS `name`,`b`.`description` AS `description`,`b`.`link_url` AS `link_url`,`b`.`code_url` AS `code_url`,`b`.`last_pushed_within` AS `last_pushed_within`,`b`.`status` AS `status`,`b`.`organization_id` AS `organization_id`,`b`.`toml` AS `toml` from ((`topics` `a` join `projects_topics` on(`a`.`id` = `projects_topics`.`topic_id`)) join `projects` `b` on(`b`.`id` = `projects_topics`.`project_id`)) order by `b`.`name`;

CREATE OR REPLACE VIEW not_assigned_synonyms AS select `projects_topics_view`.`topic` AS `topic`,`projects_topics_view`.`project_id` AS `project_id`,`projects_topics_view`.`name` AS `name`,`projects_topics_view`.`description` AS `description`,`projects_topics_view`.`link_url` AS `link_url`,`projects_topics_view`.`code_url` AS `code_url`,`projects_topics_view`.`last_pushed_within` AS `last_pushed_within`,`projects_topics_view`.`status` AS `status`,`projects_topics_view`.`organization_id` AS `organization_id`,`projects_topics_view`.`toml` AS `toml` from `projects_topics_view` where !(`projects_topics_view`.`topic` in (select `taxonomy_synonyms`.`synonym` from `taxonomy_synonyms`)) and !(`projects_topics_view`.`topic` in (select `taxonomy_tags`.`id` from `taxonomy_tags`));

CREATE OR REPLACE VIEW projects_topics_count AS select `a`.`topic` AS `topic`,count(0) AS `count` from (`topics` `a` join `projects_topics` on(`a`.`id` = `projects_topics`.`topic_id`)) group by `a`.`topic`;


/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
