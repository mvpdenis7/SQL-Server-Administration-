-- create the source table
Create Database Demo

Use Demo
CREATE TABLE dbo.Switcharoo
( id INT);
GO
create schema archive

Use Demo
CREATE TABLE archive.Switcharoo
( id INT);
GO

;WITH
 L0 AS(SELECT 1 AS C UNION ALL SELECT 1 AS O), -- 2 rows
 L1 AS(SELECT 1 AS C FROM L0 AS A CROSS JOIN L0 AS B), -- 4 rows
 L2 AS(SELECT 1 AS C FROM L1 AS A CROSS JOIN L1 AS B), -- 16 rows
 L3 AS(SELECT 1 AS C FROM L2 AS A CROSS JOIN L2 AS B), -- 256 rows
 L4 AS(SELECT 1 AS C FROM L3 AS A CROSS JOIN L3 AS B), -- 65,536 rows
 L5 AS(SELECT 1 AS C FROM L4 AS A CROSS JOIN L4 AS B), -- 4,294,967,296 rows
 Nums AS(SELECT ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS N FROM L5)
 
 INSERT INTO dbo.Switcharoo (id) SELECT TOP 1000000 N FROM Nums ORDER BY N;



 select count(1) from dbo.Switcharoo
 select count (1) from archive.Switcharoo


   --Test Partition Switch to move all records from table A to B

 ALTER TABLE dbo.Switcharoo SWITCH TO archive.Switcharoo
