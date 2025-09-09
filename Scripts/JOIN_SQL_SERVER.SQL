---========JOINS IN SQL Server =======----

/*DEMO-Practicals
Assume that a Manager for a company (Amazon) you are currently employed as a DBA requires some reports to present to auditors. The company has a database called AuditDB with four tables created to capture information for Employees, Departments, Managers and Projects within the company.*/

----Creating a database SQLSERVER_JOINS

Create database SQLSERVER_JOINS

use SQLSERVER_JOINS;

CREATE TABLE Employee
(
Emp_ID nvarchar(5) NOT NULL PRIMARY KEY,
Emp_Name VARCHAR(15) Not NULL,
Salary Int,
SSN INT NOT NULL UNIQUE,
Dept_ID nvarchar(5) not NULL,
Manager_ID nvarchar(5) NOT NULL
);


CREATE TABLE Manager
(
Manager_ID nvarchar(5) not null,
Manager_Name varchar(15),
Dept_ID nvarchar(5) not NULL
);


CREATE TABLE Department
(
Dept_ID nvarchar(5) not null,
Dept_Name varchar(15)
);


CREATE TABLE Project
(
Project_ID nvarchar(5) not null,
Project_Name varchar(30),
Project_Member_ID nvarchar(5) not NULL
);

---Inserting data into a table

INSERT INTO Employee VALUES ('E1', 'Louis', 45002, 2312, 'D1', 'M1')
INSERT INTO Employee VALUES ('E2', 'Paul', 25007, 3412, 'D1', 'M1')
INSERT INTO Employee VALUES ('E3', 'Smith', 55010, 5423, 'D2', 'M2')
INSERT INTO Employee VALUES ('E4', 'Gregg', 30007, 2034, 'D2', 'M2')
INSERT INTO Employee VALUES ('E5', 'Killian', 65008, 5634, 'D10', 'M3')
INSERT INTO Employee VALUES ('E6', 'Nouris', 40012, 3545, 'D10', 'M3')
INSERT INTO Employee VALUES ('E7', 'Samuel', 50654, 8901, 'D5', 'M2')
INSERT INTO Employee VALUES ('E8', 'Roger', 65090, 7356, 'D6', 'M5')
INSERT INTO Employee VALUES ('E9', 'Godson', 40032, 9067, 'D9', 'M4')
INSERT INTO Employee VALUES ('E10', 'Robert', 50035, 8632, 'D10', 'M4')


INSERT INTO Manager VALUES ('M1', 'Joe',  'D3')
INSERT INTO Manager VALUES ('M2', 'Mike', 'D2')
INSERT INTO Manager VALUES ('M3', 'Lawrence', 'D3')
INSERT INTO Manager VALUES ('M4', 'Peter', 'D1')
INSERT INTO Manager VALUES ('M5', 'Elias',  'D4')


INSERT INTO Department VALUES ('D1', 'IT')
INSERT INTO Department VALUES ('D2', 'HR')
INSERT INTO Department VALUES ('D3', 'Finance')
INSERT INTO Department VALUES ('D4', 'ServiceDesk')
INSERT INTO Department VALUES ('D5', 'Marketing')


INSERT INTO Project VALUES ('P1', 'Data Migration', 'E1')
INSERT INTO Project VALUES ('P1', 'Data Migration', 'E2')
INSERT INTO Project VALUES ('P1', 'Data Migration', 'E3')
INSERT INTO Project VALUES ('P2', 'Index Maintenance', 'M3')
INSERT INTO Project VALUES ('P3', 'Virtualization',  'E3')
INSERT INTO Project VALUES ('P4', 'Database Security', 'E4')
INSERT INTO Project VALUES ('P5', 'Replication', 'E5')
INSERT INTO Project VALUES ('P5', 'Replication', 'E6')
INSERT INTO Project VALUES ('P6', 'Log Shipping', 'E2')
INSERT INTO Project VALUES ('P7', 'Patches', 'M1')

select * from Employee;
select * from Department;
select * from Manager;
select * from Project;


----Most important joins in sql are INNER JOINS, LEFT OUTER JOINS, RIGHT OUTER JOINS AND FULL JOINS

--Tickets

--1.  Fetch data from the tables showing the employee name and the department they belong to.

		--Check which tables we need i.e (Employee + Dept tables). 

--INNER JOIN/JOIN = Records that are matched on both tables. Records present on both tables



Select e.emp_name, d.dept_name					
from employee e                                  --table after 'from' is left table (Employee) and table after 'Join' is Right table
inner join department d 
on e.Dept_ID = d.Dept_ID  --'on' is the condition of joining tables and what matters is the datatype on the columns and not								the naming of the columns. N:B: Datatype must be the same (ID columns= Intergal)


--2. Fetch data for ALL employees names and the department they belong to.

	--LEFT JOIN = Left table becomes main table. 
	--Left join = inner join + any additional records in the left table
Select e.emp_name, d.dept_name					
from employee e                                
Left join department d 
on e.Dept_ID = d.Dept_ID

--3. Fetch data for ALL employees names, their Salaries, SSN and the department they belong to.

Select e.emp_name, e.salary, e.SSN, d.dept_name					
from employee e                                
left join department d 
on e.Dept_ID = d.Dept_ID


--4. Fetch data of Department names with ALL the manager names supervising the department.

	--RIGHT JOIN = inner join + any additional records from the right table

Select d.dept_name, m.manager_name					
from department d                                
right join Manager m 
on d.Dept_ID = m.Dept_ID


--5. Fetch data of ALL Department names with the manager names supervising the departments.
Select d.dept_name, m.manager_name					
from Department d                                
left join Manager m 
on d.Dept_ID = m.Dept_ID


--6. Fetch details of ALL employees, their manager, their departments and ALL the projects they work on
--NB: Task is to fetch only all the employees (Main Table)

select e.emp_name, m.manager_name, d.dept_name, p.project_name
from employee e
left join department d on e.dept_id = d.dept_id
Inner join manager m on e.manager_id = m.manager_id
left join project p on p.project_member_id = e.emp_id  --The left join here applies to all tables up to that join 


--7. Fetch details of ALL employees, their manager, their departments and the projects they work on

select e.emp_name, d.dept_name, m.manager_name, p.project_name
from employee e
left join department d on e.dept_id = d.dept_id
inner join manager m on e.manager_id = m.manager_id
right join project p on p.project_member_id = e.emp_id

--8. Fetch details of ALL employees, ALL manager, ALL departments and ALL the projects they work on

--FULL JOINS = INNER JOIN 
--			+ all remaining records from the left Table (return null values for any columns fetched)
--			+ all remaining records from the right Table (return null values for any columns fetched)

select e.emp_name, d.dept_name, m.manager_name, p.project_name
from employee e
FULL join department d on e.dept_id = d.dept_id
FULL join manager m on e.manager_id = m.manager_id
FULL join project p on p.project_member_id = e.emp_id


--9. CROSS JOIN = returns CARTESIAN PRODUCT - every record from the left hand table will match with	records from the right side table
select e.emp_name, d.dept_name
from employee e 
cross join department d;		--join condition not required in this type of join.
								--returns 50 records which means that every single empoyee from employees table was matched with every single department from department table (10*5 = 50)
								--used when u can't join two tables based on corresponding columns

--NATURAL JOINS - SQL decides what is the join condition. i.e decides which columns the joins conditions should actually be on and not the user (Discouraged).

select e.emp_name, d.Dept_name
from employee e 
natural join department d;			--It looks for tables sharing the same name no matter the data type



--SELF JOINS - joining a table to itself.
--To explain self joins, let's create a table called family

CREATE TABLE Family
(
Member_ID nvarchar(5) NOT NULL PRIMARY KEY,
Name VARCHAR(15) Not NULL,
Age Int,
Parent_ID nvarchar(5) NULL,
)

INSERT INTO Family VALUES ('F1', 'David', 4, 'F5')
INSERT INTO Family VALUES ('F2', 'Carol', 10, 'F5')
INSERT INTO Family VALUES ('F3', 'Micheal', 12, 'F5')
INSERT INTO Family VALUES ('F4', 'Johnson', 36, 'F6')
INSERT INTO Family VALUES ('F5', 'Maryben', 40, 'F6')
INSERT INTO Family VALUES ('F6', 'Stephen', 70, 'F5')
INSERT INTO Family VALUES ('F7', 'Robben', 6, 'F4')
INSERT INTO Family VALUES ('F8', 'Asha', 8, 'F4')

select * from Family;
delete from Family;

/*Just by looking at the table we can see a linkage between member_id and parent_id, so we can actually search to know who is the parent of which family member but the challenge is that we don't have two tables to be able to identify the child and parent relationship. We only have one table with the information. We definitely have 

10. Using the table on Family; write a query to fetch the child name and their age corresponding to their parent name and parent ages.*/

select child.name as child_name
, child.age as child_age
, parent.name as parent_name
, parent.age as parent_age 
from family as child										   --remember to give right alias in this situation
join family as parent on child.parent_id = parent.member_id    --In this case, we just use the joins. However, we can use															left join, in that case it will return the records for all		children even if they don't have parents. Opposite with right joins.



---===========UNION OPERATORS===========---------
	/* The UNION operator is used to combine the result-set of two or more SELECT statements.

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

--The column names in the result-set are usually equal to the column names in the first SELECT statement.

	/*NOTE THAT the UNION Operator SELECTs only distinct values by default. To allow duplicate values, use UNION ALL.*/
--Demo


--1. UNION Example: Combining Two Queries
--Combine employees and business contacts into a single list of names, removing duplicates.(Slower because it filters or searches through the database to remove duplicates)*/

USE AdventureWorks2019;
GO

SELECT 
    FirstName, LastName, 'Employee' AS Source
FROM Person.Person AS p
INNER JOIN HumanResources.Employee AS e
    ON p.BusinessEntityID = e.BusinessEntityID

UNION

SELECT 
    FirstName, LastName, 'Business Contact' AS Source
FROM Person.Person AS p
INNER JOIN Person.BusinessEntityContact AS bec
    ON p.BusinessEntityID = bec.BusinessEntityID;


--2. UNION ALL Example: Including Duplicates (Faster, presents results without filtering)
SELECT 
    FirstName, LastName, 'Employee' AS Source
FROM Person.Person AS p
INNER JOIN HumanResources.Employee AS e
    ON p.BusinessEntityID = e.BusinessEntityID

UNION ALL

SELECT 
    FirstName, LastName, 'Business Contact' AS Source
FROM Person.Person AS p
INNER JOIN Person.BusinessEntityContact AS bec
    ON p.BusinessEntityID = bec.BusinessEntityID;
