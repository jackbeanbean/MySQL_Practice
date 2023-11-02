/*18.题目：现在运营想要对每个学校不同性别的用户活跃情况和发帖数量进行分析，请分别计算出每个学校每种性别的用户数、30天内平均活跃天数和平均发帖数量*/
DROP TABLE user_profile;
CREATE TABLE `user_profile` (
`id` int NOT NULL,
`device_id` int NOT NULL,
`gender` varchar(14) NOT NULL,
`age` int ,
`university` varchar(32) NOT NULL,
`gpa` float,
`active_days_within_30` float,
`question_cnt` float,
`answer_cnt` float
);
INSERT INTO user_profile 
VALUES(1,2138,'male',21,'北京大学',3.4,7,2,12),
(2,3214,'male',null,'复旦大学',4.0,15,5,25),
(3,6543,'female',20,'北京大学',3.2,12,3,30),
(4,2315,'female',23,'浙江大学',3.6,5,1,2),
(5,5432,'male',25,'山东大学',3.8,20,15,70),
(6,2131,'male',28,'山东大学',3.3,15,7,13),
(7,4321,'male',26,'复旦大学',3.6,9,6,52);

SELECT gender,university,COUNT(id) AS user_num,ROUND(AVG(active_days_within_30),1) AS avg_active_day ,ROUND(AVG(question_cnt),1) AS avg_question_cnt FROM user_profile
GROUP BY gender,university;

/*19.题目：现在运营想查看每个学校用户的平均发贴和回帖情况，寻找低活跃度学校进行重点运营，请取出平均发贴数低于5的学校或平均回帖数小于20的学校*/
SELECT university,ROUND(AVG(question_cnt),3) AS avg_question_cnt,ROUND(AVG(answer_cnt),3) AS avg_answer_cnt FROM user_profile
GROUP BY university
HAVING avg_question_cnt<5 OR avg_answer_cnt<20;

/*20.题目：现在运营想要查看不同大学的用户平均发帖情况，并期望结果按照平均发帖情况进行升序排列，请你取出相应数据*/
SELECT university,ROUND(AVG(question_cnt),4) AS avg_question_cnt FROM user_profile
GROUP BY university
ORDER BY avg_question_cnt;

/*21.题目：现在运营想要查看所有来自浙江大学的用户题目回答明细情况，请你取出相应数据*/
/*新增question_practice_detail表*/
CREATE TABLE `question_practice_detail` (
`id` int NOT NULL,
`device_id` int NOT NULL,
`question_id`int NOT NULL,
`result` varchar(32) NOT NULL
);
INSERT INTO question_practice_detail 
VALUES(1,2138,111,'wrong'),
(2,3214,112,'wrong'),
(3,3214,113,'wrong'),
(4,6543,111,'right'),
(5,2315,115,'right'),
(6,2315,116,'right'),
(7,2315,117,'wrong'),
(8,5432,118,'wrong'),
(9,5432,112,'wrong'),
(10,2131,114,'right'),
(11,5432,113,'wrong');

SELECT device_id,question_id,result FROM question_practice_detail
WHERE device_id=(SELECT device_id FROM user_profile
WHERE university="浙江大学");

/*22.运营想要了解每个学校答过题的用户平均答题数量情况，请你取出数据*/
/*先將user_profile表合併到question_practice_detail表，觀察結果*/
SELECT * FROM question_practice_detail
LEFT JOIN user_profile
	ON question_practice_detail.device_id=user_profile.device_id;

/*將需要顯示的資料放在select後面(COUNT的計算要看清楚)*/
SELECT university,COUNT(question_practice_detail.question_id)/COUNT(DISTINCT question_practice_detail.device_id) AS avg_answer_cnt FROM question_practice_detail
LEFT JOIN user_profile
	ON question_practice_detail.device_id=user_profile.device_id
GROUP BY university
ORDER BY university;

/*23.*/
drop table if  exists `question_practice_detail`;
CREATE TABLE `question_practice_detail` (
`id` int NOT NULL,
`device_id` int NOT NULL,
`question_id`int NOT NULL,
`result` varchar(32) NOT NULL
);
INSERT INTO question_practice_detail 
VALUES(1,2138,111,'wrong'),
(2,3214,112,'wrong'),
(3,3214,113,'wrong'),
(4,6543,111,'right'),
(5,2315,115,'right'),
(6,2315,116,'right'),
(7,2315,117,'wrong'),
(8,5432,117,'wrong'),
(9,5432,112,'wrong'),
(10,2131,113,'right'),
(11,5432,113,'wrong'),
(12,2315,115,'right'),
(13,2315,116,'right'),
(14,2315,117,'wrong'),
(15,5432,117,'wrong'),
(16,5432,112,'wrong'),
(17,2131,113,'right'),
(18,5432,113,'wrong'),
(19,2315,117,'wrong'),
(20,5432,117,'wrong'),
(21,5432,112,'wrong'),
(22,2131,113,'right'),
(23,5432,113,'wrong');

drop table if  exists `question_detail`;
CREATE TABLE `question_detail` (
`id` int NOT NULL,
`question_id`int NOT NULL,
`difficult_level` varchar(32) NOT NULL
);
INSERT INTO question_detail 
VALUES(1,111,'hard'),
(2,112,'medium'),
(3,113,'easy'),
(4,115,'easy'),
(5,116,'medium'),
(6,117,'easy');

/*题目：运营想要计算一些参加了答题的不同学校、不同难度的用户平均答题量，请你写SQL取出相应数据*/
/*將3個表連接*/
SELECT * FROM question_practice_detail
LEFT JOIN user_profile
	ON question_practice_detail.device_id=user_profile.device_id
LEFT JOIN question_detail
	ON question_practice_detail.question_id=question_detail.question_id;
/*題取想知道的欄位*/
SELECT 
	university,
	difficult_level,
	COUNT(question_practice_detail.question_id)/COUNT(DISTINCT question_practice_detail.device_id) AS avg_answer_cnt 
FROM question_practice_detail
LEFT JOIN user_profile
	ON question_practice_detail.device_id=user_profile.device_id
LEFT JOIN question_detail
	ON question_practice_detail.question_id=question_detail.question_id
GROUP BY university,difficult_level;
/*不使用join的解法*/
SELECT 
	t1.university,
	t3.difficult_level,
	COUNT(t2.question_id)/COUNT(DISTINCT t2.device_id) AS avg_answer_cnt 
FROM 
	user_profile AS t1,
    question_practice_detail AS t2,
    question_detail AS t3
WHERE 
	t2.device_id=t1.device_id AND
    t2.question_id=t3.question_id
GROUP BY t1.university,t3.difficult_level;

/*23.题目：运营想要查看参加了答题的山东大学的用户在不同难度下的平均答题题目数，请取出相应数据*/
/*3表連接*/
SELECT * FROM question_practice_detail
LEFT JOIN user_profile
	ON question_practice_detail.device_id=user_profile.device_id
LEFT JOIN question_detail
	ON question_practice_detail.question_id=question_detail.question_id;
/*挑選山東大學*/
SELECT * FROM question_practice_detail
LEFT JOIN user_profile
	ON question_practice_detail.device_id=user_profile.device_id
LEFT JOIN question_detail
	ON question_practice_detail.question_id=question_detail.question_id
WHERE university="山东大学";
/*選取想顯示的資料*/
SELECT 
	university,
	difficult_level,
    COUNT(question_practice_detail.question_id)/COUNT(DISTINCT question_practice_detail.device_id) AS avg_answer_cnt 
FROM question_practice_detail
LEFT JOIN user_profile
	ON question_practice_detail.device_id=user_profile.device_id
LEFT JOIN question_detail
	ON question_practice_detail.question_id=question_detail.question_id
WHERE university="山东大学"
GROUP BY difficult_level;
/*不使用join的解法*/
SELECT
    t1.university,
    t3.difficult_level,
    COUNT(t2.question_id) / COUNT(DISTINCT(t2.device_id)) as avg_answer_cnt
from
    user_profile as t1,
    question_practice_detail as t2,
    question_detail as t3
WHERE
    t1.university = '山东大学'
    and t1.device_id = t2.device_id
    and t2.question_id = t3.question_id
GROUP BY
    t3.difficult_level;



