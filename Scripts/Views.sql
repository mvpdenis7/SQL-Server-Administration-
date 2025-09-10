--What is a view?

--A view is a saved SELECT statement that presents data as a virtual table. It stores no data by default (except when indexed) and is resolved at query time.

--Basic syntax
CREATE VIEW dbo.vEmployees
AS
SELECT EmployeeID, FirstName, LastName, DepartmentID
FROM dbo.Employees;
GO

-- Read it
SELECT * FROM dbo.vEmployees;

--Create or modify
-- Preferred (SQL Server 2016 SP1+):
CREATE OR ALTER VIEW dbo.vEmployees
AS
SELECT EmployeeID, FirstName, LastName, DepartmentID
FROM dbo.Employees;
GO

-- Older approach:
IF OBJECT_ID('dbo.vEmployees', 'V') IS NOT NULL DROP VIEW dbo.vEmployees;
GO
CREATE VIEW dbo.vEmployees AS ...

Filtering & enforcing data rules
CREATE OR ALTER VIEW dbo.vUS_Employees
AS
SELECT EmployeeID, FirstName, LastName, Country
FROM dbo.Employees
WHERE Country = 'USA'
WITH CHECK OPTION;   -- prevents inserts/updates via the view that violate Country='USA'

--Updatable views

--You can INSERT/UPDATE/DELETE through a view when:

--It references a single base table (no DISTINCT, GROUP BY, HAVING, UNION, TOP, aggregates, computed columns not schema-bound, etc.).
--All required (non-nullable, no default) columns are present in the view.

---For multi-table or complex views, use an INSTEAD OF trigger:

CREATE OR ALTER VIEW dbo.vEmpDept
AS
SELECT e.EmployeeID, e.FirstName, d.DepartmentName
FROM dbo.Employees e
JOIN dbo.Departments d ON d.DepartmentID = e.DepartmentID;
GO

CREATE TRIGGER dbo.tr_vEmpDept_Ins
ON dbo.vEmpDept INSTEAD OF INSERT
AS
BEGIN
 
 -- Route inserts to base tables appropriately
  INSERT dbo.Employees (EmployeeID, FirstName, DepartmentID)
  SELECT EmployeeID, FirstName, d.DepartmentID
  FROM inserted i
  JOIN dbo.Departments d ON d.DepartmentName = i.DepartmentName;
END
GO

--Performance & “indexed views”

--A normal view is just a macro— no speedup by itself. To persist results and index them, create an indexed view (materialized):

--Make the view schema-bound and meet rules (deterministic expressions, two-part names, etc.).

--Create a unique clustered index on the view.

-- 1) Schema-bound view
CREATE OR ALTER VIEW dbo.vSalesAgg WITH SCHEMABINDING
AS
SELECT s.CustomerID,
       COUNT_BIG(*) AS OrderCount,                 -- COUNT_BIG required
       SUM(s.TotalAmount) AS TotalAmount
FROM dbo.Sales AS s
GROUP BY s.CustomerID;
GO

-- 2) Unique clustered index (materializes the view)
CREATE UNIQUE CLUSTERED INDEX IX_vSalesAgg_CustomerID
ON dbo.vSalesAgg (CustomerID);
GO

-- Optional: encourage use if the optimizer doesn't auto-match
SELECT /*+ NOEXPAND */ CustomerID, TotalAmount
FROM dbo.vSalesAgg;


Notes

--Certain SET options must be ON/OFF at creation and at query time for indexed views (e.g., ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER, ARITHABORT ON; NUMERIC_ROUNDABORT OFF).

The optimizer may auto-use indexed views for matching queries; NOEXPAND can force using the view’s index.

/*Security advantages

Grant access on the view instead of base tables (row/column exposure control).

Leverages ownership chaining to hide base tables.

GRANT SELECT ON dbo.vEmployees TO ReportingRole;

Partitioned views (horizontal federation)

Unify identically-structured tables with UNION ALL. With proper CHECK constraints the optimizer can do partition elimination:**/


CREATE VIEW dbo.vOrders ALL
AS
SELECT * FROM dbo.Orders_2024  -- CHECK(OrderDate >= '2024-01-01' AND < '2025-01-01')
UNION ALL
SELECT * FROM dbo.Orders_2025; -- CHECK(OrderDate >= '2025-01-01' AND < '2026-01-01')


For distributed partitioned views, you can reference linked servers; not compatible with SCHEMABINDING.

==Useful options

WITH SCHEMABINDING --prevents changes to underlying objects (and required for indexed views).

WITH ENCRYPTION  --obfuscates the definition (not strong security; can hinder troubleshooting).

WITH VIEW_METADATA  --returns view’s metadata to clients (niche use).

--Limitations & gotchas

/*
1 No ORDER BY inside a view (unless paired with TOP, but order isn’t guaranteed on select).

2 Can’t reference temp tables; table variables are allowed only via inline table-valued functions, not views.

3 Nested views can get hard to reason about; prefer inline logic or materialization where needed.

4 Views don’t carry base indexes/constraints (except for indexed views’ own indexes).

*/

--Maintenance & introspection
-- See definition
EXEC sp_helptext 'dbo.vEmployees';

-- Dependencies
SELECT * FROM sys.sql_expression_dependencies
WHERE referencing_id = OBJECT_ID('dbo.vEmployees');

-- All views
SELECT name, create_date, modify_date FROM sys.views;

-- Refresh metadata after base changes (non-schema-bound)
EXEC sp_refreshview 'dbo.vEmployees';          -- updates column metadata
EXEC sp_refreshsqlmodule 'dbo.vEmployees';     -- updates stored definition metadata
