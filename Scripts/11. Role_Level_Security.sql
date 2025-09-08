/* Step 1.a. Let’s create some test accounts: I will create three users for:

1. The CEO, over-all admin of the company data.

2. HR department head

3. Finance department head */

--Step 1: create a database called RLSDB

CREATE DATABASE RLSDB

--Step 2: create 3 users
Use RLSDB
CREATE USER userCEO WITHOUT LOGIN;
GO
CREATE USER userHR WITHOUT LOGIN;
GO
CREATE USER userFin WITHOUT LOGIN;
GO

--step 3 –> Create a sample table [dbo].[Employee]: with a self-referencing Manager ID column.

CREATE TABLE dbo.Employees (
    [EmpCode] NVARCHAR(50),  -- Employee ID
    [EmpName] NVARCHAR(250), -- Employee/Manager Full Name
    [Salary]  MONEY,         -- Fictious Salary
    [MgrCode] NVARCHAR(50)   -- Manager ID
);
GO

--Step 4  Now insert some test records:
-- Top Boss CEO
INSERT INTO dbo.Employees VALUES ('userCEO' , 'CEO Top Boss'  , 800, NULL)
 
-- Next 2 levels under CEO
INSERT INTO dbo.Employees VALUES ('userHR'  , 'HR User'       , 700, 'userCEO');
INSERT INTO dbo.Employees VALUES ('userFin' , 'Finance User'  , 600, 'userCEO');
 
-- Employees under Kevin
INSERT INTO dbo.Employees VALUES ('manojp'  , 'Manoj Pandey'  , 100, 'userHR');
INSERT INTO dbo.Employees VALUES ('saurabhs', 'Saurabh Sharma', 400, 'userHR');
INSERT INTO dbo.Employees VALUES ('deepakb' , 'Deepak Biswal' , 500, 'userHR');
 
-- Employees under Amy
INSERT INTO dbo.Employees VALUES ('keshavk' , 'Keshav K'      , 200, 'userFin');
INSERT INTO dbo.Employees VALUES ('viveks'  , 'Vivek S'       , 300, 'userFin');
GO

--Step 5 –> Let’s check the records before applying “Row Level Security”:
SELECT * FROM dbo.Employees; -- 8 rows
GO

/*As a normal SEELCT and without RLS, it just ignores my Execution Context and execute the Query and return all the 8 rows.*?*/


--Step 6: The Traditional way to setup the Row Level Security till now was as follows (a simple example):

-- Stored Procedure with User-Name passed as parameter:
CREATE PROCEDURE dbo.uspGetEmployeeDetails (@userAccess NVARCHAR(50))
AS
BEGIN
    SELECT * 
    FROM dbo.Employees
    WHERE [MgrCode] = @userAccess
    OR @userAccess = 'userCEO'; -- CEO, the admin should see all rows
END
GO
 
-- Execute the SP with different parameter values:

EXEC dbo.uspGetEmployeeDetails @userAccess = 'userHR'  -- only 3 rows
GO
EXEC dbo.uspGetEmployeeDetails @userAccess = 'userFin' -- only 2 rows
GO
EXEC dbo.uspGetEmployeeDetails @userAccess = 'userCEO' -- all 8 rows
GO

/*
--Step 7–> The new Row Level Security feature let you:
– apply this security at the database level
– and there is no need to apply the WHERE clause filter for the User-Name.
*/

--–> Step 8. Grant Read/SELECT access on the dbo.Employee table to all 3 users:

GRANT SELECT ON dbo.Employees TO userCEO;
GO
GRANT SELECT ON dbo.Employees TO userHR;
GO
GRANT SELECT ON dbo.Employees TO userFin;
GO

--Step 9 Let’s create an Inline Table-Valued Function to write our Filter logic:
CREATE FUNCTION dbo.fn_SecurityPredicateEmployee(@mgrCode AS sysname)
    RETURNS TABLE
WITH SCHEMABINDING
AS
    RETURN SELECT 1 AS fn_SecurityPredicateEmployee_result
    -- Predicate logic
    WHERE @mgrCode = USER_NAME() 
    OR USER_NAME() = 'userCEO'; -- CEO, the admin should see all rows
GO

/*
This function returns value 1 when:

– a row in the MgrCode (i.e. the Manager Code) column is the same as the user executing the query (@@mgrCode = USER_NAME())

– or if the user executing the query is the Top Boss user (USER_NAME() = ‘userCEO’)

*/
--Step 10 –> Create a security policy adding the function as a filter predicate:


CREATE SECURITY POLICY ManagerFilter
ADD FILTER PREDICATE dbo.fn_SecurityPredicateEmployee(MgrCode)  -- Filter Column from dbo.Employee table
ON dbo.Employees
WITH (STATE = ON); -- The state must be set to ON to enable the policy.
GO

/*
The above Security Policy takes the Filter Predicate Logic from the associated Function and applies it to the Query as a WHERE clause.
*/

--Step 11 Validation
/*--–> Now let’s again check the records after applying “Row Level Security”:

–> And if you check in the Execution Plan of above SELECT statement without WHERE clause, it will show you the Filter Predicate that is added by the Security Policy defined in Step #3 for applying RLS on this table, which looks like this:
*/

SELECT * FROM dbo.Employees; -- 0 rows, 
GO

--Step 11: Final validation
/*Let’s check the 3 users we created and provided them customized access to the dbo.Employee table and rows in it:
*/

-- Execute as our immediate boss userHR (3 rows): 
EXECUTE AS USER = 'userHR';
SELECT * FROM dbo.Employees; -- 3 rows
REVERT;
GO
 
-- Execute as our immediate boss userFin: 
EXECUTE AS USER = 'userFin';
SELECT * FROM dbo.Employees; -- 2 rows
REVERT;
GO
 
-- Execute as our Top boss userCEO (8): 
EXECUTE AS USER = 'userCEO';
SELECT * FROM dbo.Employees; -- 8 rows
REVERT;
GO


--Step 12 –> Final Cleanup
DROP SECURITY POLICY [dbo].[ManagerFilter]
GO
DROP FUNCTION [dbo].[fn_SecurityPredicateEmployee]
GO
DROP TABLE [dbo].[Employee]
GO
 
DROP PROCEDURE dbo.uspGetEmployeeDetails
GO


--EXERCISE 2
--Create database called  Row-level security RLS
Use Master
Create database RLSDB

Use RLSDB

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
