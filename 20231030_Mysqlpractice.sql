/*https://allaboutdataanalysis.medium.com/%E9%9B%B6%E5%9F%BA%E7%A4%8E-sql-%E8%B3%87%E6%96%99%E5%BA%AB%E5%B0%8F%E7%99%BD-%E5%BE%9E%E5%85%A5%E9%96%80%E5%88%B0%E7%B2%BE%E9%80%9A%E7%9A%84%E5%AD%B8%E7%BF%92%E8%B7%AF%E7%B7%9A%E8%88%87%E6%9B%B8%E5%96%AE-d9918e64389f*/

/*創建table*/
Create Table Students(
    StudentId Varchar(10),
    Name Nvarchar(200),
    Gender Nvarchar(1),
    Height Numeric(4,1),
    Mustache Varchar(3),
    SkinColor Nvarchar(1)
);
CREATE TABLE Relationships(
	RelationshipsId Int,
    BoyId Varchar(10),
    GirlId Varchar(10),
    BeginDate datetime,
    CurrentActive Varchar(10),
    EndDate datetime
);

/*新增資料*/
INSERT INTO Students(
    StudentId,
    Name,
    Gender,
    Height,
    Mustache,
    SkinColor
)
    Values
    ('001','陳冠奇','男',186,'No','白'),
    ('002','謝堂風','男',182,'No','白'),
    ('003','黄博','男',176,'Yes','黑'),
    ('004','李少杰','男',172,'Yes','黑'),
    ('005','徐少斌','男',163,'No','黑'),
    ('006','張白芷','女',172,'No','白'),
    ('007','張少函','女',163,'No','白'),
    ('008','靈昆','女',181,'No','黑'),
    ('009','夏平','女',158,'No','白'),
    ('010','莫文麗','女',156,'No','白');
    
INSERT INTO Relationships(
    RelationshipId,
    BoyId,
    GirlId,
    BeginDate,
    CurrentActive,
    EndDate
)
    Values
    (1001,'001','006','2002-04-01','Y',null),
    (1002,'003','009','2001-04-01','Y',null),
    (1003,'005','010','2003-04-01','N','2004-04-01'),
    (1004,'002','010','2004-04-01','N','2004-05-01'),
    (1005,'004','010','2004-05-01','N','2005-08-01');

/*查詢身高大於180cm的男同學*/
SELECT * FROM students
WHERE Gender="男" AND Height>180;

/*查詢身高大於170cm的膚白女同學*/
SELECT * FROM students
WHERE Gender="女" AND Height>170 AND SkinColor="白";

/*偏難*/
/*查詢最高的女同學*/
SELECT MAX(Height) FROM students WHERE Gender="女";
/*這邊只會找到Height最高的資料，且只顯示MAX(Height)*/
/*所以必須在外面再包一層select * from ，才會顯示最高女生所有的欄位*/
SELECT * FROM students
WHERE Height=(SELECT MAX(Height) FROM students WHERE Gender="女"); 

/*查詢有戀愛關係的同學*/
SELECT Boy.Name AS BoyName,
 Girl.Name AS GirlName
FROM Relationships as Rel
 INNER JOIN Students as Boy on Rel.BoyId = Boy.StudentId
 INNER JOIN Students as Girl on Rel.GirlId = Girl.StudentId;
 /*INNER JOIN Students as Boy on Rel.BoyId = Boy.StudentId：有點像是先將relationships表的BoyId=Students表的StudentId的資料提去到Boy的資料表存取紀錄*/
 /*上面的SELECT在將Boy資料表的Name顯示出來*/

/*另一種寫法(不用join)*/
/*內框的SELECT：想要顯示students表的Name，其條件是當StudentId=relationships.BoyId(因為有外框的SELECT FROM relationship，才可以這樣寫)*/
/*外框的SELECT：在上述條件下，去搜尋relationships*/
SELECT(SELECT Name FROM students WHERE StudentId=relationships.BoyId) AS BoyName,
(SELECT Name FROM students WHERE StudentId=relationships.GirlId) AS GirlName
FROM relationships;

/*最帥的陳冠奇居然留鬍子了，讓我們記錄下*/
UPDATE students
SET Mustache="Yes"
WHERE Name="陳冠奇";
SELECT * FROM students;

/*帥奇留鬍子的原因居然是，陳冠奇和張白芷前兩天分手了，我們要記錄這段關係的破裂*/
UPDATE relationships
SET CurrentActive="N" , EndDate="2008-04-01 00:00:00"
WHERE BoyId=(SELECT StudentId FROM students WHERE Name="陳冠奇") AND GirlId=(SELECT StudentId FROM students WHERE Name="張白芷");
SELECT * FROM relationships;

/*任何的痛苦都離不開戀人的離去，張白芷居然去國外留學了，因此花名冊少了這個人*/
DELETE FROM students
WHERE Name="張白芷";
SELECT * FROM students;

/*帥帥的陳冠奇，怎麼甘心就此沉淪，他又找了莫文麗做女朋友*/
INSERT INTO relationships
VALUES (1006,'001','010','2008-04-04 00:00:00','N',NULL);
SELECT * FROM relationships;

/*好奇的小樂，查了查莫文麗的後臺，發現她居然曾有過三次戀愛關係*/
SELECT count(RelationshipId) as Relationship_Count
FROM relationships
WHERE GirlId=(SELECT StudentId FROM Students WHERE Name = "莫文麗");












