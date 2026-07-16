/*
==========================================================
SEQUENCE OBJECT IN SQL SERVER 2012
==========================================================

SYNTAX:
CREATE SEQUENCE [schema_name . ] sequence_name
    [ AS [ built_in_integer_type | user-defined_integer_type ] ]
    [ START WITH <constant> ]
    [ INCREMENT BY <constant> ]
    [ { MINVALUE [ <constant> ] } | { NO MINVALUE } ]
    [ { MAXVALUE [ <constant> ] } | { NO MAXVALUE } ]
    [ CYCLE | { NO CYCLE } ]
    [ { CACHE [ <constant> ] } | { NO CACHE } ]
    [ ; ]

PROPERTIES AND DESCRIPTIONS:
----------------------------------------------------------
DataType:     Built-in integer type (tinyint, smallint, int, 
              bigint, decimal etc...) or user-defined 
              integer type. Default bigint.

START WITH:   The first value returned by the sequence object.

INCREMENT BY: The value to increment or decrement by. 
              The value will be decremented if a negative 
              value is specified.

MINVALUE:     Minimum value for the sequence object.

MAXVALUE:     Maximum value for the sequence object.

CYCLE:        Specifies whether the sequence object should 
              restart when the max value (for incrementing 
              sequence object) or min value (for decrementing 
              sequence object) is reached. Default is NO CYCLE, 
              which throws an error when minimum or maximum 
              value is exceeded.

CACHE:        Cache sequence values for performance. 
              Default value is CACHE.
==========================================================
*/
--creating an incrementing sequence
create sequence [dbo].[sequenceobject]
as int
start with 1
increment by 1

--generating the next sequence value
select next value for [dbo].[sequenceobject]

--retrieving the current sequence value
select * from sys.sequences where name='sequenceobject'

--reset the sequence value
alter sequence [sequenceobject] 
restart with 1

create table seq
(
id int primary key,
name nvarchar(20),
gender nvarchar(20)
)

insert into seq values(next value for [dbo].[sequenceobject],'deb','male')
insert into seq values(next value for [dbo].[sequenceobject],'jagan','male')
insert into seq values(next value for [dbo].[sequenceobject],'lipa','male')
select * from seq;

--for drop the sequence
--drop sequence [sequenceobject]

--decrement sequence
create sequence [dbo].[sequenceobject2]
as int
start with 100
increment by -1

select next value for [dbo].[sequenceobject2]

--set min and max sequence 
create sequence [dbo].[sequenceobject3]
as int
start with 100
increment by 10
minvalue 100
maxvalue 150

select next value for [dbo].[sequenceobject3]

--restart
alter sequence [sequenceobject3] 
      increment by 10
      minvalue 100
      maxvalue 150
      cycle

--use cache word
create sequence [dbo].[sequenceobject4]
       start with 1
       increment by 1
       cache 10
--CACHE 10 → performance optimization
/*
cache 10
SQL Server pre-allocates 10 values in memory
Improves performance (faster access)

👉 Example:

Instead of generating values one by one from disk,
It keeps 10 values ready in memory

⚠️ Important:

If SQL Server restarts, unused cached values may be lost
(so you may see gaps like 1,2,3,10...)
*/
/*
===============================================================================
DIFFERENCE BETWEEN SEQUENCE & IDENTITY
===============================================================================

-------------------------------------------------------------------------------
|  IDENTITY                               |  SEQUENCE                         |
-------------------------------------------------------------------------------
| Identity property is a table column     | Sequence is a user-defined        |
| property meaning it is tied to the      | database object and is not tied   |
| table.                                  | to any specific table meaning     |
|                                         | its value can be shared by        |
|                                         | multiple tables.                  |
-------------------------------------------------------------------------------
| To generate the next identity value,    | With sequence object there is no  |
| a row has to be inserted into the       | need to insert a row into the     |
| table.                                  | table to generate the next        |
|                                         | sequence value. You can use       |
|                                         | NEXT VALUE FOR clause to generate |
|                                         | the next sequence value.          |
-------------------------------------------------------------------------------
| Maximum value for the identity          | With the sequence object you can  |
| property cannot be specified. The       | use the MAXVALUE option to        |
| maximum value will be the maximum       | specify the maximum value. If the |
| value of the corresponding column       | MAXVALUE option is not specified  |
| data type.                              | for the sequence object, then the |
|                                         | maximum value will be the         |
|                                         | maximum value of its data type.   |
-------------------------------------------------------------------------------
| Identity property does not have any     | With the Sequence object CYCLE    |
| option to automatically restart the     | option can be used to specify     |
| identity values.                        | whether the sequence should       |
|                                         | restart automatically when the    |
|                                         | max value (for incrementing       |
|                                         | sequence object) or min value     |
|                                         | (for decrementing sequence        |
|                                         | object) is reached.               |
-------------------------------------------------------------------------------
===============================================================================
*/


--guid in sql server
/*
a guid is a 16 byte binary data type that is globally unique.guid stands for global unique identifier.
the term GUID and UNIQUEIDENTIFIER are used interchangeably 
syntax : declare @id uniqueidentifier

*how to create a guid :
 to create a guid in sql server use NEWID() function


 for example , select newid()  creates a guid that is guaranteed to be unique across tables,
 databases,and servers.

 example guid: 215D55D8-1683-42D8-927C-B151DBE4EE08
*/

declare @id uniqueidentifier
set @id=newid()
select @id

--select newid()
/*
during create a table :
create table tablename
(
id uniqueidentifier primary key default newid(),
)

insert into tablename values(default,'deb')


observation :
in case of we insert two table value into a single value but one column is primary key
so if in both the table the column value same (1,2 in one table and same 1,2 in another table) then 
during insert both value in a single table then it violates so by use guid we resolve this problem
*/

/*
===============================================================================
GUID IN SQL SERVER
===============================================================================

ADVANTAGES:
-------------------------------------------------------------------------------
* A GUID is unique across tables, databases and servers.
* Useful if you're consolidating records from multiple SQL Servers into a 
  single table.

DISADVANTAGES:
-------------------------------------------------------------------------------
* Size is 16 bytes, whereas INT is only 4 bytes.
* One of the largest datatypes in SQL Server.
* An Index built on a GUID is larger and slower.
* Hard to read compared to INT.

SUMMARY:
-------------------------------------------------------------------------------
Only use a GUID when you really need a globally unique identifier. In all 
other cases it is better to use an INT data type.
===============================================================================
*/

--how to check GUID  is null or empty in sql server
declare @myguid uniqueidentifier
set @myguid=newid()

if(@myguid is null)
begin
   print 'guid is null'
end
else
begin
   print 'guid is not null'
end

--if null then set value
declare @my_guid uniqueidentifier

if(@my_guid is null)
begin
   set @my_guid=newid()
end

select @my_guid as unique_value

--small structure
declare @my_guid_ uniqueidentifier
select isnull(@my_guid_,newid())

--generate null guid value
select cast(0x0 as uniqueidentifier)
--or
select cast(cast(0 as binary)as uniqueidentifier)

--dynamic sql in sql server
--dynamic sql is a sql built from strings at runtime 
/*
Normally, SQL queries are fixed:

SELECT * FROM Employeee
WHERE Name='Mark'

The query is already written before execution.

Dynamic SQL means:   =====================>>>>>>>>>>>>>>>>>>>>>

Build the SQL query as a string at runtime
and execute it later.

Example:

DECLARE @sql NVARCHAR(100)

SET @sql='SELECT * FROM Employeee'

EXEC(@sql)

SQL executes the string stored in @sql
*/



select * from employeee
alter procedure sp_searchemloyees
@name nvarchar(100),
@gender nvarchar(100),
@salary nvarchar(100)
as
begin
   select * from employeee where
   (name=@name or @name is null )and
   (gender=@gender or @gender is null)and
   (salary=@salary or @salary is null)
end

execute sp_searchemloyees steve , null , null
execute sp_searchemloyees mark , null , 50000

--using dynamic sql
declare @sql nvarchar(1000)
declare @params nvarchar(1000)

set @sql='select* from employeee'+' where name=@name and gender=@gender'
set @params='@name nvarchar(100),@gender nvarchar(100)'

execute sp_executesql @sql,@params,@name='mark',@gender='male'

--or
declare @sql nvarchar(1000)
declare @params nvarchar(1000)

set @sql='select* from employeee'+' where name=@name and gender=@gender'
set @params='@name nvarchar(100),@gender nvarchar(100)'

execute sp_executesql @sql,@params,'mark','male'

/*
To execute the Dynamic SQL use system stored procedure sp_executesql.
It takes two pre-defined parameters and any number of user-defined parameters.

Parameter     Description
--------------------------------------------------------------
@statement    This is the first parameter which is mandatory, 
              and contains the SQL statements to execute.

@params       This is the second parameter and is optional. 
              This is used to declare parameters specified in @statement.

The rest of the parameters are the parameters that you declared in @params,
and you pass them the same way as you pass parameters to a stored procedure.
*/