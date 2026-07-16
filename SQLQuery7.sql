/*
Triggers

In SQL server there are 3 types of triggers
1. DML triggers
2. DDL triggers
3. Logon trigger

DML triggers are fired automatically in response to DML events (INSERT, UPDATE & DELETE)

DML triggers can be again classified into 2 types
1. After triggers (Sometimes called as FOR triggers)
2. Instead of triggers

After triggers, fires after the triggering action. The INSERT, UPDATE, and DELETE statements, 
causes an after trigger to fire after the respective statements complete execution.

INSTEAD of triggers, fires instead of the triggering action. The INSERT, UPDATE, and DELETE statements, 
causes an INSTEAD OF trigger to fire INSTEAD OF the respective statement execution.
*/
/*
INSERTED Table (in SQL Server)

The INSERTED table is a special temporary table used inside triggers.

It stores the new values of the rows that are affected by INSERT or UPDATE operations.

- In INSERT trigger: INSERTED table contains newly inserted rows.
- In UPDATE trigger: INSERTED table contains the updated (new) values.
- In DELETE trigger: INSERTED table is empty.

It is used to access new data within a trigger.
*/

select * from employees;
select* from tblemployeeaudit

create trigger tr_tblemployee_forinsert
on employees
for insert
as
begin
    declare @id int
    select @id=id from inserted
    --select* from inserted
    insert into tblemployeeaudit
    values(@id,'new employee with id=' + cast(@id as nvarchar(50))+'is added at' + cast(getdate() as nvarchar(20)))
end

insert into employees values(18,'chandan','male',56000,'steel city',3)
insert into employees values(17,'rina','female',5000,'ranpur city',3)
insert into employees values(46,'rohit','male',56000,'mumbai city',1)

sp_help employees;

alter trigger tr_tblemployee_fordelete
on employees
for delete
as
begin
    declare @id int
    select @id=id from deleted
    select* from deleted
    insert into tblemployeeaudit
    values(@id,'new employee with id=' + cast(@id as nvarchar(50))+'is simply deleted at' + cast(getdate() as nvarchar(20)))
end

delete from employees where id =9
delete from employees where id =11


alter trigger tr_tblemployee_forupdate
on employees
for update
as
begin
   declare @id int
   select @id=id from inserted
   select * from inserted --new data after update 
   select * from deleted  --old data after update 
   insert into tblemployeeaudit
    values(@id,'updated on '+cast(getdate() as nvarchar(20)))
end

update employees set name='HIT MAN ' where id=46
/*
the after trigger for update event , makes use of both inserted and deleted tables.
the inserted table contains the updated data and deleted table contains the old data.
*/

select * from tblEmployee

ALTER TRIGGER tr_tblEmployee_ForUpdate
ON tblEmployee
FOR UPDATE
AS
BEGIN
    -- Variable Declarations
    DECLARE @Id int
    DECLARE @OldName nvarchar(20), @NewName nvarchar(20)
    DECLARE @OldSalary int, @NewSalary int
    DECLARE @OldGender nvarchar(20), @NewGender nvarchar(20)
    DECLARE @OldDeptId int, @NewDeptId int
    
    DECLARE @AuditString nvarchar(1000)

    -- Load new data into a temp table to process row by row
    SELECT *
    INTO #TempTable
    FROM inserted

    -- Loop through each modified record
    WHILE (Exists(SELECT Id FROM #TempTable))
    BEGIN
        SET @AuditString = ''

        -- Get the new values for the current row
        SELECT TOP 1 
            @Id = Id, 
            @NewName = Name,
            @NewGender = Gender, 
            @NewSalary = Salary,
            @NewDeptId = DepartmentId
        FROM #TempTable

        -- Get the old values for the same row from the 'deleted' table
        SELECT 
            @OldName = Name, 
            @OldGender = Gender,
            @OldSalary = Salary, 
            @OldDeptId = DepartmentId
        FROM deleted WHERE Id = @Id

        -- Start building the audit message
        SET @AuditString = 'Employee with Id = ' + CAST(@Id AS nvarchar(4)) + ' changed: '

        -- Compare and append changes to the AuditString
        IF (@OldName <> @NewName)
            SET @AuditString = @AuditString + ' NAME from ' + @OldName + ' to ' + @NewName

        IF (@OldGender <> @NewGender)
            SET @AuditString = @AuditString + ' GENDER from ' + @OldGender + ' to ' + @NewGender

        IF (@OldSalary <> @NewSalary)
            SET @AuditString = @AuditString + ' SALARY from ' + CAST(@OldSalary AS nvarchar(10)) + ' to ' + CAST(@NewSalary AS nvarchar(10))

        IF (@OldDeptId <> @NewDeptId)
            SET @AuditString = @AuditString + ' DepartmentId from ' + CAST(@OldDeptId AS nvarchar(10)) + ' to ' + CAST(@NewDeptId AS nvarchar(10))

        -- Insert the final audit log into the audit table
        INSERT INTO tblEmployeeAudit VALUES (@AuditString)

        -- Delete the processed row from the temp table to move to the next one
        DELETE FROM #TempTable WHERE Id = @Id
    END
END

select* from employees
select* from tblDepartment
sp_help employees;
sp_help tbldepartment

ALTER VIEW vwEmployeeDetails
AS
SELECT 
    e.Id,
    e.Name,
    e.Gender,
    e.Salary,
    e.City,
    d.DepartmentName,
    d.Location,
    d.DepartmentHead
FROM Employees e
JOIN tblDepartment d
ON e.DepartmentId = d.Id;
GO

select * from vwemployeedetails
select* from tblDepartment
/*

/*
Instead of Insert Trigger


                    Employee Table

+----+------+--------+--------------+
| Id | Name | Gender | DepartmentId |
+----+------+--------+--------------+
| 1  | John | Male   | 3            |
| 2  | Mike | Male   | 2            |
| 3  | Pam  | Female | 1            |
| 4  | Todd | Male   | 4            |
| 5  | Sara | Female | 1            |
| 6  | Ben  | Male   | 3            |
+----+------+--------+--------------+


                    Department Table

+--------+----------+
| DeptId | DeptName |
+--------+----------+
| 1      | IT       |
| 2      | Payroll  |
| 3      | HR       |
| 4      | Admin    |
+--------+----------+


                  vwEmployeeDetails

+----+------+--------+----------+
| Id | Name | Gender | DeptName |
+----+------+--------+----------+
| 1  | John | Male   | HR       |
| 2  | Mike | Male   | Payroll  |
| 3  | Pam  | Female | IT       |
| 4  | Todd | Male   | Admin    |
| 5  | Sara | Female | IT       |
| 6  | Ben  | Male   | HR       |
+----+------+--------+----------+


Insert into vwEmployeeDetails values
(7, 'Valarie', 'Female', 'IT')


Msg 4405, Level 16, State 1, Line 1

View or function 'vwEmployeeDetails' is not updatable
because the modification affects multiple base tables.
*/
error : instead of insert trigger

View or function 'vwemployeedetails' is not updatable because the modification affects multiple base tables.

*/
create trigger tr_vwemployeedetails_insteadofinsert
on vwemployeedetails
instead of insert
as
begin
    select* from inserted
    select* from deleted
end

ALTER TRIGGER tr_vwEmployeeDetails_InsteadOfInsert
ON vwEmployeeDetails
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @DeptId INT;

    -- Get DepartmentId from DepartmentName
    SELECT @DeptId = d.Id
    FROM tblDepartment d
    JOIN inserted i
    ON i.DepartmentName = d.DepartmentName;

    -- Check if department exists
    IF (@DeptId IS NULL)
    BEGIN
        RAISERROR('Invalid Department Name. Statement terminated',16,1);
        RETURN;
    END

    -- Insert into Employees table
    INSERT INTO Employees (Id, Name, Gender, Salary, City, DepartmentId)
    SELECT 
        Id,
        Name,
        Gender,
        Salary,
        City,
        @DeptId
    FROM inserted;
END;

INSERT INTO vwEmployeeDetails
(Id, Name, Gender, Salary, City, DepartmentName, Location, DepartmentHead)
VALUES
(100, 'saismita', 'female', 123456, 'boulanga', 'HR', 'jajpur', 'debendra');

--if and if 
INSERT INTO vwEmployeeDetails
(Id, Name, Gender, Salary, City, DepartmentName, Location, DepartmentHead)
VALUES
(100, 'saismita', 'female', 123456, 'boulanga', 'chemistry', 'jajpur', 'debendra');
/*
Invalid Department Name. Statement terminated
*/
/*
Create Trigger tr_vwEmployeeDetails_InsteadOfUpdate
on vwEmployeeDetails
instead of update
as
Begin

    -- if EmployeeId is updated
    if(Update(Id))
    Begin
        Raiserror('Id cannot be changed', 16, 1)
        Return
    End

    -- If DeptName is updated
    if(Update(DeptName))
    Begin
        Declare @DeptId int

        Select @DeptId = DeptId
        from tblDepartment
        join inserted
        on inserted.DeptName = tblDepartment.DeptName

        if(@DeptId is NULL)
        Begin
            Raiserror('Invalid Department Name', 16, 1)
            Return
        End

        Update tblEmployee
        set DepartmentId = @DeptId
        from inserted
        join tblEmployee
        on tblEmployee.Id = inserted.Id
    End

    -- If gender is updated
    if(Update(Gender))
    Begin
        Update tblEmployee
        set Gender = inserted.Gender
        from inserted
        join tblEmployee
        on tblEmployee.Id = inserted.Id
    End

    -- If Name is updated
    if(Update(Name))
    Begin
        Update tblEmployee
        set Name = inserted.Name
        from inserted
        join tblEmployee
        on tblEmployee.Id = inserted.Id
    End

End
*/
ALTER TRIGGER tr_vwEmployeeDetails_InsteadOfUpdate
ON vwEmployeeDetails
INSTEAD OF UPDATE
AS
BEGIN
    -- 1. Prevent updating primary key
    IF UPDATE(Id)
    BEGIN
        RAISERROR('Id cannot be changed', 16, 1);
        RETURN;
    END

    ---------------------------------------------------
    -- 2. Validate DepartmentName
    ---------------------------------------------------
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN tblDepartment d
        ON i.DepartmentName = d.DepartmentName
        WHERE d.Id IS NULL
    )
    BEGIN
        RAISERROR('Invalid Department Name',16,1);
        RETURN;
    END

    ---------------------------------------------------
    -- 3. SINGLE CLEAN UPDATE (BEST PRACTICE ✅)
    ---------------------------------------------------
    UPDATE e
    SET 
        e.Name = i.Name,
        e.Gender = i.Gender,
        e.Salary = i.Salary,
        e.City = i.City,
        e.DepartmentId = d.Id
    FROM Employees e
    JOIN inserted i ON e.Id = i.Id
    LEFT JOIN tblDepartment d 
        ON i.DepartmentName = d.DepartmentName;

END;
GO

UPDATE vwEmployeeDetails
SET DepartmentName = 'Payroll'
WHERE Id = 3;

select * from vwemployeedetails
select * from tblDepartment
select * from employees
select * from inserted

sp_help tbldepartment


create trigger tr_vwemployeedetails_insteadofdelete 
on vwemployeedetails
instead of delete
as 
begin
   delete employees
   from employees join deleted
   on employees.id=deleted.id

   --subquery
   --delete from employee
   --where id in (select id from deleted)
end