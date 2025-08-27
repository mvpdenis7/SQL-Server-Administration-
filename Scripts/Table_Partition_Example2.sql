--Step 1: Create File Group

ALTER DATABASE PartitioningDB
ADD FILEGROUP January
GO
ALTER DATABASE PartitioningDB
ADD FILEGROUP February
GO
ALTER DATABASE PartitioningDB
ADD FILEGROUP March
GO
ALTER DATABASE PartitioningDB
ADD FILEGROUP April
GO
ALTER DATABASE PartitioningDB
ADD FILEGROUP May
GO
ALTER DATABASE PartitioningDB
ADD FILEGROUP June
GO
ALTER DATABASE PartitioningDB
ADD FILEGROUP July
GO
ALTER DATABASE PartitioningDB
ADD FILEGROUP Avgust
GO
ALTER DATABASE PartitioningDB
ADD FILEGROUP September
GO
ALTER DATABASE PartitioningDB
ADD FILEGROUP October
GO
ALTER DATABASE PartitioningDB
ADD FILEGROUP November
GO
ALTER DATABASE PartitioningDB
ADD FILEGROUP December
GO

SELECT name AS AvailableFilegroups
FROM sys.filegroups
WHERE type = 'FG'

--Step 2 Create Files and place them on Filegroups
ALTER DATABASE [PartitioningDB]
    ADD FILE 
    (
    NAME = [PartDec],
    FILENAME = 'D:\MSSQL\PROD\PartitioningDB12.ndf',
        SIZE = 3072 KB, 
        MAXSIZE = UNLIMITED, 
        FILEGROWTH = 1024 KB
    ) TO FILEGROUP [December]

Check the files created
SELECT 
name as [FileName],
physical_name as [FilePath] 
FROM sys.database_files
where type_desc = 'ROWS'
GO

--Step 3 Create Partition Function Boundary Conditions)
CREATE PARTITION FUNCTION [PartitioningByMonth] (datetime)
AS RANGE RIGHT FOR VALUES ('20140201', '20140301', '20140401',
               '20140501', '20140601', '20140701', '20140801', 
               '20140901', '20141001', '20141101', '20141201');

--Step 4 Create Partition Scheme (Applies Boundary conditions to Files)

CREATE PARTITION SCHEME PartitionBymonth
AS PARTITION PartitioningBymonth
TO (January, February, March, 
    April, May, June, July, 
    Avgust, September, October, 
    November, December);

 --Step 5 Partition table using the scheme
 CREATE TABLE Reports
(ReportDate datetime PRIMARY KEY,
MonthlyReport varchar(max))
ON PartitionBymonth (ReportDate);
GO

 --Test data insert
INSERT INTO Reports (ReportDate,MonthlyReport)
SELECT '20140108', 'ReportJanuary' 




UNION ALL
SELECT '20140209', 'ReportFebryary' UNION ALL
SELECT '20140309', 'ReportMarch' UNION ALL
SELECT '20140409', 'ReportApril' UNION ALL
SELECT '20140509', 'ReportMay' UNION ALL
SELECT '20140611', 'ReportJune' UNION ALL
SELECT '20140710', 'ReportJuly' UNION ALL
SELECT '20140809', 'ReportAugust' UNION ALL
SELECT '20140911', 'ReportSeptember' UNION ALL
SELECT '20141012', 'ReportOctober' UNION ALL
SELECT '20141109', 'ReportNovember' UNION ALL
SELECT '20141209', 'ReportDecember' UNION ALL
SELECT '20140409', 'ReportApril'

Select * from [dbo].[Reports]

Check Data in various partition
SELECT 
p.partition_number AS PartitionNumber,
f.name AS PartitionFilegroup, 
p.rows AS NumberOfRows 
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'Reports'


--Further Test
