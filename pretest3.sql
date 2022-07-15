CREATE DATABASE dbPretest3
ON PRIMARY
(NAME = 'pretest3', FILENAME = 'C:\DATA\dbpretest3.mdf', SIZE = 5MB, MAXSIZE = unlimited, FILEGROWTH = 20MB),
FILEGROUP GroupData
(NAME = 'dbpretest3_fg', FILENAME = 'C:\DATA\dbpretest3_fg.ndf', SIZE = 5MB, MAXSIZE = unlimited, FILEGROWTH = 20MB)
LOG ON
(NAME = 'dbpretest3_log', FILENAME = 'C:\DATA\dbpretest3_log.ldf.', SIZE = 2MB, MAXSIZE = 50MB, FILEGROWTH = 10%)
GO
use dbPretest3
go
 ------------------------------------------------
create table tbEmpDetails
(
  Emp_Id varchar(5) primary key nonclustered not null,
  FullName varchar(30) not null,
  PhoneNumber varchar(20) not null,
  Designation varchar(30) check(Designation = 'Manager' or Designation='Staff'),
  Salary money check(Salary between 0 and 3000),
  join_date datetime
)
------------------------------------------------
create table tbLeaveDetails
( 
 Leave_ID int identity(1,1) primary key nonclustered not null,
 Emp_Id varchar(5) foreign key references tbEmpDetails(Emp_Id),
 LeaveTaken int check(LeaveTaken >0 and LeaveTaken<15),
 FromDate datetime,
 ToDate datetime ,
 Reason Varchar(50) not null
)
alter table tbLeaveDetails add constraint check_date check(ToDate>FromDate)
------------------------------------------------
set dateformat dmy

insert into tbEmpDetails values  ('NV01', 'Nguyen Van A', '012345678', 'Manager', '2500', '01/01/2020'),
                                 ('NV02', 'Nguyen Van B', '022345678', 'Staff', '1400', '02/01/2020'),
								 ('NV03', 'Nguyen Van C', '032345678', 'Staff', '1300', '03/01/2020'),
								 ('NV04', 'Nguyen Van D', '042345678', 'Staff', '1600', '04/01/2020'),
								 ('NV05', 'Nguyen Van E', '052345678', 'Staff', '1900', '05/01/2020')
insert into tbLeaveDetails values ( 'NV01', '5', '01/02/2020', '02/02/2020', 'sick'),
                                  ( 'NV02', '3', '03/02/2020', '04/02/2020', 'sick_1'),
								  ( 'NV03', '7', '05/02/2020', '06/02/2020', 'sick_2'),
								  ( 'NV04', '8', '07/02/2020', '08/02/2020', 'sick_3'),
								  ( 'NV05', '9', '09/02/2020', '10/02/2020', 'sick_4')

 ---------------------------------------------------------------------------------------------------------
--4.  Create a clustered index IX_Fullname for fullname column on tbEmployeeDetails table.
-- Create an index IX_EmpID for Emp_ID column on tbLeaveDetails table
create clustered index IX_Fullname on tbEmpDetails(FullName)
go
create index IX_EmpID on tbLeaveDetails(Emp_ID)
go
--5. Create a view vwManager to retrieve the number of leaves taken by employees having
--designation as Manager
--Note: this view will need to check for domain integrity and encryption.
create view vwManager with encryption as
select E.Emp_Id, sum(LeaveTaken)as total 
from tbEmpDetails E , tbLeaveDetails L
where E.Emp_Id = L.Emp_Id
      and Designation = 'Manager'
group by E.Emp_Id
with check option
go

select * from vwManager
go
 --6. Create a store procedure uspChangeSalary to increase salary of an employee by a given
--value (Hint: using input parameters)
create proc uspChangeSalary @emp varchar(5), @value float
as 
  update tbEmpDetails
  set Salary = Salary + @value
  where Emp_Id = @emp
go
drop proc uspChangeSalary
exec uspChangeSalary 'NV01', 200

select * from tbEmpDetails
go
--7. Create a trigger tgInsertLeave for table tbLeaveDetails which will perform rollback
--transaction if total of leaves taken by employees in a year greater than 15 and display
--appropriate error message.
create trigger tgInsertLeave 
on tbLeaveDetails
for insert
as
  if (select sum(LeaveTaken)
      from tbLeaveDetails
      where Emp_Id = (select Emp_Id from inserted)) >15    
  begin
       print 'Cannot insert LeaveTaken > 15'
	   rollback 
  end
go

drop trigger tgInsertLeave
go
insert into tbLeaveDetails values ( 'NV03', '1', '01/02/2020', '03/02/2020', 'sick')
--8. Create a trigger tgUpdateEmploee for table tbEmployeeDetails which removes the
--employee if new salary is reset to zero.
create trigger tgUpdateEmploee
on tbEmpDetails
for update
as 
  if(select Salary from inserted) = 0
  begin
    delete from tbEmpDetails
	where Emp_Id = (select Emp_Id from inserted)
	delete from tbEmpDetails
	where Emp_Id = (select Emp_Id from inserted)
  end
--test 
update tbEmpDetails set Salary = 0 where Emp_Id = 'NV02'