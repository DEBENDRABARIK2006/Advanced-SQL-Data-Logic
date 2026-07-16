CREATE TABLE newDepartment (
    DeptId INT PRIMARY KEY,
    DeptName VARCHAR(50)
);
CREATE TABLE newEmployee (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Gender VARCHAR(10),
    DepartmentId INT,
    FOREIGN KEY (DepartmentId) REFERENCES newDepartment(DeptId)
);

INSERT INTO newDepartment (DeptId, DeptName) VALUES
(1, 'IT'),
(2, 'Payroll'),
(3, 'HR'),
(4, 'Admin');

INSERT INTO newEmployee (Id, Name, Gender, DepartmentId) VALUES
(1, 'John', 'Male', 3),
(2, 'Mike', 'Male', 2),
(3, 'Pam', 'Female', 1),
(4, 'Todd', 'Male', 4),
(5, 'Sara', 'Female', 1),
(6, 'Ben', 'Male', 3);

/*
 Important:
   - Views do NOT store data physically (unless indexed view)
   - If used only once, alternatives like:
        * CTE (Common Table Expression)
        * Derived Tables
        * Temporary Tables
        * Table Variables
     can be better options

*/

CREATE VIEW newvwEmployeeCount
AS
SELECT 
    d.DeptName,
    e.DepartmentId,
    COUNT(*) AS TotalEmployees
FROM newEmployee e
JOIN newDepartment d
    ON e.DepartmentId = d.DeptId
GROUP BY d.DeptName, e.DepartmentId;

SELECT DeptName, TotalEmployees
FROM newvwEmployeeCount
WHERE TotalEmployees >= 2;

select * from newDepartment;
select* from newEmployee;
select * from newvwEmployeeCount;

-- temp table
--DROP TABLE #newTempEmployeeCount;
/*
Temporary Tables in SQL Server:

   1. Stored in TempDB database
   2. Local Temp Table (#table):
        - Visible only in current session
   3. Can be accessed by nested stored procedures
   4. Automatically destroyed when:
        - Session ends OR
        - Last connection using it is closed

*/

SELECT 
    d.DeptName,
    e.DepartmentId,
    COUNT(*) AS TotalEmployees
INTO #newTempEmployeeCount
FROM newEmployee e
JOIN newDepartment d
    ON e.DepartmentId = d.DeptId
GROUP BY d.DeptName, e.DepartmentId;


SELECT DeptName, TotalEmployees
FROM #newTempEmployeeCount
WHERE TotalEmployees >= 2;

--  TABLE VARIABLE APPROACH
/*
 Table Variables in SQL Server:

   1. Declared using DECLARE statement
   2. Stored in TempDB (like temp tables)
   3. Scope is limited to:
        - Current batch
        - Stored procedure
        - Function

   4. Automatically destroyed when:
        - Batch execution ends

*/

DECLARE @newEmployeeCount TABLE (
    DeptName NVARCHAR(20),
    DepartmentId INT,
    TotalEmployees INT
);

INSERT INTO @newEmployeeCount
SELECT 
    d.DeptName,
    e.DepartmentId,
    COUNT(*) AS TotalEmployees
FROM newEmployee e
JOIN newDepartment d
    ON e.DepartmentId = d.DeptId
GROUP BY d.DeptName, e.DepartmentId;

SELECT DeptName, TotalEmployees
FROM @newEmployeeCount
WHERE TotalEmployees >= 2;

/*
Derived Table in SQL Server:

   1. A derived table is a subquery inside the FROM clause
   2. It behaves like a temporary table during query execution
   3. Must always have an alias (here: EmployeeCount)

   Scope:
   - Exists only for this query execution
   - Not stored in database
*/
SELECT DeptName, TotalEmployees
FROM
(
    SELECT 
        d.DeptName,
        e.DepartmentId,
        COUNT(*) AS TotalEmployees
    FROM newEmployee e
    JOIN newDepartment d
        ON e.DepartmentId = d.DeptId
    GROUP BY d.DeptName, e.DepartmentId
) AS EmployeeCount
WHERE TotalEmployees >= 2;
-- derived tables are available only in the context of the current query 

/*
 Common Table Expression (CTE):

   1. Defined using WITH keyword
   2. Acts like a temporary result set
   3. Used within a single query

   Scope:
   - Exists only during execution of the query
   - Not stored in the database
*/

WITH EmployeeCount (DeptName, DepartmentId, TotalEmployees)
AS
(
    SELECT 
        d.DeptName,
        e.DepartmentId,
        COUNT(*) AS TotalEmployees
    FROM newEmployee e
    JOIN newDepartment d
        ON e.DepartmentId = d.DeptId
    GROUP BY d.DeptName, e.DepartmentId
)

SELECT DeptName, TotalEmployees
FROM EmployeeCount
WHERE TotalEmployees >= 2;



with count_employee(departmentid,totalemployee)
as
(
select departmentid,count(*) as totalemployee
from newEmployee 
group by DepartmentId
)
--select ('hello')
select deptname ,totalemployee
from newDepartment
join count_employee
on newDepartment.DeptId=count_employee.departmentid
order by totalemployee

/*
A Common Table Expression (CTE) was introduced in SQL Server 2005.

A CTE is a temporary result set that can be referenced within a 
SELECT, INSERT, UPDATE, or DELETE statement.

The statement that uses the CTE must immediately follow the CTE definition.
*/

-- Creating multiple CTE's using a single WITH clause

WITH EmployeesCountBy_Payroll_IT_Dept (DepartmentName, Total)
AS
(
    SELECT d.DeptName, COUNT(e.Id) AS TotalEmployees
    FROM newEmployee e
    JOIN newDepartment d
        ON e.DepartmentId = d.DeptId
    WHERE d.DeptName IN ('Payroll', 'IT')
    GROUP BY d.DeptName
),
EmployeesCountBy_HR_Admin_Dept (DepartmentName, Total)
AS
(
    SELECT d.DeptName, COUNT(e.Id) AS TotalEmployees
    FROM newEmployee e
    JOIN newDepartment d
        ON e.DepartmentId = d.DeptId
    WHERE d.DeptName IN ('HR', 'Admin')
    GROUP BY d.DeptName
)

SELECT * 
FROM EmployeesCountBy_HR_Admin_Dept

UNION

SELECT * 
FROM EmployeesCountBy_Payroll_IT_Dept;

--updateable common table expression
with employees_name_gender
as
(
select id, name, gender from newEmployee
)
select* from employees_name_gender
--update
with employees_name_gender
as
(
select id, name, gender from newEmployee
)
update employees_name_gender set name='Debendra' where id=1
/*
if a CTE is created on base table, then it is possible to update the CTE
which in turn will update the underlying base table
update CTE , updates base table .
*/

select*  from newDepartment;
select* from newEmployee;

--CTE on 2 base tables
with employeesbydepartment
as
(
select id , name,gender,deptname
from newemployee
join newDepartment
on newDepartment.deptid=newemployee.id
)
select * from employeesbydepartment

--CTE on 2 base table , update affecting only one base table
with employeesbydepartment
as
(
select id , name,gender,deptname
from newemployee
join newDepartment
on newDepartment.deptid=newemployee.id
)
update employeesbydepartment set gender='Female' where id=2

--if the update statement affects more than 1 base table , then update is not allowed
with employeesbydepartment
as
(
select id , name,gender,deptname
from newemployee
join newDepartment
on newDepartment.deptid=newemployee.id
)
update employeesbydepartment set DeptName='CSE',name='Debendra_barik' where id=1

--if the update affects only base table , the update succeeds
with employeesbydepartment
as
(
select id , name,gender,deptname
from newemployee
join newDepartment
on newDepartment.deptid=newemployee.id
)
update employeesbydepartment set DeptName='CS' where id=1


--recursive CTE

CREATE TABLE tblEmployeee
(
    EmployeeId INT PRIMARY KEY,
    Name VARCHAR(50),
    ManagerId INT NULL
);
INSERT INTO tblEmployeee VALUES (1, 'Tom', 2);
INSERT INTO tblEmployeee VALUES (2, 'Josh', NULL);
INSERT INTO tblEmployeee VALUES (3, 'Mike', 2);
INSERT INTO tblEmployeee VALUES (4, 'John', 3);
INSERT INTO tblEmployeee VALUES (5, 'Pam', 1);
INSERT INTO tblEmployeee VALUES (6, 'Mary', 3);
INSERT INTO tblEmployeee VALUES (7, 'James', 1);
INSERT INTO tblEmployeee VALUES (8, 'Sam', 5);
INSERT INTO tblEmployeee VALUES (9, 'Simon', 1);

select * from tblEmployeee
SELECT 
    Employee.Name AS [Employee Name],
    ISNULL(Manager.Name, 'Super Boss') AS [Manager Name]
FROM tblEmployeee Employee
LEFT JOIN tblEmployeee Manager
    ON Employee.ManagerId = Manager.EmployeeId;

----------
WITH EmployeesCTE (EmployeeId, Name, ManagerId, [Level])
AS
(
    -- Anchor Member (Top-level managers)
    SELECT EmployeeId, Name, ManagerId, 1 AS [Level]
    FROM tblEmployeee
    WHERE ManagerId IS NULL

    UNION ALL
    
-- Recursive Member
SELECT e.EmployeeId, e.Name, e.ManagerId, cte.[Level] + 1
FROM tblEmployeee e
JOIN EmployeesCTE cte
ON e.ManagerId = cte.EmployeeId
)

SELECT 
    EmpCTE.Name AS Employee,
    ISNULL(MgrCTE.Name, 'Super Boss') AS Manager,
    EmpCTE.[Level]
FROM EmployeesCTE EmpCTE
LEFT JOIN EmployeesCTE MgrCTE
    ON EmpCTE.ManagerId = MgrCTE.EmployeeId;