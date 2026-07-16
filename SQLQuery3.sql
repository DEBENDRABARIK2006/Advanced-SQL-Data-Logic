CREATE TABLE tblIndiaCustomers (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100)
);

INSERT INTO tblIndiaCustomers (Id, Name, Email) VALUES
(1, 'Raj', 'R@R.com'),
(2, 'Sam', 'S@S.com');

CREATE TABLE tblUKCustomers (
    Id INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(100)
);

INSERT INTO tblUKCustomers (Id, Name, Email) VALUES
(1, 'Ben', 'B@B.com'),
(2, 'Sam', 'S@S.com');

--UNION (Removes Duplicate Rows)
SELECT Id, Name, Email FROM tblIndiaCustomers
UNION
SELECT Id, Name, Email FROM tblUKCustomers;

--UNION ALL (Keeps Duplicate Rows)
SELECT Id, Name, Email FROM tblIndiaCustomers
UNION ALL
SELECT Id, Name, Email FROM tblUKCustomers
order by Name

--INTERSECT (Common Records)
SELECT Id, Name, Email FROM tblIndiaCustomers
INTERSECT
SELECT Id, Name, Email FROM tblUKCustomers;

--EXCEPT (Records in First Table Only)
SELECT Id, Name, Email FROM tblIndiaCustomers
EXCEPT
SELECT Id, Name, Email FROM tblUKCustomers;

/*
A stored procedure is group of T-SQL (Transact SQL) statements. 
If you have a situation, where you write the same query over and over again, 
you can save that specific query as a stored procedure and call it just by it's name.
*/

--stored procedure
create procedure spGetCoustomer
as
begin
   select Name,Email from tblIndiaCustomers
end

spGetCoustomer
--or 
exec spGetCoustomer
--or
execute spGetCoustomer


--stored procedure with parameter
create proc spGetcustomerbynameandid
@name nvarchar(50),
@id int
as
begin
    select id,name,email from tblIndiaCustomers 
    where name=@name and id=@id
end

spGetcustomerbynameandid 'sam',2

--to view the text of the stored procedure
sp_helptext 'spGetCoustomer'

--alter
alter procedure spGetCoustomer
as
begin
   select Name,Email from tblIndiaCustomers order by name
end
--drop
-- drop procedure procedurename
--encryption
alter proc spGetcustomerbynameandid
@name nvarchar(50),
@id int
with encryption
as
begin
    select id,name,email from tblIndiaCustomers 
    where name=@name and id=@id
end
--after encryption 
sp_helptext spGetcustomerbynameandid


--with output parameter
select* from Employees
create proc spGetemployeecountbygender
@gender nvarchar(50),
@employeecount int output -- imp
as
begin
   select @employeecount=count(id) from Employees where gender=@gender
   --select count(*) from Employees where gender='male'
end


--to execute
declare @totalcount int
execute spGetemployeecountbygender 'male' , @totalcount out
--execute spGetemployeecountbygender @employeecount=@totalcount out , @gender='male'
print @totalcount


--or
declare @totalcount int
execute spGetemployeecountbygender 'male' , @totalcount out
if(@totalcount is null)
print '@totalcount is null'
else
print '@totalcount is not null '
print @totalcount

--useful system
sp_help spGetemployeecountbygender
sp_helptext spGetemployeecountbygender
sp_depends spGetemployeecountbygender

--stored procedure with return values
create proc spGettotalcount
@totalcount int out
as
begin
   select @totalcount=count(id) from employees 
end

declare @counttotal int 
execute spGettotalcount @counttotal out
print @counttotal
--or for return values 
create proc spGettotalcount2
as
begin
   return (select count(id) from employees) 
end

declare @counttotal int 
execute @counttotal = spGettotalcount2
print @counttotal
/*
ADVANTAGES OF SP : 

Faster execution due to execution plan caching.
Reusable code.
Easier maintenance.
Better security.
Reduced network traffic.
Supports parameters, transactions, and error handling.
Encapsulates business logic.
Helps prevent SQL injection.
Centralized and efficient database management.
*/