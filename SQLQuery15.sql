--sql server except operator
--except operator returns unique rows from the left query that aren`t in the right quer`s results
-- Create Table A
CREATE TABLE table_a (
    id INT,
    name VARCHAR(50),
    gender VARCHAR(10)
);

-- Create Table B
CREATE TABLE table_b (
    id INT,
    name VARCHAR(50),
    gender VARCHAR(10)
);
INSERT INTO table_a (id, name, gender) VALUES
(1, 'Mark', 'Male'),
(2, 'Mary', 'Female'),
(3, 'Steve', 'Male'),
(4, 'John', 'Male');

INSERT INTO table_b (id, name, gender) VALUES
(4, 'John', 'Male'),
(5, 'Saha', 'Female'),
(6, 'Pam', 'Female'),
(7, 'Rebeka', 'Female');

select * from table_a
select * from table_b

select id,name,gender from table_a
except
select id,name,gender from table_b
/*
the number and order of the columns must be the same in both the queries
the data types must be same or compatible
this is simillar to minus operator in oracle
*/
/*
SQL Server Except Operator
You can also use Except operator on a single table

tblEmployees:
Id | Name   | Gender | Salary
-----------------------------
1  | Mark   | Male   | 52000
2  | Mary   | Female | 55000
3  | Steve  | Male   | 45000
4  | John   | Male   | 40000
5  | Sara   | Female | 48000
6  | Pam    | Female | 60000
7  | Tom    | Male   | 58000
8  | George | Male   | 65000
9  | Tina   | Female | 67000
10 | Ben    | Male   | 80000

Example 1:
Select Id, Name, Gender, Salary
From tblEmployees
Where Salary >= 50000
Except
Select Id, Name, Gender, Salary
From tblEmployees
Where Salary >= 60000

Result 1:
Id | Name | Gender | Salary
---------------------------
1  | Mark | Male   | 52000
2  | Mary | Female | 55000
7  | Tom  | Male   | 58000

Order By clause should be used only once after the right query

Example 2:
Select Id, Name, Gender, Salary
From tblEmployees
Where Salary >= 50000
Except
Select Id, Name, Gender, Salary
From tblEmployees
Where Salary >= 60000
Order By Id Desc

Result 2:
Id | Name | Gender | Salary
---------------------------
7  | Tom  | Male   | 58000
2  | Mary | Female | 55000
1  | Mark | Male   | 52000
*/

--difference between EXCEPT and NOT IN
select id,name,gender from table_a
except
select id,name,gender from table_b
--NOT IN 
select id,name,gender from table_a
where id not in (select id from table_b)

/*
Except filters duplicates and returns only DISTINCT rows from the left query that
aren’t in the right query’s results, where as NOT IN does not filter the duplicates

EXCEPT operator expects the same number of columns in both the queries, where
as NOT IN, compares a single column from the outer query with a single column
from the sub-query
*/


--=>=>=>=>=>intersect operator in sql server
/*
INTERSECT Operator in SQL Server

Intersect operator retrieves the common records from both the left and the right
query of the Intersect operator
* Introduced in SQL Server 2005
* The number and the order of the columns must be same in both the queries
* The data types must be same or at least compatible

*/

--Query 1:
Select Id, Name, Gender from table_a
Intersect
Select Id, Name, Gender from table_b

--Query 2 (Inner Join alternative):
Select table_a.Id, table_a.Name, table_a.Gender
From table_a Inner Join table_b
On table_a.Id = table_b.Id
/*
INTERSECT v/s INNER JOIN

INTERSECT filters duplicates and returns only DISTINCT rows that are common
between the LEFT and Right Query, where as INNER JOIN does not filter the 
duplicates

To make INNER JOIN behave like INTERSECT operator use the DISTINCT operator    --select distinct

INNER JOIN treats two NULLS as two different values. So if you are joining two
tables based on a nullable column and if both tables have NULLs in that joining
column then, INNER JOIN will not include those rows in the result-set, where as
INTERSECT treats two NULLs as a same value and it returns all matching rows
*/

/*
--UNION ALL includes the duplicates as well
*/

-- Create Department Table
CREATE TABLE Departmentt (
    Id INT PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);

-- Insert values into Department Table
INSERT INTO Departmentt (Id, DepartmentName) VALUES (1, 'IT');
INSERT INTO Departmentt (Id, DepartmentName) VALUES (2, 'HR');
INSERT INTO Departmentt (Id, DepartmentName) VALUES (3, 'Payroll');
INSERT INTO Departmentt (Id, DepartmentName) VALUES (4, 'Administration');
INSERT INTO Departmentt (Id, DepartmentName) VALUES (5, 'Sales');

-- Create Employee Table
CREATE TABLE Employeee (
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    Gender NVARCHAR(10),
    Salary INT,
    DepartmentId INT FOREIGN KEY REFERENCES Departmentt(Id)
);

-- Insert values into Employee Table
INSERT INTO Employeee (Id, Name, Gender, Salary, DepartmentId) VALUES (1, 'Mark', 'Male', 50000, 1);
INSERT INTO Employeee (Id, Name, Gender, Salary, DepartmentId) VALUES (2, 'Mary', 'Female', 60000, 3);
INSERT INTO Employeee (Id, Name, Gender, Salary, DepartmentId) VALUES (3, 'Steve', 'Male', 45000, 2);
INSERT INTO Employeee (Id, Name, Gender, Salary, DepartmentId) VALUES (4, 'John', 'Male', 56000, 1);
INSERT INTO Employeee (Id, Name, Gender, Salary, DepartmentId) VALUES (5, 'Sara', 'Female', 39000, 2);

select * from Departmentt
select * from employeee

select d.departmentname,e.name,e.gender,e.salary
from Departmentt d
inner join Employeee e
on d.id=e.DepartmentId

select d.departmentname,e.name,e.gender,e.salary
from Departmentt d
left join Employeee e
on d.id=e.DepartmentId

create function fn_getemployees_details_by_departmentid(@departmentid int)
returns table 
as 
return
(
select * from employeee
where departmentid=@departmentid
)

select * from fn_getemployees_details_by_departmentid(1)

select d.departmentname,e.name,e.gender,e.salary
from Departmentt d
cross apply fn_getemployees_details_by_departmentid(d.id) e
--on d.id=e.DepartmentId


select d.departmentname,e.name,e.gender,e.salary
from Departmentt d
outer apply fn_getemployees_details_by_departmentid(d.id) e
--on d.id=e.DepartmentId


/*
• The Table Valued Function on the right hand side of the APPLY operator gets
  called for each row from the left (also called outer table) table

• Cross Apply returns only matching rows (semantically equivalent to Inner Join)

• Outer Apply returns matching + non-matching rows (semantically equivalent to
  Left Outer Join). The unmatched columns of the table valued function will be
  set to NULL
*/
/*
INNER JOIN
-----------
Works with tables.
Returns only matching rows.

LEFT JOIN
----------
Works with tables.
Returns all rows from left table.

CROSS APPLY
-----------
Works with table-valued functions.
Returns only rows where function returns data.
Similar to INNER JOIN.

OUTER APPLY
-----------
Works with table-valued functions.
Returns all rows from left table.
Returns NULL when function returns no rows.
Similar to LEFT JOIN.

Memory Trick:

INNER JOIN  <=> CROSS APPLY
LEFT JOIN   <=> OUTER APPLY
*/
/*
DDL Triggers in SQL Server

What is the use of DDL triggers
• If you want to execute some code in response to a specific DDL event
• To prevent certain changes to your database schema
• Audit the changes that the users are making to the database structure

DDL trigger Syntax

CREATE TRIGGER [Trigger_Name]
ON [Scope (Server|Database)]
FOR [EventType1, EventType2, EventType3, ....]
AS
BEGIN
    -- Trigger Body
END

DDL triggers scope: DDL triggers can be created in a specific database or at the server level

CREATE TRIGGER trMyFirstTrigger
ON Database
FOR CREATE_TABLE
AS
BEGIN
    ROLLback
    Print 'you cannot create , alter or drop a table'
END
*/

--This trigger fires whenever a table is created
-- Trigger that fires in response to a single DDL event
CREATE TRIGGER trMyFirstTrigger
ON Database
FOR CREATE_TABLE
AS
BEGIN
    Print 'New table created'
END

--This trigger fires whenever a table is created, altered or dropped
-- Trigger that fires in response to a multiple DDL
-- events
ALTER TRIGGER trMyFirstTrigger
ON Database
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    Print 'You just created, modified or deleted a table'
END

create table deb (id int)
drop table deb

--for disable trigger
disable trigger trMyFirstTrigger on database
--for enable
enable trigger trMyFirstTrigger on database
--for drop
drop trigger trMyFirstTrigger on database

--rename something
ALTER TRIGGER trMyFirstTrigger
ON Database
FOR RENAME
AS
BEGIN
    Print 'You just RENAMED something'
END
--renameing the table 
sp_rename 'lipa' , 'lipana'
sp_rename 'lipana.id','newid','column'

/*
'on database' mean it applicable only for that perticular datbase
'on all server' mean it applicable for all database on that perticular database
*/
/*
SQL Server Trigger Execution Order

Server scoped triggers will always fire before any of the database scoped triggers

Using the sp_settriggerorder stored procedure, you can set the execution order of
server-scoped or database-scoped triggers

Parameter    | Description
-------------------------------------------------------------------------------
@triggername | Name of the trigger
@order       | Value can be First, Last or None. When set to None, trigger is fired in random order
@stmttype    | SQL statement that fires the trigger. Can be INSERT, UPDATE, DELETE or any DDL event
@namespace   | Scope of the trigger. Value can be DATABASE, SERVER, or NULL

EXEC sp_settriggerorder
@triggername = 'tr_DatabaseScopeTrigger1',
@order = 'none',
@stmttype = 'CREATE_TABLE',
@namespace = 'DATABASE'
GO
*/
-- 1. Database Scope Trigger
-- This trigger fires when a table is created within the specific database.
CREATE TRIGGER tr_DatabaseScopeTrigger
ON DATABASE
FOR CREATE_TABLE
AS
BEGIN
    Print 'Database Scope Trigger'
END
GO

-- 2. Server Scope Trigger
-- This trigger fires when a table is created anywhere on the entire SQL Server instance.
CREATE TRIGGER tr_ServerScopeTrigger
ON ALL SERVER
FOR CREATE_TABLE
AS
BEGIN
    Print 'Server Scope Trigger'
END
GO

create table deb (id int)
/*
in terminal :
Server Scope Trigger
Database Scope Trigger
*/
-- Create Database Scope Trigger 3
CREATE TRIGGER tr_DatabaseScopeTrigger3
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    Print 'Database Scope Trigger - 3'
END
GO

-- Create Database Scope Trigger 2
CREATE TRIGGER tr_DatabaseScopeTrigger2
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    Print 'Database Scope Trigger - 2'
END
GO

-- Create Database Scope Trigger 1
CREATE TRIGGER tr_DatabaseScopeTrigger1
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    Print 'Database Scope Trigger - 1'
END
GO
--by default 3->2->1

--Setting Trigger Execution Order
EXEC sp_settriggerorder
@triggername = 'tr_DatabaseScopeTrigger1',
@order = 'first',
@stmttype = 'CREATE_TABLE',
@namespace = 'DATABASE'
GO

EXEC sp_settriggerorder
@triggername = 'tr_DatabaseScopeTrigger3',
@order = 'last',
@stmttype = 'CREATE_TABLE',
@namespace = 'DATABASE'
GO

create table debendra (dob int)
/*
SQL Server Trigger Execution Order

If you have a database-scoped and a server-scoped trigger handling the same 
event, and if you have set the execution order at both the levels. Here is the 
execution order of the triggers:

1.  The server-scope trigger marked First
2.  Other server-scope triggers
3.  The server-scope trigger marked Last
4.  The database-scope trigger marked First
5.  Other database-scope triggers
6.  The database-scope trigger marked Last
*/
/*
=====================================
audit table , logon triggers
=====================================
*/
/*
--not mention *************

create trigger tr_audittablechanges
on all server
for create_table , alter_table , drop_table
as
begin
     select eventdata()
end
create table mytable (id int,name nvarchar(23))

-- Step 1: Create the audit table to store table changes
CREATE TABLE TableChanges
(
    DatabaseName NVARCHAR(250),
    TableName NVARCHAR(250),
    EventType NVARCHAR(250),
    LoginName NVARCHAR(250),
    SQLCommand NVARCHAR(2500),
    AuditDateTime DATETIME
)
GO

-- Step 2: Create or Alter the DDL Trigger to audit changes across the server
ALTER TRIGGER tr_AuditTableChanges
ON ALL SERVER
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
    -- Capture event data in XML format
    DECLARE @EventData XML
    SELECT @EventData = EVENTDATA()

    -- Insert captured event data into the audit table
    INSERT INTO SampleDB.dbo.TableChanges
    (DatabaseName, TableName, EventType, LoginName, SQLCommand, AuditDateTime)
    VALUES
    (
        @EventData.value('(/EVENT_INSTANCE/DatabaseName)[1]', 'VARCHAR(250)'),
        @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'VARCHAR(250)'),
        @EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(250)'),
        @EventData.value('(/EVENT_INSTANCE/LoginName)[1]', 'VARCHAR(250)'),
        @EventData.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'NVARCHAR(2500)'),
        GETDATE()
    )
END
GO

alter table mytable
alter column name nvarchar(200)
select * from tablechanges*/


--LOGON triggers
select is_user_process,original_login_name,*
from sys.dm_exec_sessions order by login_time desc

-- 96 , 97