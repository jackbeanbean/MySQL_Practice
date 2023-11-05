-- 30.
drop table if exists user_submit;
CREATE TABLE `user_submit` (
`id` int NOT NULL,
`device_id` int NOT NULL,
`profile` varchar(100) NOT NULL,
`blog_url` varchar(100) NOT NULL
);
INSERT INTO user_submit 
VALUES(1,2138,'180cm,75kg,27,male','http:/url/bisdgboy777'),
(1,3214,'165cm,45kg,26,female','http:/url/dkittycc'),
(1,6543,'178cm,65kg,25,male','http:/url/tigaer'),
(1,4321,'171cm,55kg,23,female','http:/url/uhsksd'),
(1,2131,'168cm,45kg,22,female','http:/url/sysdney');
-- 题目：现在运营举办了一场比赛，收到了一些参赛申请，表数据记录形式如下所示，现在运营想要统计每个性别的用户分别有多少参赛者，请取出相应结果
-- 步驟一
-- 嘗試先將female和mlae區分開來(用like)
SELECT * FROM user_submit
WHERE profile LIKE "%,female";
SELECT * FROM user_submit
WHERE profile LIKE "%,male";
-- 步驟二
-- 上述步驟一只是單一顯示，無法列成male和female各有多少，所以這邊要使用case來區分
-- 可以區分male,female後，再用COUNT()去計算出現次數
SELECT 
CASE 
    WHEN profile LIKE "%,female" THEN "female"
    WHEN profile LIKE "%,male" THEN "male"
    END AS gender,COUNT(device_id) AS number
FROM user_submit
GROUP BY gender;

-- 不用case，用if
SELECT 
	IF(profile LIKE "%,female","female","male") AS gender,
	COUNT(device_id) AS number
FROM user_submit
GROUP BY gender;

-- *新方法，使用SUBSTRING_INDEX()
-- SUBSTRING_INDEX()是從字串的固定模式，找尋想要的小段，SUBSTRING_INDEX(str:字串,delim:分隔符號,count:計數)
-- ex:str=www.ppp.tt,w
-- *中間的分隔符號不一定要是符號，也可以是依照字母做區隔
-- SUBSTRING_INDEX(str,".",1)=www , SUBSTRING_INDEX(str,".",2)=www.ppp , SUBSTRING_INDEX(str,".",-2)=ppp.tt,w
-- 若要取中間，就是先取完右邊再取左邊，SUBSTRING_INDEX(SUBSTRING_INDEX(str,".",2),".",-1)
SELECT SUBSTRING_INDEX(profile,",",-1) AS gender,COUNT(device_id) AS number
FROM user_submit
GROUP BY gender;
