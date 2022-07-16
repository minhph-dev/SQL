CREATE DATABASE dbPretest4
ON PRIMARY
(NAME = 'dbPretest4', FILENAME = 'C:\DATA\dbPretest4.mdf', SIZE = 8MB, MAXSIZE = unlimited, FILEGROWTH = 20MB),
FILEGROUP GroupData
(NAME = 'dbPretest4_fg', FILENAME = 'C:\DATA\dbPretest4_fg.ndf', SIZE = 8MB, MAXSIZE = unlimited, FILEGROWTH = 20MB)
LOG ON
(NAME = 'dbPretest4_log', FILENAME = 'C:\DATA\dbPretest4_log.ldf', SIZE = 8MB, MAXSIZE = 50MB, FILEGROWTH = 10%)
GO
use dbPretest4
------------------------------------------------
create table tbStudents
(
  stID varchar(5) primary key nonclustered not null,
  stName varchar(50) not null,
  stAge tinyint check(stAge >=14 and stAge <=70),
  stGender bit default '1'
)
------------------------------------------------
create table tbProjects
(
  pID varchar(5) primary key not null,
  pName varchar(50) unique not null,
  pType varchar(5) check(pType = 'EDU' or pType = 'DEP' or pTYpe = 'GOV'),
  pStartDate Date default getdate() not null
)
------------------------------------------------
create table tbStudentProject
(
  studentID varchar(5) not null foreign key references tbStudents(stID),
  projectID varchar(5) not null foreign key references tbProjects(pID),
  joinedDate date not null default getdate(),
  rate tinyint check(rate between 1 and	15)
  constraint  pk_tbStudentProject primary key (studentID, projectID)
)
------------------------------------------------
set dateformat dmy

insert into tbStudents values ('S01', 'Tom Hanks', '18', '1'),
                              ('S02', 'Phil Collins', '18', '1'),
							  ('S03', 'Jennifer Aniston', '19', '0'),
							  ('S04', 'Jane Fonda', '20', '0'),
							  ('S05', 'Cristiano Ronaldo', '24', '1')
insert into tbProjects values  ('P20', 'Social Network', 'GOV', '12/01/2020'),
                               ('P21', 'React Navtive + NodeJS', 'EDU', '22/08/2020'),
							   ('P22', 'Google Map API', 'DEP', '25/10/2019'),
							   ('P23', 'nCovid Vaccine', 'GOV', '16/05/2020')
insert into tbStudentProject values ('S01', 'P20', '12/02/2020', '4'),
                                    ('S01', 'P21', '12/03/2020', '5'),
									('S02', 'P20', '16/02/2020', '3'),
									('S02', 'P22', '01/09/2020', '5'),
									('S04', 'P21', '12/04/2020', '4'),
									('S04', 'P22', '01/10/2020', '3'),
									('S04', 'P20', '16/10/2020', '3'),
									('S03', 'P23', '04/07/2020', '5')
------------------------------------------------------------------------------------------------
--4. Create a clustered index ‘IX_stname’ for stname column on tbStudents table.
--Create an index ‘IX_pID’ for projectID column on tbStudentProject table	  
create clustered index IX_stname on dbo.tbStudents(stName)
go
create index IX_pID on dbo.tbStudentProject(projectID)
go
--5.Create a view ‘vwStudentProject’ to display the list of students joined to projects had
--start-date before ‘Jun-01-2020’, including following information :
--StudentID, Student name, Student Age, Project name, Start date, Join date and Rate.
--Note: this view will need to check for domain integrity and encryption.
create view vwStudentProject with encryption as
select stID, stName, stAge, pName, pStartDate, joinedDate, Rate
from dbo.tbStudents ST, dbo.tbProjects PJ, dbo.tbStudentProject STPJ
where ST.stID = STPJ.studentID
      and STPJ.projectID = PJ.pID
	  and pStartDate < '01/06/2020'
with check option
go
select * from vwStudentProject
--6.Create a stored procedure ‘upRating’ 
create proc upRating @st_name varchar(50) = null, @avg_rate float output
as if @st_name is null
   begin
     select * from tbProjects PJ, tbStudentProject STPJ, tbStudents ST
	 where PJ.pID = STPJ.projectID
	       and STPJ.studentID = ST.stID
	 select @avg_rate = avg(Rate) from tbStudentProject STPJ, tbStudents ST
	 where STPJ.studentID = ST.stID
   end
   else
   begin
    select * from tbProjects PJ, tbStudentProject STPJ, tbStudents ST
	 where PJ.pID = STPJ.projectID
	       and STPJ.studentID = ST.stID
		   and stName = @st_name
	 select @avg_rate = avg(Rate) from tbStudentProject STPJ, tbStudents ST
	 where STPJ.studentID = ST.stID
	       and stName = @st_name
   end
drop proc upRating
--test
declare @avg_rate float 
exec upRating 'Tom Hanks' , @avg_rate output
print 'Average rate of student is ' + convert(varchar(40), @avg_rate)

declare @avg_rate float 
exec upRating null , @avg_rate output
print 'Average rate of student is ' + convert(varchar(40), @avg_rate)
 --7. Create trigger ‘tgDeleteStudent’, it will remove all projects that student have worked
--for whenever a DEL statement triggered on table 'tbStudents'.