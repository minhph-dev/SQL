create database Exercise2
go
drop database Exercise2
--------------------
use Exercise2
go
--------------------
create table Students
(
  StudentID int not null,
  Name varchar(50),
  Age tinyint,
  stGender bit
)
--------------------
create table Projects
(
  PID int not null,
  PName varchar(50),
  Cost float , 
  Type varchar(10)
)
--------------------
create table StudentProjects
(
  StudentID int not null,
  PID int not null,
  WorkDate date,
  Duration int
)
--------------------insert--------------------
set dateformat dmy;

INSERT INTO Students VALUES (1,'Joe Hart',   25, 1 ),
							(2, 'Colin Doyle',20, 13),
							(3,	'Paul Robinson',16,	Null),
							(4,	'Luis Paulson',	17,	0),
							(5,	'Ben Foster', 30,  1)
GO
----------------------------------------
INSERT INTO Projects VALUES (1,	'NewYork Bridge',100,'Normal'),
							(2,	'Tenda Road',	60,	'Education'),
							(3,	'Google Road',	200,'Government'),
							(4,	'Star Bridge',	50,'Education')
GO
----------------------------------------
INSERT INTO StudentProjects VALUES (1,	4,	'15/05/2018',	3),
								  (2,	2,	'14/05/2018',	5),
								  (2,	3,	'20/05/2018',	6),
								  (2,	1,	'16/05/2018',	4),
								  (3,	1,	'16/05/2018',	6),
								  (3,	4,	'19/05/2018',	7),
								  (4,	4,	'21/05/2018',	8)
GO
--3
--a .	Constraint CHECK in column Age of Students table with range from 15 to 33.
alter table Students add constraint check_Age check(Age between 15 and 30)
--b.	Primary key : StudentID of Students, PID of Projects, (StudentID, PID) of StudentProject
alter table Students add constraint pk1 primary key (StudentID)
alter table Projects add constraint pk2 primary key (PID)
alter table StudentProjects add constraint pk3 primary key (StudentID, PID)

--c.	Default value on Duration column of StudentProject is 0.
alter table StudentProjects add constraint df1 default(0) for Duration
--d.	Constraint Foreign key on 3 tables.
alter table StudentProjects add constraint fk1 foreign key (StudentID) references Students(StudentID)
go
alter table StudentProjects add constraint fk3 foreign key (PID) references Projects(PID)
--4.	Displays the names of students working for more than 1 project
select Name from Students
where StudentID in(select StudentID from StudentProjects
                   group by StudentID
				   having count(PID)>1)

--5.	Displays the names of students who have the largest total working time for projects
select Name from Students
where StudentID in (select top 1 with ties StudentID from StudentProjects
                   group by StudentID
				   order by sum(Duration) desc)

--6.	Display the names of students that contain the word "Paul" and work for the "Star Bridge" project
select Name from Students ST , Projects PJ, StudentProjects STPJ
where ST.StudentID = STPJ.StudentID
      and PJ.PID = STPJ.PID
	  and Name like '%Paul%'
	  and PName = 'Star Bridge'

--7.	Create a view "vwStudentProject" view to display the following information (sort data incrementally by student name): Student name, Project name, Workdate and Duration
create view vwStudentProject
as
select top 100 Name, PName, WorkDate, Duration
from Students ST, StudentProjects STPJ, Projects PJ
where ST.StudentID = STPJ.StudentID
      and STPJ.PID = PJ.PID
ORDER BY Name
GO

SELECT * FROM vwStudentProject
GO
/*
8.	Create a stored procedure  "uspWorking" with a parameter, this parameter is contain the Student Name
- If this name is in the Students table, it will display information about the corresponding Student and Projects that the Student worked on
- If the parameter is 'any', display the names of all students and the projects they worked.
*/
CREATE PROC uspWorking @s_name varchar(50) 
AS
BEGIN
	IF (@s_name IN (SELECT Name FROM Students WHERE Name LIKE @s_name) )
		BEGIN
			SELECT  Name, PName FROM Students s
			JOIN StudentProjects sp ON sp.StudentID = s.StudentID
			JOIN Projects p ON sp.PID = p.PID
			WHERE Name LIKE @s_name
		END
	ELSE IF (@s_name = 'any')
		BEGIN
			SELECT  Name, PName FROM Students s
			JOIN StudentProjects sp ON sp.StudentID = s.StudentID
			JOIN Projects p ON sp.PID = p.PID
		END
	ELSE
	PRINT 'No students named ' +@s_name
END
GO
--test
EXEC uspWorking 'any'
GO
EXEC uspWorking 'Joe Hart'
GO
EXEC uspWorking 'Peter'
GO
--9.	Create a trigger "tgUpdateID" on the Students table, if modify the value on the StudentID column of the Students table, the corresponding value on the StudentID column of the StudentProject table must also be fixed.
CREATE TRIGGER tgUpdateID ON Students
INSTEAD OF UPDATE 
AS
BEGIN
	ALTER TABLE StudentProjects DROP CONSTRAINT fk1
	UPDATE Students SET StudentID = (SELECT StudentID FROM inserted)
					WHERE StudentID = (SELECT StudentID FROM deleted)
	UPDATE StudentProjects SET StudentID = (SELECT StudentID FROM inserted)
					WHERE StudentID = (SELECT StudentID FROM deleted)
	ALTER TABLE StudentProjects 
	ADD CONSTRAINT fk1 FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
END
GO

UPDATE Students SET StudentID = 6 WHERE StudentID = 2
GO
SELECT * FROM Students
SELECT * FROM StudentProjects
GO

--10.	Create a stored procedure "uspDropOut" with a parameter, which contains the name of the Project. If this name is in the Projects table, it will delete all information related to that project in all related tables of the Database.
CREATE PROC uspDropOut @p_Name varchar(50) 
AS
BEGIN
	IF (EXISTS (SELECT * FROM Projects WHERE PName LIKE '%'+@p_Name+'%'))
	BEGIN
		DELETE FROM StudentProjects WHERE PID IN (SELECT PID FROM Projects WHERE PName LIKE '%'+@p_Name+'%')
		DELETE FROM Projects WHERE PName LIKE '%'+@p_Name+'%'
	END
END
GO

EXEC uspDropOut 'Road'
SELECT * FROM Projects
SELECT * FROM StudentProjects
GO
