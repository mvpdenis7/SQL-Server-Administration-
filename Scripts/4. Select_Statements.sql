                                      /**************** SELECT STATEMENTS****************/
/*-The SELECT statement is used to SELECT data from a database.
  -The data returned is stored in a result table, called the result-set.*/

-- See Version of SQL Server, Edition, OS its running on and Patch level
SELECT @@version

-- Returns the server/instance name
SELECT @@SERVERNAME

-- Lets Create a Database
-- DROPS THE DATABASE IF ALREADY EXISTING
Use Master
DROP DATABASE IF EXISTS SelectStatementDB


--CREATES A DATABASE
Use Master
CREATE DATABASE SelectStatementDB

--CREATES A TABLE ACCOUNTHOLDER


Use SELECTStatementDB
CREATE TABLE AccountHolder
(
ClientID INT NOT NULL PRIMARY KEY,
FirstName VARCHAR (50),
LastName VARCHAR (50),
Gender CHAR (1),
Country VARCHAR (50),
AccountNumber INT,
AccountBalance INT,
);


--INSERTS 5 RECORDS IN THE TABLE
USE SelectStatementDB
INSERT INTO AccountHolder VALUES  (101, 'John', 'Magufuli', 'M', 'TANZANIA', 987654321, 100000),
						   (102, 'Nelson', 'Mandela', 'M', 'SOUTH AFRICA', 123456789,  500),
						   (103, 'Kwame', 'Nkrumah', 'M', 'GHANA', 563214789, 300000),
						   (104, 'Winnie', 'Madikizela', 'F', 'SOUTH AFRICA', 824613709, 400000),
						   (105, 'Nnamdi', 'Azikiwe', 'M', 'NIGERIA', 204856793, 500000),
						   (106, 'Nelson', 'Mandela', 'M', 'SOUTH AFRICA', 123456789,  200000),
						   (107, 'Nelson', 'Mandela', 'M', 'SOUTH AFRICA', 123456789,  200000),
						   (108, 'Abraham', 'Lincoln', 'M', 'USA', 568977710,  700000),
						   (109, 'Abraham', 'Lima', 'M', 'YUGOSLAVIA', 665482000, 9700000),


-- Add another table
Use SelectStatementDB
CREATE TABLE Employee
(
EmployeeID INT NOT NULL PRIMARY KEY,
EmpFirstName VARCHAR (50),
EmpLastName VARCHAR (50),
EmpGender CHAR (1),
EmpCountry VARCHAR (50),
EmpPhoneNo INT,
);

--Insert Same record 500 hundred times
INSERT INTO Employee VALUES  (888, 'Victor', 'Osi', 'M', 'BURUNDI', 302186522); 
GO 5000
						   
--COUNT THE RECORDS ON A TABLE IN SQL SERVER
SELECT COUNT(*) FROM Employee

--SEE ALL RECORDS FROM A DATABASE
SELECT * from [dbo].[AccountHolder]
SELECT * from Employee

--SELECT a specific field or fields (Columns)
SELECT FirstName from [dbo].[AccountHolder]
SELECT FirstName, AccountBalance from [dbo].[AccountHolder]



/*SELECT distinct: The SELECT DISTINCT statement is used to return only distinct (different) values
-a column or some columns or even some entire records often contain many duplicate values; and sometimes you only want to list the different (distinct) values*/
SELECT distinct FirstName, LastName, Country from [dbo].[AccountHolder]


/*-The WHERE clause is used to filter records.
  -It is used to extract only those records that fulfill a specified condition*/
  
 SELECT ClientID, Firstname, LastName FROM [dbo].[AccountHolder] WHERE Country = 'SOUTH AFRICA'
 
 --The WHERE clause with the between operator
 SELECT ClientID from [dbo].[AccountHolder] where ClientID between 103 and 106

   /*-The WHERE clause with the between operator
     -The AND operator displays a record if all the conditions separated by AND are TRUE*/
 
  SELECT ClientID from [dbo].[AccountHolder]
  where ClientID Between 103 and 105;

   --The OR operator displays a record if any of the conditions separated by OR is TRUE.
  
SELECT * FROM AccountHolder
WHERE Country = 'SOUTH AFRICA' OR Country = 'TANZANIA';

  --The NOT operator displays a record if the condition(s) is NOT TRUE.
 
  SELECT ClientID, FirstName, Gender
  from [dbo].[AccountHolder]
  where NOT country = 'AFGHANISTAN'

  --The ORDER BY keyword is used to sort the result-set in ascending or descending order.
  --by default it orders in asc order
  SELECT * from [dbo].[AccountHolder]
  Order by FirstName DESC

  SELECT * from [dbo].[AccountHolder]
  Order by FirstName ASC



/**The SQL LIKE Operator
The LIKE operator is used in a WHERE clause to search for a specified pattern in a column.

A wildcard character is used to substitute one or more characters in a string.

Wildcard characters are used with the LIKE operator.
There are two wildcards often used in conjunction with the LIKE operator:

 The percent sign (%) represents zero, one, or multiple characters
 The underscore sign (_) represents one single character.*/

 /*
WHERE FirstName LIKE 'a%'	Finds any values that start with "a"
WHERE FirstName LIKE '%a'	Finds any values that end with "a"
WHERE FirstName LIKE '%or%'	Finds any values that has "or" in any position
WHERE FirstName LIKE '_r%'	Finds any values that has "r" in the second position
WHERE FirstName LIKE 'a_%'	Finds any values that start with "a" and are at least 2 characters in length
WHERE FirstName LIKE 'a__%'	Finds any values that start with "a" and are at least 3 characters in length
WHERE FirstName LIKE 'a%o'	Finds any values that start with "a" and ends with "o"*/

-- example
SELECT * FROM Customer WHERE FirstName LIKE 'p%'; --Firstname starting with "p":
SELECT * FROM Customer WHERE FirstName LIKE '%a';  --Firstname ending with "a":
SELECT * FROM Customer WHERE Lastname LIKE '%or%'; --Lastname that have "or" in any position
SELECT * FROM Customer WHERE City LIKE '_e%'; --City that have "r" in the second position
SELECT * FROM Customer WHERE City LIKE '[a-c]%'; --City starting with "a", "b", or "c"
SELECT * FROM Customer WHERE City LIKE '[bsp]%'; --City starting with "b", "s", or "p":
SELECT * FROM Customer WHERE City NOT LIKE '[bsp]%'; --City not starting with "b", "s", or "p":
Select * from Product WHERE Producttype LIKE '[a-c]%'; --Products starting with "a", "b", or "c"

SELECT * FROM [dbo].[AccountHolder] WHERE FirstName LIKE 'a%';

SELECT * FROM [dbo].[AccountHolder] WHERE LastName LIKE '%gu%';

SELECT * FROM [dbo].[AccountHolder] WHERE LastName LIKE 'n%h';

SELECT * FROM [dbo].[AccountHolder] WHERE LastName LIKE 'l____%';



-----SQL Operators

--top percentage
SELECT TOP 3 * FROM Customer;
SELECT TOP 50 PERCENT * FROM Customer;
SELECT TOP 3 * FROM Customer WHERE City = 'Douala';  

/*The SQL AND, OR and NOT Operators
The WHERE clause can be combined with AND, OR, and NOT operators.
The AND and OR operators are used to filter records based on more than one condition:
The AND operator displays a record if all the conditions separated by AND are TRUE.
The OR operator displays a record if any of the conditions separated by OR is TRUE.
The NOT operator displays a record if the condition(s) is NOT TRUE.*/
SELECT * FROM Customer WHERE City ='Douala' AND Street ='Bonaberi';
SELECT * FROM Customer WHERE City='Douala' or City ='Bamenda';
select * from Product where Quantity = 1 -- which Quantity of products are going out of stock
Select * from Product WHERE Price < '100'; --Products starting with "a", "b", or "c"
Select * from Product


/*The SQL MIN() and MAX() Functions
The MIN() function returns the smallest value of the selected column.
The MAX() function returns the largest value of the selected column.*/

SELECT MIN(Quantity) AS SmallestQuantity FROM Product;
SELECT MAX(Quantity) AS LargestQuantity FROM Product;
-- SELECT Min  
SELECT MIN(AccountBalance)  FROM [dbo].[AccountHolder]
-- SELECT Max  
SELECT MAX(AccountBalance)  FROM [dbo].[AccountHolder]
select * from Product 
 --The MIN() or MAX() function returns the smallest or largest value of the Selected column respectively.


/*The SQL COUNT(), AVG() and SUM() Functions
The COUNT() function returns the number of rows that matches a specified criterion.
The AVG() function returns the average value of a numeric column. 
The SUM() function returns the total sum of a numeric column.*/

SELECT COUNT(ProductID) FROM Product;   --null values are not counted
SELECT AVG(Quantity) FROM Product;		--null values are ignored
SELECT AVG(Price) FROM Product;		--null values are ignored
SELECT SUM(Quantity) FROM Product;  --null values are ignored
SELECT SUM(Price) FROM Product;  --null values are ignored




/*SQL Aliases
SQL aliases are used to give a table, or a column in a table, a temporary name.
Aliases are often used to make column names more readable in join statements.
An alias only exists for the duration of that query.
An alias is created with the AS keyword.*/
SELECT CustomerID AS ID, CustomerName AS Customer FROM Customers;
SELECT CustomerName AS Customer, ContactName AS [Contact Person] FROM Customers;
SELECT CustomerName, Address + ', ' + PostalCode + ' ' + City + ', ' + Country AS Address
FROM Customers;

--Using variables
DECLARE @StartDate DATE = '2025-01-01';
DECLARE @EndDate DATE = GETDATE();

SELECT @StartDate AS StartDate, 
       @EndDate AS EndDate, 
       DATEDIFF(DAY, @StartDate, @EndDate) AS DaysDifference;



/* The SQL IN Operator
The IN operator allows you to specify multiple values in a WHERE clause.

The IN operator is a shorthand for multiple OR conditions. */
 --example

 SELECT * FROM [dbo].[AccountHolder]
WHERE Country IN ('TANZANIA', 'GHANA', 'YUGOSLAVIA')

/* SQL Aliases
SQL aliases are used to give a table, or a column in a table, a temporary name.

Aliases are often used to make column names more readable.

An alias only exists for the duration of that query.

An alias is created with the AS keyword.

------- ALIAS FOR COLUMNS
SELECT column_name AS alias_name
FROM table_name;  Also notice how the spaces are being created and comma added */

SELECT FirstName, LastName, AccountBalance AS BalanceinCustomersAccount
FROM AccountHolder;

/*Comibining more than one column and giving it an alias*/

SELECT FirstName + ' ' + LastName  AS CustomersFullName
FROM AccountHolder;

SELECT FirstName + ', ' + LastName  AS CustomersFullName
FROM AccountHolder;

SELECT LastName + FirstName + ', ' + Gender  AS CustomersGender
FROM AccountHolder;

-- USING THE QUERY EDITOR AS A CALCULATOR WITH SELECT STATEMENTS (You can carry out mathematical operations and calculator with SELECT statements

SELECT 150 + 150 

SELECT 100 / 2

-- Using TOP to FETCH DATA
-- SElects the TOP 3 records
SELECT TOP 3 * FROM AccountHolder

-- SElect in percentage  -- you can also add WHERE clauses into it.
SELECT TOP 50 PERCENT * FROM AccountHolder;


-------=======DML COMMANDS=====================================
--Creating Database
USE master
CREATE DATABASE SQLCommands

Create Database SQLCommands_Demo

Use SQLCommands

--CREATE TABLE
CREATE TABLE [Customer] (
  [CustomerID] nvarchar(2) not null,
  [FirstName] nvarchar(20),
  [LastName] nvarchar(20),
  [Street] nvarchar(30),
  [City] nvarchar(20),
  [Zip] int unique,
  [Phone] int unique,
  [Country] nvarchar (30),
  PRIMARY KEY ([CustomerID]))


use SQLCommands
CREATE TABLE [NewOrders] (
  [OrderNumber] nvarchar(3) not null,
  [CustomerID] nvarchar(2) not null,
  [OrderState] nvarchar(20),
  [OrderDate] date
  );


CREATE TABLE [Product] (
  [ProductID] int not null,
  [OrderNumber] nvarchar(3) not null,
  [Quantity] int,
  [ProductType] nvarchar(30),
  );

-- INSERT VALUES INTO TABLE
use SQLCommands
INSERT INTO dbo.Customer
VALUES ('B1',

INSERT INTO [dbo].[Customer]
VALUES --('A1', 'Peter', 'Schmitt', 'BM Makepe', 'Douala', '007', '7777777','CMR'),
	   ('A2', 'Petra', 'Williams', 'Bekoko', 'Texas', '003', '3333333','USA'),
	   ('A3', 'Chelsie', 'Moore', 'Tankwa', 'Califinia', '004', '4444444','USA'),
	   ('A4', 'Davila', 'Yachin', 'Lendi','Colorado', '005', '5555555','USA'),
	   ('A5', 'Glenn', 'Peters', 'Akwa', 'Washington', '002', '2222222','USA');

insert into dbo.Customer
values
('C1', 'Denis', 'Kiawi', 'Richmond', 'Texas', 77407, 6546542,'USA');

select * from  [dbo].[Customer]



INSERT INTO [dbo].[Customer]
VALUES ('A6', 'John', 'Clarkson', 'Njeleng 5', 'Bafoussam', '187', '7778888','NGR'),
	   ('A7', 'Princess', 'Lukong', 'Mile 10', 'Kumbo', '675', '3876533','CMR'),
	   ('A8', 'Chelsa', 'Vincent', 'Bagang', 'Bafanji', '0074', '4449874','CHAD'),
	   ('A9', 'Davila', 'Kana', 'PK 11','Bertoua', '025', '2987555','USA'),
	   ('B1', 'Mira', 'Mambila', 'Bonaberi', 'Douala', '192', '2274122','NAMIBIA');


INSERT INTO [dbo].[NewOrders]
VALUES ('1AB', 'A1', 'Douala', '12/12/2019'),
	   ('2AB', 'A2', 'Texas', '03/09/2018'),
	   ('3AB', 'A3', 'Califinia', '02/04/2019'),
	   ('4AB', 'A4', 'Colorado', '08/03/2020'),
	   ('5AB', 'A5', 'Washington', '04/18/2020');

select * from [dbo].[NewOrders]
delete from [dbo].[NewOrders]
where  CustomerID ='A1'

INSERT INTO [dbo].[NewOrders]
VALUES ('2AC', 'A6', 'Douala', '1/12/2018'),
	   ('3AC', 'A7', 'Texas', '03/19/2019'),
	   ('4AC', 'A8', 'Califinia', '02/04/2017'),
	   ('5AC', 'A9', 'Colorado', '08/03/2020'),
	   ('6AC', 'B1', 'Washington', '04/18/2012');

drop table Product
INSERT INTO [dbo].[Product]
VALUES ('1001', '1AB', '19', 'laptop',1003),
	   ('1002', '2AB', '12', 'Jeans',1004),
	   ('1003', '3AB', '1', 'Printer',1403),
	   ('1004', '4AB', '9', 'Shoes',1503),
	   ('1005', '5AB', '13', 'Bags',10653);
	  

INSERT INTO [dbo].[Product]
VALUES ('1011', '2AC', '1', 'laptop',4003),
	   ('1012', '3AC', '1', 'Car',1303),
	   ('1013', '4AC', '17', 'Mouse',1033),
	   ('1014', '5AC', '69', 'Face Masks',1503),
	   ('1015', '6AC', '73', 'Sanitizers',5003);


select * from Customer
select * from [NewOrders]
select * from product






---DDL Commands
 --1. Create --already seen

 --2. Drop -  delete a whole database or just a table.The DROP statement destroys the objects like an existing database, table, index, or view.

Drop table Customer
--difference between delete and truncate
select * from Customer
delete from customer
where customerid ='B1'

truncate table Customer
delete from customer


--what is the difference between truncate and drop?
--truncate deletes the data leaving the table definition while drop removes everything


 --3. Alter: alters/changes or modifies the values in a dataset.
 
 ALTER DATABASE SQLCommands_Demo
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

-- Alter to Rename database
ALTER DATABASE SQLCommands_Demo MODIFY NAME = SQLCommands;

-- Optional: set back to MULTI_USER
ALTER DATABASE SQLCommands
SET MULTI_USER;


 -- DROP command to remove a database
 Drop Database SQLCommands


 --Alter_Command to remove a column
ALTER TABLE Customer
DROP COLUMN Firstname;

select * from customer

drop table customer

-- Alter_Command to ADD a coloum and update 
ALTER TABLE Product
ADD Price DECIMAL(10, 2); 

ALTER TABLE Product
drop column price

select * from Product

-- Rename column name
 ALTER TABLE Product
Rename COLUMN Price TO Amount;--Rename works only with postgre



use AdventureWorks2019
select * from [Production].[Product]

exec sp_rename 'Production.Product.PoductID', 'ID', 'COLUMN';


--use sp_rename to change column names. Syntax= 'TableName.Oldcolumn', 'NewColumn', 'COLUMN';
EXEC sp_rename 'Customer.LastName', 'FamilyName', 'COLUMN'; --Let`s rename the "Lastname" column to "FamilyName"

EXEC sp_rename 'product.Amount', 'Price', 'COLUMN';



EXEC sp_rename 'Customer.zip', 'zipcode', 'COLUMN'; --Let`s rename the "zip" column to "zipcode"

use SQLCommand
select * from customers

-- Rename Table name

EXEC sp_rename 'Customer', 'Customers';


-- Check dependencies
SELECT OBJECT_NAME(referencing_id) AS referencing_object,
       referenced_entity_name AS referenced_column
FROM sys.sql_expression_dependencies
WHERE referenced_entity_name = 'Proc';  -- or 'OldTableName'




 --4. Truncate: Removes all data from a table, typically bypassing a number of integrity enforcing mechanisms. 
BEGIN TRANSACTION
TRUNCATE TABLE Product

--VALIDATE ACTION
COMMIT
COMMIT TRAN
COMMIT TRANSACTION

--UNDO THE ACTION
ROLLBACK
ROLLBACK TRAN
ROLLBACK TRANSACTION

Rollback;


SELECT * FROM Product

Begin Transaction
 DELETE FROM Product
 --WHERE ProductID ='1012'
 COMMIT TRAN

 Rollback;
 --4. Comments - /*multi line comment another comment inside a script*/


SELECT * FROM Product;


----DML: controls access to data and to the database

--1.1 Insert into an existing Table: Already seen above. But let´s add 1 more value to the table (new customer)

INSERT INTO [dbo].[Customers]
VALUES ('C1', 'Mike', 'Kuwan', 'Ghanastreet', 'Bamenda', '237', '0237778','USA');
select * from customers

--1.2: Insert Records from an existing table into a new table

--Create a new table
CREATE TABLE [ProductNew] (
  [ProductID] int not null,
  [OrderNumber] nvarchar(3) not null,
  [Quantity] int,
  [ProductType] nvarchar(30),
  --[Price] Decimal (10,2), --*N.B: The existing table was updated with a new coloum "Price"
  );

  select * from Product
  select * from ProductNew
  --drop table ProductNew


--Insert records into the newly created table
INSERT INTO ProductNew (ProductID, OrderNumber, Quantity, ProductType)
SELECT ProductID, OrderNumber, Quantity, ProductType
FROM Product;

Select * from ProductNew
truncate table productnew

select * from Product

Delete from ProductNew

--Or insert only specific rows into the new table
begin tran
INSERT INTO Product (ProductID, OrderNumber, Quantity, ProductType)
SELECT ProductID, OrderNumber, Quantity, ProductType
FROM ProductNew
WHERE ProductType = 'Laptop';

rollback tran
commit tran




--2. Update:
select * from [dbo].[Customer]
use sqlcommands
Begin Tran
UPDATE Customer SET lastname = 'Kiawi' 
where customerid ='E1'


begin tran
insert into Customer 
values 
('E2', 'Tim','34 Corporate Drive', 'Stafford', 77479, 553545, 'USA', 'David')

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
ALTER DATABASE [SQLCommands] SET READ_COMMITTED_SNAPSHOT ON;
begin tran
insert into Customer 
values 
('E3', 'Tim','34 Corporate Drive', 'Stafford', 77478, 554545, 'USA', 'David')

select * from [dbo].[Customer]

sp_whoisactive
sp_who2

commit tran

Rollback tran

--Update specific row with where clause
Begin Tran
UPDATE Customer SET Firstname = 'Paul'  WHERE CustomerID = 'A1';

Rollback

SELECT * FROM Customer;

--Update with "Case"
Begin Tran
UPDATE Product SET Price = CASE
    WHEN ProductID = 1001 THEN 755.00
    WHEN ProductID = 1002 THEN 45.00
    WHEN ProductID = 1003 THEN 130.00
    WHEN ProductID = 1004 THEN 60.00
    WHEN ProductID = 1005 THEN 25.00
    WHEN ProductID = 1011 THEN 800.00
    WHEN ProductID = 1012 THEN 16000.00
    WHEN ProductID = 1013 THEN 20.00
    WHEN ProductID = 1014 THEN 10.00
    WHEN ProductID = 1015 THEN 5.00
END;
commit tran

Select * from Product

--3. --Delete All Records from the table
	--It is possible to delete all rows in a table without deleting the table. This means that the table structure, attributes, and indexes will be intact:

--syntax of specific record
Begin Tran
 DELETE FROM Customer
 WHERE CustomerID = 'B1'
 Rollback;


	
--syntax of all records
Begin Tran
	DELETE FROM Customer
	rollback;
or

Begin Tran
	Delete customer
	Rollback


--Merge Statement (It merges records from 2 or more coloums into 1 single coloum)
Select FirstName + '' + LastName as FULLNAME from Customer --You can use / or -- inside the string to separate both information
Select OrderNumber + '-' + Producttype as Productvalue from Product 

--More DEMO on Locks

--SQL Locks
/*A lock is established in SQL Server when a transaction starts, and it is released when it is ended. There are different types of locks, namely:

Shared (S) Locks: When the object needs to be read, this type of lock will occur, but this is not harmful.

Exclusive (X) Locks: It prevents other transactions like inserting/updating/deleting etc., Hence no modifications can be done on a locked object.

Update (U) Locks: More or less similar to Exclusive lock but here the operation can be viewed as  read phase  and  write phase . Especially during the read phase, other transactions are prevented. 

Intent Locks: When SQL Server has the shared (S) lock or exclusive (X) lock on a row, then the intent lock is on the table.

Regular intent locks: Intent exclusive (IX) , Intent shared (IS), and Intent update (IU).

Conversion locks: Shared with intent exclusive (SIX), Shared with intent update (SIU), and Update with intent exclusive (UIX).*/


--------*****TCL*****------------
--Commit 
--used to control transactions but canot be used with creating tables
--ONLY USED with DML COMMANDS such as   INSERT, UPDATE and DELETE. 

BEGIN TRANSACTION transaction_name ; --indicates the start point of an explicit or local transaction

SET TRANSACTION [READ WRITE | READ ONLY];

commit  --The COMMIT command saves all the transactions to the database since the last COMMIT or ROLLBACK command.

DELETE FROM Customer WHERE city = 'Kumba';
COMMIT;
	
---RollBack --If any error occurs with any of the SQL grouped statements, all changes need to be aborted. i.e Process of reversing changes
DELETE FROM Customer WHERE city = 'Kumba';
ROLLBACK;



---More Research on Savepoint

-----Savepoint --creates points within the groups of transactions in which to ROLLBACK
--SAVEPOINT SAVEPOINT_NAME;

--SAVE TRANSACTION SP1;--Savepoint created.
--DELETE FROM Customer WHERE city = 'Texas';  --deleted
--SAVEPOINT SP2;  --Savepoint created.


--select * from Customer 
--ROLLBACK TO SP1;  --Rollback completed.

----------------DQL-------------------------




--SELECT Statements

Select * from Customer -- Avoid this statement in large tables. Always use it with a where-clause

SELECT FirstName, LastName FROM Customer; --selecting specific columns (Best Practice)

SELECT 100*10
SELECT 1000/2

--Other select statements
SELECT GETDATE() AS CurrentDateTime; --Getting the Current Date and Time
SELECT CAST(GETDATE() AS DATE) AS StartOfDay;--to get the start of the current date
SELECT SYSDATETIME() AS CurrentDateTimeWithPrecision; --Getting the Current Date and Time with higher precision

SELECT DATEPART(YEAR, GETDATE()) AS Year, 
       DATEPART(MONTH, GETDATE()) AS Month, 
       DATEPART(DAY, GETDATE()) AS Day; --extracting parts of a Date in year, month and day

SELECT DATENAME(WEEKDAY, GETDATE()) AS DayName, 
       DATENAME(MONTH, GETDATE()) AS MonthName;--extracting only the name of the week day and name of the month

SELECT DATEADD(DAY, 7, GETDATE()) AS DateAfter7Days,
       DATEADD(MONTH, 1, GETDATE()) AS DateNextMonth; --this script adds days, months and years

SELECT DATEADD(year, -42, GETDATE()) AS Date7DaysAgo; --this script subtracts days, months or years


SELECT DATEDIFF(week, '1983-08-09', GETDATE()) AS DaysDifference,
       DATEDIFF(YEAR, '1983-08-09', GETDATE()) AS YearsDifference; --this script calculates the difference between dates

SELECT FORMAT(GETDATE(), 'yyyy-MM-dd') AS FormattedDate,
       FORMAT(GETDATE(), 'MMMM dd, yyyy') AS LongDateFormat; --this script helps to format dates as a string datatype

SELECT CONVERT(TIME, GETDATE()) AS CurrentTime; --this script extracts only the time portion from the date

SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) AS StartOfMonth; --to get the start of this month
SELECT DATEADD(DAY, -1, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) + 1, 0)) AS EndOfMonth; --to get the end of this month

SELECT CASE WHEN (YEAR(GETDATE()) % 4 = 0 AND YEAR(GETDATE()) % 100 != 0) OR (YEAR(GETDATE()) % 400 = 0)
            THEN 'Leap Year'
            ELSE 'Not a Leap Year'
       END AS LeapYearCheck; --to check if this year is a leap year or not

SELECT DAY(EOMONTH(GETDATE())) AS DaysInMonth; --Get the number of days in the month


--Create a new table with same structure but without data from an existing table:
SELECT * INTO NewCustomer
FROM Customer
WHERE 1 = 0; -- This condition ensures no rows are copied.

--Create a new table with same structure and data from an existing table:
SELECT * INTO NewCustomer2
FROM Customer
WHERE 1 = 1; -- This condition ensures no rows are copied.


--or

--Create a new table with same structure and data from an existing table:
SELECT *
INTO NewCustomer3
FROM Customer;



----------------DCL-------------------------

--GRANT: Either Gives permissions to users using Principle of Least Privilege or RBAC-Role-based Access Control

GRANT SELECT ON Employees TO User1;

GRANT Delete ON Customer TO John;

-- REVOKE: Removes permissions from users.
REVOKE SELECT ON Employees FROM User1;

Revoke Delete ON Customer TO John;

--Demo to create Login (Logins are created on the Instance Security)
Use Master
CREATE LOGIN lewis
WITH PASSWORD = 'Password1';


-- Users are created on the Database Security
USE [AuditDB];

-- Create User for Login
CREATE USER Lewis
FOR LOGIN Lewis;

-- Grant Database Roles to User
ALTER ROLE db_datareader ADD MEMBER Lewis;
ALTER ROLE db_datawriter ADD MEMBER Lewis;

-- Grant Explicit Permissions (Database Permissions)
Revoke SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO Lewis;


--ended here 
--9/04/2025

-------------/* SQL JOIN
--A JOIN clause is used to combine rows from two or more tables, based on a related column between them.
--Different Types of SQL JOINs


--Here are the different types of the JOINs in SQL:

--1-  (INNER) JOIN: Returns records that have matching values in both tables

INNER JOIN Syntax:

SELECT column_name(s)
FROM table1
INNER JOIN table2
ON table1.column_name = table2.column_name;

Example */
SELECT Orders.OrderID, Customers.CustomerName
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID;

/* JOIN Three Tables

Example */
SELECT Orders.OrderID, Customers.CustomerName, Shippers.ShipperName
FROM ((Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID)
INNER JOIN Shippers ON Orders.ShipperID = Shippers.ShipperID);

/*
2-  LEFT (OUTER) JOIN: The LEFT JOIN keyword returns all records from the left table (table1), and the matching records from the right table (table2). The result is 0 records from the right side, if there is no match.

LEFT JOIN Syntax
SELECT column_name(s)
FROM table1
LEFT JOIN table2
ON table1.column_name = table2.column_name;

The following SQL statement will SELECT all customers, and any orders they might have:

Example */

SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
ORDER BY Customers.CustomerName;


/*
3-  RIGHT (OUTER) JOIN:The RIGHT JOIN keyword returns all records from the right table (table2), and the matching records from the left table (table1). The result is 0 records from the left side, if there is no match.

RIGHT JOIN Syntax
SELECT column_name(s)
FROM table1
RIGHT JOIN table2
ON table1.column_name = table2.column_name;

The following SQL statement will return all employees, and any orders they might have placed:

Example */

SELECT Orders.OrderID, Employees.LastName, Employees.FirstName
FROM Orders
RIGHT JOIN Employees ON Orders.EmployeeID = Employees.EmployeeID
ORDER BY Orders.OrderID;

/*
4-  FULL (OUTER) JOIN: Returns all records when there is a match in either left or right table

FULL OUTER JOIN Syntax
SELECT column_name(s)
FROM table1
FULL OUTER JOIN table2
ON table1.column_name = table2.column_name
WHERE condition;

SQL FULL OUTER JOIN Example 

The following SQL statement SELECTs all customers, and all orders:*/

SELECT Customers.CustomerName, Orders.OrderID
FROM Customers
FULL OUTER JOIN Orders ON Customers.CustomerID=Orders.CustomerID
ORDER BY Customers.CustomerName;

/* SQL UNION Operator

The UNION operator is used to combine the result-set of two or more SELECT statements.

-Every SELECT statement within UNION must have the same number of columns
-The columns must also have similar data types
-The columns in every SELECT statement must also be in the same order

UNION Syntax */

SELECT column_name(s) FROM table1
UNION
SELECT column_name(s) FROM table2;

/*
UNION ALL Syntax
The UNION operator SELECTs only distinct values by default. To allow duplicate values, use UNION ALL:
*/
SELECT column_name(s) FROM table1
UNION ALL
SELECT column_name(s) FROM table2;

Note: The column names in the result-set are usually equal to the column names in the first SELECT statement.





------ OR------------------------



--JOINS

//* WHAT IS A JOIN?
A JOIN is a clause used to combine rows from two or more tables based on a related column between them*//

--QUESTION???? Can we join two tables that do not have any Primary and Foreign key relationship???? Yes as long as the column values involved in the join can be converted to a compartible datatype.

//* DIFFERENT TYPES OF JOINS
1)INNER JOIN    (MSSQL Default JOIN where type of Join is not explicitly stated)
2)LEFT JOIN OR LEFT OUTER JOIN
3)RIGHT JOIN OR RIGHT OUTER JOIN
4)FULL OUTER JOIN
5)SELF JOIN
6)CROSS JOIN

1 - INNER JOIN: Returns "ONLY" records that have matching values in both (or all) tables. Does not return "ALL" records from any of the tables except if all the records in one or both tables actually have a match in the other table. (Much like an Intersection).
	SQL SNYTAX FOR INNER JOIN: is INNER JOIN OR JOIN
	SCENARIO WHEN YOU MIGHT NEED AN INNER JOIN: Like when you want to know customers who are actively shopping for various reasons ranging from targeted advertisement, customer reward programs etc. 

2 - LEFT JOIN OR LEFT OUTER JOIN: Returns "ALL" records from the Left table and their corresponding match from the Right Table that has been joined. Since Left Join returns ALL Records from Left Table, if there is a record that does not have a corresponding match with the Right table, it will be displayed as NULL.
    SQL SNYTAX FOR LEFT JOIN: is LEFT JOIN  OR LEFT OUTER JOIN
	SCENARIO WHEN YOU MIGHT NEED A LEFT JOIN: 

3 - RIGHT JOIN OR RIGHT OUTER JOIN: Returns "ALL" records from the Right table and their corresponding match from the Left Table that has been joined. Since Right Join returns ALL Records from Right Table, if there is a record that does not have a corresponding match with the Left table, it will be displayed as NULL.
    SQL SNYTAX FOR LEFT JOIN: is RIGHT JOIN  OR RIGHT OUTER JOIN
	SCENARIO WHEN YOU MIGHT NEED A RIGHT JOIN: 

4 - FULL JOIN OR FULL OUTER JOIN: Returns "ALL" records from "BOTH" tables displaying their corresponding matches and their non-corresponding matches as well if there is any that does not have a corresponding match.
    SQL SNYTAX FOR FULL JOIN: is FULL JOIN OR FULL OUTER JOIN
	SCENARIO WHEN YOU MIGHT NEED A FULL JOIN: 

5 - SELF JOIN: It is a regular join but the table is joined with itself. A SELF JOIN is a REGULAR JOIN and can be classided under any join INNER, OUTER and CROSS. Works in the same manner as a UNION Statement. The union operator is used to combine the result-set of two or more SELECT Statements. /Each SELECT Statement within the Union must have the same number of columns. /The columns must also have the similar datatypes/ The columns in each SELECT Statement must also be in the same order.

6 - CROSS JOIN
 The SQL CROSS JOIN produces a result set which is the number of rows in the first table multiplied by the number of rows in the second table if no WHERE clause is used along with CROSS JOIN. This kind of result is known as the Cartesian Product. TAKE SPECIAL NOTE THAT a Cross Join cannot have an ON clause.
 -- What is CARTESIAN PRODUCT IN SQL? A Cartesian Product is a product of two sets of elements where each element in one set is multiplied by every other element of the other set.
If WHERE clause is used with CROSS JOIN, it functions like an INNER JOIN.


   ***NOTE THAT the UNION Operator SELECTs only distinct values by default. To allow duplicate values, use UNION ALL.

	***N/B: THE ON STATEMENT TELLS YOU THE COMMON COLUMN ON BOTH TABLES.   *//



--------------------LAB WORK (PRACTICALS)-------------------------------


CREATE DATABASE AmazonGlobalDB

--n/b: The CREATE DATABASE Command must be executed individually so the database can exist and the other commands below can be executed at once.

USE AmazonGlobalDB

CREATE TABLE CMRCustomers (
CustomerID Varchar(MAX) NOT NULL, NameofCMRCustomers Varchar(255) NOT NULL, Address Varchar(255), City Varchar(100));

CREATE TABLE USACustomers(
CustomerID Varchar(MAX) NOT NULL, NameofUSACustomers Varchar(255));

CREATE TABLE AllOrders (
OrderID Varchar(MAX) NOT NULL, CustomerID Varchar(MAX) NOT NULL, EmployeeID_Who_Served_Customer Varchar(MAX), OrderDate date);


INSERT INTO CMRCustomers VALUES ('CMR99001', 'Uwa', 'Silicon Valley Annex', 'Sabongari')
INSERT INTO CMRCustomers VALUES ('CMR99002', 'Patience', 'Man O War Bay', 'Limbe')
INSERT INTO CMRCustomers VALUES ('CMR99003', 'Tohmoh', 'Beside Paul Biya' ,'Yaounde')
INSERT INTO CMRCustomers VALUES ('CMR99004', 'Rodrigue', 'Carrefour je rater ma vie', 'Douala')
INSERT INTO CMRCustomers VALUES ('CMR99005', 'Ernestine', 'Liberty Square', 'Buea')
INSERT INTO CMRCustomers VALUES ('CMR99006', 'Regina', 'Buy1Take2 Boulevard','Mamfe')
INSERT INTO CMRCustomers VALUES ('CMR99007', 'Vernadelle', ' Carrefour Tu dors, ta vie dort', 'Yaounde')
INSERT INTO CMRCustomers VALUES ('CMR99008', 'Dickson', 'Apres Chapelle Obili' ,'Yaounde')
INSERT INTO CMRCustomers VALUES ('CMR99009' ,'Ransom', 'Commercial Avenue', 'Bamenda')
INSERT INTO CMRCustomers VALUES ('CMR990010', 'Alain', 'Behind Banga School', 'Kumba')

INSERT INTO USACustomers VALUES ('USA121212', 'Niel Legweak')
INSERT INTO USACustomers VALUES ('USA131313', 'Matthew Heavens')
INSERT INTO USACustomers VALUES ('USA141414', 'Paul Hammer')
INSERT INTO USACustomers VALUES ('USA151515', 'Condolezza Rice')
INSERT INTO USACustomers VALUES ('USA161616', 'Peter Stone')

INSERT INTO AllOrders VALUES ('34','CMR99009', 'DME100', '2021-12-06')
INSERT INTO AllOrders VALUES ('73', 'CMR99004','DME200', '2021-05-05')
INSERT INTO AllOrders VALUES ('68','CMR99006', 'DME400', '2021-11-11')
INSERT INTO AllOrders VALUES ('102','USA121212', 'DME800', '2021-01-01')
INSERT INTO AllOrders VALUES ('27','CMR99005', 'DME600', '2021-03-03')
INSERT INTO AllOrders VALUES ('44','CMR99004', 'DME700', '2021-02-02')
INSERT INTO AllOrders VALUES ('100','USA131313', 'DME100', '2020-12-25')
INSERT INTO AllOrders VALUES ('101','USA141414', 'DME200', '2020-12-24')
INSERT INTO AllOrders VALUES ('54','CMR99002', 'DME200', '2020-12-22')
INSERT INTO AllOrders VALUES ('82','CMR99004', 'DME200', '2021-04-04')



--VIEW ALL RECORDS FROM THE TWO OR MORE TABLES AT ONCE
SELECT * FROM CMRCustomers
SELECT * FROM USACustomers
SELECT * FROM AllOrders


//* LAB WORK*//

--1--INNER JOIN
SELECT CMRCustomers.CustomerID, CMRCustomers.NameofCMRCustomers, AllOrders.OrderID, AllOrders.EmployeeID_Who_Served_Customer, AllOrders.OrderDate
FROM CMRCustomers 
INNER JOIN AllOrders 
ON CMRCustomers.CustomerID = CMRCustomers.CustomerID


--2--LEFT OUTER JOIN
SELECT LEFTTABLE.CustomerID, LEFTTABLE.NameofCMRCustomers, RIGHTTABLE.OrderID, RIGHTTABLE.EmployeeID_Who_Served_Customer, RIGHTTABLE.OrderDate
FROM CMRCustomers AS LEFTTABLE
LEFT OUTER JOIN AllOrders AS RIGHTTABLE
ON LEFTTABLE.CustomerID = RIGHTTABLE.CustomerID

--n/b if you want to join only NONE MATCHING Rows from the LEFTTABLE instead you can add the WHERE clause below to the script above
WHERE RIGHTTABLE.OrderID IS NOT NULL


--3--RIGHT OUTER JOIN
SELECT LEFTTABLE.CustomerID, LEFTTABLE.NameofCMRCustomers, RIGHTTABLE.OrderID, RIGHTTABLE.EmployeeID_Who_Served_Customer, RIGHTTABLE.OrderDate
FROM CMRCustomers AS LEFTTABLE
RIGHT OUTER JOIN AllOrders AS RIGHTTABLE
ON LEFTTABLE.CustomerID = RIGHTTABLE.CustomerID

--n/b if you want to join only NONE MATCHING Rows from the RIGHTTABLE instead you can add the WHERE clause below to the script above
WHERE LEFTTABLE.CustomerID IS NULL


--4--FULL JOIN   
SELECT LEFTTABLE.CustomerID, LEFTTABLE.NameofCMRCustomers, RIGHTTABLE.OrderID, RIGHTTABLE.EmployeeID_Who_Served_Customer, RIGHTTABLE.OrderDate
FROM CMRCustomers AS LEFTTABLE
FULL JOIN AllOrders AS RIGHTTABLE
ON LEFTTABLE.CustomerID = RIGHTTABLE.CustomerID

--n/b if you want to join only NONE MATCHING Rows from BOTH TABLES instead you can add the WHERE clause below to the script above
WHERE RIGHTTABLE.CustomerID IS NULL


--5-- SELF JOIN  (As explained earlier, a SELF is nothing more than a REGULAR JOIN and can be classided under any of join INNER, OUTER and CROSS

Use Master

CREATE DATABASE UniversityOfKiawiTechDB

USE UniversityOfKiawiTechDB

CREATE TABLE StudentsPeerSupervision(
StudentID Varchar(MAX) NOT NULL, StudentName Varchar(255), StudentWhoSupervisedByID Varchar(MAX) NOT NULL);

INSERT INTO StudentsPeerSupervision VALUES ('UOK001', 'Uzo', 'UOK008')
INSERT INTO StudentsPeerSupervision VALUES ('UOK002', 'Olukemi', 'KWA999')
INSERT INTO StudentsPeerSupervision VALUES ('UOK003', 'Mary', 'UOK010')
INSERT INTO StudentsPeerSupervision VALUES ('UOK004', 'Joy', 'UOK005')
INSERT INTO StudentsPeerSupervision VALUES ('UOK005', 'Doris', 'UOK001')
INSERT INTO StudentsPeerSupervision VALUES ('UOK006', 'Bola', 'UOK002')
INSERT INTO StudentsPeerSupervision VALUES ('UOK007', 'Agbenehovi', 'UOK007')
INSERT INTO StudentsPeerSupervision VALUES ('UOK008', 'Dieudonne', 'UOK003')
INSERT INTO StudentsPeerSupervision VALUES ('UOK009', 'David', 'NULL')
INSERT INTO StudentsPeerSupervision VALUES ('UOK010', 'Siona', 'UOK009')

SELECT * From StudentsPeerSupervision



--DEMONSTRATING SELF JOIN CLASSIFIED AS "LEFT SELF JOIN".
SELECT STUDENT.StudentName AS STUDENT, SUPERVISOR.StudentName AS SUPERVISOR
FROM StudentsPeerSupervision AS STUDENT
LEFT JOIN StudentsPeerSupervision AS SUPERVISOR
ON  STUDENT.StudentWhoSupervisedByID = SUPERVISOR.StudentID


--DEMONSTRATING SELF JOIN CLASSIFIED AS "RIGHT SELF JOIN".
SELECT STUDENT.StudentName AS STUDENT, SUPERVISOR.StudentName AS SUPERVISOR
FROM StudentsPeerSupervision AS STUDENT
RIGHT JOIN StudentsPeerSupervision AS SUPERVISOR
ON  STUDENT.StudentWhoSupervisedByID = SUPERVISOR.StudentID

--DEMONSTRATING SELF JOIN CLASSIFIED AS "INNER SELF JOIN". (Note: you can still mention ALIAS by just giving a space and type the ALIAS without "AS"
SELECT STUDENT.StudentName AS STUDENT, SUPERVISOR.StudentName AS SUPERVISOR
FROM StudentsPeerSupervision STUDENT
INNER JOIN StudentsPeerSupervision  SUPERVISOR
ON  STUDENT.StudentWhoSupervisedByID = SUPERVISOR.StudentID

--DEMONSTRATING SELF JOIN CLASSIFIED AS "FULL SELF JOIN".
SELECT STUDENT.StudentName AS STUDENT, SUPERVISOR.StudentName AS SUPERVISOR
FROM StudentsPeerSupervision STUDENT
FULL JOIN StudentsPeerSupervision  SUPERVISOR
ON  STUDENT.StudentWhoSupervisedByID = SUPERVISOR.StudentID

--DEMONSTRATING SELF JOIN CLASSIFIED AS "CROSS SELF JOIN".
SELECT STUDENT.StudentName AS STUDENT, SUPERVISOR.StudentName AS SUPERVISOR
FROM StudentsPeerSupervision STUDENT
CROSS JOIN StudentsPeerSupervision  SUPERVISOR




--6 --CROSS JOIN--
Use AmazonGlobalDB
SELECT *  
FROM CMRCustomers
CROSS JOIN AllOrders
WHERE City='Kumba' OR City='Buea'



--- JOINING MORE THAN 2 TABLES

SELECT  
CMRCustomers.NameofCMRCustomers,
CMRCustomers.CustomerID,
USACustomers.NameofUSACustomers,
USACustomers.CustomerID,
AllOrders.OrderID
FROM
    CMRCustomers
FULL JOIN
    USACustomers ON CMRCustomers.CustomerID = USACustomers.CustomerID
FULL JOIN
    AllOrders ON USACustomers.CustomerID = CMRCustomers.CustomerID

----


----- EXPLAINING USE OF ALIAS IN JOINS

 ---- ALIASES ARE USED IN JOINS WHEN TABLES NAMES ARE THE SAME. IF TABLE AND/OR COLUMN NAMES ARE DIFFERENT, YOU WONT NEED TO USE ALIASES AND THE SAME RESULT WILL BE RETURNED. SEE EXAMPLE BELOW

 USE AmazonGlobalDB

CREATE TABLE CMRCustomers2 (
CustomerID Varchar(MAX) NOT NULL, NameofCMRCustomers Varchar(255) NOT NULL, Address Varchar(255), City Varchar(100));

INSERT INTO CMRCustomers2 VALUES ('CMR99001', 'Alexia', 'Silicon Valley Annex', 'Sabongari')
INSERT INTO CMRCustomers2 VALUES ('CMR99002', 'Jak', 'Man O War Bay', 'Limbe')
INSERT INTO CMRCustomers2 VALUES ('CMR99003', 'Minette', 'Beside Paul Biya' ,'Yaounde')
INSERT INTO CMRCustomers2 VALUES ('CMR99004', 'William', 'Carrefour je rater ma vie', 'Douala')
INSERT INTO CMRCustomers2 VALUES ('CMR99005', 'Mr Cedric', 'Liberty Square', 'Buea')
INSERT INTO CMRCustomers2 VALUES ('CMR99006', 'Dr. Ernest', 'Buy1Take2 Boulevard','Mamfe')
INSERT INTO CMRCustomers2 VALUES ('CMR99007', 'Amambo', ' Carrefour Tu dors, ta vie dort', 'Yaounde')
INSERT INTO CMRCustomers2 VALUES ('CMR99008', 'Elvis', 'Apres Chapelle Obili' ,'Yaounde')
INSERT INTO CMRCustomers2 VALUES ('CMR99009' ,'Ransom', 'Commercial Avenue', 'Bamenda')
INSERT INTO CMRCustomers2 VALUES ('CMR990010', 'Barrack Ogama', 'Behind Banga School', 'Kumba')


Use AmazonGlobalDB
CREATE TABLE AllOrders2 (
OrderID Varchar(MAX) NOT NULL, ClientID Varchar(MAX) NOT NULL, EmployeeID_Who_Served_Customer Varchar(MAX), OrderDate date);

INSERT INTO AllOrders2 VALUES ('34','CMR99009', 'DME100', '2021-12-06')
INSERT INTO AllOrders2 VALUES ('73', 'CMR99004','DME200', '2021-05-05')
INSERT INTO AllOrders2 VALUES ('68','CMR99006', 'DME400', '2021-11-11')
INSERT INTO AllOrders2 VALUES ('102','USA121212', 'DME800', '2021-01-01')
INSERT INTO AllOrders2 VALUES ('27','CMR99005', 'DME600', '2021-03-03')
INSERT INTO AllOrders2 VALUES ('44','CMR99004', 'DME700', '2021-02-02')
INSERT INTO AllOrders2 VALUES ('100','USA131313', 'DME100', '2020-12-25')
INSERT INTO AllOrders2 VALUES ('101','USA141414', 'DME200', '2020-12-24')
INSERT INTO AllOrders2 VALUES ('54','CMR99002', 'DME200', '2020-12-22')
INSERT INTO AllOrders2 VALUES ('82','CMR99004', 'DME200', '2021-04-04')

-- NOW TAKE A LOOK AT THE INNER JOIN SYNTAXES. NOT ALIAS ARE REQUIRED. TABLE AND COLUMN NAMES ARE DIFFERENT BUT THE TWO TABLES ARE STILL RELATED IN THE DATA THAT IS CONTAINED WITHIN THEM.

SELECT CustomerID, NameofCMRCustomers, OrderID, EmployeeID_Who_Served_Customer, OrderDate
FROM CMRCustomers2
INNER JOIN AllOrders2
ON CustomerID = ClientID

--this applies to all types of JOINS


--HOMEWORK
--READ about 
--1) CTE
--2) VARIABLES
--3) PARAMETERS
--4) Functions and store procedures
--5 VIEWS
