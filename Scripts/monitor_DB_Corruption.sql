-- 1) Look for red flags (errors & suspect pages)

-- Recent I/O & corruption-like errors (823/824/825) in the error log
EXEC xp_readerrorlog 0, 1, N'Error: 825';  -- returns 823/824/825 lines

-- Central place SQL Server records bad pages
SELECT DB_NAME(database_id) AS db_name, file_id, page_id, event_type, error_count, last_update_date
FROM msdb.dbo.suspect_pages
ORDER BY last_update_date DESC;

--2) Run DBCC CHECKDB (gold standard)
DBCC CHECKDB (N'AdventureWorks2022') WITH NO_INFOMSGS, ALL_ERRORMSGS;

DBCC CHECKDB (N'AdventureWorks2022') WITH PHYSICAL_ONLY, NO_INFOMSGS;

--All databases (cursor—safe & explicit):
DECLARE @db sysname, @sql nvarchar(4000);
DECLARE c CURSOR LOCAL FAST_FORWARD FOR
  SELECT name FROM sys.databases WHERE state = 0; -- online only
OPEN c; FETCH NEXT FROM c INTO @db;
WHILE @@FETCH_STATUS = 0
BEGIN
  SET @sql = N'DBCC CHECKDB ('+QUOTENAME(@db)+N') WITH NO_INFOMSGS, ALL_ERRORMSGS;';
  PRINT 'Running CHECKDB on ' + @db;
  EXEC (@sql);
  FETCH NEXT FROM c INTO @db;
END
CLOSE c; DEALLOCATE c;

--If CHECKDB reports errors, don’t run repair yet. First confirm you have a clean backup chain.

--3) Verify backups can catch surface issues early

-- Create checksummed backups (detects bad pages during backup)
BACKUP DATABASE YourDatabase TO DISK='X:\Backups\YourDatabase_full.bak' WITH CHECKSUM, COPY_ONLY;

-- Quick validation of a backup file
RESTORE VERIFYONLY FROM DISK='X:\Backups\YourDatabase_full.bak' WITH CHECKSUM;

--4) Make corruption easier to detect next time
-- Ensure all DBs use page checksums (not torn page)
SELECT name, page_verify_option_desc
FROM sys.databases;

-- Enable checksums where needed
ALTER DATABASE YourDatabase SET PAGE_VERIFY CHECKSUM WITH NO_WAIT;

--5) If you use Always On AGs
--Check automatic page-repair history:
SELECT
  DB_NAME(database_id) AS db_name, file_id, page_id, modification_time,
  error_type_desc =
    CASE error_type
      WHEN 1 THEN '823 (I/O)'
      WHEN 2 THEN '824 (Logical)'
      WHEN 3 THEN '829 (Checksum/Torn)'
      ELSE CONCAT('Type ', error_type)
    END,
  page_status_desc =
    CASE page_status
      WHEN 1 THEN 'Queued'
      WHEN 2 THEN 'Request sent'
      WHEN 3 THEN 'Repaired'
      WHEN 4 THEN 'Failed'
      ELSE CONCAT('Status ', page_status)
    END
FROM sys.dm_hadr_auto_page_repair
ORDER BY modification_time DESC;
