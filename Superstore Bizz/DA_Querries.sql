use master
go
drop database Superstore
go

CREATE DATABASE Superstore
GO
USE Superstore
GO

create table Customer_DIM
(
	CustomerKEY int identity primary key not null,
	CustomerID varchar(100),
	CustomerName varchar(100),
	Segment varchar(100),
)
go

create table Date_DIM
(
	DateKEY int identity primary key not null,
	Date date
)
go

create table Geography_DIM
(
	GeoKEY int identity primary key not null,
	CountryName varchar(100),
	Region varchar(100),
	StateName varchar(100),
	City varchar(100),
	PostalCode varchar(50),
)
go

create table Category_DIM
(
	CategoryKEY int identity primary key not null,
	CategoryName varchar(50),
)
go


create table Sub_Category_DIM
(
	SubCategoryKEY int identity primary key not null,
	SubCategoryName varchar(50),
	Category_DIM_KEY int foreign key references Category_DIM(CategoryKEY)
)
go


create table Product_DIM
(
	ProductKEY int identity primary key not null,
	ProductID varchar(100),
	ProductName varchar(200),
	SubCategory_DIM_KEY int foreign key references Sub_Category_DIM(SubCategoryKEY)
)
go

create table Ship_DIM
(
	ShipKEY int identity primary key not null,
	ShipMode varchar(50)
)

create table Order_FACT
(
	RowID int,
	OrderID varchar(100) not null,
	Quantity int,
	Discount decimal(3, 2),
	Sales money,
	Profit money,
	Date_DIM_KEY int foreign key references Date_DIM(DateKEY),
	Customer_DIM_KEY int foreign key references Customer_DIM(CustomerKEY),
	Product_DIM_KEY int foreign key references Product_DIM(ProductKEY),
	Geography_DIM_KEY int foreign key references Geography_DIM(GeoKEY),
	Ship_DIM_KEY int foreign key references Ship_DIM(ShipKEY)
)
go

create table Source_Data_Staging
(
	RowID int,
	OrderID varchar(100),
	OrderDate date,
	ShipMode varchar(50),
	CustomerID varchar(100),
	CustomerName varchar(100),
	Segment varchar(100),
	CountryName varchar(100),
	Region varchar(100),
	State varchar(100),
	City varchar(100),
	PostalCode varchar(50),
	ProductID varchar(100),
	ProductName varchar(200),
	Category varchar(50),
	SubCategory varchar(50),
	Sales money,
	Quantity int,
	Discount decimal(3, 2),
	Profit money
)

---------------------------------------------------
select *
from Source_Data_Staging

select *
from Customer_DIM

select *
from Category_DIM

select *
from Sub_Category_DIM

select *
from Product_DIM

select *
from Ship_DIM

select *
from Date_DIM

select *
from Geography_DIM

select *
from Order_FACT

insert into Source_Data_Staging
values
	(
		9992, 'CA-2017-119914', '2017-05-04', 'Second Class', 'CC-12220', 'Chris Cortes', 'Consumer', 
		'United States', 'West', 'California', 'Westminster', '92683', 
		'CLO-ME-10003645', 'Test Product 1', 'Clothing', 'Men',
		'258.58', '2', '0.2', '19.39'
	)
select *
from Source_Data_Staging

select *
from Product_DIM
---------------------------------------------------
select 
	b.Segment,
	count(distinct a.OrderID) as orders,
	sum(a.Quantity) as qty,
	sum(a.Sales) as sales,
	sum(a.Profit) as profit
from Order_FACT a
join Customer_DIM b
	on a.Customer_DIM_KEY = b.CustomerKEY
group by b.Segment

---------------------------------------------------
select b.StateName, count(distinct a.Customer_DIM_KEY) as Total_customer
from Order_FACT a
join Geography_DIM b
	on a.Geography_DIM_KEY = b.GeoKEY
join Customer_DIM c
	on a.Customer_DIM_KEY = c.CustomerKEY
group by b.StateName
order by Total_customer desc

---------------------------------------------------
select 
	b.ShipMode,
	count(distinct a.OrderID) as orders
from Order_FACT a
join Ship_DIM b
	on a.Ship_DIM_KEY = b.ShipKEY
group by b.ShipMode
order by orders desc

---------------------------------------------------
select 
	b.CustomerName,
	count(distinct a.OrderID) as orders
from Order_FACT a
join Customer_DIM b
	on a.Customer_DIM_KEY = b.CustomerKEY
group by b.CustomerName
order by orders desc

---------------------------------------------------
select 
	b.CustomerName,
	sum(a.Sales) as sales
from Order_FACT a
join Customer_DIM b
	on a.Customer_DIM_KEY = b.CustomerKEY
group by b.CustomerName
order by sales desc


