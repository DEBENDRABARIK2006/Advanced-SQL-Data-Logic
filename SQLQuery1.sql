/*
wheather , you create a database graphically using the designer or , using a query , the following 2 files gets generated 
.MDF file - data file (contains actual data)
.LDF file - transaction log file (used to recover the database)

for alter database name
alter database sample1 modify name =sample2
or 
sp_renameDB 'sample1' , 'sample2'

Deleting or Dropping a database 

To Delete or Drop a database
Drop Database DatabaseThatYouWantToDrop

Dropping a database, deletes the LDF and MDF files.

You cannot drop a database, if it is currently in use. You get an error stating - Cannot drop database
"NewDatabaseName" because it is currently in use.

So, if other users are connected, you need to put the database in single user mode and then drop
the database.

Alter Database DatabaseName Set SINGLE_USER With Rollback Immediate

With Rollback Immediate option, will rollback all incomplete transactions and closes the
connection to the database.

Note: System databases cannot be dropped.


for ading foreign key constraint :
alter table tablename add constraint constraintname_fk
foreign key (foreignkey column) refeences primarykeytable (primarykey column)

A constraint is a rule that SQL Server (or any DBMS) enforces on a table to maintain data integrity and data accuracy.
A constraint is a database rule used to enforce data integrity. If a constraint name is not provided, SQL Server generates one automatically, 
but giving a meaningful name is a best practice because it simplifies maintenance, debugging, and database administration.


for default constarint :
-> for existing column 
   alter table tablename 
   add constraint constraintname 
   default [default value] for [existing column name]

-> for adding a new column 
   alter table tablename 
   add {column name} {datatype} {null / not null}
   constraint {constraint name} default {default name}

->droping a constraint
  alter table tablename 
  drop constraint {constraint name }

Cascading referential integrity

Options when setting up Cascading referential integrity constraint:

1. No Action: This is the default behaviour. No Action specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, an error is raised and the DELETE or UPDATE is rolled back.

2. Cascade: Specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, all rows containing those foreign keys are also deleted or updated.

3. Set NULL: Specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, all rows containing those foreign keys are set to NULL.

4. Set Default: Specifies that if an attempt is made to delete or update a row with a key referenced by foreign keys in existing rows in other tables, all rows containing those foreign keys are set to default values.


-> for delete row 
delete from table where id=4

Check Constraint

CHECK constraint is used to limit the range of the values, that can be entered for a column.

The general formula for adding check constraint in SQL Server:

ALTER TABLE {TABLE_NAME}
ADD CONSTRAINT {CONSTRAINT_NAME} CHECK (BOOLEAN_EXPRESSION)

If the BOOLEAN_EXPRESSION returns true, then the CHECK constraint allows the value, otherwise it doesn't. Since, AGE is a nullable column, it's possible to pass null for this column, when inserting a row. When you pass NULL for the AGE column, the boolean expression evaluates to UNKNOWN, and allows the value.

To drop the CHECK constraint:

ALTER TABLE tblPerson
DROP CONSTRAINT CK_tblPerson_Age
*/

select * from GENDER_TABLE
SELECT * FROM PERSON_TABLE

USE SAMPLE1
CREATE TABLE PERSON_TABLE_1 (
PERSON_ID INT IDENTITY(2,1) PRIMARY KEY,
NAME NVARCHAR(50)
)
/*
IDENTITY(seed, increment)
IDENTITY(StartValue, IncrementValue)
*/
INSERT INTO PERSON_TABLE_1 VALUES ('MAHENDRA')
SELECT* FROM PERSON_TABLE_1
DELETE FROM PERSON_TABLE_1 WHERE PERSON_ID=2

SET IDENTITY_INSERT PERSON_TABLE_1 ON
INSERT INTO PERSON_TABLE_1 (PERSON_ID,NAME) VALUES (2,'DEBENDRA')
SET IDENTITY_INSERT PERSON_TABLE_1 OFF
INSERT INTO PERSON_TABLE_1 VALUES ('RAJENDRA')


DELETE FROM PERSON_TABLE_1
DBCC CHECKIDENT(PERSON_TABLE_1,RESEED,0)
INSERT INTO PERSON_TABLE_1 VALUES ('MAHENDRA')




CREATE TABLE TEST1(
ID INT IDENTITY(1,2) ,
VALUE NVARCHAR(50)
)
CREATE TABLE TEST2(
ID INT IDENTITY(1,2) ,
VALUE NVARCHAR(50)
)
--USER 1 IN ONE SESSION 

INSERT INTO TEST1 VALUES('JAGAN')
SELECT * FROM TEST1
SELECT SCOPE_IDENTITY()
SELECT @@IDENTITY
SELECT IDENT_CURRENT('TEST2')

CREATE TRIGGER TRFORINSERT ON TEST1 FOR INSERT
AS 
BEGIN
    INSERT INTO TEST2 VALUES('JAGA')
END
SELECT* FROM TEST2
/*
1. SCOPE_IDENTITY()
Returns the last identity value generated in the same session and same scope.
2. @@IDENTITY
Returns the last identity value generated in the current session, regardless of scope.
3. IDENT_CURRENT()
Returns the last identity value generated for a specific table.
*/

SELECT* FROM PERSON_TABLE
ALTER TABLE PERSON_TABLE
ADD CONSTRAINT UK_PERSONTABLE_EMAIL UNIQUE(EMAIL)
INSERT INTO PERSON_TABLE VALUES (9,'RA','R@R.COM',1,21)  --SHOW ERROR


USE [SAMPLE1]
GO
SELECT [ID]
      ,[NAME]
      ,[EMAIL]
      ,[GENDER_ID]
      ,[AGE]
  FROM [dbo].[PERSON_TABLE]
GO

SELECT DISTINCT NAME, GENDER_ID FROM PERSON_TABLE
/*
DISTINCT is applied to the combination of both NAME and GENDER_ID. 
SQL returns only unique (NAME, GENDER_ID) pairs, not unique NAME values alone and not unique GENDER_ID values alone.
*/
SELECT * FROM PERSON_TABLE WHERE GENDER_ID=1
SELECT * FROM PERSON_TABLE WHERE GENDER_ID<>1  
-- <> OR !=  FOR NOT EQUAL
SELECT * FROM PERSON_TABLE WHERE GENDER_ID=1 OR GENDER_ID=2 OR GENDER_ID=3
SELECT * FROM PERSON_TABLE WHERE GENDER_ID IN (1,2,3)
SELECT * FROM PERSON_TABLE WHERE GENDER_ID BETWEEN 1 AND 3
--like pattern 
SELECT * FROM PERSON_TABLE WHERE NAME LIKE '%J%'
SELECT * FROM PERSON_TABLE WHERE NAME LIKE '__H%'
SELECT * FROM PERSON_TABLE WHERE NAME LIKE '___'
SELECT * FROM PERSON_TABLE WHERE NAME LIKE '_A%'
SELECT * FROM PERSON_TABLE WHERE NAME LIKE '[JMS]%'
SELECT * FROM PERSON_TABLE WHERE NAME LIKE '[A-K]%'
SELECT * FROM PERSON_TABLE WHERE NAME LIKE '[^DR]%'

/*
for valid email       like '%@%'
for in valid email    not like '%@%'
*/


--sorting
SELECT * FROM PERSON_TABLE ORDER BY GENDER_ID DESC
SELECT * FROM PERSON_TABLE ORDER BY GENDER_ID
SELECT * FROM PERSON_TABLE ORDER BY GENDER_ID DESC , NAME ASC

SELECT TOP 5 * FROM PERSON_TABLE
SELECT TOP 2 NAME , AGE FROM PERSON_TABLE
SELECT TOP 50 PERCENT * FROM PERSON_TABLE
--FIND ELDEST EMPLOYEE
SELECT TOP 1 * FROM PERSON_TABLE ORDER BY AGE DESC