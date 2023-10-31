drop table if exists user_profile;
CREATE TABLE user_profile(
id int NOT NULL,
device_id int NOT NULL,
gender varchar(14) NOT NULL,
age int ,
university varchar(32) NOT NULL,
province varchar(32)  NOT NULL,
gpa float);
INSERT INTO user_profile VALUES(1,2138,'male',21,'北京大学','BeiJing',3.4),
(2,3214,'male',null,'复旦大学','Shanghai',4.0),
(3,6543,'female',20,'北京大学','BeiJing',3.2),
(4,2315,'female',23,'浙江大学','ZheJiang',3.6),
(5,5432,'male',25,'山东大学','Shandong',3.8);

/*1.题目：现在运营想要查看用户信息表中所有的数据，请你取出相应结果*/
SELECT * FROM user_profile;
/*2.题目：现在运营同学想要用户的设备id对应的性别、年龄和学校的数据，请你取出相应数据*/
SELECT device_id,gender,age,university FROM user_profile;
/*3.题目：现在运营需要查看用户来自于哪些学校，请从用户信息表中取出学校的去重数据*/
SELECT DISTINCT university FROM user_profile;
/*4.题目：现在运营只需要查看前2个用户明细设备ID数据，请你从用户信息表 user_profile 中取出相应结果*/
SELECT device_id FROM user_profile
WHERE id<3;
/*5.题目：现在你需要查看前2个用户明细设备ID数据，并将列名改为 'user_infos_example',，请你从用户信息表取出相应结果*/
SELECT device_id AS user_infos_example FROM user_profile
WHERE id<3;
/*6.题目：现在运营想要筛选出所有北京大学的学生进行用户调研，请你从用户信息表中取出满足条件的数据，结果返回设备id和学校*/
SELECT device_id,university FROM user_profile
WHERE university="北京大学";
/*7.题目：现在运营想要针对24岁以上的用户开展分析，请你取出满足条件的设备ID、性别、年龄、学校*/
SELECT device_id,gender,age,university FROM user_profile
WHERE age>24;
/*8.题目：现在运营想要针对20岁及以上且23岁及以下的用户开展分析，请你取出满足条件的设备ID、性别、年龄*/
SELECT device_id,gender,age FROM user_profile
WHERE age>=20 AND age<=23;
/*9.题目：现在运营想要查看除复旦大学以外的所有用户明细，请你取出相应数据*/
SELECT device_id,gender,age,university FROM user_profile
WHERE university!="复旦大学";
/*10.题目：现在运营想要对用户的年龄分布开展分析，在分析时想要剔除没有获取到年龄的用户，请你取出所有年龄值不为空的用户的设备ID，性别，年龄，学校的信息*/
SELECT device_id,gender,age,university FROM user_profile
WHERE age IS NOT NULL;
/*11.题目：现在运营想要找到男性且GPA在3.5以上(不包括3.5)的用户进行调研，请你取出相关数据*/
SELECT device_id,gender,age,university,gpa FROM user_profile
WHERE gpa>3.5 AND gender="male";
/*12.题目：现在运营想要找到学校为北大或GPA在3.7以上(不包括3.7)的用户进行调研，请你取出相关数据*/
SELECT device_id,gender,age,university,gpa FROM user_profile
WHERE gpa>3.7 OR university="北京大学";
/*13.题目：现在运营想要找到学校为北大、复旦和山大的同学进行调研，请你取出相关数据*/
SELECT device_id,gender,age,university,gpa FROM user_profile
WHERE university='北京大学' OR university='复旦大学' OR university='山东大学';
/*14.题目：现在运营想要找到gpa在3.5以上(不包括3.5)的山东大学用户 或 gpa在3.8以上(不包括3.8)的复旦大学同学进行用户调研，请你取出相应数据*/
SELECT device_id,gender,age,university,gpa FROM user_profile
WHERE (gpa>3.5 AND university='山东大学') OR (gpa>3.8 AND university='复旦大学');
/*15.题目：现在运营想查看所有大学中带有北京的用户的信息，请你取出相应数据*/
SELECT device_id,age,university FROM user_profile
WHERE university LIKE "%北京%";
/*16.题目：运营想要知道复旦大学学生gpa最高值是多少，请你取出相应数据*/
SELECT MAX(gpa) FROM user_profile
WHERE university="复旦大学";
/*17.题目：现在运营想要看一下男性用户有多少人以及他们的平均gpa是多少，用以辅助设计相关活动，请你取出相应数据*/
SELECT COUNT(id) AS male_num, AVG(gpa) AS avg_gpa FROM user_profile
WHERE gender="male";
/*AVG(gpa)用ROUND(AVG(gpa), 1)更好*/
SELECT COUNT(id) AS male_num, ROUND(AVG(gpa),1) AS avg_gpa FROM user_profile
WHERE gender="male";



