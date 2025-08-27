--Learning Database Snapshot
USE master;
GO

CREATE DATABASE Group1_Snapshot_20250821
ON 
(
    NAME = Group1,  -- logical name of the data file
  FILENAME = 'D:\Snapshot\Group1_Snapshot_20250821.ss' -- sparse file
)
AS SNAPSHOT OF Group1;   -- source database
GO


--Insert Test Data into info Table
use Group1
insert into [dbo].[info]
values (1,'Denis', 'Kiawi')

insert into [dbo].[info]
values (2,'Eric', 'Kenui')

use Group1
select * from [dbo].[info]


--Create Database Snapshot with multiple  secondary files
CREATE DATABASE SalesDB_Snapshot_08262025
ON 
(
    NAME = SalesDB,
    FILENAME = 'D:\Snapshot\SalesDB_Snapshot_2025.ss'
),
(
    NAME = SalesDB_Orders,
    FILENAME = 'D:\Snapshot\SalesDB_Orders_Snapshot_2025.ss'
),
(
    NAME = SalesDB_Customers,
    FILENAME = 'D:\Snapshot\SalesDB_Customers_Snapshot_2025.ss'
)
AS SNAPSHOT OF SalesDB;


--Restore DB using the snapshot
use master
ALTER DATABASE Group1
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

RESTORE DATABASE Group1
    FROM DATABASE_SNAPSHOT = 'Group1_Snapshot_20250821';

ALTER DATABASE Group1 SET MULTI_USER;
