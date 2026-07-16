/*
  TOPIC: FIRST NORMAL FORM (1NF)
  -----------------------------------------------------------------------------
  A table is considered to be in 1NF if it follows these three rules:
  * 1. ATOMICITY: Each column must contain atomic (indivisible) values. 
       No multiple values or comma-separated lists (e.g., 'Sam, Mike, Shan').
  * 2. NO REPEATING GROUPS: The table should not have repeating column groups 
       (e.g., Employee1, Employee2, Employee3). This prevents wasted disk space 
       and avoids structural changes when adding more data.
  * 3. UNIQUE IDENTIFICATION: Each record must be uniquely identifiable using 
       a Primary Key.
  * THE SOLUTION:
    To resolve non-atomic data or repeating groups, the data is split into 
    separate tables linked by a Foreign Key relationship.
 * -----------------------------------------------------------------------------
 */
 -- Create the Departments table (Primary Key table)
CREATE TABLE NF_Departments (
    DeptId INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- Create the Employees table (Linking to DeptId via Foreign Key)
CREATE TABLE NF_Employees (
    DeptId INT,
    Employee VARCHAR(50) NOT NULL,
    FOREIGN KEY (DeptId) REFERENCES NF_Departments(DeptId)
);

-- Insert data into NF_Departments
INSERT INTO NF_Departments (DeptId, DeptName) VALUES 
(1, 'IT'),
(2, 'HR');

-- Insert data into NF_Employees (Atomic values only)
INSERT INTO NF_Employees (DeptId, Employee) VALUES 
(1, 'Sam'),
(1, 'Mike'),
(1, 'Shan'),
(2, 'Pam');

select * from NF_Departments;
select * from NF_Employees;

/*
 * TOPIC: SECOND NORMAL FORM (2NF)
 * -----------------------------------------------------------------------------
 * DEFINITION:
 * A table is said to be in 2NF if it satisfies the following conditions:
 * 1. The table meets all the conditions of 1NF (First Normal Form).
 * 2. Move redundant data to a separate table.
 * 3. Create a relationship between these tables using foreign keys.
 *
 * THE CORE PROBLEM: DATA REDUNDANCY
 * In the original table, Department information (Name, Head, Location) 
 * was repeated for every single employee. This leads to:
 * 1. Disk Space Wastage: Storing the same text multiple times.
 * 2. Data Inconsistency: If 'IT' moves to a new location, you must update 
 * every single row, or risk having conflicting data.
 * 3. Slow DML Queries: INSERT, UPDATE, and DELETE operations become heavy.
 *

 [MAIN TABLE: NF_EMPLOYEE_RECORDS]
 * -----------------------------------------------------------------------------
 * | EmpId | EmployeeName | Gender | Salary | DeptName | DeptHead | DeptLocation |
 * |-------|--------------|--------|--------|----------|----------|--------------|
 * | 1     | Sam          | Male   | 4500   | IT       | John     | London       |
 * | 2     | Pam          | Female | 2300   | HR       | Mike     | Sydney       |
 * | 3     | Simon        | Male   | 1345   | IT       | John     | London       |
 * | 4     | Mary         | Female | 2567   | HR       | Mike     | Sydney       |
 * | 5     | Todd         | Male   | 6890   | IT       | John     | London       |
 * -----------------------------------------------------------------------------
 * -----------------------------------------------------------------------------
 * TABLE DESIGN IN SECOND NORMAL FORM (SPLIT VIEW)
 * -----------------------------------------------------------------------------
 *
 * [TABLE 1: NF_DEPARTMENTS]
 * | DeptId | DeptName | DeptHead | DeptLocation |
 * |--------|----------|----------|--------------|
 * | 1      | IT       | John     | London       |
 * | 2      | HR       | Mike     | Sydney       |
 *
 * [TABLE 2: NF_EMPLOYEES]
 * | EmpId | EmployeeName | Gender | Salary | DeptId |
 * |-------|--------------|--------|--------|--------|
 * | 1     | Sam          | Male   | 4500   | 1      |
 * | 2     | Pam          | Female | 2300   | 2      |
 * | 3     | Simon        | Male   | 1345   | 1      |
 * | 4     | Mary         | Female | 2567   | 2      |
 * | 5     | Todd         | Male   | 6890   | 1      |
 *
 * -----------------------------------------------------------------------------
 * RESULT: 
 * By linking the tables via 'DeptId', we ensure that department details are 
 * defined only once, satisfying the requirements of 2NF.
 */






/*
 * TOPIC: THIRD NORMAL FORM (3NF)
 * -----------------------------------------------------------------------------
 * DEFINITION:
 * A table is said to be in 3NF if:
 * 1. It meets all the conditions of 1NF and 2NF.
 * 2. It does not contain columns (attributes) that are not fully dependent 
 * upon the primary key. This is known as removing Transitive Dependency.
 *
 * THE CORE PROBLEM: TRANSITIVE DEPENDENCY
 * In the examples shown:
 * - AnnualSalary: This is a "calculated column" derived from 'Salary'. It 
 * depends on Salary, not directly on the EmpId. If Salary changes, 
 * AnnualSalary must be manually updated, which is a risk.
 * - DeptName/DeptHead: These depend on 'DeptId', not 'EmpId'. 
 *
 * -----------------------------------------------------------------------------
 * [BAD TABLE: VIOLATING 3NF (With Calculated/Transitive Columns)]
 * | EmpId | EmployeeName | Gender | Salary | AnnualSalary | DeptId |
 * |-------|--------------|--------|--------|--------------|--------|
 * | 1     | Sam          | Male   | 4500   | 54000 (X)    | 1      |
 * | 2     | Pam          | Female | 2300   | 27600 (X)    | 2      |
 * -----------------------------------------------------------------------------
 * * [TABLE DESIGN IN THIRD NORMAL FORM (3NF)]
 * -----------------------------------------------------------------------------
 * To reach 3NF, we remove the calculated 'AnnualSalary' and move 
 * department-specific details into their own reference table.
 *
 * [TABLE 1: NF_EMPLOYEES]
 * | EmpId | EmployeeName | Gender | Salary | DeptId |
 * |-------|--------------|--------|--------|--------|
 * | 1     | Sam          | Male   | 4500   | 1      |
 * | 2     | Pam          | Female | 2300   | 2      |
 * | 3     | Simon        | Male   | 1345   | 1      |
 * | 4     | Mary         | Female | 2567   | 2      |
 * | 5     | Todd         | Male   | 6890   | 1      |
 *
 * [TABLE 2: NF_DEPARTMENTS]
 * | DeptId | DeptName | DeptHead |
 * |--------|----------|----------|
 * | 1      | IT       | John     |
 * | 2      | HR       | Mike     |
 *
 * -----------------------------------------------------------------------------
 * RESULT: 
 * Every non-key attribute is now functional only on the primary key. 
 * 'AnnualSalary' is removed because it can be calculated via a query: 
 * (Salary * 12), ensuring data integrity.
 */
 /*
1NF:
- Each column contains a single value.
- No repeating groups.

2NF:
- Must be in 1NF.
- No partial dependency.
- Every non-key column depends on the entire primary key.

3NF:
- Must be in 2NF.
- No transitive dependency.
- Non-key columns depend only on the primary key.

Memory Trick:

1NF = Atomic Values
2NF = Remove Partial Dependency
3NF = Remove Transitive Dependency
*/