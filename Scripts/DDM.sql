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
