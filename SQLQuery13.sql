 /*
    =================================================================================
    sql server concurrent transaction 
    =================================================================================
    */
    -- Create the Accounts table
CREATE TABLE Accounts (
    Id INT PRIMARY KEY,
    AccountName NVARCHAR(50),
    Balance DECIMAL(18, 2)
);

-- Insert initial values
INSERT INTO Accounts (Id, AccountName, Balance)
VALUES (1, 'Mark', 1000),
       (2, 'Mary', 1000);

-- Verify the initial state
SELECT * FROM Accounts;


-- Transfer $100 from Mark to Mary Account
BEGIN TRY
    BEGIN TRANSACTION
        -- Deduct from Mark
        UPDATE Accounts SET Balance = Balance - 100 WHERE Id = 1;
        
        -- Add to Mary
        UPDATE Accounts SET Balance = Balance + 100 WHERE Id = 2;
        
    COMMIT TRANSACTION
    PRINT 'Transaction Committed'
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION
    PRINT 'Transaction Rolled back'
    
    -- Optional: Output the actual error message
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- View results after transfer
SELECT * FROM Accounts;

/*
Common concurrency problems
• Dirty Reads
• Lost Updates
• Nonrepeatable Reads
• Phantom Reads

SQL Server Transaction Isolation Levels
• Read Uncommitted
• Read Committed
• Repeatable Read
• Snapshot
• Serializable

| Isolation Level    | Dirty Reads | Lost Update | Nonrepeatable Reads | Phantom Reads |
|--------------------|-------------|-------------|---------------------|---------------|
| Read Uncommitted   | Yes         | Yes         | Yes                 | Yes           |
| Read Committed     | No          | Yes         | Yes                 | Yes           |
| Repeatable Read    | No          | No          | No                  | Yes           |
| Snapshot           | No          | No          | No                  | No            |
| Serializable       | No          | No          | No                  | No            |
*/

/*
======================
Dirty Read
======================
a dirty read happens when one transaction is permitted to read data that happeen modified by another 
transaction that has not been commited

=> to see dirty read
  *set transaction isolation level read uncommited         --otherwise by default read commited data
  or
  *select * from tblname (nolock) where id=1

  =====================
  Lost Problem
  =====================
  *this happens when 2 transactions read and update the same data
  *for example two trasaction read same number of product that is 10 , T1 sell 1 product and 
  update number=9 and T2 sell 2 product and update number=8 hence atual data lost because after
  two trasaction actual number is 7

==>Transaction 1 :
  
BEGIN TRANSACTION
DECLARE @ItemsInStock INT

SELECT @ItemsInStock = ItemsInStock
FROM tblInventory
WHERE Id = 1

WAITFOR DELAY '00:00:10'
SET @ItemsInStock = @ItemsInStock - 1

UPDATE tblInventory
SET ItemsInStock = @ItemsInStock
WHERE Id = 1

PRINT @ItemsInStock
COMMIT TRANSACTION

==>Transaction 2

BEGIN TRANSACTION
DECLARE @ItemsInStock INT

SELECT @ItemsInStock = ItemsInStock
FROM tblInventory
WHERE Id = 1

WAITFOR DELAY '00:00:1'
SET @ItemsInStock = @ItemsInStock - 2

UPDATE tblInventory
SET ItemsInStock = @ItemsInStock
WHERE Id = 1

PRINT @ItemsInStock
COMMIT TRANSACTION


=>observation : first trasaction 2 complete and number of product is 8 then t1 complete so
final number is 9
======> important : set transaction isolation level repeatable read             in both trasaction and t1 is sucess and t2 is blocked 
It ensures that:
👉 Once you read a row, no other transaction can change or delete that row until your transaction finishes.
-- Another transaction CANNOT update/delete this row now

=============================
non repeatable read
=============================
it happens when one transaction reads the same data twice and another transaction updates 
the data in between the first and second read of trasaction one .
==> to overcome
    set transaction isolation level repeatable read          

==============================
phantom read
===============================
this happens when one transaction executes a query twice and its get different numbaer of rows in the 
result set each time . this happens when a second transaction insert a a new row matches where clause 


====> phantom reads is same as repeatable read but differ for insertion row 

/*
Repeatable Read v/s Serializable

Repeatable read prevents only non-repeatable read. Repeatable read isolation
level ensures that the data that one transaction has read, will be prevented
from being updated or deleted by any other transaction, but it do not prevent
new rows from being inserted by other transactions resulting in phantom read
concurrency problem.

Serializable prevents both non-repeatable read and phantom read problems.
Serializable isolation level ensures that the data that one transaction has
read, will be prevented from being updated or deleted by any other transaction.
It also prevents new rows from being inserted by other transactions, so this
isolation level prevents both non-repeatable read and phantom read problems.
*/

===============================================================
Difference between serializable and snapshot isolation levels
===============================================================
Serializable isolation is implemented by acquiring locks which means the resources are 
locked for the duration of the current transaction. This isolation level does not have any 
concurrency side effects but at the cost of significant reduction in concurrency.

Snapshot isolation doesn't acquire locks, it maintains versioning in Tempdb. Since, 
snapshot isolation does not lock resources, it can significantly increase the number of 
concurrent transactions while providing the same level of data consistency as 
serializable isolation does.

========
snapshot
========
No locks are taken for reading
No blocking between readers and writers
Data remains unchanged for you during the whole transaction
Instead of locking rows, SQL Server uses row versioning:
         When data is updated, the old version is stored in tempdb
         Your transaction reads that old version

ALTER DATABASE YourDB SET ALLOW_SNAPSHOT_ISOLATION ON;--------------------------->>>>>

SET TRANSACTION ISOLATION LEVEL SNAPSHOT;

=>error
Snapshot isolation transaction aborted due to update conflict.
You cannot use snapshot isolation to access table 'tblInventory' directly or indirectly in database 'YourDB' 
to update, delete, or insert the row that has been modified or deleted by another transaction since the start of this transaction.
👉 Snapshot does NOT overwrite newer committed data
👉 Instead, it fails with conflict error

=================================
Read committed snapshot isolation 
==================================
Read committed snapshot isolation level is not a different isolation level. It is a different
way of implementing Read committed isolation level. One problem we have with Read
Committed isolation level is that, it blocks the transaction if it is trying to read the data,
that another transaction is updating at the same time.

To use READ_COMMITTED_SNAPSHOT isolation, enable it at the database level

Alter database SampleDB SET READ_COMMITTED_SNAPSHOT ON--------------------------->>>>>

--Transaction 1
Set transaction isolation level Read Committed
Begin Transaction
Update tblInventory set ItemsInStock = 5 where Id = 1
waitfor delay '00:00:10'
Commit Transaction

-- Transaction 2
Set transaction isolation level read committed
Begin Transaction
Select ItemsInStock from tblInventory where Id = 1
Commit Transaction


| Read Committed Snapshot Isolation                                      | Snapshot Isolation                                                   |
|------------------------------------------------------------------------|----------------------------------------------------------------------|
| No update conflicts                                                    | Vulnerable to update conflicts                                       |
| Works with existing applications without requiring any change to the   | Application change may be required to use with an existing           |
| application                                                            | application                                                          |
| Can be used with distributed transactions                              | Cannot be used with distributed transactions                         |
| Provides statement-level read consistency                              | Provides transaction-level read consistency                          |

*/
