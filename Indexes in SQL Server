--- Full Demo Script for Indexes in SQL Server


-- Step 1: Create a demo database
CREATE DATABASE IndexDemoDB;
GO

-- Step 2: Use the new database
USE IndexDemoDB;
GO

-- Step 3: Create a sample table
CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Department NVARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2)
);
GO

-- Step 4: Insert sample data
INSERT INTO dbo.Employees (FirstName, LastName, Department, HireDate, Salary)
VALUES 
('Joyce', 'Takang', 'IT', '2018-01-12', 85000),
('Bertin', 'Tchoufambi', 'HR', '2020-06-01', 65000),
('Amaka', 'Obi', 'Finance', '2019-03-15', 72000),
('James', 'Bond', 'Security', '2017-10-01', 95000),
('Maria', 'Lopez', 'Marketing', '2022-02-25', 56000),
('Aliyu', 'Bello', 'IT', '2023-01-10', 71000);
GO

-- Step 5: Create a clustered index on HireDate ---First drop the primary key
CREATE CLUSTERED INDEX CIX_Employees_HireDate
ON dbo.Employees (HireDate ASC);
GO

-- Step 6: Create a non-clustered index on LastName
CREATE NONCLUSTERED INDEX IX_Employees_LastName
ON dbo.Employees (LastName);
GO

-- Step 7: Create a non-clustered index with INCLUDE columns
CREATE NONCLUSTERED INDEX IX_Employees_Department
ON dbo.Employees (Department)
INCLUDE (FirstName, LastName);
GO

-- Step 8: Create an index with a specific FILLFACTOR
CREATE NONCLUSTERED INDEX IX_Employees_Salary
ON dbo.Employees (Salary)
WITH (FILLFACTOR = 80);
GO

-- Step 9: Disable an index
ALTER INDEX IX_Employees_LastName ON dbo.Employees DISABLE;
GO

-- Step 10: Rebuild the disabled index (also re-enables it)
ALTER INDEX IX_Employees_LastName ON dbo.Employees REBUILD WITH (FILLFACTOR = 90);
GO

-- Step 11: Drop an index
DROP INDEX IX_Employees_Salary ON dbo.Employees;
GO

-- Step 12: View index metadata
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_disabled,
    i.fill_factor,
    i.allow_page_locks,
    i.allow_row_locks
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('dbo.Employees');
GO

-- Demonstrating Index Rebuild and Index Reorganized
USE MASTER
GO

-- create database 
CREATE DATABASE Indexdemo

--create a table in IndexRBRO
USE Indexdemo
GO
CREATE TABLE classindex(
	ID INT IDENTITY,
	BATCH CHAR(8000) DEFAULT 'B17-1 DBA 2025 BEST')
go

--insert data into indextable1
INSERT INTO classindex DEFAULT VALUES
GO 2000

-- select all values from the table indextable
SELECT * FROM [dbo].[classindex]

--create a second table 
CREATE TABLE classindex2(
	ID INT IDENTITY (100,5),
	BATCH CHAR(8000) DEFAULT 'B17-2 DBA 2025 BEST')
go

--create a clustered index on the second table

select * from [dbo].[classindex]
select ID from  [dbo].[classindex]
where ID =1000

CREATE CLUSTERED INDEX IX_ID ON classindex (ID)
GO

-- check the fragmentation of the second table
SELECT 
[avg_fragmentation_in_percent]
FROM sys.dm_db_index_physical_stats(
DB_ID (N'Indexdemo'), OBJECT_ID (N'classindex'), 1, NULL, 'LIMITED')
GO

--insert data into the 2nd table
INSERT INTO [dbo].[classindex2] DEFAULT VALUES
GO 1500

-- select all values from the 2nd table 
SELECT * FROM [dbo].[classindex2]

-- check the size of the databese
SP_HELPDB [Indexdemo]

-- check the fragmentation of the second table
SELECT 
[avg_fragmentation_in_percent]
FROM sys.dm_db_index_physical_stats(
DB_ID (N'Indexdemo'), OBJECT_ID (N'classindex'), 1, NULL, 'LIMITED')
GO

--let's drop the first table 'indextable1' and exesute a shrink command to reclaim the space it occupied
DROP TABLE [dbo].[indextable1]
GO

-- check the size of the databese
SP_HELPDB [Indexdemo]

--Shrink the database
DBCC SHRINKDATABASE ([Indexdemo])

-- check the size of the databese
SP_HELPDB [Indexdemo]

-- check the fragmentation of the second table
SELECT 
[avg_fragmentation_in_percent]
FROM sys.dm_db_index_physical_stats(
DB_ID (N'Indexdemo'), OBJECT_ID (N'classindex'), 1, NULL, 'LIMITED')
GO


-- Task to perform based on fragmentation level
--> 0-5% nothing should be done
--> 5%-30% Reorganize
--> >30% Rebuild


-- Rebuild statements
ALTER INDEX [IX_ID] ON classindex REBUILD

-- Reorganized statements
ALTER INDEX [IX_ID] ON classindex REORGANIZE

-- check the fragmentation of the second table
SELECT 
[avg_fragmentation_in_percent]
FROM sys.dm_db_index_physical_stats(
DB_ID (N'Indexdemo'), OBJECT_ID (N'classindex'), 1, NULL, 'LIMITED')
GO


-- script to know fragmentation level of all tables in a database (don't modify)
SELECT DB_NAME(ips.database_id) AS DatabaseName,
	   SCHEMA_NAME(ob.[schema_id]) SchemaNames,
       ob.[name] AS ObjectName,
       ix.[name] AS IndexName,
       ob.type_desc AS ObjectType,
       ix.type_desc AS IndexType,
       -- ips.partition_number AS PartitionNumber,
       ips.page_count AS [PageCount], -- Only Available in DETAILED Mode
	   ips.record_count AS [RecordCount],
       ips.avg_fragmentation_in_percent AS AvgFragmentationInPercent
-- FROM sys.dm_db_index_physical_stats (NULL, NULL, NULL, NULL, 'DETAILED') ips
FROM sys.dm_db_index_physical_stats (NULL, NULL, NULL, NULL, 'SAMPLED') ips -- QuickResult
INNER JOIN sys.indexes ix ON ips.[object_id] = ix.[object_id] 
				AND ips.index_id = ix.index_id
INNER JOIN sys.objects ob ON ix.[object_id] = ob.[object_id]
WHERE ob.[type] IN('U','V')
AND ob.is_ms_shipped = 0
AND ix.[type] IN(1,2,3,4)
AND ix.is_disabled = 0
AND ix.is_hypothetical = 0
AND ips.alloc_unit_type_desc = 'IN_ROW_DATA'
AND ips.index_level = 0
-- AND ips.page_count >= 1000 -- Filter to check only table with over 1000 pages
-- AND ips.record_count >= 100 -- Filter to check only table with over 1000 rows
-- AND ips.database_id = DB_ID() -- Filter to check only current database
-- AND ips.avg_fragmentation_in_percent > 50 -- Filter to check over 50% indexes
ORDER BY DatabaseName
