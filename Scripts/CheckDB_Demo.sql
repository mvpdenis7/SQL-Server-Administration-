CREATE DATABASE CorruptionDrillDB;
GO
ALTER DATABASE CorruptionDrillDB SET PAGE_VERIFY CHECKSUM;
GO

USE CorruptionDrillDB;
CREATE TABLE dbo.Orders(
  OrderID int IDENTITY PRIMARY KEY,
  OrderDate datetime2 NOT NULL DEFAULT sysdatetime(),
  Amount money NOT NULL
);

INSERT INTO dbo.Orders (Amount)
SELECT TOP (100000) ABS(CHECKSUM(NEWID())) % 10000 / 1.0
FROM sys.all_objects a CROSS JOIN sys.all_objects b;
GO

-- Backup with CHECKSUM to catch latent page issues during backup
BACKUP DATABASE CorruptionDrillDB
TO DISK = 'B:\MSSQL\PROD\CorruptionDrillDB_full.bak'
WITH INIT, CHECKSUM, COPY_ONLY, STATS=5;

DBCC CHECKDB (N'CorruptionDrillDB') WITH NO_INFOMSGS, ALL_ERRORMSGS;

RESTORE VERIFYONLY FROM DISK='B:\MSSQL\PROD\CorruptionDrillDB_full.bak' WITH CHECKSUM;

-- Restore to a scratch DB and run CHECKDB there
RESTORE DATABASE CorruptionDrillDB_verify
FROM DISK='B:\MSSQL\PROD\CorruptionDrillDB_full.bak'
WITH REPLACE, RECOVERY,
     MOVE 'CorruptionDrillDB'     TO 'D:\MSSQL\PROD\CorruptionDrillDB_verify.mdf',
     MOVE 'CorruptionDrillDB_log' TO 'L:\MSSQL\PROD\CorruptionDrillDB_verify_log.ldf';
GO
DBCC CHECKDB (N'CorruptionDrillDB_verify') WITH NO_INFOMSGS, ALL_ERRORMSGS;
GO
DROP DATABASE CorruptionDrillDB_verify;


-- Ensure all DBs use page checksums
SELECT name, page_verify_option_desc FROM sys.databases;

-- Watch for recorded bad pages
SELECT DB_NAME(database_id) AS db_name, file_id, page_id, event_type, error_count, last_update_date
FROM msdb.dbo.suspect_pages
ORDER BY last_update_date DESC;
