                                                                --SQL Server Security--
					 
	 --IMPLEMENTATION OF TDE---

/*Transparent Data Encryption (TDE) is a special case of encryption using a symmetric key. TDE encrypts entire database using a symmetric key called the database encryption key – DEK.
 
 TDE does real-time I/O encryption and decryption of data and log files.
 This encryption is known as encrypting data at rest. Introduced with SQL server 2008. 

TDE isn't available for system databases. It can't be used to encrypt master, model, or msdb. 

However, tempdb is automatically encrypted when a user database enabled TDE, but can't be encrypted directly.

TDE doesn't provide encryption across communication channels.*/


--Use master and create db
Use Master
Create Database EncryptDB

--Back up database
Backup Database EncryptDB 
To Disk = N'C:\Program Files\Microsoft SQL Server\MSSQL15.PROD\MSSQL\Backup\EncryptDB2_29Aug25.Bak'

--Create Master key
USE Master

CREATE MASTER KEY ENCRYPTION
BY PASSWORD='InsertStrongPasswordHere'

 
 --Create Certificate protected by master key
CREATE CERTIFICATE TDE_Cert
WITH 
SUBJECT='Database_Encryption'


--Create Database Encryption Key
USE EncryptDB

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE TDE_Cert

--Backup Certificate
Use Master 

BACKUP CERTIFICATE TDE_Cert
TO FILE = 'C:\Program Files\Microsoft SQL Server\MSSQL15.PROD\MSSQL\Backup\TDE_Cert.cer'
WITH PRIVATE KEY (file='C:\Program Files\Microsoft SQL Server\MSSQL15.PROD\MSSQL\Backup\BackupTDE_CertKey.pvk',
ENCRYPTION BY PASSWORD='InsertStrongPasswordHere') 

--Enable Encryption
ALTER DATABASE EncryptDB
SET ENCRYPTION ON

--Verify All DB: those with "is_encrypted" implies they are encrypted already
Select name, database_id, is_encrypted 
From sys.databases

Backup Database EncryptDB 
To Disk = N'C:\Program Files\Microsoft SQL Server\MSSQL15.PROD\MSSQL\Backup\EncryptDB3_29Aug25.Bak'

-- Restore ecrypted backup in another instance using the GIU
--Notice it won't restor, it will only be possible after restoring the certificate to that instance

--Restoring a certificate
USE Master
CREATE MASTER KEY ENCRYPTION
BY PASSWORD='InsertAnotherStrongPasswordHere';


-- Certificate name should change but the two file paths should match the source path and names
CREATE CERTIFICATE TDECert
FROM FILE = 'C:\Program Files\Microsoft SQL Server\MSSQL15.PROD\MSSQL\Backup\TDE_Cert.cer'
WITH PRIVATE KEY (FILE = 'C:\Program Files\Microsoft SQL Server\MSSQL15.PROD\MSSQL\Backup\BackupTDE_CertKey.pvk',
DECRYPTION BY PASSWORD = 'InsertStrongPasswordHere' ) --First password





  --UNDERSTANDING AND IMPLEMENTING ROW-LEVEL SECURITY--

--Create database called  Row-level security RLS
Use Master
Create database RLS

Use RLS

-- Create a Patient table
Create table Patient(
	PatientID int identity,
	NurseName Varchar(20),
	PatientName Varchar(20),
	RoomNumber Int
)

--Populate Patient Table
Insert Into Patient
Values('Nurse1', 'Suzane',1),
	  ('Nurse1', 'Jazy',2),
	  ('Nurse1', 'Papol',3),
	  ('Nurse2', 'Jamile',4),
	  ('Nurse2', 'Kamel',5),
	  ('Nurse2', 'Nathy',6)

Select * from Patient


--Create users Doctor and Nurse1 and 2

Create User Doctor Without Login
Create User Nurse1 Without Login
Create User Nurse2 Without Login


--Grant full access to Doctor and read only access to Nurse1 and 2

Grant Select, Insert, Update, Delete on Patient to Doctor
Grant Select on Patient to Nurse1
Grant Select on Patient to Nurse2


--Select all by the different users

Select * From Patient

EXECUTE AS USER = 'Doctor';
SELECT * FROM Patient
REVERT


EXECUTE AS USER = 'Nurse1';
SELECT * FROM Patient
REVERT

EXECUTE AS USER = 'Nurse2';
SELECT * FROM Patient;
REVERT


--Create the inline table-valued function
--Once the users are created the next step is to create the table-valued function. This function will check the user who has logged in and will return the result set based on the login context of the user only. Execute the script below to create the inline function.

CREATE FUNCTION dbo.fn_PatientSecurity(@NurseName AS sysname)
    RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS fn_PatientSecurity_Result
    -- Logic for filter predicate
    WHERE @NurseName = USER_NAME() 
    OR USER_NAME() = 'Doctor';
GO

--Apply the Security Policy
--Once both the above steps are done, the final step to implement Row-Level Security in SQL Server is to apply the specific security policy which will enforce the filter predicate and pass it to the underlying query just like a where clause filter.


CREATE SECURITY POLICY UserFilter
ADD FILTER PREDICATE dbo.fn_PatientSecurity(NurseName) 
ON dbo.Patient
WITH (STATE = ON);


--Test the RLS Implementation
Select * From Patient

EXECUTE AS USER = 'Doctor';
SELECT * FROM Patient
REVERT


EXECUTE AS USER = 'Nurse1';
SELECT * FROM Patient
REVERT

EXECUTE AS USER = 'Nurse2';
SELECT * FROM Patient;
REVERT




--UNDERSTANDING AND IMPLEMENTING DYNAMIC DATA MASKING--
--Video link below
https://www.youtube.com/watch?v=KRXrxANuHnc
/*Dynamic Data Masking helps to limit exposure of sensitive data to unprivileged users.

It can be easily implemented along with other security measures like auditing, encryption and row level security.

Dynamic Data Masking only masks the sensitive data. Users who do not have the appropriate access will be able to view only the masked data.

It does not change the original data in the database.

Lets learn how this can be implemented in SQL Server.

We are going to work with the Memberships sample data -*/

-- Creating a database
Use master

Create Database DDM

use DDM

-- Creating a table
CREATE TABLE Membership (
    MemberID        int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName        varchar(100) NULL,
    LastName        varchar(100) NOT NULL,
    Phone            varchar(12) NULL,
    Email            varchar(100) NOT NULL,
    DiscountCode    smallint NULL
	);

INSERT INTO Membership (FirstName, LastName, Phone, Email, DiscountCode)
VALUES   
	('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com', 10),  
	('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co', 5),  
	('Shakti', 'Menon', '555.123.4570', 'SMenon@contoso.net', 50),  
	('Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net', 40); 


/We are going to mask separate columns. Since the columns belong to an existing table, we will use the Alter Table statements./

Select * from Membership;

--To mask a particular column, use ADD MASKED WITH (FUNCTION = '#option#');

Alter Table Membership
Alter Column FirstName ADD MASKED WITH (FUNCTION = 'default()');

Alter Table Membership
Alter Column DiscountCode ADD MASKED WITH (FUNCTION = 'default()');

--To change the mask type of an already masked column , use the below syntax

Alter Table Membership
Alter Column DiscountCode smallint MASKED WITH (FUNCTION = 'random(20,30)');

--To remove a mask on a column, execute the query as below -

/*Alter Table Membership
Alter Column DiscountCode DROP MASKED;*/
Select * from Membership;


Alter Table Membership
Alter Column MemberID ADD MASKED WITH (FUNCTION = 'default()');

Alter Table Membership
Alter Column Phone ADD MASKED WITH (FUNCTION = 'partial(2,"X.XXX.XX",1)');


Alter Table Membership
Alter Column Email ADD MASKED WITH (FUNCTION = 'email()');


--Create a Test User with only Select Access on the schema -
Create User TESTUSER WITHOUT LOGIN;

-- Granting Select priviledge to the user above
use [DDM]
GO
GRANT SELECT ON SCHEMA::[dbo] TO [TESTUSER]
GO


--Selecting as user TESTUSER from the table;
EXECUTE AS USER = 'TESTUSER';
Select * from Membership;



/*Grant Unmask access to this user to enable him to view all original data */
GRANT UNMASK to TESTUSER;
