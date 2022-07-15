create database dbPretest
use dbPretest
go
 ------------------------------------------------
create table tbRoom
( 
  RoomNo int primary key not null,
  Type varchar(20) check (Type in('VIP', 'Double', 'Single')),
  UnitPrice money check (UnitPrice >=0 and UnitPrice <1000)
)
------------------------------------------------
create table tbBooking 
(
  BookingNo int not null,
  RoomNo  int foreign key references tbRoom(RoomNo) not null,
  TouristName varchar(20) not null, 
  DateFrom datetime, 
  DateTo datetime 
)
alter table tbBooking add constraint check_date check(DateTo > DateFrom)
alter table tbBooking add constraint PK_CTHD PRIMARY KEY NONCLUSTERED (BookingNo, RoomNo) 
------------------------------------------------
set dateformat dmy
insert into tbRoom values ('101', 'Single', '100'),
                          ('102', 'Single', '100'),
						  ('103', 'Double', '250'),
						  ('201', 'Double', '250'),
						  ('202', 'Double', '300'),
						  ('203', 'Single', '150'),
						  ('301', 'VIP', '900')
insert into tbBooking values ('1', '101', 'Julia', '12/11/2020', '14/11/2020'), 
                             ('1', '103', 'Julia', '12/12/2020', '13/12/2020'), 
							 ('2', '301', 'Bill', '10/01/2021', '14/01/2021'), 
							 ('3', '201', 'Ana', '12/01/2021', '14/01/2021'), 
							 ('3', '202', 'Ana', '12/01/2021', '14/01/2021')
------------------------------------------------------------------------------------------------------------------------
--3. Create a clustered index ixName on column TouristName of table tbBooking
create clustered index ixName on tbBooking(TouristName)
go
--4. Create a non-clustered index ixType on column Type of table tbRoom
create index ixType on tbRoom(Type)
go
--5. Create a view vwBooking to see the information about bookings in year 
--2020 which contain the following columns:
--BookingNo, TouristName, RoomNo,Type, UnitPrice, DateFrom, DateTo. The
--definition of view must be encrypted.
create view vwBooking with encryption
as
  select BookingNo, TouristName, tbRoom.RoomNo,Type, UnitPrice, DateFrom, DateTo 
  from tbBooking inner join tbRoom on tbBooking.RoomNo =tbRoom.RoomNo
  where year(DateFrom)= '2020' or year(DateTo) = '2020'
go
select * from vwBooking
--6. Create a stored procedure name uspPriceDecrease will down the unit price of double rooms a
--given amount (input parameter). If non value given, display a list of rooms, sorted by price .
create proc uspPriceDecrease @pricedown float = null
as if @pricedown is null
   begin
     select * from tbRoom 
	 order by UnitPrice DESC
   end
   else
   begin
      update tbRoom
      set UnitPrice = UnitPrice - @pricedown
      where Type ='Double'
   end
 --test proc
 exec uspPriceDecrease
 go
 exec uspPriceDecrease 50
 select * from tbRoom
 --7. Create a stored procedure name uspSpecificPriceIncrease will increment the unit price of a given
--room (input parameter) by a given amount (input parameter) and return the number of rooms
--(output parameter) which have room rate above 250.
create proc uspSpecificPriceIncrease @Price_increase float,@roomNo int, @Totalroom int output
as 
  update tbRoom
  set UnitPrice = UnitPrice + @Price_increase
  where RoomNo = @roomNo
  select @Totalroom = count(*)
  from tbRoom
  where UnitPrice >250
go
--test proc
declare @Totalroom int 
exec uspSpecificPriceIncrease 50,101, @Totalroom output
print 'Total room is ' + convert(varchar(40), @Totalroom)
select * from tbRoom

--8. Create a trigger named tgBookingRoom that allows one booking order having 3 rooms maximum.
create trigger tgBookingRoom on tbBooking
for insert
as
	if (select count(*) 
	from tbBooking 
	where BookingNo = (Select BookingNo from inserted)) > 3
	begin
		print 'Cannot booking more than 3 room in a order booking'
		rollback
	end
go
--test
insert into tbBooking values (1, 201, 'Julia','12/12/2020', '13/12/2020' )
go
--9.Create a trigger named tgRoomUpdate that doing the following (using try-catch structure) : If new
--price is equal to 0 and this room has not existed in tbBooking, then remove it from tbRoom table
--else display an error message and roll back transaction.
 create trigger tgRoomUpdate on tbRoom
 for update
 as
   if(select UnitPrice from inserted ) = 0
   begin
     if(select RoomNo from inserted) not in (select RoomNo from tbBooking)
	 begin
	   delete from tbRoom where RoomNo = (select RoomNo from inserted)
	 end
	 else
	 begin
	   print 'Cannot update this room'
	   rollback
	 end
     
   end
