--DATABASE TABLE PARTITIONING

-- PERFORMING TABLE PARTITION WITH A NEW TABLE

--CREATE THE DATABASE TO USE

Use Master
DROP DATABASE IF EXISTS PartitionDB

CREATE DATABASE PartitionDB 
/*ON PRIMARY

(NAME = N'PartitionDB_DataFile',
FILENAME = N'D:\MSSQL\DEFAULT\PartitionDB_Datafile.mdf')

LOG ON
(NAME = N'PartitionDB_LogFile',
FILENAME = N'L:\MSSQL\DEFAULT\PartitionDB_LogFile.ldf')*/

--FILEGROUPS ARE NEEDED. 
/*THE SCRIPT BELOW WILL ALTER (EXISTING) DATABASE AND ADD 12 FILEGROUPS REPRESENTING FILEGROUPS THAT WILL BE CONTAINING DATA FOR 
THE DIFFERENT MONTHS OF THE YEAR. NB: REMEMBER MICROSOFT RECOMMENDS AS BEST PRACTICE THAT FILEGROUPS BE CREATED WHEN PARTITIONING 
A TABLE.*/

Use PartitionDB;

ALTER DATABASE PartitionDB ADD FILEGROUP JANUARY25
ALTER DATABASE PartitionDB ADD FILEGROUP FEBRUARY25
ALTER DATABASE PartitionDB ADD FILEGROUP MARCH25 
ALTER DATABASE PartitionDB ADD FILEGROUP APRIL25
ALTER DATABASE PartitionDB ADD FILEGROUP MAY25
ALTER DATABASE PartitionDB ADD FILEGROUP JUNE25
ALTER DATABASE PartitionDB ADD FILEGROUP JULY25
ALTER DATABASE PartitionDB ADD FILEGROUP AUGUST25
ALTER DATABASE PartitionDB ADD FILEGROUP SEPTEMBER25
ALTER DATABASE PartitionDB ADD FILEGROUP OCTOBER25
ALTER DATABASE PartitionDB ADD FILEGROUP NOVEMBER25
ALTER DATABASE PartitionDB ADD FILEGROUP DECEMBER25
ALTER DATABASE PartitionDB ADD FILEGROUP JANUARY26
ALTER DATABASE PartitionDB ADD FILEGROUP FEBRUARY26
ALTER DATABASE PartitionDB ADD FILEGROUP MARCH26 
ALTER DATABASE PartitionDB ADD FILEGROUP APRIL26
ALTER DATABASE PartitionDB ADD FILEGROUP MAY26
ALTER DATABASE PartitionDB ADD FILEGROUP JUNE26
ALTER DATABASE PartitionDB ADD FILEGROUP JULY26
ALTER DATABASE PartitionDB ADD FILEGROUP AUGUST26
ALTER DATABASE PartitionDB ADD FILEGROUP SEPTEMBER26
ALTER DATABASE PartitionDB ADD FILEGROUP OCTOBER26
ALTER DATABASE PartitionDB ADD FILEGROUP NOVEMBER26
ALTER DATABASE PartitionDB ADD FILEGROUP DECEMBER26


-- USE THE SCRIPT BELOW TO SEE ALL FILEGROUPS IN A DATABASE BOTH PRIMARY AND SECONDARY FILEGROUPS
Use PartitionDB
SELECT name AS AvailableFilegroups
FROM sys.filegroups


--Or this to see the data_space_ID as well
SELECT name, data_space_id, is_default, is_read_only
FROM sys.filegroups;


--USE THE SCRIPT BELOW TO SEE ALL DATA FILES (Both .mdf and .ndf) IN A DATABASE, THE FILEGROUP IN WHICH 
--THEY ARE, THE FILESIZE AND THE FILEPATH OF THE DATA FILES

SELECT
dbfile.name AS DatabaseFileName,
dbfile.size/128 AS FileSizeInMB,
sysFG.name AS FileGroupName,
dbfile.physical_name AS DatabaseFilePath
FROM
sys.database_files AS dbfile
INNER JOIN
sys.filegroups AS sysFG 
ON
dbfile.data_space_id = sysFG.data_space_id


-- ADDING FILES INSIDE EXISTING FILEGROUPS
ALTER DATABASE [PartitionDB] ADD FILE 
    (NAME = [Jan25Data],
    FILENAME = N'D:\MSSQL\PROD\JanData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [January25]


	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [Feb25Data],
    FILENAME = 'D:\MSSQL\PROD\FebData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [February25]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [March25Data],
    FILENAME = 'D:\MSSQL\PROD\MarchData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [March25]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [April25Data],
    FILENAME = 'D:\MSSQL\PROD\AprilData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [April25]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [May25Data],
    FILENAME = 'D:\MSSQL\PROD\MayData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [May25]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [June25Data],
    FILENAME = 'D:\MSSQL\PROD\JuneData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [June25]
	
	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [July25Data],
    FILENAME = 'D:\MSSQL\PROD\JulyData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [July25]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [Aug25Data],
    FILENAME = 'D:\MSSQL\PROD\AugData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [August25]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [Sep25Data],
    FILENAME = 'D:\MSSQL\PROD\SepData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [September25]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [Oct25Data],
    FILENAME = 'D:\MSSQL\PROD\OctData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [October25]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [NovData25],
    FILENAME = 'D:\MSSQL\PROD\NovData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [November25]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [Dec25Data],
    FILENAME = 'D:\MSSQL\PROD\DecData.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [December25]

    ALTER DATABASE [PartitionDB] ADD FILE 
    (NAME = [Jan26Data],
    FILENAME = N'D:\MSSQL\PROD\Jan26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [January26]


	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [Feb26Data],
    FILENAME = 'D:\MSSQL\PROD\Feb26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [February26]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [March26Data],
    FILENAME = 'D:\MSSQL\PROD\March26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [March26]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [April26Data],
    FILENAME = 'D:\MSSQL\PROD\April26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [April26]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [May26Data],
    FILENAME = 'D:\MSSQL\PROD\May26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [May26]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [June26Data],
    FILENAME = 'D:\MSSQL\PROD\June26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [June26]
	
	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [July26Data],
    FILENAME = 'D:\MSSQL\PROD\July26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [July26]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [Aug26Data],
    FILENAME = 'D:\MSSQL\PROD\Aug26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [August26]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [Sep26Data],
    FILENAME = 'D:\MSSQL\PROD\Sep26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [September26]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [Oct26Data],
    FILENAME = 'D:\MSSQL\PROD\Oct26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [October26]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [NovData26],
    FILENAME = 'D:\MSSQL\PROD\Nov26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [November26]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [Dec26Data],
    FILENAME = 'D:\MSSQL\PROD\Dec26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [December26]

--USE THE SCRIPT AGAIN, this time, TO SEE ALL DATA FILES INCLUDING THE ONES THAT HAVE JUST BEEN ADDED (Both mdf and ndf) IN A DATABASE,
--THE FILEGROUP IN WHICH THEY ARE, THE FILESIZE AND THE FILEPATH OF THE DATA FILES

SELECT
dbfile.name AS DatabaseFileName,
dbfile.size/128 AS FileSizeInMB,
sysFG.name AS FileGroupName,
dbfile.physical_name AS DatabaseFilePath
FROM
sys.database_files AS dbfile
INNER JOIN
sys.filegroups AS sysFG 
ON
dbfile.data_space_id = sysFG.data_space_id

--Or this to see the filegroups have files and are online
SELECT 
    fg.name AS FilegroupName,
    df.name AS LogicalFileName,
    df.physical_name,
    df.state_desc
FROM sys.database_files df
JOIN sys.filegroups fg
    ON df.data_space_id = fg.data_space_id
ORDER BY fg.name;

--
--Or
SELECT 
    fg.name AS FilegroupName,
    f.name AS LogicalFileName,
    f.physical_name AS PhysicalFilePath,
    f.size * 8 / 1024 AS SizeMB,
    f.max_size,
    f.file_id
FROM sys.filegroups fg
JOIN sys.database_files f 
    ON fg.data_space_id = f.data_space_id
ORDER BY fg.name, f.file_id;

-- AFTER FILEGROUPS CREATION (if they are not existing) NEXT IS TO CREATE PARTITION FUNCTION. THE SCRIPTS BELOW WILL CREATE A
--PARTITION FUNCTION
-- NOTE--PARTITION FUNCTION is actually setting PARTITION BOUNDARIES or BOUNDARY CONDITIONS and 
--"number of partitions is always = Boundary conditions -1" 
	--(This means, total number of boundary conditions is always less than number of partitions by 1.)

--First Use the DMV-script below to see any existing partition functions in the DB 
--(You can have more than 1 Partition Functions in a DB but only one can be applied to a Partition Scheme Table.

Use PartitionDB
SELECT * FROM
sys.partition_functions


-- Now Create the Partition Function using Months
Use PartitionDB
CREATE PARTITION FUNCTION PF_MonthlyPartitionFunction (Datetime)
AS RANGE RIGHT FOR VALUES ('20250201', '20250301', '20250401', '20250501', '20250601', '20250701', '20250801', '20250901',
                            '20251001', '20251101', '20251201', '20260101','20260201', '20260301', '20260401', '20260501', '20260601', '20260701', '20260801', '20260901',
                            '20261001', '20261101', '20261201')


--Use script below to see partition function that you have just created.
Use PartitionDB
SELECT * FROM
sys.partition_functions
	
	----NOTE THAT FROM LINE 212 to LINE 215, it is just something for you to know. We will use it ahead. You can skip it.------
--if ever you have to input date format into a RDBMS like SQL Server and need to understand the date format by knowing 
--the current date and time, use the function below..
	Select Getdate()

--Current date with exact increments. The script belows returns the date and time exactly one month from the date and time now.
--You can change from YEARS, TO Months, to Days, To Minutes, to seconds, to milliseconds, etc.
	Select DATEADD(MONTH, 1, GETDATE())


--NEXT STEP IS TO CREATE THE PARTITION SCHEME  (The Partition Scheme is used to MAP the boundaries to the fileGroups.


Use PartitionDB
	
CREATE PARTITION SCHEME PS_MonthlyPartitionScheme
AS PARTITION PF_MonthlyPartitionFunction
TO (January25, February25, March25, April25, May25, June25, July25, August25, September25, October25, November25, December25, January26, February26, 
March26, April26, May26, June26, July26, August26, September26, October26, November26, December26);

--Use script below to see partition Scheme that you have just created.
Use PartitionDB
SELECT * FROM
sys.partition_schemes

-- SCRIPT TO SEE PARTITION SCHEME
--Now use the DMV-script below to see any existing partitions schemes and partitions functions in the DB.

-----Note that--- you can run lines 268 up to 275 at once
--Function
Use PartitionDB
SELECT * FROM
sys.partition_functions

--Scheme
Use PartitionDB
SELECT * FROM
sys.partition_schemes

-- NEXT STEP IS APPLYING THE PARTITION SCHEME TO A TABLE

USE PartitionDB

CREATE TABLE TraineeInfo (
TraineeID INT IDENTITY (1,1) NOT NULL,
FirstName VARCHAR (255),
LastName VARCHAR (255),
Occupation VARCHAR (255),
YearlyIncome FLOAT,
RegisteredDate DATETIME
)
ON PS_MonthlyPartitionScheme (RegisteredDate) --this column in the bracket is used to define the best candidate column to be used for the partition.

--now let's insert some records into the table created above.
INSERT INTO TraineeInfo VALUES ('Faith', 'Oboh', 'Secretary', 500000, GETDATE()),
							   ('Isaac', 'Niom', 'DBA', 700000, GETDATE()),
							   ('Celina', 'Tambe', 'HR', 600000, GETDATE()),
							   ('Linus', 'Okoro', 'Security', 380000, GETDATE()),
							   ('Divine', 'Waigi', 'SDBA', 1000000, GETDATE()),
							   ('Linda', 'Tamo', 'HR', 1000000, GETDATE()),
                                ('Claudine', 'Timo', 'Reporter', 4500000, DATEADD(Month, 1, GETDATE()))



/*--now let's insert some records into the table created for various months.
INSERT INTO TraineeInfo VALUES ('Faith', 'Oboh', 'Secretary', 500000, GETDATE()),
							   ('Isaac', 'Niom', 'DBA', 700000, GETDATE()),
							   ('Celina', 'Tambe', 'HR', 600000, DATEADD(Month, 1, GETDATE())),
							   ('Linus', 'Okoro', 'Security', 380000, DATEADD(Month, 2, GETDATE())),
							   ('Divine', 'Waigi', 'SDBA', 1000000, DATEADD(Month, 7, GETDATE())),
							   ('Linda', 'Tamo', 'HR', 1000000, DATEADD(Month, 10, GETDATE()))*/

SELECT * FROM TraineeInfo

--Exercise: You have received a ticket to add 2 more Trainees into the November and December Filegroups
INSERT INTO TraineeInfo VALUES ('John', 'Molinga', 'DBA', 650000, DATEADD(Month, -2, GETDATE())),
							   ('Pius', 'Young', 'Accountant', 670000, DATEADD(Month, -3, GETDATE()))



-- THE SCRIPT BELOW WILL SHOW THE FILEGROUPS (WHICH ARE THE PARTITIONS) AND THE ROWS INSERTED ACCORDINGLY INTO EACH PARTITION ACCORDING TO INSERTEDDATE WHICH HAS BEEN USED HERE AS THE CANDIDATE COLUMN FOR PARTITIONING.

SELECT 
p.partition_number AS PartitionNumber_FileGroups,
f.name AS partitionASfilegroups, 
p.rows AS NumberOfRows 
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'TraineeInfo'


-- NOW ADD ONE MORE ROW (record) INTO TRAINEEINFO TABLE SPECIFYING YOUR OWN DATE AND TIME AND THEN RUN THE SCRIPT ABOVE AGAIN TO SEE THE PARTITION INTO WHICH ITS GONNA GET INSERTED INTO

--insert record that is before first boundary
INSERT INTO TraineeInfo VALUES ('Jade', 'Asamoah', 'Chef', 4000000, '20241201 10:34:09PM')  --Jan25

--Another record before first boundary
INSERT INTO TraineeInfo VALUES ('Joy', 'Uguru', 'Security', 4000000, '20240101 10:34:09PM')  --Jan25

---insert another record on Jan 1st, 2026
INSERT INTO TraineeInfo VALUES ('Sangay', 'Paloma', 'Janitor', 1000000, '20260101 11:34:09PM')  --Jan26

---insert another record on December 30th, 2025
INSERT INTO TraineeInfo VALUES ('Sang', 'loma', 'Cook', 1500000, '20251201 11:34:09PM')

---insert another record on Dec 30th, 2026
INSERT INTO TraineeInfo VALUES ('Sangay', 'Paloma', 'Janitor', 1000000, '20261201 11:34:09PM')  --Dec26

--If All the filegroups of 2026 are full, and you need to insert data in 2027, then Add a new FileGroup and make it the next used
ALTER DATABASE PartitionDB ADD FILEGROUP JANUARY27

--Add the Data File to the FileGroup
ALTER DATABASE [PartitionDB] 
ADD FILE (NAME = [Jan27Data],
    FILENAME = N'D:\MSSQL\PROD\Jan27Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [January27]

-- NOW make sure to map the existing PS into the new filegroup by Altering the Partition Scheme
ALTER PARTITION SCHEME [PS_MonthlyPartitionScheme] NEXT USED January27

-- View Transaction Logs Movement
checkpoint
Select * from fn_dblog(null, null)

--SPLIT THE EMPTY PARTITION AT THE END
ALTER PARTITION FUNCTION PF_MonthlyPartitionFunction() SPLIT RANGE('20270101');
GO

---insert New record on Jan 1st, 2027
INSERT INTO TraineeInfo VALUES ('Rene', 'Yong', 'Instructor', 5000000, '20270101 11:34:09PM')  --Jan27
INSERT INTO TraineeInfo VALUES ('Zeb', 'Kiawih', 'Instructor', 5000000, '20270101 11:44:09PM')  --Jan27
INSERT INTO TraineeInfo VALUES ('Ernest', 'Timgum', 'Instructor', 5000000, '20270101 11:54:09PM')  --Jan27

-- TO PROVE THAT A TABLE WITH NO PARTITIONS IS A WHOLE  (which is = 1 partition) - RUN THE CREATE TABLE AND INSERT INTO SCRIPTS
--BELOW TO CREATE A TABLE AND INSERT VALUES. After doing that RUN THE SCRIPT BELOW TO SEE PARTITION AND ROWS INSERTED INTO.
   --NOTE THAT THIS TABLE IS NOT CREATED ON ANY PARTITION SCHEME

USE PartitionDB

CREATE TABLE NoPartitionTable (
TraineeID INT IDENTITY (1,1) NOT NULL,
FirstName VARCHAR (255),
LastName VARCHAR (255),
Occupation VARCHAR (255),
YearlyIncome FLOAT,
DateInserted DATETIME
)

INSERT INTO NoPartitionTable VALUES ('Sunny', 'Oboh', 'Secretary', 5000000, GETDATE()),
							   ('Caroline', 'Agbor', 'DBA', 7000000, GETDATE()),
							   ('Regina', 'Tambe', 'HRO', 6000000, DATEADD(Month, 1, GETDATE())),
							   ('Joy', 'Uguru', 'Security', 4000000, '20210101 09:34:09PM'),
							   ('Edes', 'Edes', 'Driver', 3000000, '20210201 10:34:09PM'),
							   ('Vernadelle', 'Ven', 'Chef', 2000000, '20210301 11:34:09PM');

SELECT * FROM NoPartitionTable

-- run this script below to see . NOTE THAT OBJECT NAME is changed to reflect the name of the table. 

SELECT partition_id AS ID,
       partition_number AS [PartitionNumber_FileGroups],
	   rows AS [Number of Rows in that Partition]
FROM sys.partitions AS part
WHERE OBJECT_NAME(OBJECT_ID) = 'NoPartitionTable'

--Versus


SELECT partition_id AS ID,
       partition_number AS [PartitionNumber_FileGroups],
	   rows AS [Number of Rows in that Partition]
FROM sys.partitions AS part
WHERE OBJECT_NAME(OBJECT_ID) = 'TraineeInfo'



--Example to archive only a filegroup from the table, by creating a different table and inserting the data into it.
--1) Create a staging table with the exact structure like the main table. The table needs to be created on the filegroup that you want to archive.
USE PartitionDB

CREATE TABLE Stage_TraineeInfo1 (
TraineeID INT IDENTITY (1,1) NOT NULL,
FirstName VARCHAR (255),
LastName VARCHAR (255),
Occupation VARCHAR (255),
YearlyIncome FLOAT,
RegisteredDate DATETIME
)
ON [DECEMBER25];

--2) Use the SWITCH---OUT Command
-- Example: Switch partition 12 (December) into archive. To know which partition to switch, run this script:

SELECT 
p.partition_number AS PartitionNumber_FileGroups,
f.name AS partitionASfilegroups, 
p.rows AS NumberOfRows 
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'TraineeInfo'

--Then choose the partition number and run this script.
ALTER TABLE TraineeInfo
SWITCH PARTITION 12 TO Stage_TraineeInfo;

--Or
SELECT *
INTO Stage_TraineeInfo1
FROM TraineeInfo
WHERE $PARTITION.PF_MonthlyPartitionFunction(RegisteredDate) = 11;


--Or remove the entire filegroup but the FG must be Empty: Delete the file and then the filegroup.
ALTER DATABASE PartitionDB REMOVE FILE Feb25Data;



--Example to archive the entire table, by creating a different table and inserting the data into it.
Use [PartitionDB] SELECT [TraineeID], [FirstName], [LastName], [Occupation], [YearlyIncome], [RegisteredDate]
INTO [TraineeInfo_New2] ON [January25]
FROM TraineeInfo


--ANOTHER EXAMPLE TO DEMONSTRATE TABLE PARTITIONING (2nd EXAMPLE)  - This time using a different column. ID Column AND USING THE LEFT RANGE

-- Create a new Partition Function - You can have more than 1 partition function in a DB  
	-- This time based on your environment, lets show how we can use partition to easily separate old data from new frequently accessed one.


-- ***REMEMBER YOU HAVE TO CREATE FILEGROUPS OR YOU CAN STILL USE EXISTING ONES FOR PURPOSE OF THIS DEMO. NOTE THAT YOU CAN CREATE FILES AND FILEGROUPS USING T-SQL SCRIPTS AS WELL AS SSMS GUI.

--Lets use the GUI ALTER THE TABLE AND CREATE fileGRoups
Use PartitionDB
ALTER DATABASE PartitionDB ADD FILEGROUP OrderIDPartitionone
ALTER DATABASE PartitionDB ADD FILEGROUP OrderIDPartitiontwo
ALTER DATABASE PartitionDB ADD FILEGROUP OrderIDPartitionthree
ALTER DATABASE PartitionDB ADD FILEGROUP OrderIDPartitionfour

-- Add the files in the FILEGROupS
ALTER DATABASE [PartitionDB] ADD FILE 
    (NAME = [OrderIDOneData],
    FILENAME = N'D:\MSSQL\DEFAULT\OrderIDOneData.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [OrderIDPartitionone]


	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [OrderIDtwoData],
    FILENAME = 'D:\MSSQL\DEFAULT\OrderIDtwoData.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [OrderIDPartitiontwo]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [OrderIDThreeData],
    FILENAME = 'D:\MSSQL\DEFAULT\OrderIDThreeData.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [OrderIDPartitionthree]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [OrderIDfourData],
    FILENAME = 'D:\MSSQL\DEFAULT\OrderIDfourData.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [OrderIDPartitionfour]

--Create the Partition Function
Use PartitionDB;

CREATE PARTITION FUNCTION PF_OrderSegments (INT)
AS RANGE LEFT FOR VALUES ('3', '7', '10')


--Create a Partition Scheme --(Note that you may need to create the filegroups if you specify different from existing)
Use PartitionDB
CREATE PARTITION SCHEME PS_OrderSegmentWise
AS PARTITION PF_OrderSegments
TO (OrderIDPartitionone, OrderIDPartitiontwo, OrderIDPartitionthree, OrderIDPartitionfour);

-- See available Partition Functions Now
Use PartitionDB
SELECT * FROM
sys.partition_functions


-- See avaialble Partition Schemes now
Use PartitionDB
SELECT * FROM
sys.partition_schemes


Use PartitionDB

CREATE TABLE Orders(
OrderID INT IDENTITY (1,1) NOT NULL,
ItemPurchased varchar (10) NOT NULL,
OrderDate datetime NOT NULL,
)
ON PS_OrderSegmentWise (OrderID);  -- Note that you can use one partition scheme on many tables.


INSERT INTO Orders VALUES
('Shoe', DATEADD(Month, 1, GETDATE())),
('Umbrella', DATEADD(Month, 2, GETDATE())),
('Bag', DATEADD(Month, 3, GETDATE())),
('Toothpaste', DATEADD(Month, 4, GETDATE())),
('Biscuit', DATEADD(Month, 5, GETDATE())),
('Calculator', DATEADD(Month, 6, GETDATE())),
('Telephone', DATEADD(Month, 7, GETDATE())),
('Television', DATEADD(Month, 8, GETDATE())),
('Toy', DATEADD(Month, 9, GETDATE())),
('Soap', DATEADD(Month, 10, GETDATE()));


SELECT * FROM Orders

-- TO SEE PARTITIONS AND WHERE ROWS THAT HAVE BEEN INSERTED
SELECT partition_id AS ID,
       partition_number AS [PartitionNumber_FileGroups],
	   rows AS [Number of Rows in that Partition]
FROM sys.partitions AS part
WHERE OBJECT_NAME(OBJECT_ID) = 'Orders'


--3RD EXAMPLE TO DEMONSTRATE TABLE PARTITIONING - 
	--EXAMPLE: this time segregating country that the company does not do business with again.

--NOTE THAT FileGroups with DATA Files inside needs to be created. There are scripts below to create it.
Use PartitionDB

ALTER DATABASE PartitionDB ADD FILEGROUP USA
ALTER DATABASE PartitionDB ADD FILEGROUP GERMANY
ALTER DATABASE PartitionDB ADD FILEGROUP HUNGARY 
ALTER DATABASE PartitionDB ADD FILEGROUP NIGERIA
ALTER DATABASE PartitionDB ADD FILEGROUP CAMEROON
ALTER DATABASE PartitionDB ADD FILEGROUP OTHER_COUNTRY_MORE_THAN_CMR_CODE


--Add Data files into the FileGroups
ALTER DATABASE [PartitionDB] ADD FILE 
    (NAME = [USAData],
    FILENAME = N'E:\MSSQL150\DATA\MSSQL\DEVDATA\USAData.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [USA]


	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [HUNGARYData],
    FILENAME = 'E:\MSSQL150\DATA\MSSQL\DEVDATA\HUNGARYData.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [HUNGARY]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [GERMANYData],
    FILENAME = 'E:\MSSQL150\DATA\MSSQL\DEVDATA\GERMANYData.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [GERMANY]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [NIGERIAData],
    FILENAME = 'E:\MSSQL150\DATA\MSSQL\DEVDATA\NIGERIAData.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [NIGERIA]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [CAMEROONData],
    FILENAME = 'E:\MSSQL150\DATA\MSSQL\DEVDATA\CAMEROONData.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [CAMEROON]

	ALTER DATABASE [PartitionDB]
    ADD FILE 
    (
    NAME = [OTHER_COUNTRY_MORE_THAN_CMR_CODEData],
    FILENAME = 'E:\MSSQL150\DATA\MSSQL\DEVDATA\OTHER_COUNTRY_MORE_THAN_CMR_CODEData.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [OTHER_COUNTRY_MORE_THAN_CMR_CODE]

--Create the Partition Function
Use PartitionDB
CREATE PARTITION FUNCTION PF_ByCountry (int)
AS RANGE LEFT FOR VALUES ('001', '049', '050', '234', '237')  --note MSSQL Server only supports RANGE PARITIONING. So  the candidate column calculated for the partition must be one that makes sense with range partitioning with the right data type

--Create a Partition Scheme
Use PartitionDB
CREATE PARTITION SCHEME PS_CountryWise
AS PARTITION PF_ByCountry 
TO ('USA', 'GERMANY', 'HUNGARY', 'NIGERIA', 'CAMEROON', 'OTHER_COUNTRY_MORE_THAN_CMR_CODE');

-- See available Partition Functions Now
Use PartitionDB
SELECT * FROM
sys.partition_functions

-- See avaialble Partition Schemes now
Use PartitionDB
SELECT * FROM
sys.partition_schemes


Use PartitionDB
CREATE TABLE Customer
(CustomerID INT IDENTITY (1000,1000) NOT NULL,
FirstName VARCHAR (255) NOT NULL,
LastName VARCHAR (255) NOT NULL,
CustomerCountry VARCHAR (255) NOT NULL,
CountryCode INT NOT NULL,
Gender VARCHAR (11) NOT NULL,
)
ON PS_CountryWise (CountryCode);

INSERT INTO Customer VALUES ('Sunny', 'Oboh', 'USA', 001, 'Male'),
							   ('Caroline', 'Agbor', 'GERMANY', 049, 'Female'),
							   ('Regina', 'Tambe', 'HUNGARY', 050, 'Male'),
							   ('Joy', 'Uguru', 'NIGERIA', 234, 'Female'),
							   ('Edes', 'Edes', 'CAMEROON', 237, 'Male'),
							   ('Victor', 'Collins', 'CAMEROON', 237, 'Male');
							     
		--check partitions and rows inserted         ----     then go ahead and insert records one after the other.
	SELECT partition_id AS ID,
       partition_number AS [PartitionNumber_FileGroups],
	   rows AS [Number of Rows in that Partition]
FROM sys.partitions AS part
WHERE OBJECT_NAME(OBJECT_ID) = 'Customer'

INSERT INTO Customer VALUES ('Saheed', 'Kumar', 'Afghanistan', 238, 'Male')

INSERT INTO Customer VALUES ('Saheed', 'Kumar', 'Cameroon', 237, 'Male')

INSERT INTO Customer VALUES ('Saheed', 'Kumar', 'Tchad', 239, 'Male')


SELECT * FROM Customer
WHERE FirstName = 'Victor'

	--check partitions and rows inserted
	SELECT partition_id AS ID,
       partition_number AS [PartitionNumber_FileGroups],
	   rows AS [Number of Rows in that Partition]
FROM sys.partitions AS part
WHERE OBJECT_NAME(OBJECT_ID) = 'Customer'


-- DEMO 2 -- PARTITIONING A TABLE THAT IS ALREADY EXISTING WITHOUT wanting to first create a new partitioned table and then copy the data from your existing table into the new table and do a table rename. 

--- LET'S START BY CREATING THE TABLE - Note that if the table does not have a Clustered index at the time you want to perform the partitioning , you will have to first create Clustered index as a prerequisite for existing tables.

Use PartitionDB
CREATE TABLE Customer9
(CustomerID INT IDENTITY (1,1) NOT NULL,
FirstName VARCHAR (255) NOT NULL,
LastName VARCHAR (255) NOT NULL,
CustomerCountry VARCHAR (255) NOT NULL,
CountryCode INT NOT NULL,
Gender VARCHAR (11) NOT NULL,
)

INSERT INTO Customer9 VALUES ('Sunny', 'Oboh', 'USA', 001, 'Male'),
							   ('Caroline', 'Agbor', 'GERMANY', 049, 'Female'),
							   ('Regina', 'Tambe', 'HUNGARY', 050, 'Male'),
							   ('Joy', 'Uguru', 'NIGERIA', 234, 'Female'),
							   ('Edes', 'Edes', 'CAMEROON', 237, 'Male'),
							   ('Victor', 'Collins', 'CAMEROON', 237, 'Transgender');


 --First lets view the table.
 Use PartitionDB
 Select * from Customer9

 --Now check the number of partitions on that table using the script below  -- should have everything in one partition
Use PartitionDB
SELECT o.name AS ObjectName,i.name AS IndexName, partition_id, partition_number, [rows]
FROM sys.partitions p
INNER JOIN sys.objects o ON o.object_id=p.object_id
INNER JOIN sys.indexes i ON i.object_id=p.object_id and p.index_id=i.index_id
WHERE o.name = 'Customer9'

-- Partition Number tells you there is one partition containing all the indexes and constraints. The reason why you are having all 6 rows on one partition. 


-- NOW you can go ahead and create Clustered indexes with T-SQL or GUI. (if the table did not have. But if the table had, you can drop if existing and recreate it when doing Table Partitioning with existing table. (And that becomes the existing table). For purpose of this Demo, we will just create the INDEX using GUI. Index Name should be "CIX_CustomerID_Customer9"  AFter creating the Index, run the same script up again and under index column, you will now see an index on the same 1 partion, same table and still 6 rows.


-- NExt we create a Partition Function to be used based on your choice of Candidate column. For this demo, we have use the BusinessEntityID
Use PartitionDB
	CREATE PARTITION FUNCTION PF_CustomerIDPartition (INT)
	AS RANGE RIGHT FOR VALUES ('2','4', '6')

	-- AFTER THIS YOU CAN CHOICE TO CREATE FILEGROUPS BEFORE YOu create the SCHEME AND THEN MAP THE PARTITIONS TO FILEGROUPS. DEPENDING ON YOUR NEEDS< YOu can still create partitions on one filegroup.

	--- Next is Create the Partition Scheme  -- In this demo, the partition is done on one filegroup (The Primary FileGroup) -  However, it is recommended to create FileGroups and do partitioning using the FileGroups. It makes management easier.

CREATE PARTITION SCHEME PS_CustomerID 
AS PARTITION PF_CustomerIDPartition ALL TO ([PRIMARY]) 
GO

-- NEXT: DROP AND RECREATE THE CLUSTERED INDEX. This is a very important part of our scenario. If you are working with a brand new table to partition, it is a highly recommended step. If you are partitioning an already existing table, it is a required step. In our example, since we are considering the same column as a CLUSTERED KEY column so if we just drop and re create it, it is fine. If we consider a different column to be a partitioned, then remember you have to drop the CLUSTERED INDEX and make it the new column as the CLUSTERED INDEX Column. You can restore the other index as a NON CLUSTERED INDEX. In our case since we have considered an already existing table, I will drop the Clustered index and re create it one more time. For doing that, I use the below query.

Use PartitionDB

CREATE UNIQUE CLUSTERED INDEX CIX_CustomerID_Customer9 ON Customer9 (CustomerID)  
    WITH (DROP_EXISTING = ON, ONLINE=ON)
ON PS_CustomerID  (CustomerID)
GO


	-- VIEW PARTITIONS AND RECORDS
	Use PartitionDB
SELECT o.name AS ObjectName,i.name AS IndexName, partition_id, partition_number, [rows]
FROM sys.partitions p
INNER JOIN sys.objects o ON o.object_id=p.object_id
INNER JOIN sys.indexes i ON i.object_id=p.object_id and p.index_id=i.index_id
WHERE o.name = 'TraineeInfo'

  


-- HOW YOU CAN COPY A TABLE INTO ANOTHER TABLE

Use [PartitionDB] SELECT [TraineeID], [FirstName], [LastName], [Occupation], [YearlyIncome], [RegisteredDate]
INTO [TraineeInfo_New] ON [December]
FROM TraineeInfo 

--Example 1 below  - Run the script below and See the table created with a different name with all Columns

Use [PartitionDB] SELECT *
INTO TraineeInfo ON [December]
FROM TraineeInfo 


--Example 2 below  - Run the script below and See the table created with selected columns
Use [PartitionDB] SELECT [TraineeID], [FirstName], [LastName], [Occupation], [YearlyIncome], [RegisteredDate]
INTO [TraineeInfo_New2] ON [January]
FROM TraineeInfo


--  view the table, filegroups, partitions and rows
SELECT OBJECT_NAME (p.object_id) AS obj_name, f.name, p.partition_number, p.rows
FROM sys.system_internals_allocation_units a
JOIN sys.partitions p
ON p.partition_id = a.container_id
JOIN sys.filegroups f ON a.filegroup_id = f.data_space_id
WHERE p.object_id = OBJECT_ID (N'dbo.TraineeInfo')
ORDER BY obj_name, p.index_id, p.partition_number;
GO



-- NOW LETS CREATE A TABLE TO SEGREGATE OLD DATA FROM NEW DATA AND PREPARE FOR NEW DATA THAT WILL COME BY PREPARING ITS PARTITITION FOR AN EXISTING TABLE

Use Master
Create Database PartitionDB

-- We start by Creating the FILES AND FILEGROUPS
--we just use the GUI to do this. Create FILEGROUPS three FileGroups FGUptoendof2018, FG2019, FG2020 and FG2021
--we just create the Data files called Up FGUptoendof2018Data, 2019Data, 2020Data, 2021Data

--NEXT -create Partition Function
Use PartitionDB
CREATE PARTITION FUNCTION PF_OrdersByYear (Date)
AS RANGE RIGHT FOR VALUES ('20190101','20200101', '20210101')

--NEXT - Create the Partition Scheme
Use PartitionDB
CREATE PARTITION SCHEME PS_YearWiseOrders
AS PARTITION PF_OrdersByYear ALL TO (FGUptoendof2018, FG2019, FG2020, FG2021) 
GO
--ERROR if you run the Script like above  -- Only a single filegroup can be specified while creating partition scheme using option ALL to specify all the filegroups.

--NOW - Create the Partition Scheme  -- remove ALL
Use PartitionDB
CREATE PARTITION SCHEME PS_YearWiseOrders 
AS PARTITION PF_OrdersByYear TO (FGUptoendof2018, FG2019, FG2020, FG2021) 
GO

--NEXT is to create the Table using the Partition Scheme

Use PartitionDB

CREATE TABLE Orders
(OrderID INT IDENTITY (1,1) NOT NULL,
ItemPurchased varchar (10) NOT NULL,
OrderDate date NOT NULL,
)
ON PS_YearWiseOrders (OrderDate);  -- Note that you can use one partition scheme on many tables.


INSERT INTO Orders VALUES
('Shoe', '20150101'),
('Umbrella', '20160101'),
('Bag', '20170101'),
('Toothpaste', '20181231'),
('Biscuit', '20190101'),
('Calculator', '20200101'),
('Telephone', '20200101'),
('Television', '20210101'),
('Toy', '20210201'),
('Soap', '20210301');


SELECT * FROM Orders

-- *** view the table, filegroups, partitions and rows
SELECT OBJECT_NAME (p.object_id) AS obj_name, f.name, p.partition_number, p.rows
FROM sys.system_internals_allocation_units a
JOIN sys.partitions p
ON p.partition_id = a.container_id
JOIN sys.filegroups f ON a.filegroup_id = f.data_space_id
WHERE p.object_id = OBJECT_ID (N'dbo.Orders')
ORDER BY obj_name, p.index_id, p.partition_number;
GO

--WHAT ABOUT NEW DATA FOR 2022? - WE Have to do SPLITTING

--Add a new FileGroup and make it the next used
ALTER DATABASE PartitionDB ADD FILEGROUP JANUARY26

--Add the Data File to the FileGroup
ALTER DATABASE [PartitionDB] 
ADD FILE (NAME = [Jan26Data],
    FILENAME = N'D:\MSSQL\PROD\Jan26Data.ndf',
        SIZE = 8192 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [January26]

-- NOW Alter Partition Scheme
ALTER PARTITION SCHEME [MonthlyPartitionScheme] NEXT USED January26

-- View Transaction Logs Movement
checkpoint
Select * from fn_dblog(null, null)

--SPLIT THE EMPTY PARTITION AT THE END
ALTER PARTITION FUNCTION MonthlyPartition() SPLIT RANGE('20230101');
GO

-- View Transaction Logs Movement
checkpoint
Select * from fn_dblog(null, null)

-- Now lets Insert 2022 records
INSERT INTO Orders VALUES ('Plate', '20220101')
INSERT INTO Orders VALUES ('Sugar', '20220201')
INSERT INTO Orders VALUES ('Chocolate', '20220401')

-- WHAT WILL HAPPEN IF WE HAVE DATA FOR THAT YEAR BEFORE SPLITTING? -- VERY BAD PRACTICE WHICH IS NOT RECOMMENDED AS IT LEADS TO PERFORMANCE DEGRADATION. But lets get to understand why.
-- BUT IF Faced with this situation, what do you do?
/*DONT SPLIT a partition if you are have in it
--Plan carefully and perform SPLIT BEFORE the new data comes to avoid Moving Data Around. This causes DeLETE from old Partition and Insert to New Partition and with Millions of records, you can imagine how this can instead adversely affect performance?
--Incase you missed to SPLIT before inserting new data then..
  . Switch the entire Partition out
  . Split Data into two table
  . SPLIT the partition function
  . Switch Data IN the two partitions*/

 
 --Lets insert Data for 2023 before we create the partition so we assume there is already 2023 Data in there before creating the partition for it.

 INSERT INTO Orders VALUES ('Fan', '20230101')
INSERT INTO Orders VALUES ('TV', '20230201')
INSERT INTO Orders VALUES ('Radio', '20230301')

--Add a new FileGroup and make it the next used
ALTER DATABASE PartitionDB ADD FILEGROUP FG2023

--Add the Data File to the FileGroup
ALTER DATABASE PartitionDB
ADD FILE (NAME = FG2023Data, FILENAME = N'E:\MSSQL150\DATA\MSSQL\DEVDATA\FG2023Data.ndf',
SIZE = 3MB, FILEGROWTH = 50%) TO FILEGROUP FG2023;
GO

-- NOW Alter Partition Scheme
ALTER PARTITION SCHEME PS_YearWiseOrders NEXT USED FG2023

-- View Transaction Logs Movement
checkpoint
Select * from fn_dblog(null, null)

--SPLITTING WITH EXISTING DATA IN IT  -- Once this is done, the Respective Data takes the right partitions. This is fine if you currently do not have much data.
ALTER PARTITION FUNCTION PF_OrdersByYear() SPLIT RANGE('20230101');
GO

-- NEXT*************

--LOADING and DELETING DATA
--SWITCH IN and OUT, MERGE

---**** WE WILL START WITH Loading IN***

--Loading Data for a year 2019 -- for example--- SWITCH IN
--Create a staging table on our new filegroup   -- required
-- Drop table Year2019Load

CREATE TABLE Year2019Load
(OrderID INT IDENTITY (1,1) NOT NULL,
ItemPurchased varchar (10) NOT NULL,
OrderDate date NOT NULL,
) ON [FG2019]
GO

-- Now lets Insert 2019 records
INSERT INTO Year2019Load VALUES ('Toyota', '20190111')
INSERT INTO Year2019Load VALUES ('Chevrolet', '20190609')
INSERT INTO Year2019Load VALUES ('Ford', '20190822')


-- *** view the table, filegroups, partitions and rows
SELECT OBJECT_NAME (p.object_id) AS obj_name, f.name, p.partition_number, p.rows
FROM sys.system_internals_allocation_units a
JOIN sys.partitions p
ON p.partition_id = a.container_id
JOIN sys.filegroups f ON a.filegroup_id = f.data_space_id
WHERE p.object_id = OBJECT_ID (N'dbo.Year2019Load')
ORDER BY obj_name, p.index_id, p.partition_number;
GO


--Create two check Contraints on the staging table
/*This will ensure data fits in with the allowed range for the partition we want to put it in. Constraints WITH CHECK are required for Switching IN. Create one Constraint for the "low end"*/

ALTER TABLE Year2019Load
WITH CHECK
ADD CONSTRAINT CKLoadDateLow
CHECK (OrderDate is not null and OrderDate >= '20190101')
GO
ALTER TABLE Year2019Load
WITH CHECK
ADD CONSTRAINT CKLoadDateHigh
CHECK (OrderDate is not null and OrderDate <'20200101')
GO


ALTER TABLE Year2019Load   -- you can use the script below to empty the partition first
SWITCH TO Orders Partition 2;

--Use the script below to TRUNCATE the partition first **( Amazing. This TRUNCATES ONLY A given Partition in a table.) Imagine million of records with respect to speed.
TRUNCATE TABLE Orders
WITH (PARTITIONS (2));
GO

--Verify the table   -- Notice that the data in the Staging table called Year2019Load is no more in that table. It has been SWITCH TO orders table Partition 2
SELECT * FROM Orders
SELECT * FROM Year2019Load   


--NOW Lets ARCHIVE DATA by SWITCHING OUT, MERGE PARTITIONS -- We will create Staging table again.


Use PartitionDB

CREATE TABLE Year2020Archive
(OrderID INT IDENTITY (1,1) NOT NULL,
ItemPurchased varchar (10) NOT NULL,
OrderDate date NOT NULL,
) ON [FG2020]
GO

ALTER TABLE Orders SWITCH PARTITION 2 TO Year2020Archive   -- this basically means that I am Deleting the data within a matter of seconds from the orders table to an archive table. Very far Delete which preserves the deleted data for archiving

SELECT * FROM Orders
SELECT * FROM Year2020Archive


-- Use this to check and see that the rows have been deleted and Sent to the new Table for archiving. Old data has been deleted and archived
SELECT OBJECT_NAME (p.object_id) AS obj_name, f.name, p.partition_number, p.rows
FROM sys.system_internals_allocation_units a
JOIN sys.partitions p
ON p.partition_id = a.container_id
JOIN sys.filegroups f ON a.filegroup_id = f.data_space_id
WHERE p.object_id = OBJECT_ID (N'Orders')
ORDER BY obj_name, p.index_id, p.partition_number;
GO

-- NEXT MERGE PARTITION  - its actually Dropping the Partition.

-- Merge Partition for Year 2015
-- The Dropped Partition is the one that includes the specified boundary AND the Partition that is empty  -- AGain please this is recommended to do when the partition is empty to avoid Data movement and adverse performance.

ALTER PARTITION FUNCTION PF_OrdersByYear() MERGE RANGE('FGUptoEndof2018');  -- this actually removes the Empty Partition
GO


--MANAGING PARTITIONS -- DOs and DONTs

--PLan Only Empty Partitions for Removal
--Always Check Partitions record first
--Use TRUNCATE Table with Partition option to empty Partition
-- A MERGE should typically be performed after a Purge/Archive of Data by using SWITCH


--CLEAN UP
ALTER PARTITION FUNCTION PF_OrdersByYear()
MERGE RANGE ('20230101');
GO

--SCRIPT TO SEE MORE DETAILS ABOUT PARTITIONED TABLE.
USE [PartitionDB]
GO
SELECT PartitionScheme AS [Partition Scheme Name],
       PartitionFunction AS [Partition Function Name],
          FileGroupName AS [File Group Name],
          rows AS [Record Count],
          CAST(SUM(CAST(sf.size AS BIGINT))/131072.0 AS DECIMAL(19,2)) AS [Size GB],
          PartitionFunctionValue AS [Partition Function Value]
FROM
(select distinct ps.Name AS PartitionScheme, pf.name AS PartitionFunction,fg.name AS FileGroupName,
 p.rows, prv.value AS PartitionFunctionValue,fg.data_space_id
    from sys.indexes i 
    join sys.partitions p ON i.object_id=p.object_id AND i.index_id=p.index_id 
    join sys.partition_schemes ps on ps.data_space_id = i.data_space_id 
    join sys.partition_functions pf on pf.function_id = ps.function_id 
    left join sys.partition_range_values prv on prv.function_id = pf.function_id AND prv.boundary_id = p.partition_number
    join sys.allocation_units au  ON au.container_id = p.hobt_id  
    join sys.filegroups fg  ON fg.data_space_id = au.data_space_id 
    where i.object_id = object_id('Orders')) a
join sys.sysfiles sf ON a.data_space_id=sf.groupid
GROUP BY PartitionScheme,PartitionFunction,FileGroupName,rows,PartitionFunctionValue


--WHAT IF U GET INTO AN ENVIRONMENT THAT ALREADY HAS A PARITIONED TABLE AND YOU HAVE TO UNDO THE PARTITION WITHOUT CREATING A NEW TABLE BEFORE MOVING THE DATA INTO AND THEN DELETING THE FORMER

--Lets Create a Test Database
USE master;
GO

CREATE DATABASE PartitionTest

-- Add four new filegroups to the PartitionTest database.
USe PartitionTest
ALTER DATABASE PartitionTest ADD FILEGROUP PartitionFG1;
GO
ALTER DATABASE PartitionTest ADD FILEGROUP PartitionFG2;
GO
ALTER DATABASE PartitionTest ADD FILEGROUP PartitionFG3;
GO
ALTER DATABASE PartitionTest ADD FILEGROUP PartitionFG4;
GO


-- Adds one file for each filegroup.
ALTER DATABASE PartitionTest
    ADD FILE
    (
        NAME = PartitionFile1,
        FILENAME = N'E:\MSSQL150\DATA\MSSQL\DEVDATA\PartitionFile1.ndf',
        SIZE = 25MB, MAXSIZE = 100MB, FILEGROWTH = 5MB
    )
    TO FILEGROUP PartitionFG1;
GO


ALTER DATABASE PartitionTest
    ADD FILE
    (
        NAME = PartitionFile2,
        FILENAME = N'E:\MSSQL150\DATA\MSSQL\DEVDATA\PartitionFile2.ndf',
        SIZE = 25MB, MAXSIZE = 100MB, FILEGROWTH = 5MB
    )
    TO FILEGROUP PartitionFG2;
GO


ALTER DATABASE PartitionTest
    ADD FILE
    (
        NAME = PartitionFile3,
        FILENAME = N'E:\MSSQL150\DATA\MSSQL\DEVDATA\PartitionFile3.ndf',
        SIZE = 25MB, MAXSIZE = 100MB, FILEGROWTH = 5MB
    )
    TO FILEGROUP PartitionFG3;
GO


ALTER DATABASE PartitionTest
    ADD FILE
    (
        NAME = PartitionFile4,
        FILENAME = N'E:\MSSQL150\DATA\MSSQL\DEVDATA\PartitionFile4.ndf',
        SIZE = 25MB, MAXSIZE = 100MB, FILEGROWTH = 5MB
    )
    TO FILEGROUP PartitionFG4;
GO
-- Creates a partition function called myRangePF1 that will partition a table into four partitions
CREATE PARTITION FUNCTION myRangePF1 (int)
    AS RANGE LEFT FOR VALUES (500, 1000, 1500);
GO

-- Creates a partition scheme called myRangePS1 that applies myRangePF1 to the four filegroups created above
CREATE PARTITION SCHEME myRangePS1
    AS PARTITION myRangePF1
    TO (PartitionFG1, PartitionFG2, PartitionFG3, PartitionFG4);
GO

--Create the partitioned tables on the partition scheme; one (PartitionTable1) with a clustered index and one (PartitionTable2) with a non-clustered index.

-- Creates a partitioned table called PartitionTable1 with a clustered index  -- NOTE that you can still create a table without Indexes.
CREATE TABLE PartitionTable1 (
StudentID int IDENTITY(1,1), 
EnrolmentDate datetime, 
StudentName char(8000))
ON myRangePS1 (StudentID);
GO
CREATE CLUSTERED INDEX [PK_CIX_StudentID] ON [dbo].[PartitionTable1]
    ([StudentID] ASC) ON [myRangePS1](StudentID);
GO


--Creates a partitioned table called PartitionTable2 with a nonclustered index

CREATE TABLE PartitionTable2 (
StudentID int IDENTITY(1,1), 
EnrolmentDate datetime, 
StudentName char(8000))
ON myRangePS1 (StudentID);
GO
CREATE NONCLUSTERED INDEX [NCIX_EnrolmentDate_StudentName] ON [dbo].[PartitionTable2]
    ([StudentID],[EnrolmentDate] ASC) ON [myRangePS1]([StudentID]);
GO



--Now add 2000 rows of dummy data to each table.  The random date generator code is courtesy of Latif Khan.
 
--Insert dummy data.

INSERT PartitionTable1 (EnrolmentDate, StudentName)
SELECT  CAST(CAST(GETDATE() AS INT) -2000 * RAND(CAST(CAST(NEWID() AS BINARY(8)) AS INT))AS DATETIME), REPLICATE('1',8000);
GO 2000

Select * From PartitionTable1


INSERT PartitionTable2 (EnrolmentDate, StudentName)
SELECT  CAST(CAST(GETDATE() AS INT) -2000 * RAND(CAST(CAST(NEWID() AS BINARY(8)) AS INT))AS DATETIME), REPLICATE('2',8000);
GO 2000

Select * From PartitionTable2


--Let s query the sys.partitions table and see what we have created.
 
-- Get partition information.  -- this returns it for the two tables.
SELECT
     SCHEMA_NAME(t.schema_id) AS SchemaName
    ,OBJECT_NAME(i.object_id) AS ObjectName
    ,p.partition_number AS PartitionNumber
    ,fg.name AS Filegroup_Name
    ,rows AS 'Rows'
    ,au.total_pages AS 'TotalDataPages'
    ,CASE boundary_value_on_right
        WHEN 1 THEN 'less than'
        ELSE 'less than or equal to'
     END AS 'Comparison'
    ,value AS 'ComparisonValue'
    ,p.data_compression_desc AS 'DataCompression'
    ,p.partition_id
FROM sys.partitions p
    JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
    JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
    JOIN sys.partition_functions f ON f.function_id = ps.function_id
    LEFT JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id
    JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id =ps.data_space_id AND dds.destination_id = p.partition_number
    JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id
    JOIN (SELECT container_id, sum(total_pages) as total_pages
            FROM sys.allocation_units
            GROUP BY container_id) AS au ON au.container_id = p.partition_id 
    JOIN sys.tables t ON p.object_id = t.object_id
WHERE i.index_id < 2
ORDER BY ObjectName,p.partition_number;
GO

--You can also use this script below to get separately for each table by changing the object name in red below.
Use PartitionTest
SELECT o.name AS ObjectName,i.name AS IndexName, partition_id, partition_number, [rows]
FROM sys.partitions p
INNER JOIN sys.objects o ON o.object_id=p.object_id
INNER JOIN sys.indexes i ON i.object_id=p.object_id and p.index_id=i.index_id
WHERE o.name = 'PartitionTable1'


-- YOu can also use SSMS GUI to see the number of Partitions and Parition Scheme used

--Solution for PartitionTable1   This table has a clustered index which makes our solution pretty easy.
--Since we have a partitioned clustered index, we can remove partitioning from this table by simply executing a single statement; CREATE INDEX using the DROP_EXISTING option and specifying a different filegroup.  This will drop the current partitioned index (which includes the data) and recreate it on the PRIMARY filegroup all within a single command.

--Quick and easy way to unpartition and move it.
CREATE CLUSTERED INDEX [PK_CIX_StudentID]
    ON [dbo].[PartitionTable1]([StudentID])
    WITH (DROP_EXISTING = ON)
    ON [PRIMARY];
GO

--Check again using the Script below and you will now see that ParitionTable 1 only has 1 partition now.  You can also see this in SSMS GUI
Use PartitionTest
SELECT o.name AS ObjectName,i.name AS IndexName, partition_id, partition_number, [rows]
FROM sys.partitions p
INNER JOIN sys.objects o ON o.object_id=p.object_id
INNER JOIN sys.indexes i ON i.object_id=p.object_id and p.index_id=i.index_id
WHERE o.name = 'PartitionTable1'


--Solution for PartitionTable2   We can t use the previous index trick on this table because it doesn t have a clustered index.  For this solution, we ll need to use a few ALTER commands such as MERGE RANGE, NEXT USED, SPLIT RANGE, and SWITCH.

--First we need to use the ALTER PARTITION FUNCTION MERGEcommand to combine all of the four partitions into a single partition.  The MERGE RANGE command removes the boundary point between the specified partitions.

ALTER PARTITION FUNCTION myRangePF1() MERGE RANGE (500);
GO
ALTER PARTITION FUNCTION myRangePF1() MERGE RANGE (1000);
GO
ALTER PARTITION FUNCTION myRangePF1() MERGE RANGE (1500);
GO

--Use script below to see changes  -- NOTE that to see initial boundaries that you had , you can use the GUI and also get it.
Use PartitionTest
SELECT o.name AS ObjectName,i.name AS IndexName, partition_id, partition_number, [rows]
FROM sys.partitions p
INNER JOIN sys.objects o ON o.object_id=p.object_id
INNER JOIN sys.indexes i ON i.object_id=p.object_id and p.index_id=i.index_id
WHERE o.name = 'PartitionTable2'

--Query the sys.partitions DMV again, and you will see that all 2000 rows have been combined, or merged, into a single partition and now reside on the PartitionFG4 filegroup.

--Next, we need to use ALTER PARTITION SCHEME NEXT USED to specify the PRIMARY filegroup as the next partition.

--Create next partition as PRIMARY.
ALTER PARTITION SCHEME myRangePS1 NEXT USED [PRIMARY];
GO

--Then we need to use ALTER PARTITION FUNCTION SPLIT RANGEusing a partition value that is larger than the maximum value of your partition column.  In our example, since we re doing a RANGE LEFT partition then specifying any value greater than or equal to 2000 will do the trick.  The SPLIT RANGEcommand will create a new boundary in the partitioned table.

-- Split the single partition into 2 separates ones to push all data to the PRIMARY FG.
ALTER PARTITION FUNCTION myRangePF1() SPLIT RANGE (2000);
GO

--Using the script below Query the sys.partitions DMV once again.  You can see that PartitionTable2 is still partitioned into two partitions, but all 2000 rows now reside in the PRIMARYfilegroup.

SELECT
     SCHEMA_NAME(t.schema_id) AS SchemaName
    ,OBJECT_NAME(i.object_id) AS ObjectName
    ,p.partition_number AS PartitionNumber
    ,fg.name AS Filegroup_Name
    ,rows AS 'Rows'
    ,au.total_pages AS 'TotalDataPages'
    ,CASE boundary_value_on_right
        WHEN 1 THEN 'less than'
        ELSE 'less than or equal to'
     END AS 'Comparison'
    ,value AS 'ComparisonValue'
    ,p.data_compression_desc AS 'DataCompression'
    ,p.partition_id
FROM sys.partitions p
    JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
    JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
    JOIN sys.partition_functions f ON f.function_id = ps.function_id
    LEFT JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id
    JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id =ps.data_space_id AND dds.destination_id = p.partition_number
    JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id
    JOIN (SELECT container_id, sum(total_pages) as total_pages
            FROM sys.allocation_units
            GROUP BY container_id) AS au ON au.container_id = p.partition_id 
    JOIN sys.tables t ON p.object_id = t.object_id
WHERE i.index_id < 2
ORDER BY ObjectName,p.partition_number;
GO

--Creating Stagging table
--At this point we re only half way done.  Now we need to create a non-partitioned table in the PRIMARY filegroup that matches the PartitionTable2 in every way, including any data types, constraints, etc.  This new table will only be used as a temporary holding location for the data. 

--How to know which constraints and datatype a table was having? You can script out the table. and it is always GOOD to SCRIPT OUT the table before you start dropping the indexes etc.


CREATE TABLE NonPartitionTable (
StudentID int IDENTITY(1,1), 
EnrolmentDate datetime, 
StudentName char(8000))
ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [NCIX_EnrolmentDate_StudentName] ON [dbo].[NonPartitionTable]
    ([StudentID],[EnrolmentDate] ASC) ON [PRIMARY];
GO

--Next we ll use the ALTER TABLE SWITCH command to move the 2000 rows of data into the NonPartitionTable.

--  Switch the partitioned data into the temporary table.  -- SWITCH PARTITION creates the new table.
ALTER TABLE PartitionTable2 SWITCH PARTITION 1 TO NonPartitionTable;
GO

--Query the sys.partitions DMV again to see there are now zero rows in the PartitionTable2.

--The SWITCH command is very efficient because it s just making a metadata change.  Under the covers, no data is actually being moved; it s just reassigning the partition_idof PartitionTable2 to the the NonPartitionTable object_id.  If you want to really see the undercover action, then you can run this script before and after the SWITCH command to see the 2000 rows of data never leave the same partition_ids. 

SELECT
     o.name
    ,o.object_id
    ,p.index_id
    ,p.partition_id
    ,p.partition_number
    ,p.rows
FROM sys.objects o
    JOIN sys.partitions p ON o.object_id = p.object_id
WHERE o.name IN ('NonPartitionTable')
ORDER BY o.name,p.partition_number;
GO

--Drop the partitioned table.
DROP TABLE PartitionTable2;
GO

-- Rename the temporary table to the original name.
EXEC sp_rename 'dbo.NonPartitionTable', 'PartitionTable2', 'OBJECT';
GO


--Partitioning has now been completely removed from both PartitionTable1 and PartitionTable2.  We can drop the remaining parts (partition schema, partition function,files, and filegroups) of partitioning to complete the clean up.

-- Remove the partition scheme, function, files, and filegroups.

DROP PARTITION SCHEME myRangePS1;  -- you drop partition scheme first before partition function
GO

DROP PARTITION FUNCTION myRangePF1;
GO

ALTER DATABASE PartitionTest REMOVE FILE PartitionFile1
ALTER DATABASE PartitionTest REMOVE FILE PartitionFile2
ALTER DATABASE PartitionTest REMOVE FILE PartitionFile3;
ALTER DATABASE PartitionTest REMOVE FILE PartitionFile4;
GO

ALTER DATABASE [PartitionTest] REMOVE FILEGROUP PartitionFG1;
ALTER DATABASE [PartitionTest] REMOVE FILEGROUP PartitionFG2;
ALTER DATABASE [PartitionTest] REMOVE FILEGROUP PartitionFG3;
ALTER DATABASE [PartitionTest] REMOVE FILEGROUP PartitionFG4;
GO

--What we are left with is a completely un-partitioned database, and all rows of data in each table completely intact.             '20261001', '20261101', '20261201')
