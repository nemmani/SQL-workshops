/*
SQL COMPLETE PRACTICAL TUTORIAL
Dialect: Microsoft SQL Server (T-SQL)

How to use:
1. Open SQL Server Management Studio (SSMS) or Azure Data Studio.
2. Run this script in a practice/test database.
3. The script creates fresh tutorial tables and sample data.
4. UPDATE and DELETE examples are wrapped in transactions and rolled back
   so the original sample data remains available for practice.
*/

-- =========================================================
-- 0. CLEANUP: remove tutorial tables if they already exist
-- =========================================================
DROP TABLE IF EXISTS dbo.Employees;
DROP TABLE IF EXISTS dbo.Departments;
GO

-- =========================================================
-- 1. CREATE TABLE
-- =========================================================
CREATE TABLE dbo.Departments (
    DepartmentID   INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE dbo.Employees (
    EmployeeID   INT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    Department   VARCHAR(50),
    Salary       DECIMAL(10,2),
    City         VARCHAR(50),
    Age          INT,
    ManagerID    INT NULL
);
GO

-- =========================================================
-- 2. INSERT DATA
-- =========================================================
INSERT INTO dbo.Departments (DepartmentID, DepartmentName)
VALUES
    (101, 'IT'),
    (102, 'HR'),
    (103, 'Finance'),
    (104, 'Marketing');
GO

INSERT INTO dbo.Employees
    (EmployeeID, EmployeeName, Department, Salary, City, Age, ManagerID)
VALUES
    (1, 'Ravi',   'IT',      60000, 'Hyderabad', 28, NULL),
    (2, 'Priya',  'HR',      45000, 'Bangalore', 26, 1),
    (3, 'Kiran',  'IT',      75000, 'Hyderabad', 32, 1),
    (4, 'Anu',    'Finance', 55000, 'Chennai',   29, 3),
    (5, 'Suresh', 'HR',      40000, 'Hyderabad', 24, 2),
    (6, 'Meena',  'Finance', 80000, 'Bangalore', 35, 3);
GO

-- View all records
SELECT * FROM dbo.Employees;
SELECT * FROM dbo.Departments;
GO

-- =========================================================
-- 3. UPDATE
-- =========================================================
-- Update one employee's salary
BEGIN TRANSACTION;
UPDATE dbo.Employees
SET Salary = 65000
WHERE EmployeeID = 1;

SELECT * FROM dbo.Employees WHERE EmployeeID = 1;
ROLLBACK TRANSACTION; -- Undo this practice change
GO

-- Update multiple columns
BEGIN TRANSACTION;
UPDATE dbo.Employees
SET Salary = 70000,
    City = 'Pune'
WHERE EmployeeID = 2;

SELECT * FROM dbo.Employees WHERE EmployeeID = 2;
ROLLBACK TRANSACTION;
GO

-- Increase IT salaries by 5%
BEGIN TRANSACTION;
UPDATE dbo.Employees
SET Salary = Salary * 1.05
WHERE Department = 'IT';

SELECT * FROM dbo.Employees WHERE Department = 'IT';
ROLLBACK TRANSACTION;
GO

-- IMPORTANT: UPDATE without WHERE changes every row.
-- Do not run broad updates on production tables unintentionally.

-- =========================================================
-- 4. DELETE
-- =========================================================
-- Delete one employee (practice only; transaction is rolled back)
BEGIN TRANSACTION;
DELETE FROM dbo.Employees
WHERE EmployeeID = 5;

SELECT * FROM dbo.Employees;
ROLLBACK TRANSACTION;
GO

-- Delete employees earning less than 45,000 (practice only)
BEGIN TRANSACTION;
DELETE FROM dbo.Employees
WHERE Salary < 45000;

SELECT * FROM dbo.Employees;
ROLLBACK TRANSACTION;
GO

-- DELETE all rows but keep table structure:
-- DELETE FROM dbo.Employees;
--
-- TRUNCATE all rows (cannot use WHERE):
-- TRUNCATE TABLE dbo.Employees;
--
-- Drop the table itself:
-- DROP TABLE dbo.Employees;
--
-- These three commands above are comments and will not execute.

-- =========================================================
-- 5. SQL OPERATORS
-- =========================================================

-- Comparison operators: =, <>, !=, >, <, >=, <=
SELECT * FROM dbo.Employees WHERE Department = 'IT';
SELECT * FROM dbo.Employees WHERE Department <> 'HR';
SELECT * FROM dbo.Employees WHERE Salary > 50000;
SELECT * FROM dbo.Employees WHERE Salary < 60000;
SELECT * FROM dbo.Employees WHERE Salary >= 60000;
SELECT * FROM dbo.Employees WHERE Age <= 30;
GO

-- AND: all conditions must be true
SELECT * FROM dbo.Employees
WHERE Department = 'IT' AND Salary > 60000;
GO

-- OR: at least one condition must be true
SELECT * FROM dbo.Employees
WHERE City = 'Hyderabad' OR City = 'Bangalore';
GO

-- NOT: negate a condition
SELECT * FROM dbo.Employees
WHERE NOT Department = 'HR';
GO

-- BETWEEN: inclusive range
SELECT * FROM dbo.Employees
WHERE Salary BETWEEN 40000 AND 60000;
GO

-- IN: match any listed value
SELECT * FROM dbo.Employees
WHERE Department IN ('IT', 'Finance');
GO

-- LIKE: pattern matching
SELECT * FROM dbo.Employees WHERE EmployeeName LIKE 'R%';    -- Starts with R
SELECT * FROM dbo.Employees WHERE EmployeeName LIKE '%a';    -- Ends with a
SELECT * FROM dbo.Employees WHERE EmployeeName LIKE '%ri%';  -- Contains ri
SELECT * FROM dbo.Employees WHERE EmployeeName LIKE '____';  -- Four characters
GO

-- NULL checks
SELECT * FROM dbo.Employees WHERE ManagerID IS NULL;
SELECT * FROM dbo.Employees WHERE ManagerID IS NOT NULL;
GO

-- Arithmetic operators: +, -, *, /
SELECT EmployeeName,
       Salary,
       Salary + 5000 AS SalaryPlus5000,
       Salary - 2000 AS SalaryMinus2000,
       Salary * 12 AS AnnualSalary,
       Salary / 2 AS HalfSalary
FROM dbo.Employees;
GO

-- DISTINCT, ORDER BY, TOP
SELECT DISTINCT Department FROM dbo.Employees;

SELECT * FROM dbo.Employees
ORDER BY Salary DESC;

SELECT * FROM dbo.Employees
ORDER BY Salary ASC;

SELECT TOP 3 *
FROM dbo.Employees
ORDER BY Salary DESC;
GO

-- =========================================================
-- 6. AGGREGATE FUNCTIONS
-- =========================================================
SELECT COUNT(*) AS TotalEmployees FROM dbo.Employees;
SELECT SUM(Salary) AS TotalSalary FROM dbo.Employees;
SELECT AVG(Salary) AS AverageSalary FROM dbo.Employees;
SELECT MIN(Salary) AS MinimumSalary FROM dbo.Employees;
SELECT MAX(Salary) AS MaximumSalary FROM dbo.Employees;
GO

-- GROUP BY: total salary per department
SELECT Department,
       SUM(Salary) AS TotalSalary
FROM dbo.Employees
GROUP BY Department;
GO

-- Count employees per city
SELECT City,
       COUNT(*) AS EmployeeCount
FROM dbo.Employees
GROUP BY City;
GO

-- Average salary per department
SELECT Department,
       AVG(Salary) AS AverageSalary
FROM dbo.Employees
GROUP BY Department;
GO

-- HAVING: filter groups after aggregation
SELECT Department,
       AVG(Salary) AS AverageSalary
FROM dbo.Employees
GROUP BY Department
HAVING AVG(Salary) > 50000;
GO

SELECT Department,
       COUNT(*) AS EmployeeCount
FROM dbo.Employees
GROUP BY Department
HAVING COUNT(*) >= 2;
GO

-- =========================================================
-- 7. JOINS
-- Employees.Department matches Departments.DepartmentName
-- =========================================================

-- INNER JOIN: only matching rows
SELECT E.EmployeeName, E.Department, D.DepartmentID
FROM dbo.Employees AS E
INNER JOIN dbo.Departments AS D
    ON E.Department = D.DepartmentName;
GO

-- LEFT JOIN: every employee, matching department when available
SELECT E.EmployeeName, E.Department, D.DepartmentID, D.DepartmentName
FROM dbo.Employees AS E
LEFT JOIN dbo.Departments AS D
    ON E.Department = D.DepartmentName;
GO

-- RIGHT JOIN: every department, employees when available
SELECT E.EmployeeName, D.DepartmentName
FROM dbo.Employees AS E
RIGHT JOIN dbo.Departments AS D
    ON E.Department = D.DepartmentName;
GO

-- FULL OUTER JOIN: matching and nonmatching rows from both tables
SELECT E.EmployeeName, E.Department, D.DepartmentName
FROM dbo.Employees AS E
FULL OUTER JOIN dbo.Departments AS D
    ON E.Department = D.DepartmentName;
GO

-- CROSS JOIN: every possible employee-department combination
SELECT E.EmployeeName, D.DepartmentName
FROM dbo.Employees AS E
CROSS JOIN dbo.Departments AS D;
GO

-- SELF JOIN: employee and manager names
SELECT E.EmployeeName AS Employee,
       M.EmployeeName AS Manager
FROM dbo.Employees AS E
LEFT JOIN dbo.Employees AS M
    ON E.ManagerID = M.EmployeeID;
GO

-- =========================================================
-- 8. SUBQUERIES
-- =========================================================

-- Employees earning more than the average salary
SELECT *
FROM dbo.Employees
WHERE Salary > (
    SELECT AVG(Salary)
    FROM dbo.Employees
);
GO

-- Employees in the IT department
SELECT *
FROM dbo.Employees
WHERE Department IN (
    SELECT DepartmentName
    FROM dbo.Departments
    WHERE DepartmentName = 'IT'
);
GO

-- Second-highest distinct salary
SELECT MAX(Salary) AS SecondHighestSalary
FROM dbo.Employees
WHERE Salary < (
    SELECT MAX(Salary)
    FROM dbo.Employees
);
GO

-- =========================================================
-- 9. CASE EXPRESSION
-- =========================================================
SELECT EmployeeName,
       Salary,
       CASE
           WHEN Salary >= 70000 THEN 'High Salary'
           WHEN Salary >= 50000 THEN 'Medium Salary'
           ELSE 'Low Salary'
       END AS SalaryCategory
FROM dbo.Employees;
GO

-- =========================================================
-- 10. COMBINED PRACTICAL QUERY
-- Departments with at least 2 employees and average salary > 45,000
-- =========================================================
SELECT Department,
       COUNT(*) AS TotalEmployees,
       SUM(Salary) AS TotalSalary,
       AVG(Salary) AS AverageSalary,
       MAX(Salary) AS HighestSalary,
       MIN(Salary) AS LowestSalary
FROM dbo.Employees
WHERE Salary >= 40000
GROUP BY Department
HAVING COUNT(*) >= 2
   AND AVG(Salary) > 45000
ORDER BY AverageSalary DESC;
GO

-- =========================================================
-- 11. COMMON SQL EXECUTION ORDER
-- FROM / JOIN -> WHERE -> GROUP BY -> HAVING -> SELECT -> ORDER BY
-- =========================================================
