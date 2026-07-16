use SAMPLE1
--ASCII()
SELECT ASCII('a') as ascii_value
SELECT ASCII('BCDW') as ascii_values
SELECT ASCII('Z') AS ASCII_Code
SELECT ASCII('0')

--char()
SELECT CHAR(65)

declare @start int
set @start=48    --65,97,48
while(@start<=57)--90,122,57
begin
print char(@start)
set @start=@start+1
end

--CHARINDEX()
--Finds the position of a substring in a string.
SELECT CHARINDEX('SQL', 'Learn SQL Server') AS Position;

--DIFFERENCE()
--Compares two strings using Soundex and returns similarity (0–4).
SELECT DIFFERENCE('Smith','Smyth') AS Similarity;

/*
Similarity Score Meaning
Score	Meaning
4	Very similar / same pronunciation
3	Highly similar
2	Moderately similar
1	Slightly similar
0	No similarity
*/

--left()
--Returns characters from the left side.
SELECT LEFT('Database',4) AS Result;

--len()
--Returns length of string (excluding trailing spaces).
SELECT LEN('SQL Server') AS Length;

--lower()
--Converts string to lowercase.
SELECT LOWER('HELLO WORLD') AS Result;

--ltrim()
--Removes leading spaces
SELECT LTRIM('   SQL Server') AS Result;

--nchar()
--Returns Unicode character from integer code
SELECT NCHAR(65) AS UnicodeChar;

--PATINDEX()
--Returns starting position of pattern
SELECT PATINDEX('%SQL%', 'Learn SQL Server') AS Position;

--QUOTENAME()
--Adds delimiters around string
SELECT QUOTENAME('Employee sipun') AS Result;

--REPLACE()
--Replaces a substring
SELECT REPLACE('I love SQL','SQL','Database') AS Result;

--REPLICATE()
--Repeats a string multiple times.
SELECT REPLICATE('SQL ',3) AS Result;

--REVERSE()
--Reverses a string.
SELECT REVERSE('HELLO') AS Result;

--RIGHT()
--Returns characters from right side.
SELECT RIGHT('Database',4) AS Result;

--RTRIM()
--Removes trailing spaces
SELECT RTRIM('SQL Server   ') AS Result;

--soundex()
--eturns phonetic representation of string
SELECT SOUNDEX('Smith') AS SoundCode;

--space()
SELECT 'Hello' + SPACE(5) + 'World' AS Result;

--STR()
--Converts numeric value to string.
SELECT STR(123.8945,8,2) AS Result;
/*
Visual Representation
| | |1|2|3|.|8|9|
Total length = 8 characters.
*/

--STRING_SPLIT()
--Splits string into rows.
SELECT value
FROM STRING_SPLIT('HTML,CSS,SQL,JS', ',');

--STUFF()
--Deletes part of string and inserts another
SELECT STUFF('HelloWorld',6,2,'SQL') AS Result;

--substring()
--Returns part of string.
SELECT SUBSTRING('SQL Server',2,3) AS Result;

--unicode()
SELECT UNICODE('A') AS UnicodeValue;

--CONCAT_WS()
SELECT CONCAT_WS('-', '2026','03','14') AS DateFormat;

select getdate();
select current_timestamp;
select SYSDATETIME();
select SYSDATETIMEOFFSET();
select getutcdate();
select SYSUTCDATETIME()

select isdate(current_timestamp)
select day(getdate()) as day
select month(getdate()) as month
select year(getdate()) as year

select datename(day,getdate())
select datename(weekday,getdate())
select datename(month,getdate())

--datepart()
--DATEPART(datepart , date)
SELECT DATEPART(year,'2026-03-15') AS Year_Value;
SELECT DATEPART(month,'2026-03-15') AS Month_Value;
SELECT DATEPART(day,'2026-03-15') AS Day_Value;
SELECT DATEPART(weekday,'2026-03-15') AS Day_Number;

--dateadd()
--DATEADD(datepart , number , date)
SELECT DATEADD(day,5,'2026-03-15') AS New_Date;
SELECT DATEADD(month,2,'2026-03-15') AS New_Date;
SELECT DATEADD(year,1,'2026-03-15') AS Next_Year;
SELECT DATEADD(day,-7,GETDATE()) AS Last_Week;

--daydiff()
--DATEDIFF(datepart , start_date , end_date)
SELECT DATEDIFF(day,'2026-03-01','2026-03-15') AS Days_Difference;
SELECT DATEDIFF(month,'2025-01-01','2026-03-15') AS Month_Difference;
SELECT DATEDIFF(year,'2000-01-01','2026-03-15') AS Year_Difference;


--calculate dob
CREATE TABLE Persons(
Id INT PRIMARY KEY,
Name VARCHAR(50),
DateOfBirth DATETIME
);
INSERT INTO Persons VALUES
(1,'Sam','1980-12-30'),
(2,'Pam','1982-09-01'),
(3,'John','1985-08-22'),
(4,'Sara','1979-11-29');
select * from Persons

create function fncomputeage(@dob datetime)
returns nvarchar(50)
as
begin
DECLARE --@DOB DATETIME = '2006-04-16',
        @tempdate DATETIME,
        @years INT,
        @months INT,
        @days INT

SET @tempdate = @DOB

SET @years = DATEDIFF(YEAR,@tempdate,GETDATE()) -
CASE
    WHEN (MONTH(@DOB) > MONTH(GETDATE()))
      OR (MONTH(@DOB)=MONTH(GETDATE()) AND DAY(@DOB) > DAY(GETDATE()))
    THEN 1 ELSE 0
END

SET @tempdate = DATEADD(YEAR,@years,@tempdate)

SET @months = DATEDIFF(MONTH,@tempdate,GETDATE()) -
CASE
    WHEN DAY(@DOB) > DAY(GETDATE())
    THEN 1 ELSE 0
END

SET @tempdate = DATEADD(MONTH,@months,@tempdate)

SET @days = DATEDIFF(DAY,@tempdate,GETDATE())

declare @age nvarchar(50)
set @age=cast(@years as nvarchar(4)) +'years'+cast(@months as nvarchar(4))+'months'+cast(@days as nvarchar(4))+'days old'
return @age
--SELECT @years AS Years,@months AS Months,@days AS Days
end

select id , Name , DateOfBirth , dbo.fncomputeage(DateOfBirth) as age from Persons

--cast()
--CAST (expression AS data_type [(length)])
SELECT CAST(GETDATE() AS DATE) AS TodayDate;
select getdate()
SELECT CAST(GETDATE() AS nvarchar) AS TodayDate;

--convert()
--CONVERT (data_type [(length)] , expression [, style])
SELECT CONVERT(VARCHAR,GETDATE()) AS DateFormat;
SELECT CONVERT(VARCHAR,GETDATE(),105) AS DateFormat;

