/*
RANK and DENSE_RANK in SQL Server

RANK and DENSE_RANK functions
- Return a rank starting at 1 based on the ordering of rows imposed by the ORDER BY clause
- ORDER BY clause is required
- PARTITION BY clause is optional
- When the data is partitioned, rank is reset to 1 when the partition changes

Difference between RANK and DENSE_RANK functions
- RANK function skips ranking(s) if there is a tie whereas DENSE_RANK will not

For example:
If you have 2 rows at rank 1 and you have 5 rows in total

RANK() returns       -> 1, 1, 3, 4, 5
DENSE_RANK() returns -> 1, 1, 2, 3, 4

Syntax:
RANK() OVER (ORDER BY Col1, Col2, ...)
DENSE_RANK() OVER (ORDER BY Col1, Col2, ...)
*/
select * from employees

select name,gender,salary,
rank() over (order by salary desc) as rank,
DENSE_RANK() over (order by salary desc) as dens_rank
from employees


select name,gender,salary,
rank() over (partition by gender order by salary desc) as rank,
DENSE_RANK() over (partition by gender order by salary desc) as dens_rank
from employees
/*
RANK and DENSE_RANK in SQL Server
Use case for RANK and DENSE_RANK functions: Both these functions can be used to find the Nth highest salary. However, which function to use depends on what you want to do when there is a tie.

RANK() Function
Since we have 2 Employees with the FIRST highest salary, the Rank() function will not return any rows for the SECOND highest Salary.
WITH Result AS
(
    SELECT Salary, RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
    FROM Employees
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2

DENSE_RANK() Function
Though we have 2 Employees with the FIRST highest salary, the Dense_Rank() function returns the next Salary after the tied rows as the SECOND highest Salary.

WITH Result AS
(
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
    FROM Employees
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2
*/
WITH Result AS
(
    SELECT Salary, RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
    FROM Employees
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 1


WITH Result AS
(
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) AS Salary_Rank
    FROM Employees
)
SELECT TOP 1 Salary FROM Result WHERE Salary_Rank = 2

/*
Similarities between RANK, DENSE_RANK and ROW_NUMBER functions:

Returns an increasing integer value starting at 1 based on the ordering of rows imposed by the ORDER BY clause (if there are no ties).

ORDER BY clause is required.

PARTITION BY clause is optional.

When the data is partitioned, the integer value is reset to 1 when the partition changes.
*/

select name,gender,salary,
row_number() over(order by salary desc) as rownumber,
rank() over (order by salary desc) as rank,
DENSE_RANK() over (order by salary desc) as dens_rank
from employees

/*
Difference between RANK, DENSE_RANK and ROW_NUMBER functions:

ROW_NUMBER : Returns an increasing unique number for each row starting at 1, even if there are duplicates.

RANK : Returns an increasing unique number for each row starting at 1. When there are duplicates, same rank is assigned to all the duplicate rows, but the next row after the duplicate rows will have the rank it would have been assigned if there had been no duplicates. So RANK function skips rankings if there are duplicates.

DENSE_RANK : Returns an increasing unique number for each row starting at 1. When there are duplicates, same rank is assigned to all the duplicate rows but the DENSE_RANK function will not skip any ranks. This means the next row after the duplicate rows will have the next rank in the sequence.
*/

--calculating running total
select name,gender,salary,
sum(salary) over(partition by gender order by id )as runningtotal
from employees
--always use order by clause with unique row value : reason=> all same value added once same time and same for all column


/*
NTILE function :

ORDER BY Clause is required

PARTITION BY clause is optional

Distributes the rows into a specified number of groups

If the number of rows is not divisible by number of groups, you may have groups of two different sizes.

Larger groups come before smaller groups

For example,

NTILE(2) of 10 rows divides the rows in 2 Groups (5 in each group)

NTILE(3) of 10 rows divides the rows in 3 Groups (4 in first group, 3 in 2nd & 3rd group)

Syntax: NTILE (Number_of_Groups) OVER (ORDER BY Col1, Col2, ...)
*/
select name,gender,salary,
ntile(4) over(order by salary) as [ntile]
from employees

--if ntile more than column number
select name,gender,salary,
ntile(16) over(order by salary) as [ntile]
from employees

--with partition
select name,gender,salary,
ntile(4) over(partition by gender order by salary) as [ntile]
from employees

/*
Lead and Lag functions
- Introduced in SQL Server 2012
- Lead function is used to access subsequent row data along with current row data
- Lag function is used to access previous row data along with current row data
- ORDER BY clause is required
- PARTITION BY clause is optional

Syntax :
LEAD(Column_Name, Offset, Default_Value) OVER (ORDER BY Col1, Col2, ...)
LAG (Column_Name, Offset, Default_Value) OVER (ORDER BY Col1, Col2, ...)

Offset: Number of rows to lead or lag
Default_Value: The default value to return if the number of rows to lead or lag 
               goes beyond first row or last row in a table or partition. 
               If default value is not specified NULL is returned.
*/

select name,gender,salary,
lead(salary) over(order by salary) as lead
from employees

select name,gender,salary,
lead(salary,2,-1) over(order by salary) as lead,
lag(salary,1,-1) over(order by salary) as lag
from employees

--partition by gender
select name,gender,salary,
lead(salary,2,-1) over(partition by gender order by salary) as lead,
lag(salary,1,-1) over(partition by gender order by salary) as lag
from employees

/*
FIRST_VALUE function
- Introduced in SQL Server 2012
- Retrieves the first value from the specified column
- ORDER BY clause is required
- PARTITION BY clause is optional

Syntax : 
FIRST_VALUE(Column_Name) OVER (ORDER BY Col1, Col2, ...)
*/
select name,gender,salary,
first_value(name) over(partition by gender order by salary) as first_val
from employees


/*
Window functions in SQL Server

Different categories of window functions:
- Aggregate functions - AVG, SUM, COUNT, MIN, MAX etc..
- Ranking functions - RANK, DENSE_RANK, ROW_NUMBER etc..
- Analytic functions - LEAD, LAG, FIRST_VALUE, LAST_VALUE etc...

OVER Clause defines the partitioning and ordering of rows (i.e a window) for the above
functions to operate on. Hence these functions are called window functions. The OVER
clause accepts the following three arguments to define a window for these functions to
operate on:
- ORDER BY : Defines the logical order of the rows
- PARTITION BY : Divides the query result set into partitions. The window function is
  applied to each partition separately.
- ROWS or RANGE clause : Further limits the rows within the partition by specifying
  start and end points within the partition.

The default for ROWS or RANGE clause is:
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
*/

select name,gender,salary,
avg(salary) over (order by salary) as avg_salary,
count(salary) over (order by salary) as [count],
sum(salary) over (order by salary) as [sum]
from Employees

--using window function

select name,gender,salary,
avg(salary) over (order by salary rows between unbounded preceding and unbounded following) as avg_salary,
count(salary) over (order by salary rows between unbounded preceding and unbounded following) as [count],
sum(salary) over (order by salary rows between unbounded preceding and unbounded following) as [sum]
from Employees

--UNBOUNDED PRECEDING → from the first row of the partition
--UNBOUNDED FOLLOWING → up to the last row of the partition

select name,gender,salary,
avg(salary) over (partition by gender order by salary rows between unbounded preceding and unbounded following) as avg_salary,
count(salary) over (partition by gender order by salary rows between unbounded preceding and unbounded following) as [count],
sum(salary) over (partition by gender order by salary rows between unbounded preceding and unbounded following) as [sum]
from Employees

--other 
select name,gender,salary,
avg(salary) over (order by salary rows between 1 preceding and 1 following) as avg_salary,
count(salary) over (order by salary rows between 1 preceding and 1 following) as [count],
sum(salary) over (order by salary rows between 1 preceding and 1 following) as [sum]
from Employees

--difference between range and rows
select name,salary,
sum(salary) over (order by salary rows between unbounded preceding and current row) as running_total
from employees
--------
select name,salary,
sum(salary) over (order by salary range between unbounded preceding and current row) as running_total
from employees
--difference is in the way duplicate rows are treated.
--rows treated duplicates as distinct values , where as range treats them as a single entity

select name,salary,
sum(salary) over (order by salary)as [default],
sum(salary) over (order by salary rows between unbounded preceding and current row) as [rows],
sum(salary) over (order by salary range between unbounded preceding and current row) as [range]
from employees

/*
LAST_VALUE function
- Introduced in SQL Server 2012
- Retrieves the last value from the specified column
- ORDER BY clause is required
- PARTITION BY clause is optional
- ROWS or RANGE clause is optional, but for it to work correctly you may have to 
  explicitly specify a value

Syntax : 
LAST_VALUE(Column_Name) OVER (ORDER BY Col1, Col2, ...)
*/

select name,gender,salary,
last_value(name) over(partition by gender order by salary rows between unbounded preceding and unbounded following) as last_val
from employees


/*
UNPIVOT in SQL Server

PIVOT operator turns ROWS into COLUMNS, whereas UNPIVOT turns COLUMNS into ROWS

SalesAgent   India   US   UK
--------------------------------
David        960     520  360
John         970     540  800

SalesAgent   Country   SalesAmount
-----------------------------------
David        India     960
David        US        520
David        UK        360
John         India     970
John         US        540
John         UK        800

SELECT SalesAgent, Country, SalesAmount
FROM tblProductSales
UNPIVOT
(
    SalesAmount
    FOR Country IN (India, US, UK)
) AS UnpivotExample
*/

select * from tblproductsales
--pivot
SELECT 
    SalesAgent,
    ISNULL([India], 0) AS India,
    ISNULL([US], 0) AS US,
    ISNULL([UK], 0) AS UK
FROM 
(
    SELECT SalesAgent, SalesCountry, SalesAmount
    FROM tblproductsales
) AS SourceTable
PIVOT
(
    SUM(SalesAmount)
    FOR SalesCountry IN ([India], [US], [UK])
) AS PivotTable
ORDER BY SalesAgent;

--unpivot
/*
SELECT 
    SalesAgent,
    Country,
    SalesAmount
FROM 
(
    SELECT SalesAgent, India, US, UK
    FROM YourPivotTable
) AS SourceTable
UNPIVOT
(
    SalesAmount
    FOR Country IN (India, US, UK)
) AS UnpivotTable;
*/


/*..
Is it always possible to reverse what PIVOT operator has done using UNPIVOT operator

No, not always. If the PIVOT operator has not aggregated the data, you can get your 
original data back using the UNPIVOT operator but not if the data is aggregated.

PIVOT operator turns ROWS into COLUMNS

SalesAgent | Country | SalesAmount
-----------------------------------
David      | India   | 960
David      | US      | 520
John       | India   | 970
John       | US      | 540

SELECT SalesAgent, India, US
FROM tblProductSales
PIVOT
(
    SUM(SalesAmount)
    FOR Country IN (India, US)
) AS PivotTable

SalesAgent | India | US
------------------------
David      | 960   | 520
John       | 970   | 540
*/

/*
Reverse PIVOT table in SQL Server

UNPIVOT operator reverses what PIVOT operator has done (turn COLUMNS into ROWS)

SalesAgent | India | US
------------------------
David      | 960   | 520
John       | 970   | 540

SELECT SalesAgent, Country, SalesAmount
FROM
(
    SELECT SalesAgent, India, US
    FROM tblProductSales
    PIVOT
    (
        SUM(SalesAmount)
        FOR Country IN (India, US)
    ) AS PivotTable
) P
UNPIVOT
(
    SalesAmount
    FOR Country IN (India, US)
) AS UnpivotTable

We are able to get the original data back, because
the SUM aggregate function that we used with the PIVOT
operator did not perform any aggregation

SalesAgent | Country | SalesAmount
-----------------------------------
David      | India   | 960
David      | US      | 520
John       | India   | 970
John       | US      | 540
*/
