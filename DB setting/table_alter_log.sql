drop table  ball.timer;
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

select * from timer;

drop table ball.alarm_message;
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
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


ALTER TABLE `ball`.`group_table` 
ADD COLUMN `group_target_time` TIME NULL DEFAULT NULL AFTER `group_person_count`;
use ball;



ALTER TABLE `ball`.`timer` 
ADD COLUMN `timer_is_on_site` TINYINT(1) NULL DEFAULT NULL AFTER `timer_is_play`;
update timer set timer_is_on_site = 0 where timer_id<2000;




ALTER TABLE `ball`.`user` 
ADD UNIQUE INDEX `user_email_UNIQUE` (`user_email` ASC) VISIBLE;

ALTER TABLE `ball`.`group_table` 
ADD COLUMN `group_target_minute` VARCHAR(10) NULL DEFAULT NULL AFTER `group_target_hour`,
CHANGE COLUMN `group_target_time` `group_target_hour` VARCHAR(10) NULL DEFAULT NULL ;



-- 6/30

ALTER TABLE `ball`.`timer` 
ADD COLUMN `timer_is_use_apple` TINYINT(1) NULL DEFAULT NULL AFTER `timer_is_on_site`;



drop view accumulated_time_per_group;
create view accumulated_time_per_group as
select gr.group_id, SEC_TO_TIME(ROUND(AVG(TIME_TO_SEC(
    CASE
        when t.timer_accumulated_day is null then '00:00:00'
        when t.timer_is_on_site = 0 then t.timer_accumulated_day
        when t.timer_is_play =1 and t.timer_is_on_site = 1 and t.timer_is_use_apple = 0 then TIMEDIFF(NOW(), t.timer_mod_date)
        else t.timer_accumulated_day
    END
    )))) as group_accumulated_avg_time
from group_user_relationship gr
         left outer join timer t
                         on gr.user_id = t.user_id
                             and  date(t.timer_date) = if(hour(now())<3, date(DATE_SUB(NOW(), INTERVAL 1 DAY)), date(now()))
group by gr.group_id;

commit;


--  7/2

DROP TABLE IF EXISTS schedule_table;

CREATE TABLE `schedule_table` (
  `schedule_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` varchar(45) DEFAULT NULL,
  `schedule_date` date DEFAULT NULL,
  `schedule_time` time DEFAULT NULL,
  `schedule_content` varchar(45) DEFAULT NULL,
  `schedule_checked` tinyint(1) DEFAULT NULL,
  `schedule_reg_date` DATETIME NULL DEFAULT NULL,
  `schedule_mod_date` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`schedule_id`),
  KEY `FKsieldxyek3ks98ckiu0djxu82l_idx` (`user_id`) /*!80000 INVISIBLE */,
  CONSTRAINT `FKsieldxyek3ks98ckiu0djxu82l` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


desc schedule_table;
commit;


-- 7/7
drop view if exists accumulated_time_per_group;
create view accumulated_time_per_group as
select `g`.`group_id` AS `group_id`,
       SEC_TO_TIME(ROUND(AVG(TIME_TO_SEC((CASE
                                              WHEN (`t`.`timer_accumulated_day` IS NULL) THEN '00:00:00'
                                              WHEN (`t`.`timer_is_on_site` = 0) THEN `t`.`timer_accumulated_day`
                                              WHEN
                                                  ((`t`.`timer_is_play` = 1)
                                                      AND (`t`.`timer_is_on_site` = 1)
                                                      AND (`t`.`timer_is_use_apple` = 0))
                                                  THEN
                                                  TIMEDIFF(NOW(), `t`.`timer_mod_date`)
                                              ELSE `t`.`timer_accumulated_day`
           END))),
                         0)) AS `group_accumulated_avg_time`
from group_table g
    left join group_user_relationship gr on g.group_id = gr.group_id
left join (
        select * from timer
        where timer_date = if((HOUR(NOW()) < 3), CAST((NOW() - INTERVAL 1 DAY) AS DATE), CAST(NOW() AS DATE))
    ) t on gr.user_id = t.user_id
GROUP BY g.group_id
order by g.group_id desc;

commit;


-- 7/8
drop view if exists accumulated_time_per_group;
create view accumulated_time_per_group as
select `g`.`group_id` AS `group_id`,
       SEC_TO_TIME(ROUND(AVG(TIME_TO_SEC((
			CASE
				  WHEN (`t`.`timer_accumulated_day` IS NULL) THEN '00:00:00'
				  WHEN (`t`.`timer_is_on_site` = 0) THEN `t`.`timer_accumulated_day`
				  WHEN
					  ((`t`.`timer_is_play` = 1)
						  AND (`t`.`timer_is_on_site` = 1)
						  AND (`t`.`timer_is_use_apple` = 0))
					  THEN
					  ADDTIME(`t`.`timer_accumulated_day`, TIMEDIFF(NOW(), `t`.`timer_mod_date`))
				  ELSE `t`.`timer_accumulated_day`
           END))),
                         0)) AS `group_accumulated_avg_time`
from group_table g
    left join group_user_relationship gr on g.group_id = gr.group_id
left join (
        select * from timer
        where timer_date = if((HOUR(NOW()) < 3), CAST((NOW() - INTERVAL 1 DAY) AS DATE), CAST(NOW() AS DATE))
    ) t on gr.user_id = t.user_id
GROUP BY g.group_id
order by g.group_id desc;

commit;

