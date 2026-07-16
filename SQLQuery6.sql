/*
Why Indexes

Indexes are used by queries to find data from tables quickly. Indexes are created on tables and views. 
Index on a table or a view, is very similar to an index that we find in a book.

If you don't have an index, and I ask you to locate a specific chapter in the book, 
you will have to look at every page starting from the first page of the book.

On, the other hand, if you have the index, you lookup the page number of the chapter in the index, 
and then directly go to that page number to locate the chapter.

Obviously, the book index is helping to drastically reduce the time it takes to find the chapter.

In a similar way, Table and View indexes, can help the query to find data quickly.

In fact, the existence of the right indexes, can drastically improve the performance of the query. 
If there is no index to help the query, then the query engine, checks every row in the table from the beginning to the end. 
This is called as Table Scan. Table scan is bad for performance.
*/

/*
Syntax for Creating an Index

-- Non-Clustered Index
CREATE INDEX IndexName
ON TableName (ColumnName);

Example:
CREATE INDEX IX_Employee_Name
ON Employees (Name);


-- Clustered Index
CREATE CLUSTERED INDEX IndexName
ON TableName (ColumnName);

Example:
CREATE CLUSTERED INDEX IX_Employee_Id
ON Employees (Id);


-- Composite Index (Multiple Columns)
CREATE INDEX IndexName
ON TableName (Column1, Column2);

Example:
CREATE INDEX IX_Employee_Name_Gender
ON Employees (Name, Gender);


-- Unique Index
CREATE UNIQUE INDEX IndexName
ON TableName (ColumnName);

Example:
CREATE UNIQUE INDEX IX_Employee_Email
ON Employees (Email);
*/
--index
select * from Employee

create index ix_tblemployee_salary
on employee (salary asc)

sp_helpindex employee

-- to drop index : 
/*
-- SQL Server (Modern Syntax)
DROP INDEX IndexName
ON TableName;

-- Alternative Syntax (Older SQL Server Versions)
DROP INDEX TableName.IndexName;
*/

--clustered index determines the physical order of data in a table . for this reason a table 
--can have only one clustered index .
select * from Employees

create clustered index ix_employee_gender_salary
on employees(gender desc , salary asc)

sp_helpindex employees
/*
primary key , constraint create clustered indexes automatically if no clustered index alreay
exists on the table .
*/

/*
Clustered Index:
- Physically stores table data in the order of the clustered key.
- Data is maintained in sorted order.
- If rows are inserted as 1,6,2,5,3,9 and Id is the clustered key,
  SQL Server stores them internally as 1,2,3,5,6,9.
- New rows are inserted at the correct location in the index tree.
- Page splits may occur when inserting rows between existing values.
*/
/*
An index works like the index of a book.
Without an index, SQL Server scans every row to find data.
With an index, SQL Server uses a B-Tree structure to quickly locate rows.
This greatly improves SELECT performance because SQL Server performs an Index Seek instead of a Table Scan.
However, indexes require extra storage and make INSERT, UPDATE, and DELETE operations slightly slower because the index must also be maintained.
*/

create nonclustered index ix_table_employee_name
on employees(name)

/*
Non-Clustered Index:

1. Does not change the physical order of data in the table.
2. Creates a separate structure containing indexed column values and row pointers.
3. Works like the index of a book.
4. SQL Server first searches the index and then uses the pointer to locate the actual row.
5. Multiple non-clustered indexes can be created on a table.
6. Improves SELECT query performance.
7. Requires extra storage space.
8. Slows INSERT, UPDATE, and DELETE operations because the index must also be updated.

Clustered Index
= Data itself is sorted.

Non-Clustered Index
= Separate sorted list + pointer to actual data.
*/

/*
Difference Between Clustered Index and Non-Clustered Index

1. Data Storage
   - Clustered Index:
     Physically sorts and stores the actual table data in the order
     of the indexed column.

   - Non-Clustered Index:
     Does not change the physical order of the table data.
     Creates a separate structure that stores index values and pointers
     to the actual rows.

2. Physical Order of Data
   - Clustered Index:
     Data is stored in sorted order based on the index key.

   - Non-Clustered Index:
     Data remains in its original storage order.

3. Number of Indexes Allowed
   - Clustered Index:
     Only one clustered index per table.

   - Non-Clustered Index:
     Multiple non-clustered indexes can be created on a table.

4. Leaf Level
   - Clustered Index:
     Leaf nodes contain the actual data rows.

   - Non-Clustered Index:
     Leaf nodes contain index key values and row locators (pointers).

5. Storage Requirement
   - Clustered Index:
     Does not require separate storage for data because the data itself
     forms the leaf level of the index.

   - Non-Clustered Index:
     Requires additional storage space for the separate index structure.

6. Data Retrieval Speed
   - Clustered Index:
     Faster for range searches and retrieval of large sets of data.

   - Non-Clustered Index:
     Faster for searching specific values through index lookups.

7. Insert, Update and Delete Performance
   - Clustered Index:
     Slower when inserting rows between existing values because page
     splits may occur.

   - Non-Clustered Index:
     Additional maintenance is required whenever data changes.

8. Default Creation
   - Clustered Index:
     A PRIMARY KEY creates a clustered index by default (unless specified otherwise).

   - Non-Clustered Index:
     Must be created explicitly or through constraints configured as non-clustered.

Example:

-- Clustered Index
CREATE CLUSTERED INDEX IX_Employee_Id
ON Employees(Id);

-- Non-Clustered Index
CREATE NONCLUSTERED INDEX IX_Employee_Name
ON Employees(Name);

Example Data Inserted:

INSERT INTO Employees VALUES(1,'A');
INSERT INTO Employees VALUES(6,'B');
INSERT INTO Employees VALUES(2,'C');
INSERT INTO Employees VALUES(5,'D');
INSERT INTO Employees VALUES(3,'E');

Clustered Index on Id:
Stored as:
1, 2, 3, 5, 6

Non-Clustered Index on Name:
Actual table data remains unchanged.
A separate index stores:
A -> Row1
B -> Row2
C -> Row3
D -> Row4
E -> Row5

Memory Trick:

Clustered Index
= Data itself is sorted.

Non-Clustered Index
= Separate sorted list + pointer to actual data.
*/

/*
Can we drop an index created by a PRIMARY KEY?

No, not directly.

Indexes created to support a PRIMARY KEY or UNIQUE constraint
cannot be dropped using DROP INDEX.

Instead, drop the constraint:

ALTER TABLE TableName
DROP CONSTRAINT ConstraintName;

When the constraint is dropped, SQL Server automatically
removes the associated index.
*/

--views
/*
View Definition:

A View is a virtual table in SQL Server that is based on the result
of a SELECT query. A view does not store data itself; it retrieves
data from one or more underlying tables whenever it is queried.
Advantages of Views:

1. Simplifies complex queries.
2. Provides data security by restricting access to specific columns.
3. Hides the complexity of underlying tables.
4. Can combine data from multiple tables.
5. Improves code reusability.
Note:
- A view is called a virtual table because it does not physically
  store data (except Indexed Views).
- Any changes made to the base table are reflected in the view.
*/

SELECT name FROM sys.tables;
select * from Departments
select * from Employees

create view vwemployeesdepartment
as
select name ,gender,salary,city,departmentname,location 
from Employees
join Departments
on Employees.DepartmentId=Departments.id

sp_helptext vwemployeesdepartment
select * from vwemployeesdepartment

--to modify a view
--alter view statement
--to drop a view
--drop view vwname

alter view vwemployeewithoutsalary
as
select id,name,gender,city,departmentid
from Employees 

select * from vwemployeewithoutsalary

update vwemployeewithoutsalary
set name='romario' where id=10

select * from Employees

delete from vwemployeewithoutsalary where id=8

insert into [Employees] values (8,'debendra','Male',90000,'jajpur',3)

/*
Can we update the base table through a view?
Yes.
If the view is updatable, any INSERT, UPDATE, or DELETE
performed on the view is automatically applied to the
underlying base table.

if a views based on multiple underlying base table then can it modify correctly the base table 

Short Answer: Sometimes Yes, Sometimes No.

If a view is based on multiple tables (JOIN), SQL Server has restrictions on which table can be modified.

Single-table view  → Usually fully updatable.

Multi-table view   → Partially updatable with restrictions.

Complex modifications → Use INSTEAD OF triggers.
*/


/*
when we create an index , on a view , the view gets materialized . this means , the view is now capable of storing data
in sql server , we call them indexed views and in oracle , materialized views .
*/

CREATE TABLE Product (
    ProductId INT PRIMARY KEY,
    Name VARCHAR(50),
    UnitPrice INT
);

CREATE TABLE Sales (
    ProductId INT,
    QuantitySold INT
);
INSERT INTO Product VALUES
(1, 'Books', 20),
(2, 'Pens', 14),
(3, 'Pencils', 11),
(4, 'Clips', 10);
INSERT INTO Sales VALUES
(1, 10),
(3, 23),
(4, 21),
(2, 12),
(1, 13),
(3, 12),
(4, 13),
(1, 11),
(2, 12),
(1, 11);
--Guidelines
--The view should be created with SchemaBinding option
--If an Aggregate function in the SELECT LIST references an expression, and if there is a possibility for that expression to become NULL, then, a replacement value should be specified.
--If GROUP BY is specified, the view select list must contain a COUNT_BIG(*) expression
--The base tables in the view, should be referenced with 2 part name.
Create view vwTotalSalesByProduct
With SchemaBinding
as
Select Name,
SUM(ISNULL((QuantitySold * UnitPrice), 0)) as TotalSales,
COUNT_BIG(*) as TotalTransactions -- imp
from dbo.Sales
join dbo.Product
on dbo.Product.ProductId = dbo.Sales.ProductId
group by Name

select * from vwTotalSalesByProduct

Create Unique Clustered Index UIX_vwTotalSalesByProduct_Name
on vwTotalSalesByProduct (Name)

/*
Difference Between Clustered Index and Unique Clustered Index

1. Purpose

   Clustered Index:
   - Physically sorts and stores the table data based on the index key.
   - Does not necessarily enforce uniqueness.

   Unique Clustered Index:
   - Physically sorts and stores the table data.
   - Also enforces uniqueness of the indexed column(s).

2. Duplicate Values

   Clustered Index:
   - Duplicate values are allowed.

   Unique Clustered Index:
   - Duplicate values are NOT allowed.

3. Uniqueness Enforcement

   Clustered Index:
   - SQL Server does not check for duplicate values.

   Unique Clustered Index:
   - SQL Server prevents duplicate values from being inserted.

4. Internal Storage

   Clustered Index:
   - Data rows are stored in sorted order.
   - If duplicate key values exist, SQL Server internally adds a
     uniqueifier to distinguish rows.

   Unique Clustered Index:
   - No uniqueifier is needed because values are already unique.

5. Performance

   Clustered Index:
   - Slightly more overhead when duplicate values exist because
     SQL Server maintains uniqueifiers.

   Unique Clustered Index:
   - Slightly more efficient because every key value is unique.

6. Number Allowed

   - Only one Clustered Index or Unique Clustered Index per table.
   - A table cannot have both simultaneously because both determine
     the physical order of the data.
*/

/*
View Limitations

1. You cannot pass parameters to a view. Table Valued functions are an excellent replacement for parameterized views.

2. Rules and Defaults cannot be associated with views.

3. The ORDER BY clause is invalid in views unless TOP or FOR XML is also specified.

4. Views cannot be based on temporary tables.
*/