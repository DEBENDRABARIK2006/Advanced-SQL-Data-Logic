--mathematical function
SELECT ABS(-25) AS Result;
SELECT ACOS(0.5) AS Result;
SELECT ASIN(0.5) AS Result;
SELECT ATAN(1) AS Result;
SELECT ATN2(10,5) AS Result;
SELECT CEILING(4.3) AS Result;
SELECT COS(60) AS Result;
SELECT COT(1) AS Result;
SELECT DEGREES(1) AS Result;
SELECT EXP(2) AS Result;
SELECT FLOOR(4.9) AS Result;
SELECT LOG(10) AS Result;
SELECT LOG10(100) AS Result;
SELECT PI() AS Result;
SELECT POWER(2,3) AS Result;
SELECT RADIANS(180) AS Result;
SELECT RAND() AS Random_Number;
SELECT ROUND(123.4567,2) AS Result;
SELECT SIGN(-20) AS Result;
SELECT SIN(1) AS Result;
SELECT SQRT(16) AS Result;
SELECT SQUARE(5) AS Result;
SELECT TAN(1) AS Result;

--print random 10 number 
declare @counter int
set @counter=1
while @counter<=10
begin
print floor(rand()*100)
set @counter=@counter+1
end

--If digit ≥ 5 → increase previous digit by 1
--If digit < 5 → keep same
select round(840.556,-2)  -- -2 means round to the nearest hundred.
SELECT ROUND(1234,-1)     -- -1 means nearest ten
SELECT ROUND(1234,-2)   
SELECT ROUND(1234,-3) 



--General Syntax of Scalar Function
--CREATE FUNCTION function_name
--(
--    @parameter1 datatype,
--    @parameter2 datatype
--)
--RETURNS return_datatype
--AS
--BEGIN
--   DECLARE @result return_datatype

    -- logic
--   SET @result = expression

--   RETURN @result
--END
CREATE FUNCTION fn_AddNumbers
(
    @num1 INT,
    @num2 INT
)
RETURNS INT
AS
BEGIN
    DECLARE @sum INT

    SET @sum = @num1 + @num2

    RETURN @sum
END
SELECT dbo.fn_AddNumbers(10,20) AS Result;


--practice problem 
CREATE TABLE tblEmployees
(
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    DateOfBirth DATETIME,
    Gender VARCHAR(10),
    DepartmentId INT
);
INSERT INTO tblEmployees VALUES
(1,'Sam','1980-12-30 00:00:00.000','Male',1),
(2,'Pam','1982-09-01 12:02:36.260','Female',2),
(3,'John','1985-08-22 12:03:30.370','Male',1),
(4,'Sara','1979-11-29 12:59:30.670','Female',3),
(5,'Todd','1978-11-29 12:59:30.670','Male',1);
CREATE TABLE tblDepartment
(
    Id INT PRIMARY KEY,
    DepartmentName VARCHAR(50),
    Location VARCHAR(50),
    DepartmentHead VARCHAR(50)
);
INSERT INTO tblDepartment VALUES
(1,'IT','London','Rick'),
(2,'Payroll','Delhi','Ron'),
(3,'HR','New York','Christie'),
(4,'Other Department','Sydney','Cindrella');

CREATE FUNCTION fn_EmployeesByGender(@Gender VARCHAR(10))
RETURNS TABLE
AS
RETURN
(
    SELECT Id, Name, DateOfBirth, Gender, DepartmentId
    FROM tblEmployees
    WHERE Gender = @Gender
);

SELECT * FROM fn_EmployeesByGender('Male');

SELECT Name, Gender, DepartmentName
FROM fn_EmployeesByGender('Male') E
JOIN tblDepartment D
ON D.Id = E.DepartmentId;

--Multi-Statement Table Valued Function
CREATE FUNCTION fn_MSTVF_GetEmployees()
RETURNS @Table TABLE
(
    Id INT,
    Name NVARCHAR(20),
    DOB DATE
)
AS
BEGIN

    INSERT INTO @Table
    SELECT Id,
           Name,
           CAST(DateOfBirth AS DATE)
    FROM tblEmployees

    RETURN
END


SELECT * FROM fn_MSTVF_GetEmployees();
update dbo.fn_MSTVF_GetEmployees() set name='debendra' where id=1
update dbo.fn_EmployeesByGender('Male') set name='debendra' where id=1
SELECT * FROM fn_EmployeesByGender('Male');

/*
Deterministic and Nondeterministic

Deterministic functions always return the same result any time 
they are called with a specific set of input values and given the same state of the database.

Examples: Square(), Power(), Sum(), Avg() and Count()

Note: All aggregate functions are deterministic functions.

Nondeterministic functions may return different results each time 
they are called with a specific set of input values even if the database state that they access remains the same.

Examples: GetDate() and CURRENT_TIMESTAMP

Rand() function is a Non-deterministic function, but if you provide the seed value, 
the function becomes deterministic, as the same value gets returned for the same seed value.

RAND() is normally a non-deterministic function because it returns different random values on each execution.
However, when a seed value is provided, such as RAND(100), 
SQL Server starts the random number generation from the same initial point every time.
Therefore, the same seed always produces the same random number, making the function deterministic for that seed value.
*/

--encryption and schema binding 

--concept related to function 
select * from tblEmployees
select count(*) from tblEmployees

--TEMPORARY TABLE 
create table #persondetails (id int, name varchar(20))
insert into #persondetails values (1,'debnedra'),(2,'jagan')
select * from #persondetails

select name from tempdb..sysobjects
where name like '#persondetails%'

/*
Check if the local temporary table is created:

Temporary tables are created in the TEMPDB.
Query the sysobjects system table in TEMPDB. The name of the table, is suffixed
with lot of underscores and a random number. For this reason you have to use the
LIKE operator in the query.

Select    name from tempdb..sysobjects
where     name like '#PersonDetails%'

A local temporary table is available, only for
the connection that has created the table

A local temporary table is automatically
dropped, when the connection that has
created the it, is closed.

If the user wants to explicitly drop the
temporary table, he can do so using DROP
TABLE #PersonDetails
*/

/*
If the temporary table, is created inside the stored procedure, it get's dropped automatically upon
the completion of stored procedure execution.
*/
Create Procedure spCreateLocalTempTable
as
Begin

Create Table #PersonDetails(Id int, Name nvarchar(20))

Insert into #PersonDetails Values(1, 'Mike')
Insert into #PersonDetails Values(2, 'John')
Insert into #PersonDetails Values(3, 'Todd')

Select * from #PersonDetails

End

exec spCreateLocalTempTable
/*
It is also possible for different connections, to create a local temporary table with the same name.
For example User1 and User2, both can create a local temporary table with the same name
#PersonDetails.
*/

--global temporary tables declared with ##
/*
global temporary tablees are visible to all the connection of the sql server , and are only 
destroyed when the last connection referencing the table is closed 

global temporary table name has to be unique 

*/

/*
Difference Between Local Temporary Table and Global Temporary Table

1. Prefix
   - Local Temporary Table  : #TableName
   - Global Temporary Table : ##TableName

2. Visibility
   - Local Temporary Table  : Visible only to the session that created it.
   - Global Temporary Table : Visible to all sessions.

3. Scope
   - Local Temporary Table  : Current session/connection only.
   - Global Temporary Table : All sessions/connections.

4. Storage Location
   - Both are stored in TEMPDB.

5. Automatic Deletion
   - Local Temporary Table:
     Automatically dropped when the session ends.
     
   - Global Temporary Table:
     Dropped when the session that created it ends and no other
     session is using it.

6. Accessibility
   - Local Temporary Table:
     Other users/sessions cannot access it.
     
   - Global Temporary Table:
     Any user/session can access it.

7. Name Conflict
   - Local Temporary Table:
     Multiple users can create temporary tables with the same name.
     SQL Server internally appends a unique suffix.

   - Global Temporary Table:
     Only one global temporary table with a given name can exist.

Example:

-- Local Temporary Table
CREATE TABLE #PersonDetails
(
    Id INT,
    Name VARCHAR(50)
);

-- Global Temporary Table
CREATE TABLE ##PersonDetails
(
    Id INT,
    Name VARCHAR(50)
);

Interview Answer:

Local Temporary Table (#):
- Visible only to the session that created it.
- Automatically dropped when the session ends.
- Stored in TEMPDB.

Global Temporary Table (##):
- Visible to all sessions.
- Remains available until the creating session ends and all
  other sessions stop using it.
- Stored in TEMPDB.
*/