--R1
CREATE DATABASE MusicDB
ON PRIMARY
(NAME = 'Music_dat', FILENAME = 'C:\DATA\Music_dat.mdf', SIZE = 20MB, MAXSIZE = 200MB, FILEGROWTH = 20MB),
FILEGROUP SavedGroup
(NAME = 'Music', FILENAME = 'C:\DATA\Music.ndf', SIZE = 50MB, MAXSIZE = 250MB, FILEGROWTH = 20MB)
LOG ON
(NAME = 'Music_log', FILENAME = 'C:\DATA\Music_log.ldf.', SIZE = 50MB, MAXSIZE = 250MB, FILEGROWTH = 20MB)
GO

use MusicDB
go


--R2
 create table Categories
(
  CateID int not null,
  CateName varchar(15),
  Decription varchar(100)
)
go
--insert
insert into Categories values ('01', 'cat1', 'cat1 is'),
                              ('02', 'cat2', 'cat2 is'),
							  ('03', 'cat3', 'cat3 is'),
							  ('04', 'cat4', 'cat4 is'),
							  ('05', 'cat5', 'cat5 is')
select * from Categories
--R3
create table Albums
(
  AlbumID int not null,
  Title varchar(20),
  CateID int,
  CoverImage varchar(250),
  ShortDescription varchar(100),
  Price int,
  Edition int
)
--insert
insert into Albums values ('001', 'title1', '01', 'abc.img', 'mota1','100', '1'),	
                           ('002', 'title2', '02', 'abcd.img', 'mota2','200', '2'),
						   ('003', 'title3', '03', 'abcde.img', 'mota3','400', '3'),
						   ('004', 'title4', '04', 'abcdef.img', 'mota4','500', '4'),
						   ('005', 'title5', '05', 'abcefg.img', 'mota5','600', '5')
go
select * from Albums
--R4
alter table Categories add constraint pk1 primary key nonclustered (CateID)
alter table Albums add constraint pk2 primary key (AlbumID)

alter table Albums add constraint fk foreign key (CateID) references Categories
--R5
alter table Albums add constraint check_price check(Price >0)

alter table Albums add constraint df1 default(1) for Edition
--R6
create clustered index IX_CateID on Categories (CateID)
go
--R7
create view vInfo as
select AlbumID, Title, CateName, CoverImage, Price, Edition
from Categories CT, Albums AB
where CT.CateID = AB.CateID

select * from vInfo
go

--R8
create proc sp_AlbumInfo @AlbumID int, @price_increase int
as
begin
  select * from Categories CT, Albums AB
  where CT.CateID = AB.CateID
        and AlbumID = @AlbumID
  update Albums
  set Price = Price * 1.1
  select * from Categories CT, Albums AB
  where CT.CateID = AB.CateID
        and AlbumID = @AlbumID
end
go
exec sp_AlbumInfo '001', 200
--R9
create trigger Prevent on Categories 
instead of delete
as
begin
  if(select CateID from deleted) in (select CT.CateID from Categories CT, Albums AB
                                     where CT.CateID = AB.CateID)
  begin
    print 'You cannot delete this category because some Albums that belong this category are existsed in the database'
	rollback
  end
end

drop trigger Prevent

--test trigger
delete from Categories
where CateID = '005'
go








