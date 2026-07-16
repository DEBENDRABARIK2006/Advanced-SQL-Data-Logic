/*
-------------------------------------------------------
CHOOSE FUNCTION IN SQL SERVER
-------------------------------------------------------
DESCRIPTION:
* Returns the item at the specified index from the list 
  of available values.
* The index position starts at 1 and NOT 0 (ZERO).

SYNTAX:
CHOOSE ( index, val_1, val_2, ... )

EXAMPLE:
Returns the item at index position 2:

SELECT CHOOSE(2, 'India', 'US', 'UK') AS Country

OUTPUT:
Country
-------
US
-------------------------------------------------------
*/


SELECT CHOOSE(3, 'India', 'US', 'UK') AS Country

CREATE TABLE Users (
    Id INT PRIMARY KEY,
    Name NVARCHAR(50),
    DateOfBirth DATE
);
INSERT INTO Users (Id, Name, DateOfBirth)
VALUES 
(1, 'Mark',  '1980-01-11'),
(2, 'John',  '1981-12-12'),
(3, 'Amy',   '1979-11-21'),
(4, 'Ben',   '1978-05-14'),
(5, 'Sara',  '1970-03-17'),
(6, 'David', '1978-04-05');

SELECT * FROM Users;
--using choose function
SELECT Name, 
       CHOOSE(MONTH(DateOfBirth), 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec') AS BirthMonth
FROM Users;
--use case 
SELECT 
    Name, 
    DateOfBirth,
    CASE MONTH(DateOfBirth)
        WHEN 1 THEN 'January'
        WHEN 2 THEN 'February'
        WHEN 3 THEN 'March'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'May'
        WHEN 6 THEN 'June'
        WHEN 7 THEN 'July'
        WHEN 8 THEN 'August'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'October'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'December'
        ELSE 'Unknown'
    END AS BirthMonthName
FROM Users;


/*
-------------------------------------------------------
IIF FUNCTION IN SQL SERVER
-------------------------------------------------------
DESCRIPTION:
* Returns one of two values, depending on whether the 
  Boolean expression evaluates to true or false
* IIF is a shorthand way for writing a CASE expression

SYNTAX:
IIF ( boolean_expression, true_value, false_value )

EXAMPLE:
Returns Male as the boolean expression evaluates to TRUE:

DECLARE @Gender INT
SET @Gender = 1
SELECT IIF( @Gender = 1, 'Male', 'Female') AS Gender

OUTPUT:
Gender
-------
Male
-------------------------------------------------------
*/

DECLARE @Gender INT
SET @Gender = 1
SELECT IIF( @Gender = 1, 'Male', 'Female') AS Gender

/*
-------------------------------------------------------
IIF FUNCTION IN SQL SERVER
-------------------------------------------------------
Example: Using IIF() function with table data

[Table Data Representation]
Id | Name   | GenderId  =>  Name   | GenderId | Gender
---|--------|---------      -------|----------|-------
1  | Mark   | 1             Mark   | 1        | Male
2  | John   | 1             John   | 1        | Male
3  | Amy    | 2             Amy    | 2        | Female
4  | Ben    | 1             Ben    | 1        | Male
5  | Sara   | 2             Sara   | 2        | Female
6  | David  | 1             David  | 1        | Male

-------------------------------------------------------
Using CASE statement:
-------------------------------------------------------
SELECT Name, GenderId,
       CASE WHEN GenderId = 1
            THEN 'Male'
            ELSE 'Female'
       END AS Gender
FROM Employees

-------------------------------------------------------
Using IIF function:
-------------------------------------------------------
SELECT Name, GenderId,
       IIF(GenderId = 1, 'Male', 'Female') AS Gender
FROM Employees
-------------------------------------------------------
*/



/*
-------------------------------------------------------
TRY_PARSE FUNCTION IN SQL SERVER 2012
-------------------------------------------------------
DESCRIPTION:
* Introduced in SQL Server 2012.
* Converts a string to Date/Time or Numeric type.
* Returns NULL if the provided string cannot be converted 
  to the specified data type.
* Requires .NET Framework Common Language Runtime (CLR).

SYNTAX:
TRY_PARSE ( string_value AS data_type )

EXAMPLE 1:
As the string can be converted to INT, the result will be 99

SELECT TRY_PARSE('99' AS INT) AS Result

OUTPUT:
Result
-------
99

EXAMPLE 2:
As the string cannot be converted to INT, TRY_PARSE returns NULL

SELECT TRY_PARSE('ABC' AS INT) AS Result

OUTPUT:
Result
-------
NULL
-------------------------------------------------------
*/

SELECT TRY_PARSE('99' AS INT) AS Result
SELECT TRY_PARSE('ABC' AS INT) AS Result

--use case
select 
case when TRY_PARSE('ABC' AS INT) is null
     then 'conversion failed'
     else 'conversion successful'
end as result

select IIF(TRY_PARSE('ABC' AS INT) is null,'conversion failed','conversion successful') as result
--it show error
SELECT PARSE('ABC' AS INT) AS Result
--it do not
SELECT TRY_PARSE('ABC' AS INT) AS Result


/*
-------------------------------------------------------
TRY_CONVERT FUNCTION IN SQL SERVER
-------------------------------------------------------
DESCRIPTION:
* Introduced in SQL Server 2012.
* Converts a value to the specified data type.
* Returns NULL if the provided value cannot be converted 
  to the specified data type.
* If you request a conversion that is explicitly not 
  permitted, then TRY_CONVERT fails with an error.

SYNTAX:
TRY_CONVERT ( data_type, value, [style] )

NOTE:
Style parameter is optional. The range of acceptable 
values is determined by the target data_type.

EXAMPLE:
As the string can be converted to INT, the result will be 99

SELECT TRY_CONVERT(INT, '99') AS Result

OUTPUT:
Result
-------
99
-------------------------------------------------------
*/

SELECT TRY_CONVERT(INT, '99') AS Result
/*
-------------------------------------------------------
DIFFERENCE BETWEEN TRY_PARSE AND TRY_CONVERT FUNCTIONS
-------------------------------------------------------

1. DATA TYPE LIMITATIONS:
* TRY_PARSE: Can only be used for converting from string to 
  date/time or number data types.
* TRY_CONVERT: Can be used for any general type conversions.

EXAMPLE: Converting to XML
* TRY_CONVERT(XML, '<root><child/></root>') -> SUCCESS
* TRY_PARSE('<root><child/></root>' AS XML) -> ERROR 
  ("Invalid data type xml in function TRY_PARSE")

2. DEPENDENCIES:
* TRY_PARSE: Relies on the presence of the .NET Framework 
  Common Language Runtime (CLR).
* TRY_CONVERT: Does not rely on the .NET CLR.

-------------------------------------------------------
CODE SAMPLES FROM IMAGE:
-------------------------------------------------------

-- Using TRY_CONVERT (Success)
SELECT TRY_CONVERT(XML, '<root><child/></root>') AS [XML]

-- Using TRY_PARSE (Fails with error)
SELECT TRY_PARSE('<root><child/></root>' AS XML) AS [XML]
-------------------------------------------------------
*/

--EOMONTH function
--returns the last day of the month of the specified date

select EOMONTH('04/16/2006',3) as lastday --here 3=>month_to_add
select eomonth(getdate()) as  MonthEnd;

--DATEFROMPARTS function
--DATEFROMPARTS(YEAR,MONTH,DAY)
select DATEFROMPARTS(2006,04,16)as[date]

/*
-------------------------------------------------------
DATEFROMPARTS FUNCTION IN SQL SERVER
-------------------------------------------------------
New date and time functions introduced in SQL Server 2012
-------------------------------------------------------

EOMONTH: 
* Returns the last day of the month containing a specified date.
  (Discussed in Part 125 of SQL Server tutorial)

DATETIMEFROMPARTS: 
* Returns a DateTime value.
* Syntax: 
  DATETIMEFROMPARTS (year, month, day, hour, minute, seconds, milliseconds)

SMALLDATETIMEFROMPARTS: 
* Returns a SmallDateTime value.
* Syntax: 
  SMALLDATETIMEFROMPARTS (year, month, day, hour, minute)

*/

/*
-------------------------------------------------------
DATETIME V/S SMALLDATETIME IN SQL SERVER
-------------------------------------------------------

| Attribute     | SmallDateTime                  | DateTime                                |
|---------------|--------------------------------|-----------------------------------------|
| Date Range    | January 1, 1900, through       | January 1, 1753, through                |
|               | June 6, 2079                   | December 31, 9999                       |
|---------------|--------------------------------|-----------------------------------------|
| Time Range    | 00:00:00 through 23:59:59      | 00:00:00 through 23:59:59.997           |
|---------------|--------------------------------|-----------------------------------------|
| Accuracy      | 1 Minute                       | 3.33 Milli-seconds                      |
|---------------|--------------------------------|-----------------------------------------|
| Size          | 4 Bytes                        | 8 Bytes                                 |
|---------------|--------------------------------|-----------------------------------------|
| Default value | 1900-01-01 00:00:00            | 1900-01-01 00:00:00                     |

-------------------------------------------------------
KEY TAKEAWAYS:
* SmallDateTime is more storage-efficient (half the size).
* DateTime offers a much larger date range and higher precision.
* DateTime accuracy is rounded to increments of .000, .003, or .007 seconds.
-------------------------------------------------------
*/
/*
syntax:

DATETIME2FROMPARTS
(
    year,
    month,
    day,
    hour,
    minute,
    seconds,
    fractions,
    precision
)
*/
--max precision 7
select datetime2fromparts(2015,11,15,20,55,55,5,7)as[datetime2]  --here 5 : fraction and 7 : precision
select timefromparts(20,55,55,5,7)as[datetime2]

/*
-------------------------------------------------------
DATETIME V/S DATETIME2 IN SQL SERVER
-------------------------------------------------------

Differences between DateTime and DateTime2

| Attribute     | DateTime                        | DateTime2                               |
|---------------|---------------------------------|-----------------------------------------|
| Date Range    | January 1, 1753, through        | January 1, 0001, through                |
|               | December 31, 9999               | December 31, 9999                       |
|---------------|---------------------------------|-----------------------------------------|
| Time Range    | 00:00:00 through 23:59:59.997   | 00:00:00 through 23:59:59.9999999       |
|---------------|---------------------------------|-----------------------------------------|
| Accuracy      | 3.33 Milli-seconds              | 100 nanoseconds                         |
|---------------|---------------------------------|-----------------------------------------|
| Size          | 8 Bytes                         | 6 to 8 Bytes (Depends on the precision) |
|---------------|---------------------------------|-----------------------------------------|
| Default Value | 1900-01-01 00:00:00             | 1900-01-01 00:00:00                     |

-------------------------------------------------------
NOTES:
-------------------------------------------------------
* DATETIME2 has a bigger date range than DATETIME. 
  Also, DATETIME2 is more accurate than DATETIME.

* So I would recommend using DATETIME2 over DATETIME when possible.

* I think the only reason for using DATETIME over DATETIME2 is 
  for backward compatibility.
-------------------------------------------------------
*/

/*
-------------------------------------------------------
DATETIME2 SYNTAX AND STORAGE IN SQL SERVER
-------------------------------------------------------

SYNTAX: 
DATETIME2 [ (fractional seconds precision) ]

WITH DATETIME2:
* Optional fractional seconds precision can be specified.
* The precision scale is from 0 to 7 digits.
* The default precision is 7 digits.

-------------------------------------------------------
STORAGE SIZE BASED ON PRECISION:
-------------------------------------------------------
| Precision Scale | Storage Size |
|-----------------|--------------|
| 0, 1, and 2     | 6 bytes      |
| 3 and 4         | 7 bytes      |
| 5, 6, and 7     | 8 bytes      |
-------------------------------------------------------
*/

declare @temptable table(
datetime2precision0 datetime2(0),
datetime2precision1 datetime2(1),
datetime2precision2 datetime2(2),
datetime2precision3 datetime2(3),
datetime2precision4 datetime2(4),
datetime2precision5 datetime2(5),
datetime2precision6 datetime2(6),
datetime2precision7 datetime2(7)
)

insert into @temptable values(
   '2015-10-20 15:09:12.1234567',
   '2015-10-20 15:09:12.1234567',
   '2015-10-20 15:09:12.1234567',
   '2015-10-20 15:09:12.1234567',
   '2015-10-20 15:09:12.1234567',
   '2015-10-20 15:09:12.1234567',
   '2015-10-20 15:09:12.1234567',
   '2015-10-20 15:09:12.1234567'
)

select 'precision-0' as[precision],
        datetime2precision0 as[datetime],
        datalength(datetime2precision0) as[storage_size]
from @temptable

--offset fetch next
/*
* returns a page of results from the result set 
* order by clause is required

=> syntax
select * from table_name
order by column_list
offset rows_to_skip rows
fetch next rows_to_fetch rows only 

*/
create table fetch_tbl
(
id int primary key identity,
name nvarchar(25),
[description] nvarchar(50),
price int
)
go

declare @start int
set @start=1

declare @name nvarchar(25)
declare @description nvarchar(50)

while(@start<=100)
begin
set @name='product - '+LTRIM(@start)   --LTRIM(@start)  => LTRIM(CAST(@start AS VARCHAR(10)))
set @description='product description - ' + LTRIM(@start)
insert into fetch_tbl values(@name,@description,@start*10)
set @start=@start+1
end

truncate table fetch_tbl
select * from fetch_tbl

--offset fetch next 
select * from fetch_tbl
order by id 
offset 21 rows
fetch next 14 rows only

--stored procedure
create procedure spgetrowsbypagenumberandsize
@pagenumber int,
@pagesize int
as
begin
     select * from fetch_tbl
     order by id 
     offset (@pagenumber-1)*@pagesize rows
     fetch next @pagesize rows only
end

execute spgetrowsbypagenumberandsize 3,10

--sys.dm_sql_referencing_entities
--return all the objects that depend on employees table
select * from sys.dm_sql_referencing_entities('dbo.employees','object')

/*
Difference between referencing entity and referenced entity

A dependency is created between two objects when one object appears by name inside
a SQL statement stored in another object. The object which is appearing inside SQL
expression is known as REFERENCED ENTITY and the object which has the SQL
expression is known as a REFERENCING ENTITY.

Referencing entities    : sys.dm_sql_referencing_entities
Referenced entities     : sys.dm_sql_referenced_entities

Example:

Create view vwEmployees
as
Select * from Employees

vwEmployees  --> REFERENCING ENTITY
Employees    --> REFERENCED ENTITY
*/

select * from sys.dm_sql_referenced_entities('dbo.spGetemployeecountbygender','object')
/*
Difference between Schema-bound dependency and Non-schema-bound dependency

Schema-bound dependency:
Schema-bound dependency prevents referenced objects from being dropped or modified 
as long as the referencing object exists.

Example:
A view created with SCHEMABINDING, or a table created with foreign key constraint.

Non-schema-bound dependency:
A non-schema-bound dependency doesn't prevent the referenced object from being 
dropped or modified.
*/
/*
sp_depends

1. A system stored procedure that returns object dependencies

2. For example:
   1. If you specify a table name as the argument, then the views and procedures 
      that depend on the specified table are displayed

   2. If you specify a view or a procedure name as the argument, then the tables 
      and views on which the specified view or procedure depends are displayed

Syntax:
Execute sp_depends 'ObjectName'
*/
Execute sp_depends 'employees'
Execute sp_depends 'dbo.spGetemployeecountbygender'
--sp_depends does not report dependencies correctly, if the table on which the stored procedure depends is deleted and rrecreated
--sp_depends is on the deprecation path. this might be removed from the future versions of sql server
