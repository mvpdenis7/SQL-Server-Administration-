CREATE PROCEDURE GetProductDesc
AS
BEGIN 
SELECT P.ProductID,P.ProductName,PD.ProductDescription  FROM 
Product P
INNER JOIN ProductDescription PD 
ON P.ProductID=PD.ProductID
END

EXEC GetProductDesc

-- create a stored procedure to run the select on person table
CREATE PROCEDURE SelectPersonTable
AS
BEGIN
select * from person.person
END

EXECUTE SelectPersonTable
EXEC SelectPersonTable
SelectPersonTable


SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

ALTER PROCEDURE GetProductDesc
AS
BEGIN 
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT P.ProductID,P.ProductName,PD.ProductDescription  FROM 
Product P
INNER JOIN ProductDescription PD 
ON P.ProductID=PD.ProductID
END


CREATE PROCEDURE SelectAddress
(@denis INT =100)
AS
begin
select * FROM  PERSON.ADDRESS
WHERE AddressID=@denis
end

execute SelectAddress

CREATE TABLE Employee 
(
EmpID int identity(1,1),
EmpName varchar(500)
)


CREATE PROCEDURE ins_NewEmp_with_outputparamaters
(@Ename varchar(50),
@EId int output)
AS
BEGIN
SET NOCOUNT ON
 
INSERT INTO Employee (EmpName) VALUES (@Ename)
 
SELECT @EId= SCOPE_IDENTITY()
 
END

declare @EmpID INT
 
EXEC ins_NewEmp_with_outputparamaters 'Andrew', @EmpID OUTPUT
 
SELECT @EmpID


-- Local temporary Table--> denoted with #
-- Global temporary tables --> ##


--Local temporary stored procedures
ALTER PROCEDURE #Temp
AS
BEGIN
PRINT 'Local temp procedure'
END
exec #Temp


-- Global temporary stored procedures
ALTER PROCEDURE ##Temp
AS
BEGIN
PRINT 'Local temp procedure'
END
exec ##Temp


--Diference between local and global temporary tables
--local temporary table examples
CREATE TABLE #Product
(ProductID INT, ProductName VARCHAR(100) )
GO

CREATE TABLE #ProductDescription
(ProductID INT, ProductDescription VARCHAR(800) )
GO


 
INSERT INTO #Product VALUES (680,'HL Road Frame - Black, 58')
,(706,'HL Road Frame - Red, 58')
,(707,'Sport-100 Helmet, Red')
GO
 
INSERT INTO #ProductDescription VALUES (680,'Replacement mountain wheel for entry-level rider.')
,(706,'Sturdy alloy features a quick-release hub.')
,(707,'Aerodynamic rims for smooth riding.')
GO


CREATE TABLE #Product
(ProductID INT, ProductName VARCHAR(100) )
GO

CREATE TABLE #ProductDescription
(ProductID INT, ProductDescription VARCHAR(800) )
GO


--Example of Global temporary tables
 
INSERT INTO ##Product VALUES (680,'HL Road Frame - Black, 58')
,(706,'HL Road Frame - Red, 58')
,(707,'Sport-100 Helmet, Red')
GO
 
INSERT INTO ##ProductDescription VALUES (680,'Replacement mountain wheel for entry-level rider.')
,(706,'Sturdy alloy features a quick-release hub.')
,(707,'Aerodynamic rims for smooth riding.')
GO


select * from ##ProductDescription
select * from ##product


ALTER PROCEDURE HelloWorldprocedure
AS
PRINT 'Hello World trainee from Kiawitech Academy'

HelloWorldprocedure


--What is a function in SQL server and how it differs from stored procedure
select Getdate()
select @@version 


ALTER PROCEDURE HelloWorldprocedure
AS
PRINT 'Hello World trainee from Kiawitech Academy'

HelloWorldprocedure


CREATE FUNCTION dbo.helloworldfunction()
RETURNS varchar(20)
AS 
BEGIN
	 RETURN 'Hello world'
END

exec HelloWorldprocedure
execute HelloWorldprocedure
execute dbo.HelloWorldprocedure
HelloWorldprocedure

select dbo.helloworldfunction()

CREATE PROCEDURE CONVERTCELSIUSTOFAHRENHEIT
@celsius real
as
select @celsius*1.8+32 as Fahrenheit


exec CONVERTCELSIUSTOFAHRENHEIT 35


CREATE FUNCTION dbo.f_celsiustofahrenheit(@celcius real)
RETURNS real
AS 
BEGIN
	
	RETURN  @celcius*1.8+32
END

select dbo.f_celsiustofahrenheit(0) as Fahrenheit


