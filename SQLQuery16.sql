--select into in sql server
select * from Departments
select * from Employees

--copy all rows and columns from an existing table into a new table 
select * into employeebackup from Employees
select * from employeebackup
drop table employeebackup
/*
===>copy all rows and columns from an existing table into a new table in an external database
select * into databasename.dbo.tablename from employees
select * from databasename.dbo.tablename
drop table databasename.dbo.tablename
*/
--copy some selected column
select id,name,gender into employeebackup from Employees
select * from employeebackup
drop table employeebackup
--copy only selected row 
select * into employeebackup from Employees where DepartmentId=1
select * from employeebackup
drop table employeebackup

--copy column from 2 or more table into a new table 
select 
e.name,
e.id,
e.gender,
d.location,
d.DepartmentHead
into employeebackup
from Employees e
inner join Departments d
on e.DepartmentId=d.id

select * from employeebackup
drop table employeebackup

/*
====> other method to avoid conflict due to select * (duplicate row)
select 
    Employees.*,
    Departments.DepartmentName
into employeebackup
from Employees
inner join Departments
on Employees.DepartmentId = Departments.id;
*/
--only for schema same 
--that mean same column name and datatype not the data
select * into employeebackup from Employees where 1<>1
select * from employeebackup 
--you cannot use select into statement to select data into an existing table
--select * into employeebackup --no
--use insert into
insert into employeebackup select * from Employees
--other way
insert into employeebackup(id , name , Gender) 
select id , name , Gender from Employees


--difference between where and having clauses in sql server
select * from sales

select productid,sum(quantitysold) as total_sold
from sales
group by productid 
having sum(quantitysold)>34
--where clause doesnot work with aggregare functions like sum,min,max,avg,etc.
/*
WHERE clause filters rows before aggregate calculations are performed where as 
HAVING clause filters rows after aggregate calculations are performed.
So from a performance standpoint, HAVING is slower than WHERE and should be 
avoided when possible.
*/
select productid,sum(quantitysold) as total_sold
from sales
where productid in(1,2)
group by productid 

--use both having and where
select productid,sum(quantitysold) as total_sold
from sales
where productid in(1,2)
group by productid 
having sum(quantitysold)>25
/*
Table Valued Parameter is a new feature introduced in SQL SERVER 2008. Table 
Valued Parameter allows a table (i.e multiple rows of data) to be passed as a 
parameter to a stored procedure from T-SQL code or from an application. Prior to 
SQL SERVER 2008, it is not possible to pass a table variable to a stored procedure.

Please note : Table valued parameters must be passed as read-only to stored 
procedures, functions etc. This means you cannot perform DML operations like 
INSERT, UPDATE or DELETE on a table-valued parameter in the body of a function, 
stored procedure etc.

3 steps to pass multiple rows to a stored procedure using Table Valued Parameter:
Step 1 : Create User-defined Table Type
Step 2 : Use the User-defined Table Type as a parameter in the stored procedure.
Step 3 : Declare a table variable, insert the data rows and then pass the table 
variable as a parameter to the stored procedure


READONLY = Can read data
           Cannot insert, update, or delete data
*/

create table stud
(
id int primary key,
name nvarchar(50),
gender nvarchar(50)
)
go
select * from stud

--for table valued parameter
--Step 1 : Create User-defined Table Type
create type studtype as table
(
id int primary key,
name nvarchar(50),
gender nvarchar(50)
)
--Step 2 : Use the User-defined Table Type as a parameter in the stored procedure.
create proc spinsertstud
@studtype studtype readonly
as
begin
    insert into stud
    select * from @studtype
end
--Step 3 : Declare a table variable, insert the data rows and then pass the table 
declare @studtype studtype

--insert into @studtype values (1, 'deb', 'male')
insert into @studtype values (2, 'smita', 'female')
insert into @studtype values (3, 'jagan', 'male')
insert into @studtype values (4, 'rali', 'female')
insert into @studtype values (5, 'gulu', 'female')

exec spinsertstud @studtype

select * from stud

--grouping sets in sql server
select * from employees
--In SQL, every non-aggregated column in SELECT must be in GROUP BY
select city,Gender,sum(Salary)as total_salary from employees
group by city,gender

union all
--sum of salary by city
select city,null,sum(Salary)as total_salary 
from employees
group by city

union all
--sum of salary by gender
select null,Gender,sum(Salary)as total_salary from employees
group by gender

union all
--grand total
select null,null,sum(Salary)as total_salary from employees

--====>>>> MASTER METHOD
select city,Gender,sum(Salary)as total_salary from employees
group by 
grouping sets
(
(city,gender),
(city),
(gender),
()
)
order by grouping(city),grouping(gender),gender

/*
What does GROUPING() return?
GROUPING(ColumnName)

Returns:

Value	Meaning
0	Actual column value exists
1	Column is aggregated (NULL added by GROUPING SETS)

Delhi	Female	0	0
London	NULL	0	1
Delhi	NULL	0	1
NULL	Male	1	0
NULL	Female	1	0
*/


--rollup in sql server
--rollup is used to do aggregate operation on multiple levels in a hierarchy
--retrieve salary by country along with grand total
select city,sum(Salary)as total_salary from employees
group by rollup(city)
--group by country with rollup             same result 

--group salary by city and gender also compute the subtotal at country level and grand total
select city,gender,sum(Salary)as total_salary from employees
group by rollup(city,gender)
--other method
SELECT city, gender, SUM(Salary) AS total_salary
FROM employees
GROUP BY GROUPING SETS 
(
    (city, gender),  -- detail level
    (city),          -- subtotal by city
    ()               -- grand total
);


--cube in sql server
select city,gender,sum(Salary)as total_salary from employees
group by cube(city,gender)
--other
select city,gender,sum(Salary)as total_salary from employees
GROUP BY GROUPING SETS
(
    (city, gender),  -- detail
    (city),          -- city-wise total
    (gender),        -- gender-wise total
    ()               -- grand total
)
/*
(city, gender)
  → Total salary for each city + gender combination
(city)
→ Total salary for each city (ignores gender)
(gender)
→ Total salary for each gender (ignores city)
() (Grand Total)
→ Total salary of all employees
*/


/*
Difference between CUBE and ROLLUP

CUBE generates a result set that shows aggregates for all combinations of values in the 
selected columns, where as ROLLUP generates a result set that shows aggregates for a 
hierarchy of values in the selected columns

Continent | Country        | City       | SaleAmount
Asia      | India          | Bangalore  | 1000
Asia      | India          | Chennai    | 2000
Asia      | Japan          | Tokyo      | 4000
Asia      | Japan          | Hiroshima  | 5000
Europe    | United Kingdom | London     | 1000
Europe    | United Kingdom | Manchester | 2000
Europe    | France         | Paris      | 4000
Europe    | France         | Cannes     | 5000

ROLLUP(Continent, Country, City)
Continent, Country, City
Continent, Country,
Continent
()

CUBE(Continent, Country, City)
Continent, Country, City
Continent, Country,
Continent, City
Continent
Country, City
Country
City
()
*/

/*
=======================
grouping function
=======================
grouping(column) indicates whether the column in a group by list is aggregated or not.
return 1 for aggregated otherwise 0

*/

select city,gender,sum(Salary)as total_salary,
grouping(city) as gp_city,
grouping(gender) as gp_gender
from employees
group by rollup(city,gender)

--replace null as all
SELECT
Case When GROUPING(city) = 1 THEN 'All' ELSE ISNULL(city, 'Unknown') END AS City,
Case When GROUPING(gender) = 1 THEN 'All' ELSE ISNULL(gender, 'Unknown') END AS Gender,
SUM(Salary) AS total_salary
FROM employees
GROUP BY ROLLUP(city, gender);
--or
SELECT
ISNULL(city, 'ALL') AS City,
ISNULL(gender, 'All') AS Gender,
SUM(Salary) AS total_salary
FROM employees
GROUP BY ROLLUP(city, gender);
--grouping is best approach(because when value of any row is null then it replace by isnull())
/*
GROUPING_ID function in SQL Server

GROUPING_ID function computes the level of grouping

Difference between GROUPING and GROUPING_ID
Syntax : GROUPING function is used on single column, where as the column list for
GROUPING_ID function must match with GROUP BY column list.

GROUPING(Col1)

GROUPING_ID(Col1, Col2, Col3, ....)

GROUPING indicates whether the column in a GROUP BY list is aggregated or not.
Grouping returns 1 for aggregated or 0 for not aggregated in the result set.

GROUPING_ID() concatenates all the GROUPING() functions, perform the binary to
decimal conversion, and returns the equivalent integer.

In short

GROUPING_ID (A, B, C) = GROUPING(A) + GROUPING(B) + GROUPING(C)
*/

select city,gender,sum(Salary)as total_salary,
cast(grouping(city) as nvarchar(1)) +
cast(grouping(gender)as nvarchar(1)) as groupings,
grouping_id(city,gender) as grp_id --binary to decimal
from employees
group by rollup(city,gender)
order by grp_id
--if i want city level total price 
select city,gender,sum(Salary)as total_salary,
cast(grouping(city) as nvarchar(1)) +
cast(grouping(gender)as nvarchar(1)) as groupings,
grouping_id(city,gender) as grp_id --binary to decimal
from employees
group by rollup(city,gender)
having grouping_id(city,gender)=1

--order clause
/*
Over clause in SQL Server

The OVER clause combined with PARTITION BY is used to break up data into partitions.
The specified function operates for each partition

Syntax:
function (...) OVER (PARTITION BY col1, col2, ...)

For example:
COUNT(Gender) OVER (PARTITION BY Gender) will partition the data by GENDER.
i.e there will 2 partitions (Male and Female) and then the COUNT() function is
applied over each partition

Any of the following functions can be used
COUNT(), AVG(), SUM(), MIN(), MAX(), ROW_NUMBER(), RANK(), DENSE_RANK() etc
*/
select *from Employees
select id,name,gender,salary from Employees
select gender,count(*) as gender_total,avg(salary) as avgsal,
       min(salary)as minsal,max(salary)as maxsal
from employees
group by gender

--what if we want non-aggregated values (like empployee name and salary) in result set 
--along with aggregated values 
select name,salary, gender,count(*) as gender_total,avg(salary) as avgsal,
       min(salary)as minsal,max(salary)as maxsal
from employees
group by gender
--error :Column 'employees.Name' is invalid in the select list because it is not contained in either an aggregate function or the GROUP BY clause.
select name,salary,employees.gender,genders.gender_total,genders.avgsal,genders.minsal,genders.maxsal
from employees 
inner join
(select gender,count(*) as gender_total,avg(salary) as avgsal,
       min(salary)as minsal,max(salary)as maxsal
from employees
group by gender) as genders
on genders.gender=employees.gender
--======>master method 
select name,salary,gender,
count(gender) over (partition by gender) as genderstotal,
avg(salary) over (partition by gender) as genderstotal,
min(salary) over (partition by gender) as genderstotal,
max(salary) over (partition by gender) as genderstotal
from employees

/*
Row_Number function

- Introduced in SQL Server 2005
- Returns the sequential number of a row starting at 1
- ORDER BY clause is required
- PARTITION BY clause is optional
- When the data is partitioned, row number is reset to 1 when the partition changes

Syntax:
ROW_NUMBER() OVER (ORDER BY Col1, Col2)
*/

select name,gender,salary,
row_number() over(partition by gender order by gender) as rownumber
from employees
/*
--when duplicate row inserted then to delete duplicate

with employeesCTE as
(
   select *,row_number() over(partition by id order by id)  AS RN
    FROM employees
)

DELETE
FROM employeesCTE
WHERE RN > 1;
*/
