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
To Disk = N'N:\MSSQL\TDE\EncryptDB_04Sept25.Bak'

--Create Master key
USE Master

CREATE MASTER KEY ENCRYPTION
BY PASSWORD='Password1'

 
 --Create Certificate protected by master key
CREATE CERTIFICATE TDE_Cert_Server1
WITH 
SUBJECT='Database_Encryption'


--Create Database Encryption Key
USE EncryptDB

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE TDE_Cert_Server1

--Backup Certificate
Use Master 
BACKUP CERTIFICATE TDE_Cert_Server1
TO FILE = '\\DC\DBADocs\Files\TDE_Certs\TDE_Cert_Server1.cer'
WITH PRIVATE KEY (file='\\DC\DBADocs\Files\TDE_Certs\TDE_Cert_Server1.pvk',
ENCRYPTION BY PASSWORD='Password1') 

--Enable Encryption
ALTER DATABASE EncryptDB
SET ENCRYPTION ON

--Verify All DB: those with "is_encrypted" implies they are encrypted already
Select name, database_id, is_encrypted 
From sys.databases

Backup Database EncryptDB 
To Disk = N'N:\MSSQL\TDE\EncryptDB_with_EncryptionON_.04Sept25.Bak'

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
