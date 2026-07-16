--pivot operator 
CREATE TABLE tblProductSales (
    SalesAgent VARCHAR(50),
    SalesCountry VARCHAR(50),
    SalesAmount INT
);

INSERT INTO tblProductSales (SalesAgent, SalesCountry, SalesAmount) VALUES 
('Tom',   'UK',    200),
('John',  'US',    180),
('John',  'UK',    260),
('David', 'India', 450),
('Tom',   'India', 350),
('David', 'US',    200),
('Tom',   'US',    130),
('John',  'India', 540),
('John',  'UK',    120),
('David', 'UK',    220),
('John',  'UK',    420),
('David', 'US',    320),
('Tom',   'US',    340),
('Tom',   'UK',    660),
('John',  'India', 430),
('David', 'India', 230),
('David', 'India', 280),
('Tom',   'UK',    480),
('John',  'US',    360),
('David', 'UK',    140);

SELECT SalesCountry, SalesAgent,
SUM(SalesAmount) AS Total
FROM tblProductSales
GROUP BY SalesCountry, SalesAgent
ORDER BY SalesCountry, SalesAgent;

--query using pivot 
select SalesAgent,india,us,uk from tblProductSales
pivot(
      sum(salesamount) 
      for salescountry 
      in([india],[us],[uk])
)
as pivottable
/*
PIVOT is used to convert rows into columns.

It transforms unique values from one column into multiple columns
It also applies an aggregate function (like SUM, COUNT)
*/

------imp imp imp 
/*
if primary key : id is present in tblProductSales then with above query it return same 20 row 
but for this query we pivot from an derived table 
*/
select salesagent , india,us,uk from 
(
select salesagent,salescountry,salesamount
from tblProductSales
) as sourcetable
pivot
(
sum(salesamount) for salescountry in([india],[us],[uk])
) as pivottable



--Error Handling
--TRY....CATCH
BEGIN TRY
    -- risky code
END TRY

BEGIN CATCH
    -- what to do if error occurs
END CATCH

--example 
BEGIN TRY
    SELECT 10 / 0;   -- error (divide by zero)
END TRY

BEGIN CATCH
    PRINT 'Error occurred!';
END CATCH

--Getting Error Details
BEGIN CATCH
    SELECT 
        ERROR_MESSAGE() AS Message,
        ERROR_LINE() AS Line,
        ERROR_NUMBER() AS Number;
END CATCH
-- Transactions + Error Handling (VERY IMPORTANT )
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE A SET Balance = Balance - 1000;
    UPDATE B SET Balance = Balance + 1000;

    COMMIT;
END TRY

BEGIN CATCH
    ROLLBACK;
    PRINT 'Transaction Failed!';
END CATCH


create table tbl_productsales (
 productsalesid int primary key,
 productid int,
 qtysold int
)
select * from tbl_productsales
create table tblproduct (
productid int primary key,
name nvarchar(30),
unitprice int,
qtyavailable int 
)
insert into tblproduct values(1,'laptops',2340,90),(2,'desktops',3467,50)
select* from tblproduct;
select* from tbl_productsales;

execute spsellproduct 1,10

alter procedure spsellproduct
@productid int,
@quantitytosell int
as
begin
     --check the stock available
     declare @stockavailable int
     select @stockavailable=qtyavailable
     from tblproduct where productid=@productid
     --if enough stock is not available
     if(@stockavailable<@quantitytosell)
       begin
       Raiserror('enough stock not available',16,1)
       end
     else
       begin
          begin tran
           --first reduce the quantity available 
           update tblproduct set qtyavailable=(qtyavailable-@quantitytosell)
           where productid=@productid

           declare @maxproductsalesid int
           --calculate max productsalesid
           select @maxproductsalesid =case 
                                           when max(productsalesid) is NULL then 0 
                                           else max(productsalesid) end
                                           from tbl_productsales

           set @maxproductsalesid=@maxproductsalesid+1
           insert into tbl_productsales values(@maxproductsalesid,@productid,@quantitytosell)
           if(@@error<>0)
           begin
              rollback transaction
              print 'transaction rolled back'
           end
           else
           begin
              commit tran
              print 'complete transaction'
           end
       end
end



-- Example 1: Checking error immediately after INSERT
INSERT INTO tblProduct VALUES (2, 'Mobile Phone', 1500, 100)
IF (@@ERROR <> 0)
    PRINT 'Error Occurred'
ELSE
    PRINT 'No Errors'

--Example 2: Demonstrating how @@ERROR gets reset
INSERT INTO tblProduct VALUES (2, 'Mobile Phone', 1500, 100)
--At this point:
--@@ERROR will have a NON-ZERO value (because duplicate ID error may occur)
SELECT * FROM tblProduct
--Now:
--@@ERROR becomes ZERO because SELECT executed successfully
IF (@@ERROR <> 0)
    PRINT 'Error Occurred'
ELSE
    PRINT 'No Errors'


--solution of example 2
declare @error int
INSERT INTO tblProduct VALUES (2, 'Mobile Phone', 1500, 100)
set @error=@@error
select * from tblproduct
if (@error <> 0)
    print 'error occured'
else
    print 'no errors'




--Try Catch block

alter procedure spsellproduct
@productid int,
@quantitytosell int
as
begin
     --check the stock available
     declare @stockavailable int
     select @stockavailable=qtyavailable
     from tblproduct where productid=@productid
     --if enough stock is not available
     if(@stockavailable<@quantitytosell)
       begin
       Raiserror('enough stock not available',16,1)
       end
     else
       begin
        begin try
          begin tran
           --first reduce the quantity available 
           update tblproduct set qtyavailable=(qtyavailable-@quantitytosell)
           where productid=@productid

           declare @maxproductsalesid int
           --calculate max productsalesid
           select @maxproductsalesid =case 
                                           when max(productsalesid) is NULL then 0 
                                           else max(productsalesid) end
                                           from tbl_productsales

           --set @maxproductsalesid=@maxproductsalesid+1
           insert into tbl_productsales values(@maxproductsalesid,@productid,@quantitytosell)
           commit tran
        end try
        begin catch
              rollback transaction
              select 
                ERROR_NUMBER() as errornumber,
                ERROR_MESSAGE() as errormessage,
                ERROR_PROCEDURE() as errorprocedure,
                ERROR_STATE() as errorstate,
                ERROR_SEVERITY () as errorseverity,
                ERROR_LINE() as errorline
        end catch
       end
end