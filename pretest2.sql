CREATE DATABASE Pretset2DB
ON PRIMARY
(NAME = 'pretest2', FILENAME = 'C:\DATA\pretest2.mdf', SIZE = 5MB, MAXSIZE = 50MB, FILEGROWTH = 10%),
FILEGROUP GroupData
(NAME = 'pretest2_fg', FILENAME = 'C:\DATA\pretest2_fg.ndf', SIZE = 10MB, MAXSIZE = unlimited, FILEGROWTH = 5MB)
LOG ON
(NAME = 'NewDataBase3_log', FILENAME = 'C:\DATA\pretest2_log.ldf', SIZE = 2MB, MAXSIZE = unlimited, FILEGROWTH = 10%)
GO
use Pretset2DB
go

create table tbFlight
(
  AircraftCode  nvarchar(10) primary key NONCLUSTERED not null,
  Ftype nvarchar(10) check (Ftype in('Boeing', 'Airbus')),
  Source nvarchar(20),
  Destination nvarchar(20),
  DepTime datetime,
  JourneyHrs int check(JourneyHrs between 1 and 20)
)	
insert into tbFlight values ('UA01', 'Boeing', 'Los AngeLes', 'London', '15:30', '6'),
                            ('UA02', 'Boeing', 'California', 'New York', '9:30', '8'),
							('SA01', 'Boeing', 'Istanbul', 'Ankara', '10:45', '8'),
							('SA02', 'Airbus', 'London', 'Moscow', '11:15', '9'),
							('SQ01', 'Airbus', 'Subney', 'Ankara', '01:45', '15'),
							('SQ02', 'Boeing', 'Perth', 'Aden', '13:30', '10'),
							('SQ03', 'Airbus', 'San Francisco', 'Nairobi', '15:45', '15')
--4. a. Create a clustered index IX_Source for Source column on tbFlight table.
create clustered index IX_Source on dbo.tbFlight(Source)
go
-- b. Create an index IX_Destination for Destination column on tbFlight table
create index IX_Destination on dbo.tbFlight(Destination)
go
select * from tbFlight
--5. Write a query to display the flights that have journey hours less than 9.
select *
from tbFlight 
where JourneyHrs < '9'
--6. Create a view vwBoeing which contains flights that have Boeing aircrafts.
--Note: this view will need to check for domain integrity.
create view vwBoeing as
select AircraftCode, FType, Source, Destination, DepTime, JourneyHrs
from dbo.tbFlight 
where Ftype = 'Boeing'
with check option
go
select * from vwBoeing
--7. Create a store procedure uspChangeHour to increase journey hours by a given value
--(input parameter)
create proc uspChangeHour @increase_Hour int
as
  update tbFlight
  set JourneyHrs = JourneyHrs +@increase_Hour
go
--run
exec uspChangeHour '2'
select * from tbFlight
--8. Create a trigger tgFlightInsert for table tbFlight which will perform rollback transaction
--if a new record has the source same as the destination and display appropriate error
--message.
create trigger tgFlightInsert
on tbFlight
for insert
as
  if(select Source from inserted) = (select Destination from inserted) 
  begin
    print 'orror insert same'
    rollback
  end
insert into tbFlight values  ('UA03', 'Boeing', 'London', 'London', '15:30', '6')
--9. Create a trigger tgFlightUpdate for table tbFlight which is not allowed to change value of
--aircraft code
create trigger tgFlightUpdate 
on tbFlight
for update
as 
  if update(AircraftCode)
  begin
       print 'Cannot update AircraftCode'
	   rollback
  end
update tbFlight
set AircraftCode = 'UA09'
where AircraftCode = 'UA01'