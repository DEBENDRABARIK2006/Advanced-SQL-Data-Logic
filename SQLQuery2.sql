use SAMPLE1
--group by
CREATE TABLE Employees (
    ID INT PRIMARY KEY,
    Name VARCHAR(50),
    Gender VARCHAR(10),
    Salary INT,
    City VARCHAR(50)
);

INSERT INTO Employees (ID, Name, Gender, Salary, City) VALUES
(1, 'Tom', 'Male', 4000, 'London'),
(2, 'Pam', 'Female', 3000, 'New York'),
(3, 'John', 'Male', 3500, 'London'),
(4, 'Sam', 'Male', 4500, 'London'),
(5, 'Todd', 'Male', 2800, 'Sydney'),
(6, 'Ben', 'Female', 2800, 'New York'),
(7, 'Sara', 'Female', 4800, 'Sydney'),
(8, 'Valarie', 'Female', 5500, 'New York'),
(9, 'James', 'Male', 6500, 'London'),
(10, 'Russell', 'Male', 8800, 'London');

SELECT * FROM Employees;

--agregate function 
select SUM(salary) from Employees
select MAX(salary) from Employees
select MIN(salary) from Employees
SELECT AVG(Salary) FROM Employees
SELECT COUNT(*) FROM Employees --Counts total number of rows (employees)
select COUNT(salary) from Employees
--grouping by single column
select city , SUM(salary) as totalsalary from Employees group by City
select gender , MAX(salary) as maxsalary from Employees group by gender
--grouping by multiple column
select city,gender , SUM(salary) as totalsalary from Employees group by City,gender
--use multiple aggregate function
select city,gender , SUM(salary) as totalsalary, COUNT(id) as [total employee] from Employees group by City,gender

select city,gender , SUM(salary) as totalsalary, COUNT(id) as [total employee] from Employees group by City,gender having gender='male'


--inner join
CREATE TABLE Departments (
    Id INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    Location VARCHAR(50),
    DepartmentHead VARCHAR(50)
);
INSERT INTO Departments (Id, DepartmentName, Location, DepartmentHead) VALUES
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella');
select * from Departments

ALTER TABLE Employees
ADD DepartmentId INT;
UPDATE Employees SET DepartmentId = 1 WHERE ID = 1;
UPDATE Employees SET DepartmentId = 3 WHERE ID = 2;
UPDATE Employees SET DepartmentId = 1 WHERE ID = 3;
UPDATE Employees SET DepartmentId = 2 WHERE ID = 4;
UPDATE Employees SET DepartmentId = 2 WHERE ID = 5;
UPDATE Employees SET DepartmentId = 1 WHERE ID = 6;
UPDATE Employees SET DepartmentId = 3 WHERE ID = 7;
UPDATE Employees SET DepartmentId = 1 WHERE ID = 8;
UPDATE Employees SET DepartmentId = NULL WHERE ID = 9;
UPDATE Employees SET DepartmentId = NULL WHERE ID = 10;

SELECT Employees.Name, Employees.Salary, Departments.DepartmentName
FROM Employees
INNER JOIN Departments
ON Employees.DepartmentId = Departments.Id;

--left outer join
SELECT Employees.Name, Employees.Salary, Departments.DepartmentName
FROM Employees
left JOIN Departments
ON Employees.DepartmentId = Departments.Id;

--right outer join
SELECT Employees.Name, Employees.Salary, Departments.DepartmentName
FROM Employees
right JOIN Departments
ON Employees.DepartmentId = Departments.Id;

--full outer join
SELECT Employees.Name, Employees.Salary, Departments.DepartmentName
FROM Employees
full JOIN Departments
ON Employees.DepartmentId = Departments.Id;

--cross join
SELECT Employees.Name, Employees.Salary, Departments.DepartmentName
FROM Employees
cross JOIN Departments
--rows = multiply of rows of both table 


--14 lecture
--Non-Matching Records from LEFT Table (Employees)
SELECT Employees.Name, Employees.Salary, Departments.DepartmentName
FROM Employees
LEFT JOIN Departments
ON Employees.DepartmentId = Departments.Id
WHERE Departments.Id IS NULL;

--Non-Matching Records from RIGHT Table (Departments)
SELECT Employees.Name, Employees.Salary, Departments.DepartmentName
FROM Employees
RIGHT JOIN Departments
ON Employees.DepartmentId = Departments.Id
WHERE Employees.ID IS NULL;

--Non-Matching Records from BOTH Tables
SELECT Employees.Name, Employees.Salary, Departments.DepartmentName
FROM Employees
FULL JOIN Departments
ON Employees.DepartmentId = Departments.Id
WHERE Employees.DepartmentId IS NULL
OR Departments.Id IS NULL;

--self join
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(50),
    Salary INT,
    ManagerID INT
);
INSERT INTO Employee VALUES
(1, 'Tom', 5000, NULL),
(2, 'Pam', 4000, 1),
(3, 'John', 3500, 1),
(4, 'Sam', 4500, 2),
(5, 'Todd', 3000, 2),
(6, 'Sara', 4200, 3); 
--SELF LEFT JOIN
SELECT e.Name AS Employee, m.Name AS Manager
FROM Employee e
LEFT JOIN Employee m
ON e.ManagerID = m.EmpID;

--SELF RIGHT JOIN
SELECT e.Name AS Employee, m.Name AS Manager
FROM Employee e
RIGHT JOIN Employee m
ON e.ManagerID = m.EmpID;

--SELF FULL JOIN
SELECT e.Name AS Employee, m.Name AS Manager
FROM Employee e
FULL JOIN Employee m
ON e.ManagerID = m.EmpID;

--SELF CROSS JOIN
SELECT e.Name AS Employee1, m.Name AS Employee2
FROM Employee e
CROSS JOIN Employee m;

--to replace null values 
--using ISNULL()
SELECT 
ISNULL(e.Name,'No Employee') AS Employee,
ISNULL(m.Name,'No Manager') AS Manager
FROM Employee e
LEFT JOIN Employee m
ON e.ManagerID = m.EmpID;
--using COALESCE()
/*
COALESCE() Function – Returns the first NON NULL value

Table: tblEmployee

+----+-----------+------------+----------+
| Id | FirstName | MiddleName | LastName |
+----+-----------+------------+----------+
| 1  | Sam       | NULL       | NULL     |
| 2  | NULL      | Todd       | Tanzan   |
| 3  | NULL      | NULL       | Sara     |
| 4  | Ben       | Parker     | NULL     |
| 5  | James     | Nick       | Nancy    |
+----+-----------+------------+----------+

Result

+----+-------+
| Id | Name  |
+----+-------+
| 1  | Sam   |
| 2  | Todd  |
| 3  | Sara  |
| 4  | Ben   |
| 5  | James |
+----+-------+

Query:

SELECT Id,
       COALESCE(FirstName, MiddleName, LastName) AS Name
FROM tblEmployee;

Note:
COALESCE() returns the first NON NULL value from the list
of expressions provided.
*/
SELECT 
COALESCE(e.Name,'No Employee') AS Employee, -- returns the first non null value
COALESCE(m.Name,'No Manager') AS Manager
FROM Employee e
FULL JOIN Employee m
ON e.ManagerID = m.EmpID;


--USING CASE ... END
SELECT 
CASE 
    WHEN e.Name IS NULL THEN 'No Employee'
    ELSE e.Name
END AS Employee,

CASE 
    WHEN m.Name IS NULL THEN 'No Manager'
    ELSE m.Name
END AS Manager

FROM Employee e
FULL JOIN Employee m
ON e.ManagerID = m.EmpID;