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

/*24.题目：运营想要查看参加了答题的山东大学的用户在不同难度下的平均答题题目数，请取出相应数据*/
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

/*25.题目：现在运营想要分别查看学校为山东大学或者性别为男性的用户的device_id、gender、age和gpa数据，请取出相应结果，结果不去重*/
SELECT device_id,gender,age,gpa FROM user_profile
WHERE university="山东大学"
UNION ALL
SELECT device_id,gender,age,gpa FROM user_profile
WHERE gender="male";

/*26.题目：现在运营想要将用户划分为25岁以下和25岁及以上两个年龄段，分别查看这两个年龄段用户数量
本题注意：age为null 也记为 25岁以下*/
SELECT 
CASE
	WHEN age>=25 THEN "25岁及以上"
    ELSE "25岁以下"
END AS age_cut,
COUNT(CASE
	WHEN age>=25 THEN "25岁及以上"
    ELSE "25岁以下"
END) AS number
FROM user_profile
GROUP BY age_cut;

SELECT 
CASE
	WHEN age>=25 THEN "25岁及以上"
    ELSE "25岁以下"
END AS age_cut,
COUNT(*) AS number /*這邊用*就好，因為後面有GROUP BY了*/
FROM user_profile
GROUP BY age_cut;

/*用IF的寫法*/
SELECT 
	IF(age>=25,"25岁及以上","25岁以下") AS age_cut,
    COUNT(*) AS number
FROM user_profile
GROUP BY age_cut;


/*27.题目：现在运营想要将用户划分为20岁以下，20-24岁，25岁及以上三个年龄段，分别查看不同年龄段用户的明细情况，请取出相应数据。（注：若年龄为空请返回其他。）*/
SELECT device_id,gender,
CASE
    WHEN age>24 THEN "25岁及以上"
    WHEN 20<=age<=24 THEN "20-24岁"
    WHEN age<20 THEN "20岁以下"
    ELSE "其他"
END AS "age_cut"
FROM user_profile;

/*28.*/
/*難*/
drop table if  exists `question_practice_detail`;
CREATE TABLE `question_practice_detail` (
`id` int NOT NULL,
`device_id` int NOT NULL,
`question_id`int NOT NULL,
`result` varchar(32) NOT NULL,
`date` date NOT NULL
);
INSERT INTO question_practice_detail 
VALUES(1,2138,111,'wrong','2021-05-03'),
(2,3214,112,'wrong','2021-05-09'),
(3,3214,113,'wrong','2021-06-15'),
(4,6543,111,'right','2021-08-13'),
(5,2315,115,'right','2021-08-13'),
(6,2315,116,'right','2021-08-14'),
(7,2315,117,'wrong','2021-08-15'),
(8,3214,112,'wrong','2021-05-09'),
(9,3214,113,'wrong','2021-08-15'),
(10,6543,111,'right','2021-08-13'),
(11,2315,115,'right','2021-08-13'),
(12,2315,116,'right','2021-08-14'),
(13,2315,117,'wrong','2021-08-15'),
(14,3214,112,'wrong','2021-08-16'),
(15,3214,113,'wrong','2021-08-18'),
(16,6543,111,'right','2021-08-13');

/*题目：现在运营想要计算出2021年8月每天用户练习题目的数量，请取出相应数据*/
SELECT
    day (date) AS day,
    COUNT(question_id) AS question_cnt
FROM
    question_practice_detail
WHERE
    year (date) = 2021
    AND month (date) = 08
GROUP BY
    date;

/*29.题目：现在运营想要查看用户在某天刷题后第二天还会再来刷题的平均概率。请你取出相应数据*/
SELECT * FROM question_practice_detail;
/*步驟一*/
/*因為這邊SELECT後面是顯示device_id, date，所以這邊的DISTINCT會塞選，是當device_id, date都相同時，才不會顯示多的*/
	/*比如說ID=1學生，在8/12做了QID=1的題目兩次，那只會顯示"同天同一題"一次，若當天還有做QID=2一次，那原資料(3筆)DISTINCT後，會剩下兩筆*/
select distinct device_id, date
        from question_practice_detail;
/*步驟二*/
/*為了找出第二天是否有做題目，這邊要將同一張表做兩次(left join)，且兩表都要DISTINCT(因為只要看後面一天有沒有做題目，不管你做幾題)*/
/*第一張=qpd，第二張=uniq_id_date*/
/*等於是說，列出在同一個device_id下，所有"有做題目"的date排列組合*/
	/*舉例來說，id=1的學生，day1,2,3各做兩題，且同一天的題目相同，所以DISTINCT後，只剩下3筆*/
	/*使用LEFT JOIN後，會有11,12,13,21,22,23,31,32,33，共9種組合*/
select distinct qpd.device_id,
        qpd.date as date1,
        uniq_id_date.date as date2
    from question_practice_detail as qpd
left join(
        select distinct device_id, date
        from question_practice_detail
    ) as uniq_id_date
    on qpd.device_id=uniq_id_date.device_id;
/*步驟三*/
/*再來，為了找date2是否為date1的前一天，必須在on加上date_add(qpd.date, interval 1 day)=uniq_id_date.date*/
/*這樣表示在LEFT JOIN時，要同時符合device_id=device_id，還要符合"date1+1天"=date2*/
/*因為是LEFT JOIN，所以當date2不符合時，會給予NULL*/
select distinct qpd.device_id,
        qpd.date as date1,
        uniq_id_date.date as date2
    from question_practice_detail as qpd
left join(
        select distinct device_id, date
        from question_practice_detail
    ) as uniq_id_date
    on qpd.device_id=uniq_id_date.device_id
		and date_add(qpd.date, interval 1 day)=uniq_id_date.date;/*多加一個條件來符合"date1+1天"=date2*/
/*步驟四*/
/*當我有上述date1,date2的表時，就可以計算出有多少學生(device_id)，date1練習後，date2也有練習*/
SELECT COUNT(id_last_next_date.date2)/COUNT(id_last_next_date.date1) AS avg_ret
FROM(
	select distinct qpd.device_id,
			qpd.date as date1,
			uniq_id_date.date as date2
		from question_practice_detail as qpd
	left join(
			select distinct device_id, date
			from question_practice_detail
		) as uniq_id_date
		on qpd.device_id=uniq_id_date.device_id
			and date_add(qpd.date, interval 1 day)=uniq_id_date.date) AS id_last_next_date;

    
    
    
    
    



