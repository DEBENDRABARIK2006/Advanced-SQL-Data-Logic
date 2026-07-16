/*
=============
dead lock
=============

In a database, a deadlock occurs when two or more processes have a resource locked,
and each process requests a lock on the resource that another process has already
locked. Neither of the transactions here can move forward, as each one is waiting for
the other to release the lock

Dead Lock Scenario in SQL Server

1. Process A Locks Table A
2. Process B Locks Table B
3. Process A Requests Table B (Waiting)
4. Process B Requests Table A (Waiting)

When deadlocks occur, SQL Server will choose one of processes as the deadlock victim
and rollback that process, so the other process can move forward

*/

/*
>>>>>SQL Server deadlock victim selection

How SQL Server detects deadlocks :
Lock monitor thread in SQL Server, runs every 5 seconds by default to detect if there
are any deadlocks. If the lock monitor thread finds deadlocks, the deadlock detection
interval will drop from 5 seconds to as low as 100 milliseconds depending on the
frequency of deadlocks. If the lock monitor thread stops finding deadlocks, the
Database Engine increases the intervals between searches to 5 seconds

What happens when a deadlock is detected
When a deadlock is detected, the Database Engine ends the deadlock by choosing one
of the threads as the deadlock victim. The deadlock victim's transaction is then rolled
back and returns a 1205 error to the application. Rolling back the transaction of the
deadlock victim releases all locks held by that transaction. This allows the other
transactions to become unblocked and move forward.


>>>>>What is DEADLOCK_PRIORITY:

What is DEADLOCK_PRIORITY
By default, SQL Server chooses a transaction as the deadlock victim that is least
expensive to roll back. However, a user can specify the priority of sessions in a deadlock
situation using the SET DEADLOCK_PRIORITY statement. The session with the lowest
deadlock priority is chosen as the deadlock victim

Example: SET DEADLOCK_PRIORITY NORMAL

DEADLOCK_PRIORITY
1. The default is Normal
2. Can be set to LOW, NORMAL, or HIGH
3. Can also be set to a integer value in the range of -10 to 10
   • LOW: -5
   • NORMAL: 0
   • HIGH: 5

>>>>>>>Deadlock Victim Selection Criteria

What is the deadlock victim selection criteria
1. If the DEADLOCK_PRIORITY is different, the session with the lowest priority is
   selected as the victim

2. If both the sessions have the same priority, the transaction that is least expensive to
   rollback is selected as the victim

3. If both the sessions have the same deadlock priority and the same cost, a victim is
   chosen randomly
*/


Create table TableA
(
    Id int identity primary key,
    Name nvarchar(50)
)
Go

Insert into TableA values ('Mark')
Go

Create table TableB
(
    Id int identity primary key,
    Name nvarchar(50)
)
Go

Insert into TableB values ('Mary')
Insert into TableA values ('Ben')
Insert into TableA values ('Todd')
Insert into TableA values ('Pam')
Insert into TableA values ('Sara')
Go

--DELETE FROM TableB
--WHERE id BETWEEN 2 AND 5;

Select * from TableA
Select * from TableB

/*
Transaction 1

Begin Tran

Update TableA Set Name = Name + ' Transaction 1'
where Id IN (1, 2, 3, 4, 5)

Update TableB Set Name = Name + ' Transaction 1'
where Id = 1

Commit Transaction



Transaction 2

SET DEADLOCK_PRIORITY HIGH
Begin Tran

Update TableB Set Name = Name + ' Transaction 2'
where Id = 1

Update TableA Set Name = Name + ' Transaction 2'
where Id IN (1, 2, 3, 4, 5)

Commit Transaction



👉 Transaction 1 will be the deadlock victim

if "SET DEADLOCK_PRIORITY HIGH" is not present then
Transaction 1
Already updated many rows in TableA
Transaction 2
Already updated only 1 row in TableB

👉 So rollback work:

T1 → undo many changes ❌ (costly)
T2 → undo 1 row ✅ (cheap)
👉 Transaction 2 becomes victim
because:

It has less work to rollback at that exact moment
*/

--set sql server trace flag 1222
DBCC traceon (1222,-1)
--check the status of the trace flag
DBCC tracestatus (1222,-1)
--turn off the trace flag
DBCC traceoff(1222,-1)

--to read the error log
execute sp_readerrorlog

-- -1 parameter indicates trace flag must be global level . if you omit -1 parameter the trace
-- flag will be set only at the session level 

--to find blocking queries in sql server 
-- DBCC OPENTRAN

/*
Deadlock analysis and prevention


The deadlock information in the error log has three sections

Section            Description
Deadlock Victim    Contains the ID of the process that was selected as the deadlock victim and killed by SQL Server
Process List       Contains the list of the processes that participated in the deadlock
Resource List      Contains the list of the resources (database objects) owned by the processes involved in the deadlock


Process List Section :

Node        Description
loginname   The loginname associated with the process
isolationlevel   What isolation level is used
procname    The stored procedure name
Inputbuf    The code the process is executing when the deadlock occured


to prevent the deadlock that we have in our case, we need to ensure that database objects (both table)
are accessed in the same order every time 

82 to 86
*/