create database Exercise3
go
use Exercise3
go
------------------------
create table Customer
(
 CustomerID int not null,
 Name varchar(30),
 Birth datetime, 
 Gender bit
)
------------------------
create table Product
(
  ProductId int not null,
  Name varchar(30), 
  PDesc text,
  Pimage varchar(200),
  Pstatus bit
)
------------------------
create table Comment
(
 ComID int identity not null,
 ProductID int not null,
 CustomerID int not null,
 Date datetime,
 Title varchar(200),
 Content text,
 Status bit

)
--------------------------------------------insert------------------------------------------------------
set dateformat dmy

insert into Customer values (1, 'Jonny Owen', '10/10/1980', 1),
                            (2, 'Christina Tiny', '10/03/1989', 0),
							(3, 'Garry Kelley', '16/03/1990', null),
							(4, 'Tammy Beckham', '17/05/1980', 0),
							(5, 'David Phantom', '30/12/1987', 1)

insert into Product values (1, 'Nokia N90', 'Mobile Nokia', 'Image1.jpg', 1),
                           (2, 'HP DV6000', 'Laptop', 'Image2.jpg', null),
						   (3, 'HP DV2000', 'Laptop', 'Image3.jpg', 1),
						   (4, 'Samsung G488', 'Mobile Samsung', 'Image4.jpg', 0),
						   (5, 'LCD Plasma', 'TV LCD', 'Image5.jpg', 0)

insert into Comment values (1,1,'15/03/09', 'Hot product', null, 1),
                           (2,2,'14/03/09', 'Hot price', 'Very much', 1),
						   (3,2,'20/03/09', 'Cheapest', 'Unlimited', 1),
						   (4,2,'16/04/09', 'Sale off', '50%', 1)
------------------------------------------------------------------------------------------------
--3.
--a.	Default value on Date column of Comment is current date.
alter table Comment add constraint df_date default( getdate()) for Date
--b.	Primary key : CustomerID of Customer, ProductID of Product and ComID of Comment
alter table Customer add constraint pk1 primary key (CustomerID) 
alter table Product add constraint pk2 primary key (ProductID)
alter table Comment add constraint pk3 primary key (ComID)
--c.	Constraint Foreign key on 3 tables.
alter table Comment add constraint fk1 foreign key (ProductID) references Product(ProductID)
alter table Comment add constraint fk2 foreign key (CustomerID) references Customer(CustomerID)
--d.	Constraint Unique for Pimage of Product.
alter table Product add constraint constraint_uni unique(Pimage)
--4.	Displays the products have PStatus is null or 0.
select * from Product 
where Pstatus is null or Pstatus =0
go
--5.	Displays the products have no comments.
select * from Product
where ProductID not in(select ProductID from Comment )
go
--6.	Display the name of customers who have the largest comment.
select Name from Customer
where CustomerID in (select top 1 with ties CustomerID from Comment
	                     group by CustomerID
						 order by sum(CustomerID) desc)
go
--7.	Create a view "vwCustomerList" to display the information of customer includes all the column of Customer and age of customer >=35
create view vwCustomerList as
select CustomerID, Name , Gender
from Customer
where year(getdate())- year(Birth) >=35
go

select * from vwCustomerList
go
--8.	Create a trigger "tgUpdateProduct" on the Product table, 
--if modify the value on the ProductID column of the Product table, 
--the corresponding value on the ProductID column of the Comment table must also be fixed.
create trigger tgUpdateProduct on Product
for update
as
begin
   alter table Comment drop constraint fk1
   UPDATE Product SET ProductID = (SELECT ProductID FROM inserted)
					WHERE ProductID = (SELECT ProductID FROM deleted)
   UPDATE Comment SET ProductID = (SELECT ProductID FROM inserted)
					WHERE ProductID = (SELECT ProductID FROM deleted)
	ALTER TABLE Comment 
	ADD CONSTRAINT fk1 FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
end
go
--9.	Create a stored procedure "uspDropOut" with a parameter,
--which contains the name of Customer. If this name is in the Customer table,
--it will delete all information related to this customer in all related tables of the Database.
CREATE PROC uspDropOut @cust_name varchar(50) 
as 
  IF (EXISTS (SELECT * FROM Customer WHERE Name LIKE '%'+@cust_name+'%'))
	BEGIN
		DELETE FROM Comment WHERE CustomerID IN (SELECT CustomerID FROM Customer WHERE Name LIKE '%'+@cust_name+'%')
		DELETE FROM Customer WHERE Name LIKE '%'+@cust_name+'%'
	END
go
EXEC uspDropOut 'Owen'
SELECT * FROM Customer
SELECT * FROM Comment
GO