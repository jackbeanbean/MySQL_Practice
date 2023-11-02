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

/*题目：现在运营想要查看不同大学的用户平均发帖情况，并期望结果按照平均发帖情况进行升序排列，请你取出相应数据*/








