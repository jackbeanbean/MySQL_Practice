/*新增欄位*/
ALTER TABLE user_profile
ADD active_days_within_30 INT,
ADD question_cnt INT,
ADD answer_cnt INT;
/*新增資料*/
INSERT INTO user_profile
(active_days_within_30,question_cnt,answer_cnt)
VALUES (7,2,12),(15,5,25),(12,3,30),(5,1,2),(20,15,70),(15,7,13),(9,6,52);

SELECT * FROM user_profile;