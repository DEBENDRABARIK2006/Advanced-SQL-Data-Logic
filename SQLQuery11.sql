select * from tblproduct
begin transaction 
update tblproduct set qtyavailable=300 where productid=1
commit transaction
--rollback transaction
/*
for another session : 
--if uncommited transaction to read

set transaction isolation level read UNCOMMITTED
select * from tblproduct
*/

/*
===========================================
TABLE: tblPhysicalAddress                  ===============
===========================================
AddressId | EmployeeNumber | HouseNumber | StreetAddress | City    | PostalCode
--------------------------------------------------------------------------------
1         | 101            | #10         | King Street   | LONDOON | CR27DW


===========================================
TABLE: tblMailingAddress
===========================================
AddressId | EmployeeNumber | HouseNumber | StreetAddress | City    | PostalCode
--------------------------------------------------------------------------------
1         | 101            | #10         | King Street   | LONDOON | CR27DW


===========================================
STORED PROCEDURE: spUpdateAddress
===========================================
This procedure updates the City in both tables.
It uses TRANSACTION with TRY-CATCH for safety.

If both updates succeed → COMMIT
If any update fails → ROLLBACK
==========================================
CREATE PROCEDURE spUpdateAddress
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

        -- Update Mailing Address
        UPDATE tblMailingAddress 
        SET City = 'LONDON'
        WHERE AddressId = 1 AND EmployeeNumber = 101

        -- Update Physical Address
        UPDATE tblPhysicalAddress 
        SET City = 'LONDON'
        WHERE AddressId = 1 AND EmployeeNumber = 101

        COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION
    END CATCH
END
*/

EXEC sp_help;

-- Create the Products table
CREATE TABLE newtblProducts
(
    [Id] INT IDENTITY PRIMARY KEY,
    [Name] NVARCHAR(50),
    [Description] NVARCHAR(250)
)

-- Create the Product Sales table
CREATE TABLE newtblProductSales
(
    Id INT PRIMARY KEY IDENTITY,
    ProductId INT FOREIGN KEY REFERENCES newtblProducts(Id),
    UnitPrice INT,
    QuantitySold INT
)

-- Inserting Products
INSERT INTO newtblProducts VALUES ('TV', '52 inch black color LCD TV')
INSERT INTO newtblProducts VALUES ('Laptop', 'Very thin black color acer laptop')
INSERT INTO newtblProducts VALUES ('Desktop', 'HP high performance desktop')

-- Inserting Sales Records
-- (ProductId, UnitPrice, QuantitySold)
INSERT INTO newtblProductSales VALUES (3, 450, 5)
INSERT INTO newtblProductSales VALUES (2, 250, 7)
INSERT INTO newtblProductSales VALUES (3, 450, 4)
INSERT INTO newtblProductSales VALUES (3, 450, 9)

select* from newtblProducts;
select* from newtblProductSales;

/*==================================
 subqueries
====================================
*/
--write query that product not sale
select id , name ,description
from newtblProducts
where id not in (select productid from newtblProductSales)
--or (in another way)
select newtblProducts.id,name,description,newtblProductSales.ProductId
from newtblProducts
left join newtblProductSales
on newtblProducts.id=newtblProductSales.ProductId
where newtblProductSales.ProductId is null


--write a query to retreive the NAME and TOTALQUANTITY sold
-- co related subquery method
select name,
(select sum(QuantitySold) from newtblProductSales where newtblProducts.id=ProductId) as totalquantity
from newtblProducts
order by name
--or(another method)
select name,sum(QuantitySold) as totalquantity
from newtblProducts
join newtblProductSales
on newtblProducts.id=newtblProductSales.ProductId
group by name

/*
=> for drop table 
if(exists(select* 
          from information_schema.tables 
          where table_name='table_to_delete'))
begin
     drop table table_to_delete
end
*/

--insert sample data into newtblProducts table
declare @id int
set @id=1
while(@id<=1000)
begin
     insert into newtblProducts values('product -'+cast(@id as nvarchar(20)),
     'product-'+cast(@id as nvarchar(20))+'description')
     set @id=@id+1
end
select * from newtblProducts


--declare random id between two number
--RAND() returns a decimal number between:0 and 1
declare @ll int
set @ll=1

declare @ul int
set @ul=5

declare @rand int
while(1=1)
begin
    select @rand=round(((@ul-@ll)*rand()+1),0)
    print @rand
    if(@rand<1 or @rand>=5)
    begin
        print 'error-'+ cast(@rand as nvarchar(4))
        break
    end
end


DECLARE @RandomProductId INT
DECLARE @RandomUnitPrice INT
DECLARE @RandomQuantitySold INT

-- Declare and set variables to generate a random ProductId between 1 and 8500
DECLARE @UpperLimitForProductId INT
DECLARE @LowerLimitForProductId INT

SELECT @LowerLimitForProductId = MIN(Id), 
       @UpperLimitForProductId = MAX(Id) 
FROM newtblProducts;

-- Now the rest of your loop will only use IDs that actually exist.

-- Declare and set variables to generate a random UnitPrice between 1 and 100
DECLARE @UpperLimitForUnitPrice INT
DECLARE @LowerLimitForUnitPrice INT

SET @LowerLimitForUnitPrice = 1
SET @UpperLimitForUnitPrice = 100

-- Declare and set variables to generate a random QuantitySold between 1 and 10
DECLARE @UpperLimitForQuantitySold INT
DECLARE @LowerLimitForQuantitySold INT

SET @LowerLimitForQuantitySold = 1
SET @UpperLimitForQuantitySold = 10

-- Insert Sample data into tblProductSales table
DECLARE @Counter INT
SET @Counter = 1

WHILE (@Counter <= 15000)
BEGIN
    SELECT @RandomProductId = ROUND(((@UpperLimitForProductId - @LowerLimitForProductId) * RAND() + @LowerLimitForProductId), 0)
    SELECT @RandomUnitPrice = ROUND(((@UpperLimitForUnitPrice - @LowerLimitForUnitPrice) * RAND() + @LowerLimitForUnitPrice), 0)
    SELECT @RandomQuantitySold = ROUND(((@UpperLimitForQuantitySold - @LowerLimitForQuantitySold) * RAND() + @LowerLimitForQuantitySold), 0)
    
    INSERT INTO newtblProductSales VALUES (@RandomProductId, @RandomUnitPrice, @RandomQuantitySold)

    PRINT @Counter
    SET @Counter = @Counter + 1
END

select * from newtblProducts;
select * from newtblProductSales;

select count(*) from newtblProducts;
select count(*) from newtblProductSales;

checkpoint;
go
dbcc dropcleanbuffers;--clear query cache
go
dbcc freeproccache;--clears execution plan cache
go

--1003 rows affected 22:42:44
select id , name ,description
from newtblProducts
where id in (select productid from newtblProductSales)

--1003 rows , 22:53:53
select distinct newtblProducts.id,name,description
from newtblProducts
inner join newtblProductSales
on newtblProducts.id=newtblProductSales.ProductId
/*
Performance - SubQueries or Joins

According to MSDN, in most cases, there is usually no performance difference 
between queries that uses sub-queries and equivalent queries using joins.

According to MSDN, in some cases where existence must be checked, a join 
produces better performance. Otherwise, the nested query must be processed for 
each result of the outer query. In such cases, a join approach would yield better 
results.

In general joins work faster than sub-queries, but in reality it all depends on the 
execution plan that is generated by SQL Server. It does not matter how we have 
written the query, SQL Server will always transform it on an execution plan. If it 
is "smart" enough to generate the same plan from both queries, you will get the 
same result.

I would say, rather than going by theory, turn on client statistics and execution 
plan to see the performance of each option, and then make a decision. In a 
later video session we will discuss about client statistics and execution plans in 
detail.
*/

/*
ACID Properties in DBMS (Database Management System)

ACID is a set of properties that ensures database transactions
are processed reliably and maintain data integrity.

A = Atomicity
C = Consistency
I = Isolation
D = Durability


---------------------------------------------------------
1. Atomicity (All or Nothing)
---------------------------------------------------------

Definition:
A transaction must be completed entirely or not executed at all.
If any part of the transaction fails, the entire transaction
is rolled back.

Example:

BEGIN TRANSACTION

UPDATE Accounts
SET Balance = Balance - 1000
WHERE AccountId = 1

UPDATE Accounts
SET Balance = Balance + 1000
WHERE AccountId = 2

COMMIT TRANSACTION

Suppose the first UPDATE succeeds but the second UPDATE fails.

Result:
ROLLBACK occurs and both changes are undone.

Money is neither lost nor partially transferred.

Atomicity = "All or Nothing"


---------------------------------------------------------
2. Consistency
---------------------------------------------------------

Definition:
A transaction must take the database from one valid state
to another valid state while preserving all rules,
constraints, and relationships.

Example:

Accounts Table

AccountId    Balance
---------    -------
1            5000
2            3000

Total Balance = 8000

Transfer Rs.1000 from Account 1 to Account 2

After Transaction:

AccountId    Balance
---------    -------
1            4000
2            4000

Total Balance = 8000

Database remains consistent.

Consistency ensures:
- Primary Key constraints are maintained.
- Foreign Key constraints are maintained.
- Check constraints are maintained.
- Data integrity is preserved.


---------------------------------------------------------
3. Isolation
---------------------------------------------------------

Definition:
Multiple transactions executing simultaneously should not
interfere with each other.

Each transaction should behave as if it is the only
transaction running.

Example:

Transaction A:
Withdraw Rs.1000 from Account 1

Transaction B:
Check Balance of Account 1

Without Isolation:
Transaction B may read temporary or incomplete data.

With Isolation:
Transaction B sees only committed data.

Isolation prevents:
- Dirty Reads
- Non-Repeatable Reads
- Phantom Reads


---------------------------------------------------------
4. Durability
---------------------------------------------------------

Definition:
Once a transaction is committed, the changes are permanent,
even if a system crash, power failure, or server restart occurs.

Example:

BEGIN TRANSACTION

UPDATE Employees
SET Salary = 50000
WHERE Id = 1

COMMIT TRANSACTION

After COMMIT:
Even if the database server crashes immediately,
the updated salary remains saved.

Durability ensures committed data is never lost.


---------------------------------------------------------
Real Life Bank Transfer Example
---------------------------------------------------------

Account A = 10000
Account B = 5000

Transfer Rs.2000 from A to B

Atomicity:
    Either both debit and credit occur,
    or neither occurs.

Consistency:
    Total money remains 15000.

Isolation:
    Other users cannot see incomplete transfer.

Durability:
    Once transfer is committed,
    it remains saved permanently.


---------------------------------------------------------
Memory Trick
---------------------------------------------------------

A = Atomicity
    All or Nothing

C = Consistency
    Rules are preserved

I = Isolation
    Transactions don't interfere

D = Durability
    Committed data stays forever


Interview Definition:

ACID is a set of database transaction properties that
ensures reliable, accurate, and secure processing of data.

A - Atomicity
C - Consistency
I - Isolation
D - Durability
*/