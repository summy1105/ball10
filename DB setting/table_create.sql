-- create database ball;
use ball;

set GLOBAL time_zone = 'Asia/Seoul';
set time_zone = 'Asia/Seoul';

DROP TABLE IF EXISTS alarm_message;
DROP TABLE IF EXISTS group_user_relationship;
DROP TABLE IF EXISTS group_message;
DROP TABLE IF EXISTS notice;
DROP TABLE IF EXISTS timer;
DROP TABLE IF EXISTS group_table;
DROP TABLE IF EXISTS ball.user;



CREATE TABLE `user` (
  `user_id` varchar(45) NOT NULL,
  `user_password` varchar(45) DEFAULT NULL,
  `user_nickname` varchar(45) DEFAULT NULL,
  `user_email` varchar(45) DEFAULT NULL,
  `user_reg_date` datetime DEFAULT NULL,
  `user_mod_date` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `timer` (
  `timer_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` varchar(45) DEFAULT NULL,
  `timer_date` datetime DEFAULT NULL,
  `timer_accumulated_day` time DEFAULT NULL,
  `timer_is_play` tinyint(1) DEFAULT NULL,
  `timer_reg_date` datetime DEFAULT NULL,
  `timer_mod_date` datetime DEFAULT NULL,
  PRIMARY KEY (`timer_id`),
  KEY `FKguhmxby09uuo83rsebbm97jro` (`user_id`),
  CONSTRAINT `FKguhmxby09uuo83rsebbm97jro` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `alarm_message` (
  `alarm_message_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` varchar(45) DEFAULT NULL,
  `alarm_message_content` varchar(250) DEFAULT NULL,
  `alarm_message_is_new` tinyint(1) DEFAULT NULL,
  `alarm_message_reg_date` datetime DEFAULT NULL,
  `alarm_message_mod_date` datetime DEFAULT NULL,
  PRIMARY KEY (`alarm_message_id`),
  KEY `FKrkmolo8stoqoty1efp85e1vbt` (`user_id`),
  CONSTRAINT `FKrkmolo8stoqoty1efp85e1vbt` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `notice` (
  `notice_id` bigint NOT NULL AUTO_INCREMENT,
  `notice_content` varchar(2100) DEFAULT NULL,
  `notice_reg_date` datetime DEFAULT NULL,
  `notice_mod_date` datetime DEFAULT NULL,
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `group_table` (
  `group_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id_group_header` varchar(45) DEFAULT NULL,
  `group_name` varchar(65) DEFAULT NULL,
  `group_category` varchar(25) DEFAULT NULL,
  `group_is_secret` tinyint(1) DEFAULT NULL,
  `group_password` varchar(20) DEFAULT NULL,
  `group_person_count` int NOT NULL,
  `group_content` varchar(1100) DEFAULT NULL,
  `group_reg_date` datetime DEFAULT NULL,
  `group_mod_date` datetime DEFAULT NULL,
  PRIMARY KEY (`group_id`),
  KEY `FKe3qcnrfwnlk4jwhijrq3k0iaw` (`user_id_group_header`),
  CONSTRAINT `FKe3qcnrfwnlk4jwhijrq3k0iaw` FOREIGN KEY (`user_id_group_header`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `group_user_relationship` (
  `group_user_relationship_id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` bigint DEFAULT NULL,
  `user_id` varchar(45) DEFAULT NULL,
  `group_user_relationship_reg_date` datetime DEFAULT NULL,
  `group_user_relationship_mod_date` datetime DEFAULT NULL,
  PRIMARY KEY (`group_user_relationship_id`),
  KEY `FK25jvf2aghr30031ugcvhphimg` (`group_id`),
  KEY `FKn5f6fmgobp5a2bmgyyhm044f1` (`user_id`),
  CONSTRAINT `FK25jvf2aghr30031ugcvhphimg` FOREIGN KEY (`group_id`) REFERENCES `group_table` (`group_id`),
  CONSTRAINT `FKn5f6fmgobp5a2bmgyyhm044f1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `group_message` (
  `group_message_id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` bigint DEFAULT NULL,
  `user_id` varchar(45) DEFAULT NULL,
  `group_message_content` varchar(450) DEFAULT NULL,
  `group_message_reg_date` datetime DEFAULT NULL,
  `group_message_mod_date` datetime DEFAULT NULL,
  `schedule_reg_date` DATETIME NULL DEFAULT NULL,
  `schedule_mod_date` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`group_message_id`),
  KEY `FKt0wynm5k21v3j1wqkoucc463i` (`group_id`),
  KEY `FK43mpryhlgkpqi220wqdn03wht` (`user_id`),
  CONSTRAINT `FK43mpryhlgkpqi220wqdn03wht` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
  CONSTRAINT `FKt0wynm5k21v3j1wqkoucc463i` FOREIGN KEY (`group_id`) REFERENCES `group_table` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;




desc user;
desc timer;
desc alarm_message;
desc notice;
desc group_table;
desc group_user_relationship;
desc group_message;


