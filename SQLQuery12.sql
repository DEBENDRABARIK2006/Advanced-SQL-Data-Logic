/*
however,if there is ever a need to process the rows , on a row by row basis, then cursors are your choice .
cursors are very bad for performance , and should be avoided always. most of the time ,
cursor can be very easily replaced using joins

types of cursor :
1.foward-only
2.static
3.keyset
4.dynamic
*/

select top 10 * from newtblProducts
select top 10 * from newtblProductSales

select count(*) from newtblProducts
select count(*) from newtblProductSales

declare @productid int
declare @name nvarchar(30)

declare productcursor cursor for
select id,name from newtblProducts where id<=1000

open productcursor
fetch next from productcursor into @productid,@name --fetch first row

while(@@FETCH_STATUS = 0)
begin
     print 'id = ' + cast(@productid as nvarchar(20)) +'name = '+@name
     fetch next from productcursor into @productid , @name  -- fetch next row
end

close productcursor
deallocate productcursor
/*
fetch status 
| Value | Meaning      |
| ----- | ------------ |
| 0     | Success      |
| -1    | No more rows |
| -2    | Row missing  |

*/

--replacing cursor using joins
UPDATE newtblProductSales
SET UnitPrice = 
CASE
    WHEN Name = 'product-55' THEN 55
    WHEN Name = 'product-65' THEN 65
    WHEN Name LIKE 'product-100%' THEN 1000
END
FROM newtblProductSales
JOIN newtblProducts 
    ON newtblProducts.Id = newtblProductSales.ProductId
WHERE Name = 'product-55'
   OR Name = 'product-65'
   OR Name LIKE 'product-100%';

--list all tables in a sql query
select * from sysobjects where xtype='U'
select distinct xtype from sysobjects
select * from sys.tables
select * from sys.views
select * from sys.procedures
select * from INFORMATION_SCHEMA.TABLES

--runable script
/*
if not exist (select * from information_schema.tables where table_name='to be create name ')
*/
IF OBJECT_ID('tblEmployee') IS NULL
BEGIN
    -- Create Table Script
    PRINT 'Table tblEmployee created'
END
ELSE
BEGIN
    PRINT 'Table tblEmployee already exists'
END



IF OBJECT_ID('tblEmployee') IS NOT NULL
BEGIN
    DROP TABLE tblEmployee
END

CREATE TABLE tblEmployee
(
    ID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100),
    Gender NVARCHAR(10),
    DateOfBirth DATETIME
)


-- Check if column 'EmailAddress' does NOT exist in table 'tblEmployee'
IF NOT EXISTS (
    SELECT * 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE COLUMN_NAME = 'EmailAddress'
      AND TABLE_NAME = 'tblEmployee'
      AND TABLE_SCHEMA = 'dbo'
)
BEGIN
    -- Add the column if it does not exist
    ALTER TABLE tblEmployee
    ADD EmailAddress NVARCHAR(50)
END
ELSE
BEGIN
    -- If column already exists, print message
    PRINT 'Column EmailAddress already exists'
END


--method 2
-- Check if column exists using COL_LENGTH function
IF COL_LENGTH('tblEmployee', 'EmailAddress') IS NOT NULL
BEGIN
    -- Column exists
    PRINT 'Column already exists'
END
ELSE
BEGIN
    -- Column does not exist
    PRINT 'Column does not exist'
END
--bestpractice
-- Safely add column only if it doesn't exist
IF COL_LENGTH('tblEmployee', 'EmailAddress') IS NULL
BEGIN
    ALTER TABLE tblEmployee
    ADD EmailAddress NVARCHAR(50)
END

--alter database column name 
alter table table_name
alter column salary int



CREATE TABLE tblNewEmployee
(
    Id INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(50),
    Email NVARCHAR(50),
    Age INT,
    Gender NVARCHAR(50),
    HireDate DATE
);

INSERT INTO tblNewEmployee VALUES 
('Sara Nan', 'Sara.Nan@test.com', 35, 'Female', '1999-04-04');

INSERT INTO tblNewEmployee VALUES 
('James Histo', 'James.Histo@test.com', 33, 'Male', '2008-07-13');

INSERT INTO tblNewEmployee VALUES 
('Mary Jane', 'Mary.Jane@test.com', 28, 'Female', '2005-11-11');

INSERT INTO tblNewEmployee VALUES 
('Paul Senit', 'Paul.Senit@test.com', 29, 'Male', '2007-10-23');

select * from tblNewEmployee 
ALTER PROC spsearchemp
@name NVARCHAR(50) = NULL,
@email NVARCHAR(50) = NULL,
@gender NVARCHAR(50) = NULL,
@age INT = NULL
AS
BEGIN
    SELECT * 
    FROM tblNewEmployee
    WHERE (Name = @name OR @name IS NULL)
      AND (Email = @email OR @email IS NULL)
      AND (Gender = @gender OR @gender IS NULL)
      AND (Age = @age OR @age IS NULL)
END

execute spsearchemp @gender='Male',@age=29
/*
===========================================================================================

MERGE Statement in SQL:

The MERGE statement is used to perform INSERT, UPDATE, or DELETE operations 
on a target table based on the result of a join with a source table.

It is often called an "UPSERT" operation because it can update existing rows 
and insert new rows in a single query.

Key Components:
1. TARGET TABLE – The table where changes will be applied.
2. SOURCE TABLE – The table from which data is taken.
3. MATCH CONDITION – Defines how rows from source and target are matched.

Operations:
- WHEN MATCHED:
    Executes when a matching row is found in both source and target.
    Typically used for UPDATE or DELETE.

- WHEN NOT MATCHED BY TARGET:
    Executes when a row exists in source but not in target.
    Typically used for INSERT.

- WHEN NOT MATCHED BY SOURCE:
    Executes when a row exists in target but not in source.
    Typically used for DELETE or UPDATE.

Advantages:
- Combines multiple operations into a single statement.
- Improves performance by reducing multiple queries.
- Ensures data synchronization between tables.

Example Use Case:
Used in data warehousing, ETL processes, and syncing tables 
where data needs to be updated or inserted efficiently.
==============================================================================
General Syntax of MERGE in SQL:

MERGE INTO target_table AS T
USING source_table AS S
ON (T.common_column = S.common_column)

WHEN MATCHED THEN
    UPDATE SET 
        T.column1 = S.column1,
        T.column2 = S.column2

WHEN NOT MATCHED BY TARGET THEN
    INSERT (column1, column2, column3)
    VALUES (S.column1, S.column2, S.column3)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

Explanation:
- target_table: Table to be modified.
- source_table: Table providing new data.
- ON: Condition to match rows between source and target.
- WHEN MATCHED: Update or delete existing rows.
- WHEN NOT MATCHED BY TARGET: Insert new rows.
- WHEN NOT MATCHED BY SOURCE: Delete rows not present in source.
*/
-- Source Table
CREATE TABLE StudentSource (
    ID INT,
    NAME VARCHAR(50)
);

-- Target Table
CREATE TABLE StudentTarget (
    ID INT,
    NAME VARCHAR(50)
);


-- Insert into Source Table
INSERT INTO StudentSource (ID, NAME) VALUES
(1, 'Mike'),
(2, 'Sara');

-- Insert into Target Table
INSERT INTO StudentTarget (ID, NAME) VALUES
(1, 'Mike M'),
(3, 'John');

TRUNCATE TABLE StudentSource
TRUNCATE TABLE StudentTarget
select * from StudentSource;
select * from StudentTarget;

MERGE INTO StudentTarget AS T
USING StudentSource AS S
ON T.ID = S.ID

WHEN MATCHED THEN
    UPDATE SET T.NAME = S.NAME

WHEN NOT MATCHED BY TARGET THEN
    INSERT (ID, NAME) VALUES (S.ID, S.NAME)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;---must be end by ;

--or in production level
select * from StudentSource;
select * from StudentTarget;

MERGE INTO StudentTarget AS T
USING StudentSource AS S
ON T.ID = S.ID

WHEN MATCHED THEN
    UPDATE SET T.NAME = S.NAME

WHEN NOT MATCHED BY TARGET THEN
    INSERT (ID, NAME) VALUES (S.ID, S.NAME);

   