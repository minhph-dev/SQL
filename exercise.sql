CREATE DATABASE sales_management 
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
use sales_management
go
-- Customer
CREATE TABLE Customer(
	CustomerID	char(4) not null,	
	CustName	varchar(40),
	CustAddress	varchar(50),
	CustPhone	varchar(20),
	Birthday	smalldatetime,
	RegisterDate	smalldatetime,
	Revenue	money,
	constraint pk_Customer primary key(CustomerID)
)
go
---------------------------------------------
-- Employee
CREATE TABLE Employee(
	EmpID	char(4) not null,	
	EmpName	varchar(40),
	EmpPhone	varchar(20),
	StartDate	smalldatetime	
	constraint pk_Emp primary key(EmpID)
)
go
---------------------------------------------
-- Product
CREATE TABLE Product(
	ProductID	char(4) not null,
	ProductName	varchar(40),
	Unit	varchar(20),
	Country	varchar(40),
	Price	money,
	constraint pk_Product primary key(ProductID)	
)
go
---------------------------------------------
-- Bill
CREATE TABLE Bill(
	BillID	int not null,
	BillDate 	smalldatetime,
	CustomerID 	char(4),
	EmpID 	char(4),
	BillVal	money,
	constraint pk_Bill primary key(BillID)
)
go
---------------------------------------------
-- DetailBill
   CREATE TABLE DetailBill(
	BillID	int,
	ProductID	char(4),
	Quantity	int,
	constraint pk_cthd primary key(BillID,ProductID)
)
go

-- Khoa ngoai table Bill
ALTER TABLE Bill ADD CONSTRAINT fk01_Bill FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID)
go
ALTER TABLE Bill ADD CONSTRAINT fk02_Bill FOREIGN KEY(EmpID) REFERENCES Employee(EmpID)
go
-- Khoa ngoai cho table DetailBill
ALTER TABLE DetailBill ADD CONSTRAINT fk01_DetailBill FOREIGN KEY(BillID) REFERENCES Bill(BillID)
go
ALTER TABLE DetailBill ADD CONSTRAINT fk02_DetailBill FOREIGN KEY(ProductID) REFERENCES Product(ProductID)
go
-----------------------------------------------------
-----------------------------------------------------
set dateformat dmy
-----------------------------------------------------
---------------------INSERT--------------------------
-----------------------------------------------------
--Customer
insert into Customer values('C01','Nguyen Van A','731 Tran Hung Dao, Q5, TpHCM','8823451','22/10/1960','22/07/2006',13060000)
insert into Customer values('C02','Tran Ngoc Han','23/5 Nguyen Trai, Q5, TpHCM','908256478','03/04/1974','30/07/2006',280000)
insert into Customer values('C03','Tran Ngoc Linh','45 Nguyen Canh Chan, Q1, TpHCM','938776266','12/06/1980','08/05/2006',3860000)
insert into Customer values('C04','Tran Minh Long','50/34 Le Dai Hanh, Q10, TpHCM','917325476','09/03/1965','10/02/2006',250000)
insert into Customer values('C05','Le Nhat Minh','34 Truong Dinh, Q3, TpHCM','8246108','10/03/1950','28/10/2006',21000)
insert into Customer values('C06','Le Hoai Thuong','227 Nguyen Van Cu, Q5, TpHCM','8631738','31/12/1981','24/11/2006',915000)
insert into Customer values('C07','Nguyen Van Tam','32/3 Tran Binh Trong, Q5, TpHCM','916783565','06/04/1971','12/01/2006',12500)
insert into Customer values('C08','Phan Thi Thanh','45/2 An Duong Vuong, Q5, TpHCM','938435756','10/01/1971','13/12/2006',365000)
insert into Customer values('C09','Le Ha Vinh','873 Le Hong Phong, Q5, TpHCM','8654763','03/09/1979','14/01/2007',70000)
insert into Customer values('C10','Ha Duy Lap','34/34B Nguyen Trai, Q1, TpHCM','8768904','02/05/1983','16/01/2007',67500)
go
-----------------------------------------------------
--Employee
insert into Employee values('E01','Nguyen Nhu Nhut','927345678','13/04/2006')
insert into Employee values('E02','Le Thi Phi Yen','987567390','21/04/2006')
insert into Employee values('E03','Nguyen Van B','997047382','27/04/2006')
insert into Employee values('E04','Ngo Thanh Tuan','913758498','24/06/2006')
insert into Employee values('E05','Nguyen Thi Truc Thanh','918590387','20/07/2006')
go
-----------------------------------------------------
--Product
insert into Product values('BC01','But chi','cay','Singapore',3000)
insert into Product values('BC02','But chi','cay','Singapore',5000)
insert into Product values('BC03','But chi','cay','Viet Nam',3500)
insert into Product values('BC04','But chi','hop','Viet Nam',30000)
insert into Product values('BB01','But bi','cay','Viet Nam',5000)
insert into Product values('BB02','But bi','cay','Trung Quoc',7000)
insert into Product values('BB03','But bi','hop','Thai Lan',100000)
insert into Product values('TV01','Tap 100 giay mong','quyen','Trung Quoc',2500)
insert into Product values('TV02','Tap 200 giay mong','quyen','Trung Quoc',4500)
insert into Product values('TV03','Tap 100 giay tot','quyen','Viet Nam',3000)
insert into Product values('TV04','Tap 200 giay tot','quyen','Viet Nam',5500)
insert into Product values('TV05','Tap 100 trang','chuc','Viet Nam',23000)
insert into Product values('TV06','Tap 200 trang','chuc','Viet Nam',53000)
insert into Product values('TV07','Tap 100 trang','chuc','Trung Quoc',34000)
insert into Product values('ST01','So tay 500 trang','quyen','Trung Quoc',40000)
insert into Product values('ST02','So tay loai 1','quyen','Viet Nam',55000)
insert into Product values('ST03','So tay loai 2','quyen','Viet Nam',51000)
insert into Product values('ST04','So tay','quyen','Thai Lan',55000)
insert into Product values('ST05','So tay mong','quyen','Thai Lan',20000)
insert into Product values('ST06','Phan viet bang','hop','Viet Nam',5000)
insert into Product values('ST07','Phan khong bui','hop','Viet Nam',7000)
insert into Product values('ST08','Bong bang','cai','Viet Nam',1000)
insert into Product values('ST09','But long','cay','Viet Nam',5000)
insert into Product values('ST10','But long','cay','Trung Quoc',7000)
go
-----------------------------------------------------
-- Bill
insert into Bill values(1001,'23/07/2006','C01','E01',320000)
insert into Bill values(1002,'12/08/2006','C01','E02',840000)
insert into Bill values(1003,'23/08/2006','C02','E01',100000)
insert into Bill values(1004,'01/09/2006','C02','E01',180000)
insert into Bill values(1005,'20/10/2006','C01','E02',3800000)
insert into Bill values(1006,'16/10/2006','C01','E03',2430000)
insert into Bill values(1007,'28/10/2006','C03','E03',510000)
insert into Bill values(1008,'28/10/2006','C01','E03',440000)
insert into Bill values(1009,'28/10/2006','C03','E04',200000)
insert into Bill values(1010,'01/11/2006','C01','E01',5200000)
insert into Bill values(1011,'04/11/2006','C04','E03',250000)
insert into Bill values(1012,'30/11/2006','C05','E03',21000)
insert into Bill values(1013,'12/12/2006','C06','E01',5000)
insert into Bill values(1014,'31/12/2006','C03','E02',3150000)
insert into Bill values(1015,'01/01/2007','C06','E01',910000)
insert into Bill values(1016,'01/01/2007','C07','E02',12500)
insert into Bill values(1017,'02/01/2007','C08','E03',35000)
insert into Bill values(1018,'13/01/2007','C08','E03',330000)
insert into Bill values(1019,'13/01/2007','C01','E03',30000)
insert into Bill values(1020,'14/01/2007','C09','E04',70000)
insert into Bill values(1021,'16/01/2007','C10','E03',67500)
insert into Bill values(1022,'16/01/2007',Null,'E03',7000)
insert into Bill values(1023,'17/01/2007',Null,'E01',330000)
go
-----------------------------------------------------
-- DetailBill
insert into DetailBill values(1001,'TV02',10)
insert into DetailBill values(1001,'ST01',5)
insert into DetailBill values(1001,'BC01',5)
insert into DetailBill values(1001,'BC02',10)
insert into DetailBill values(1001,'ST08',10)
insert into DetailBill values(1002,'BC04',20)
insert into DetailBill values(1002,'BB01',20)
insert into DetailBill values(1002,'BB02',20)
insert into DetailBill values(1003,'BB03',10)
insert into DetailBill values(1004,'TV01',20)
insert into DetailBill values(1004,'TV02',10)
insert into DetailBill values(1004,'TV03',10)
insert into DetailBill values(1004,'TV04',10)
insert into DetailBill values(1005,'TV05',50)
insert into DetailBill values(1005,'TV06',50)
insert into DetailBill values(1006,'TV07',20)
insert into DetailBill values(1006,'ST01',30)
insert into DetailBill values(1006,'ST02',10)
insert into DetailBill values(1007,'ST03',10)
insert into DetailBill values(1008,'ST04',8)
insert into DetailBill values(1009,'ST05',10)
insert into DetailBill values(1010,'TV07',50)
insert into DetailBill values(1010,'ST07',50)
insert into DetailBill values(1010,'ST08',100)
insert into DetailBill values(1010,'ST04',50)
insert into DetailBill values(1010,'TV03',100)
insert into DetailBill values(1011,'ST06',50)
insert into DetailBill values(1012,'ST07',3)
insert into DetailBill values(1013,'ST08',5)
insert into DetailBill values(1014,'BC02',80)
insert into DetailBill values(1014,'BB02',100)
insert into DetailBill values(1014,'BC04',60)
insert into DetailBill values(1014,'BB01',50)
insert into DetailBill values(1015,'BB02',30)
insert into DetailBill values(1015,'BB03',7)
insert into DetailBill values(1016,'TV01',5)
insert into DetailBill values(1017,'TV02',1)
insert into DetailBill values(1017,'TV03',1)
insert into DetailBill values(1017,'TV04',5)
insert into DetailBill values(1018,'ST04',6)
insert into DetailBill values(1019,'ST05',1)
insert into DetailBill values(1019,'ST06',2)
insert into DetailBill values(1020,'ST07',10)
insert into DetailBill values(1021,'ST08',5)
insert into DetailBill values(1021,'TV01',7)
insert into DetailBill values(1021,'TV02',10)
insert into DetailBill values(1022,'ST07',1)
insert into DetailBill values(1023,'ST04',6)
go
--1. Show ProductID, ProductName produced by “Viet Nam”
SELECT ProductID, ProductName
FROM Product
WHERE Country = 'Viet Nam'
go
--2. Show ProductID, ProductName has unit is “cay”, “quyen”
SELECT ProductID, ProductName
FROM Product
WHERE Unit IN('cay', 'quyen')
go
--3. Show ProductID, ProductName has product code start by “B” and end by “01”
SELECT ProductID, ProductName
FROM Product
WHERE ProductID LIKE'B%01'
go
--4. Show ProductID, ProductName produced by “Trung Quoc” and price from 30.000 to 40.000
SELECT ProductID,ProductName,Country
FROM Product
WHERE Country = 'Trung Quoc'
AND Price BETWEEN 30000 AND 40000
go
--5. Show ProductID, ProductName produced by “Trung Quoc” or “Viet Nam” and price from 30.000 to 40.000
SELECT ProductID, ProductName, Country
FROM Product
WHERE (Country = 'Trung Quoc' OR Country = 'Viet Nam') AND Price BETWEEN 30000 AND 40000
go
--6. Show BillID, BillVal are sold on 1/1/2007 and 2/1/2007
SELECT BillID, BillVal
FROM Bill
WHERE BillDate IN ('1/1/2007', '2/1/2007')
go
--7. Show BillID, BillVal are sold on January 2007, order by date (ascending) and invoice value(descending) 
SELECT BillID, BillVal
FROM Bill
WHERE MONTH(BillDate) = 1 AND YEAR(BillDate) = 2007
ORDER BY BillDate ASC, BillVal DESC
go
--8. Show CustomerID, CustName have bought product on 1/1/2007
SELECT DISTINCT Customer.CustomerID, CustName
FROM Customer, Bill
WHERE 
	Customer.CustomerID = Bill.CustomerID 
	AND BillDate = '1/1/2007'
go
--9. Show BillID, BillVal are recorded by employee “Nguyen Van B” on 28/10/2006
SELECT BillID, BillVal
FROM Bill, Employee
WHERE
	Bill.EmpID = Employee.EmpID
	AND EmpName = 'Nguyen Van B'
	AND day(BillDate)=28 and  month(BillDate) =10 and year(BillDate)=2006
go
--10. Show ProductID, ProductName are bought by customer “Nguyen Van A” on 10/2006
SELECT DISTINCT P.ProductID, ProductName
FROM Product P INNER JOIN DetailBill D ON P.ProductID = D.ProductID
AND EXISTS(SELECT * FROM DetailBill D INNER JOIN Bill B ON D.BillID = B.BillID
AND MONTH(BillDate) = 10 AND YEAR(BillDate) = 2006 AND CustomerID IN (SELECT B.CustomerID
FROM Bill B INNER JOIN Customer C
ON B.CustomerID = C.CustomerID
WHERE CustName = 'Nguyen Van A') AND P.ProductID = D.ProductID)
go
--
SELECT DISTINCT P.ProductID, ProductName
FROM Product P, DetailBill D, Customer C, Bill B
WHERE
	D.ProductID = P.ProductID
	AND D.BillID = B.BillID
	AND B.CustomerID = C.CustomerID
	AND CustName = 'Nguyen Van A'
	AND MONTH(BillDate) = 10 AND YEAR(BillDate) = 2006
go
--11. Show BillID have ProductID is “BB01” or “BB02”
SELECT BillID
FROM DetailBill
WHERE ProductID IN ('BB01', 'BB02')
go
--12. Show BillID have ProductID is “BB01” or “BB02” with each quantity from 10 to 20
SELECT DISTINCT BillID
FROM DetailBill
WHERE 
	ProductID IN ('BB01', 'BB02') 
	AND Quantity BETWEEN 10 AND 20
go
--13.	Show BillID have bought 2 products “BB01” and “BB02” at the same time, each quantity from 10 to 20 (hint: use INTERSECT)
SELECT BillID
FROM DetailBill D
WHERE D.ProductID = 'BB01' AND Quantity BETWEEN 10 AND 20 
AND EXISTS(SELECT * FROM DetailBill D
                    WHERE D.ProductID = 'BB02'
                    AND Quantity BETWEEN 10 AND 20
)
go
--
SELECT DISTINCT BillID
FROM DetailBill
WHERE ProductID = 'BB01' AND Quantity BETWEEN 10 AND 20
INTERSECT
(
	SELECT DISTINCT BillID
	FROM DetailBill
	WHERE ProductID = 'BB02' AND Quantity BETWEEN 10 AND 20
)
go
--14.  Show ProductID, ProductName are produced by “Trung Quoc” and sold on 1/1/2007
SELECT DISTINCT P.ProductID, ProductName
FROM Product P INNER JOIN DetailBill D ON P.ProductID = D.ProductID
WHERE Country = 'Trung Quoc'
      AND D.BillID IN (SELECT DISTINCT D.BillID
                       FROM DetailBill D INNER JOIN Bill B ON D.BillID = B.BillID
                       WHERE BillDate ='1/1/2007')
go
--
SELECT DISTINCT P.ProductID, ProductName
FROM Bill B, Product P, DetailBill D
WHERE
	B.BillID = D.BillID
	AND D.ProductID = P.ProductID
	AND (Country = 'Trung Quoc'
	AND  BillDate = '1/1/2007')
go
--15.	Show the revenue in 2006
SELECT SUM(BillVal) AS DOANHTHU
FROM Bill
WHERE YEAR(BillDate) = 2006
go
--16. 	Show ProductID, ProductName not sold (hint: use NOT IN, NOT EXISTS or EXCEPT)
SELECT P.ProductID, ProductName
FROM Product P
WHERE NOT EXISTS (SELECT * FROM Product P2 INNER JOIN DetailBill D ON P2.ProductID =  D.ProductID
      AND P2.ProductID = P.ProductID 
)
go
--
SELECT ProductID, ProductName
FROM Product
WHERE ProductID NOT IN (SELECT ProductID FROM DetailBill)
go
--
SELECT ProductID, ProductName
FROM Product
WHERE NOT EXISTS  
       (select ProductID from DetailBill
	    where DetailBill.ProductID = Product.ProductID)
go
--
select ProductID, ProductName
from Product
except 
select Product.ProductID,ProductName
from DetailBill join Product
    on DetailBill.ProductID = Product.ProductID
go
--17.	Show ProductID, ProductName not sold in 2006 
SELECT ProductID, ProductName
FROM Product
WHERE ProductID NOT IN
(
	SELECT ProductID 
	FROM DetailBill, Bill
	WHERE 
		DetailBill.BillID = Bill.BillID
		AND YEAR(BillDate) = 2006
)
go
--18.	Show ProductID, ProductName not sold in 2006 produced by “Trung Quoc”
SELECT ProductID, ProductName
FROM Product
WHERE
	Country = 'Trung Quoc'
	AND ProductID NOT IN
	(
		SELECT ProductID 
		FROM DetailBill D, Bill B
		WHERE 
			D.BillID = B.BillID
			AND YEAR(BillDate) = 2006
	)
go
--19.	Show the number of invoices have bought by non-member customer
SELECT COUNT(*)
FROM Bill B
WHERE CustomerID NOT IN
(  
    SELECT CustomerID
    FROM Customer C 
    WHERE C.CustomerID = B.CustomerID
)
go
--
SELECT COUNT(*)
FROM Bill
WHERE CustomerID IS NULL
go
--
select count(BillID) - count(CustomerID)
from Bill
go
select count(*) - count(CustomerID)
from Bill
go
--20.	Show the number of different products were sold in 2006.
SELECT COUNT(DISTINCT ProductID) Total
FROM DetailBill D INNER JOIN Bill B
ON D.BillID = B.BillID
WHERE YEAR(BillDate) = 2006
go
--
SELECT COUNT(DISTINCT ProductID) Total
FROM Bill, DetailBill
WHERE
	Bill.BillID = DetailBill.BillID
	AND YEAR(BillDate) = 2006
go 
--21.	Show the highest  and lowest invoice value
SELECT MAX(BillVal) AS MAX, MIN(BillVal) AS MIN
FROM Bill
go
--22.	Show the average of invoice value were sold in 2006
SELECT AVG(BillVal) average
FROM Bill
WHERE YEAR(BillDate) = 2006
go
--23.	Show BillID has the highest invoice value in 2006
SELECT BillID
FROM Bill
WHERE BillVal = (SELECT MAX(BillVal) FROM Bill)
      AND YEAR(BillDate) = 2006 
go
--24.	Show CustName have bought the highest invoice value in 2006
SELECT DISTINCT CustName
FROM Customer C, Bill B
WHERE 
	B.CustomerID = C.CustomerID
	AND YEAR(BillDate) = 2006
	AND BillVal = (SELECT MAX(BillVal) FROM Bill WHERE YEAR(BillDate) = 2006)
go
--25.	Show 3 customers (CustomerID, CustName) have highest revenue
SELECT TOP 3 CustomerID, CustName
FROM Customer
ORDER BY Revenue DESC
go
--26.	Show a list of products (ProductID, ProductName) that sells at one of the three highest prices.
SELECT ProductID, ProductName
FROM Product
WHERE Price IN (SELECT DISTINCT TOP 3 Price
			    FROM Product
			    ORDER BY Price DESC)
go
--27.	Show a list of products (ProductID, ProductName) that sells at one of the three highest prices produced by “Thai Lan”
SELECT ProductID, ProductName
FROM Product
WHERE Country = 'Thai Lan'
AND Price IN (
          SELECT DISTINCT TOP 3 Price
          FROM Product
          ORDER BY Price DESC)
go
--28.	Show the total of products produced by “Trung Quoc”
SELECT COUNT(DISTINCT ProductID)
FROM Product
WHERE Country = 'Trung Quoc'
go
-- 29.	Show the total of products of each country.
SELECT Country, COUNT(DISTINCT ProductID) AS Total
FROM Product
GROUP BY Country
go
--30.	Show the revenue per day
SELECT BillDate, SUM(BillVal) AS Revenue_per_day
FROM Bill
GROUP BY BillDate
go
--31.	Show the customer(CustomerID, CustName) have the number of times purchasing is highest
SELECT CustomerID, CustName
FROM Customer
WHERE CustomerID = ( SELECT TOP 1 CustomerID
                     FROM Bill
                     GROUP BY CustomerID
                     ORDER BY COUNT(DISTINCT BillID) DESC )	
go
--
SELECT C.CustomerID, CustName
FROM Customer C, Bill B
WHERE C.CustomerID = B.CustomerID
      GROUP BY C.CustomerID, CustName
      HAVING COUNT(*) >= ALL(SELECT COUNT(*) FROM Bill GROUP BY CustomerID)
go
--32.	Show the country where the total number of products is the largest
SELECT TOP 1 Country, COUNT(ProductID)
FROM Product 
GROUP BY Country
ORDER BY COUNT(ProductID) DESC
go
--33.	Show BillID have bought all products produced by Singapore
SELECT BillID
FROM Bill
WHERE NOT EXISTS
(
	SELECT *
	FROM Product
	WHERE Country = 'Singapore'
	AND NOT EXISTS
	(
		SELECT *
		FROM DetailBill
		WHERE DetailBill.BillID = Bill.BillID
		AND DetailBill.ProductID = Product.ProductID
	)
)
go
--Cach 2
-- Dau tien tim Singapore san xuat bao nhieu san pham
SELECT COUNT(*)
FROM Product
WHERE Country = 'Singapore'
GO
-- Tim xem moi bill ban duoc bao nhieu san pham
SELECT BillID, COUNT(ProductID)
FROM DetailBill
GROUP By BillID
GO
-- Tim xem moi bill ban duoc bao nhieu san pham của Singapore
SELECT BillID, COUNT(D.ProductID)
FROM DetailBill D JOIN Product P ON D.ProductID = P.ProductID
WHERE Country = 'Singapore'
GROUP By BillID
GO
-- Da mua tat ca (loai tru ra)
SELECT BillID, COUNT(D.ProductID)
FROM DetailBill D JOIN Product P ON D.ProductID = P.ProductID
WHERE Country = 'Singapore'
GROUP By BillID
HAVING COUNT(D.ProductID) = (SELECT COUNT(*)
								FROM Product
								WHERE Country = 'Singapore')
GO
--34	Show BillID have bought all products produced by Singapore in 2006.
SELECT BillID
FROM Bill
WHERE YEAR(BillDate) = 2006 
AND NOT EXISTS
(
	SELECT *
	FROM Product
	WHERE Country = 'Singapore'
	AND NOT EXISTS
	(
		SELECT *
		FROM DetailBill
		WHERE DetailBill.BillID = Bill.BillID
		AND DetailBill.ProductID = Product.ProductID
	)
)
go
--
SELECT D.BillID, COUNT(D.ProductID)
FROM Product P	JOIN DetailBill D ON P.ProductID = D.ProductID
				JOIN Bill B ON D.BillID = B.BillID
WHERE Country = 'Singapore' AND YEAR(BillDate) = 2006
GROUP By D.BillID
HAVING COUNT(D.ProductID) = (SELECT COUNT(*)
								FROM Product
								WHERE Country = 'Singapore')
								
GO