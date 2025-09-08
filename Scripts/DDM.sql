
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


/**We are going to mask separate columns. Since the columns belong to an existing table, we will use the Alter Table statements.**/

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

EXECUTE AS USER = 'TESTUSER';
Select * from Membership;
REVERT
GO



--EXERCISE 2
-- schema to contain user tables
CREATE SCHEMA Data;
GO

-- table with masked columns
CREATE TABLE Data.Membership (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(100) MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)') NULL,
    LastName VARCHAR(100) NOT NULL,
    Phone VARCHAR(12) MASKED WITH (FUNCTION = 'default()') NULL,
    Email VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    DiscountCode SMALLINT MASKED WITH (FUNCTION = 'random(1, 100)') NULL
);

-- inserting sample data
INSERT INTO Data.Membership (FirstName, LastName, Phone, Email, DiscountCode)
VALUES
('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com', 10),
('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co', 5),
('Shakti', 'Menon', '555.123.4570', 'SMenon@contoso.net', 50),
('Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net', 40);
GO



CREATE USER MaskingTestUser WITHOUT LOGIN;

GRANT SELECT ON SCHEMA::Data TO MaskingTestUser;

-- impersonate for testing:
EXECUTE AS USER = 'MaskingTestUser';

SELECT * FROM Data.Membership;

REVERT;

--Add or editing a mask on an existing column
ALTER TABLE Data.Membership
ALTER COLUMN LastName ADD MASKED WITH (FUNCTION = 'partial(2,"xxxx",0)');

ALTER TABLE Data.Membership
ALTER COLUMN LastName VARCHAR(100) MASKED WITH (FUNCTION = 'default()');

--Grant permissions to view unmasked data
GRANT UNMASK TO MaskingTestUser;

EXECUTE AS USER = 'MaskingTestUser';

SELECT * FROM Data.Membership;

REVERT;

-- Removing the UNMASK permission
REVOKE UNMASK TO MaskingTestUser;


--Drop a dynamic data mask
ALTER TABLE Data.Membership
ALTER COLUMN LastName DROP MASKED;


--EXERCISE 3
--Granular permission examples
--1 Create schema to contain user tables:
CREATE SCHEMA Data2;
GO

-- 2 Create table with masked columns:
CREATE TABLE Data2.Membership2 (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    FirstName VARCHAR(100) MASKED WITH (FUNCTION = 'partial(1, "xxxxx", 1)') NULL,
    LastName VARCHAR(100) NOT NULL,
    Phone VARCHAR(12) MASKED WITH (FUNCTION = 'default()') NULL,
    Email VARCHAR(100) MASKED WITH (FUNCTION = 'email()') NOT NULL,
    DiscountCode SMALLINT MASKED WITH (FUNCTION = 'random(1, 100)') NULL,
    BirthDay DATETIME MASKED WITH (FUNCTION = 'default()') NULL
);


-- 3 Insert sample data:

INSERT INTO Data2.Membership2 (FirstName, LastName, Phone, Email, DiscountCode, BirthDay)
VALUES
('Roberto', 'Tamburello', '555.123.4567', 'RTamburello@contoso.com', 10, '1985-01-25 03:25:05'),
('Janice', 'Galvin', '555.123.4568', 'JGalvin@contoso.com.co', 5, '1990-05-14 11:30:00'),
('Shakti', 'Menon', '555.123.4570', 'SMenon@contoso.net', 50, '2004-02-29 14:20:10'),
('Zheng', 'Mu', '555.123.4569', 'ZMu@contoso.net', 40, '1990-03-01 06:00:00');



-- 4 Create schema to contain service tables:
CREATE SCHEMA Service;
GO

--5 Create service table with masked columns:
CREATE TABLE Service.Feedback (
    MemberID INT IDENTITY(1, 1) NOT NULL PRIMARY KEY CLUSTERED,
    Feedback VARCHAR(100) MASKED WITH (FUNCTION = 'default()') NULL,
    Rating INT MASKED WITH (FUNCTION = 'default()'),
    Received_On DATETIME
    );

--6 Insert sample data:
INSERT INTO Service.Feedback(Feedback, Rating, Received_On)
VALUES
('Good', 4, '2022-01-25 11:25:05'),
('Excellent', 5, '2021-12-22 08:10:07'),
('Average', 3, '2021-09-15 09:00:00');

--7 Create different users in the database:
CREATE USER ServiceAttendant WITHOUT LOGIN;
GO

CREATE USER ServiceLead WITHOUT LOGIN;
GO

CREATE USER ServiceManager WITHOUT LOGIN;
GO

CREATE USER ServiceHead WITHOUT LOGIN;
GO

--8 Grant read permissions to the users in the database:
ALTER ROLE db_datareader ADD MEMBER ServiceAttendant;

ALTER ROLE db_datareader ADD MEMBER ServiceLead;

ALTER ROLE db_datareader ADD MEMBER ServiceManager;

ALTER ROLE db_datareader ADD MEMBER ServiceHead;

--9 Grant different UNMASK permissions to users:
--Grant column level UNMASK permission to ServiceAttendant
GRANT UNMASK ON Data2.Membership2(FirstName) TO ServiceAttendant;

-- Grant table level UNMASK permission to ServiceLead
GRANT UNMASK ON Data2.Membership2 TO ServiceLead;

-- Grant schema level UNMASK permission to ServiceManager
GRANT UNMASK ON SCHEMA::Data2 TO ServiceManager;
GRANT UNMASK ON SCHEMA::Service TO ServiceManager;

--Grant database level UNMASK permission to ServiceHead;
GRANT UNMASK TO ServiceHead;

--10 Query the data under the context of user ServiceAttendant:
EXECUTE AS USER = 'ServiceAttendant';

SELECT MemberID, FirstName, LastName, Phone, Email, BirthDay
FROM Data2.Membership2;

SELECT MemberID, Feedback, Rating
FROM Service.Feedback;

REVERT;


-- 11  Query the data under the context of user ServiceLead:
EXECUTE AS USER = 'ServiceLead';

SELECT MemberID, FirstName, LastName, Phone, Email, BirthDay
FROM Data2.Membership2;

SELECT MemberID, Feedback, Rating
FROM Service.Feedback;

REVERT;

--12  Query the data under the context of user ServiceManager:
EXECUTE AS USER = 'ServiceManager';

SELECT MemberID, FirstName, LastName, Phone, Email, BirthDay
FROM Data2.Membership2;

SELECT MemberID, Feedback, Rating
FROM Service.Feedback;

REVERT;

--13 Query the data under the context of user ServiceHead

EXECUTE AS USER = 'ServiceHead';

SELECT MemberID, FirstName, LastName, Phone, Email, BirthDay
FROM Data2.Membership2;

SELECT MemberID, Feedback, Rating
FROM Service.Feedback;

REVERT;

--14 To revoke UNMASK permissions, use the following T-SQL statements:

REVOKE UNMASK ON Data.Membership(FirstName) FROM ServiceAttendant;

REVOKE UNMASK ON Data.Membership FROM ServiceLead;

REVOKE UNMASK ON SCHEMA::Data FROM ServiceManager;

REVOKE UNMASK ON SCHEMA::Service FROM ServiceManager;

REVOKE UNMASK FROM ServiceHead;
