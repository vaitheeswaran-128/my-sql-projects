create database project;
use project;

select * from orderss;
select * from details;

SELECT * FROM Details WHERE profit < 0;
SET SQL_SAFE_UPDATES = 0;
UPDATE Details 
SET profit = 0 
WHERE profit < 0;
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE Orderss RENAME COLUMN `Order ID` TO OrderID;
ALTER TABLE details RENAME COLUMN `Order ID` TO OrderID;


-- 1. Total Sales per City
select o.city,sum(d.amount) as total_sales
from orderss o
join details d
on d.orderid=o.orderid
group by o.city
order by total_sales desc;


-- 2. Total Profit per Customer
 select o.customername,sum(d.profit)as total_profit
 from orderss o
 join details d
 on o.orderid=d.orderid
 group by o.customername
 order by total_profit desc;
 
 
 -- 3. Order Count and Revenue per State
select o.state,count(distinct o.orderid) as ordercount,
sum(d.amount)as revenue from orderss o
join details d
on d.orderid=o.orderid
group by o.state
order by  revenue desc;


--  4.Category-Wise Revenue per Payment Mode
select paymentmode,category,sum(amount)as revenue 
from details
group by paymentmode,category
order by revenue desc;


-- 5. Customers Whose Total Profit Is Above Average
select o.customername,sum(d.profit) as total_profit
from orderss o
join details d
on d.orderid=o.orderid
group by o.customername having sum(d.profit)>(select avg(profit) from details);


-- 6. Top City by Revenue in Each State
select city,state,total from
(select o.state,o.city,sum(d.amount)as total,
rank() over(partition by o.state order by sum(d.amount) desc) as rnk
from orderss o 
join details d
on d.orderid=o.orderid
group by o.state,o.city)ranked
where rnk=1;

-- 7. Orders with Maximum Quantity
select * from details where quantity=(select max(quantity) from details);

ALTER TABLE details RENAME COLUMN `Sub-Category` TO sub_category;
--  7.Most Common Sub-Category per Category
 select category,sub_category from(select category,sub_category,
 rank()over(partition by category order by count(*) desc) as rnk from details
 group by category,sub_category)ranked 
 where rnk=1;
 
 --  8.Top 3 Categories by Revenue
select * from ( select category,sum(amount) as revenue,
rank() over(partition by category order by sum(amount) desc) as rnk
from details 
group by category)ranked
where rnk>= 1;

-- 9.Number of Orders Placed Each Week
ALTER TABLE orderss RENAME COLUMN `order Date` TO order_date;
select week(str_to_date(order_date,"%d-%m-%y")) as weeknum,
count(*) as ordercount
from orderss
group by weeknum
order by weeknum;

-- 10.Find Customers Who Placed Orders on Weekends
 select customername,order_date
 from orderss where dayofweek(STR_TO_DATE(order_date,"%d-%m-%y")) in (1,7);
 
 -- 11.Find Customers Who Placed Orders on Weekdays
select customername,order_date from 
orderss where dayofweek(str_to_date(order_date,"%d-%m-%y")) between 2 and 6;

-- 12.Orders in the Last Quarter of the Year
select * from orderss where 
quarter(str_to_date(order_date,"%d-%m-%y"))=4;


-- 13. Sales per City per Year
select o.city, year(str_to_date(order_date,"%d-%m-%y"))as orderyear,
sum(d.amount)as total_sales
from orderss o
join details d on d.orderid=o.orderid
group by o.city,orderyear
order by orderyear,total_sales;
