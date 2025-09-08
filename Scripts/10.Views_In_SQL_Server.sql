/*VIEWS IN SQL SERVER

WHAT IS A VIEW?
A view is just a saved SQL query and can be considered as a virtual table.
A view contains rows and columns, just like a real table. 
The fields in a view are fields from one or more real tables in the database.

You can add SQL statements and functions to a view and present the data as if the data were coming from one single table.

A view is created with the CREATE VIEW statement. 

FORMS OF VIEWS
SQL Server views are in two forms;

1. SIMPLE VIEW   - Simple view is view created using only one table as base table.

2. COMPLEX VIEW  - Complex view is view created on more than 1 tables. This therefore means that a view with JOIN is a complex view.*/

----Types of System defined views

--1. Dynamic Management views: provide information about the server state to diagnose problems, monitor the health and the current-state of the SQL server machine

--This returns current session information 
SELECT login_name ,COUNT(session_id) AS session_count  
FROM sys.dm_exec_sessions  
GROUP BY login_name;
 
--To see all SQL Server connections
SELECT connection_id,session_id,client_net_address,
auth_scheme FROM sys.dm_exec_connections ;

--2: Catalog Views: return information that is used by the SQL Server Database engine for example info concerning objects, logins, permissions etc.

--Display all the tables in the database
SELECT * FROM sys.objects 
WHERE type_desc = 'USER_TABLE' 

--Display all the tables in the database with additional columns specific to table 
SELECT * FROM sys.tables 

--Display all the views in the database 
SELECT * FROM sys.objects 
WHERE type_desc = 'VIEW'

--Display all the views in the database with additional columns specific to view 
SELECT * FROM sys.views

--3. Information Schema Views: These views allow you to retrieve metadata about the objects within a database.

--Following is the SQL statement to view detailed information of the columns of table tblEmployee
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='tblEmployee'; 

--The following INFORMATION_SCHEMA.CHECK_CONSTRAINTS returns information about constraints of a table.
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS  
WHERE TABLE_NAME ='tblEmployee';

--The following INFORMATION_SCHEMA.VIEWS will return all the views present in the current database.
SELECT * FROM INFORMATION_SCHEMA.VIEWS ;

/*
ONCE A VIEW HAS BEEN CREATED, YOU CAN QUERY IT AS A TABLE AND YOU CAN EVEN CREATE ANOTHER VIEW FROM AN EXISTING VIEW. NOTE THAT ANY UPDATE DONE IN A VIEW REFLECTS IN THE MOTHER TABLE OR TABLES WHERE THAT COLUMNS WAS DRAWN FROM TO CREATE VIEW.

Assume you are a DBA for the examination board in your country

*/

Use Master
CREATE DATABASE ExamsBoardDB

USE ExamsBoardDB

CREATE TABLE Candidates (
CandidateID INT, 
CandidateName varchar(255), 
IndividualDiscountsOnSubjects int, 
Gender varchar(6))

CREATE TABLE SubjectsRegistered (
Candidate_ID INT, 
SubjectCode Varchar(MAX))


INSERT INTO CANDIDATES VALUES ('1', 'Vandy', '0','Female')       
INSERT INTO CANDIDATES VALUES ('2', 'Jak', '1000','Male')      
INSERT INTO CANDIDATES VALUES ('3', 'Mary', '0', 'Female')       
INSERT INTO CANDIDATES VALUES ('4', 'Annie', '0', 'Female')       
INSERT INTO CANDIDATES VALUES ('5', 'Linda', '0', 'Female')       
INSERT INTO CANDIDATES VALUES ('6', 'William', '1500','Male')       
INSERT INTO CANDIDATES VALUES ('7', 'Leo', '800', 'Male')       
INSERT INTO CANDIDATES VALUES ('8', 'Udy', '200','Female')      
INSERT INTO CANDIDATES VALUES ('9', 'Taiwo', '4000','Male')       
INSERT INTO CANDIDATES VALUES ('10', 'Ebenezer','150','Male')
INSERT INTO CANDIDATES VALUES ('11', 'Maurine', '350','Female')      
INSERT INTO CANDIDATES VALUES ('12', 'Cedric','0','Male')       
INSERT INTO CANDIDATES VALUES ('13', 'Stephen','0', 'Male')  

INSERT INTO SubjectsRegistered VALUES ('7', 'MATH101')       
INSERT INTO SubjectsRegistered VALUES ('9', 'ENG202')      
INSERT INTO SubjectsRegistered VALUES ('11', 'MATH101')       
INSERT INTO SubjectsRegistered VALUES ('6', 'BIO303')                   
INSERT INTO SubjectsRegistered VALUES ('10', 'LIT808')            
INSERT INTO SubjectsRegistered VALUES ('10', 'PHY505')
INSERT INTO SubjectsRegistered VALUES ('8', 'CHE404')      
INSERT INTO SubjectsRegistered VALUES ('9', 'BIO303')    
INSERT INTO SubjectsRegistered VALUES ('2', 'MATH101')
INSERT INTO SubjectsRegistered VALUES ('14', 'GEO909')

SELECT * FROM Candidates
SELECT * FROM SubjectsRegistered

---Simple views
IF OBJECT_ID('vWcandidates', 'V') IS NOT NULL
    DROP VIEW vWcandidates;

create view vWcandidates
as
SELECT * FROM Candidates
select [CandidateID], [CandidateName] from vWcandidates


create view vWSubjectsRegistered
AS
SELECT * FROM SubjectsRegistered

---Let say you want to hide some number from subject code
CREATE VIEW vWCodeMasked
AS
SELECT Candidate_ID, '***' + SUBSTRING(SubjectCode, 7, 3) AS Expr1
FROM     dbo.SubjectsRegistered
GO

select * from vWCodeMasked

--Let say your manager comes and ask you to generate information from the tables to be shared with some external parties who are not part of your organization.
  
--First thing: you have to join the tables with all the required data 

-- JOINING TWO TABLES AND CREATING A VIEW
SELECT LEFTTABLE.CandidateID, LEFTTABLE.CandidateName, LEFTTABLE.IndividualDiscountsOnSubjects, LEFTTABLE.Gender, RIGHTTABLE.SubjectCode
FROM Candidates AS LEFTTABLE
JOIN SubjectsRegistered AS RIGHTTABLE
ON LEFTTABLE.CandidateID=RIGHTTABLE.Candidate_ID


-- OR THE SCRIPT CAN ALSO BE WRITTEN THIS WAY SINCE THERE IS A DISTINCTION ON THE CANDIDATEID COLUMN IN BOTH TABLES
SELECT CandidateID, CandidateName, IndividualDiscountsOnSubjects, Gender, SubjectCode
FROM Candidates
FULL JOIN SubjectsRegistered
ON CandidateID=Candidate_ID


SELECT * FROM Candidates
SELECT * FROM SubjectsRegistered


--- CREATE A VIEW USING T-SQL
CREATE VIEW vWCandidatesBySubjectsRegistered
AS
SELECT CandidateID, CandidateName, IndividualDiscountsOnSubjects, Gender, SubjectCode
FROM Candidates
JOIN SubjectsRegistered
ON CandidateID=Candidate_ID

SELECT * FROM [dbo].[vWCandidatesBySubjectsRegistered]

--TO VIEW THE SAVED QUERY OF A VIEW
sp_helptext vWCandidatesBySubjectsRegistered


SELECT * FROM vWCandidatesBySubjectsRegistered

SELECT *FROM vWCandidatesBySubjectsRegistered WHERE CandidateName='Udy';


/* SCENARIOS OR ADVANTAGES OF VIEWS

--1 - Views can be used as a way of reducing complexity of database tables especially for non-IT users. If they need to access data from two or more tables, as a DBA, you can just create a view for what they need and give them access to it. */


--2 - VIEWS TO ENFORCE ROWS LEVEL SECURITY

CREATE VIEW vWMathsCandidates
AS
SELECT CandidateID, CandidateName, IndividualDiscountsOnSubjects, Gender, SubjectCode
FROM Candidates
JOIN SubjectsRegistered
ON CandidateID=Candidate_ID
WHERE SubjectCode='MATH101'

SELECT *FROM vWMathsCandidates
Select *FROM vWMathsCandidates WHERE CandidateName='Jak'


--3 -- VIEW TO ENFORCE COLUMN LEVEL SECURITY  (More often, some columns contain data that is not supposed to be viewed by everyone)

CREATE VIEW vWNonConfidentialData
AS
SELECT CandidateID, CandidateName, Gender, SubjectCode
FROM Candidates
JOIN SubjectsRegistered
ON CandidateID=Candidate_ID


SELECT *FROM vWNonConfidentialData
Select *FROM vWNonConfidentialData WHERE IndividualDiscountsOnSubjects='4000'   --(Cannot be displayed since the column was not included)---


-- 4 -- VIEW TO PRESENT ONLY AGREGATE DATA AND NOT DETAILED DATA

CREATE VIEW vWSummarizedAgregate
AS
SELECT SUM(IndividualDiscountsOnSubjects) AS TOTAL_DISCOUNT_TO_CANDIDATES
FROM Candidates 

-- Execute a select to see
SELECT *FROM vWSummarizedAgregate    --(execute only this Line first)
WHERE IndividualDiscountsOnSubjects='4000'   -- (now execute the 2 lines to see if you can get specific record)


--TO CREATE A VIEW--

CREATE VIEW vWExamCandidates AS
SELECT [CandidateID], [CandidateName]
FROM [dbo].[Candidates]

Select * from vWExamCandidates


-- TO UPDATE A VIEW--
UPDATE vWExamCandidates
SET CandidateName = 'Zebedee'
WHERE CandidateName = 'Jak';   --(Do a Select on the base table "Candidates" table itself and see that the record is also updated)

Select * from vWExamCandidates


-- TO DROP (Delete) A VIEW
DROP VIEW vWExamCandidates

--CREATE A VIEW FROM ANOTHER VIEW--
Create View vWExamCandidates_New AS
Select * FROM vWExamCandidates
WHERE CandidateID >8

Select * FROM vWExamCandidates_New

create view vwDiscount
as
select * from Candidates where IndividualDiscountsOnSubjects>0

alter table Candidates 
add column_name datatpes 
--NB: you can filter by adding WHERE...etc, no problem. It all depends on your needs.


---Limitations of views

--1: Cannot Create Views on Temporary Tables
CREATE TABLE ##PatientTable
(
   id int,
   name VARCHAR (20),
   blood_group VARCHAR (20)
)

INSERT INTO ##PatientTable
VALUES (1, 'Mark', 'O+'),
(2, 'Fred', 'A-'),
(3, 'Joe', 'AB+'),
(4, 'Elice', 'B+'),
(5, 'Marry', 'O-')  

--Let create a view on the temporary table
CREATE VIEW ViewPatientTable
AS
SELECT id, name, blood_group
FROM ##PatientTable   

--Unfortunately, there is no solution to this problem. You have to use permanent tables if you want to implement views.

--2. Cannot Use ORDER BY Clause with Views
ALTER VIEW ViewBookDetails
AS
SELECT id, name, price
FROM Books
ORDER BY price   --produces an error

---Solution
ALTER VIEW ViewBookDetails
AS
SELECT TOP 3
id, name, price
FROM Books
ORDER BY price

--4:  Views cannot have RULES and DEFAULTS
/*Rules and Defaults cannot be associated with views. This is because views do not store actual data, they are merely SQL statements. Therefore, it makes sense that they do not have any RULES and DEFAULTS.*/
