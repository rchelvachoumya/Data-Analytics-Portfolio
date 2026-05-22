-- create database
CREATE DATABASE retail_db;
-- use database
USE retail_db;
-- create table
create table online_retail
(
invoice_no VARCHAR(100),
stockCode VARCHAR(100),
descriptions TEXT,
quantity INT,
invoice_date varchar(100),
unitPrice DECIMAL,
customerID VARCHAR(100),
country VARCHAR(100)
);
-- load data into table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/online_retail_cleann.csv'
INTO TABLE online_retail
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
-- check loaded data 
select count(*) from online_retail;
-- calculate total revenue
select 
round(sum(unitprice*quantity)) as total_revenue
from online_retail
where quantity>0;
-- top 10 countries by revenue
SELECT 
Country,
ROUND(SUM(Quantity * UnitPrice),2) AS revenue
FROM online_retail
WHERE Quantity > 0
GROUP BY Country
ORDER BY revenue DESC
LIMIT 10;
-- best selling products
SELECT 
Descriptions,
SUM(Quantity) AS total_quantity_sold
FROM online_retail
WHERE Quantity > 0
AND Descriptions IS NOT NULL
AND Descriptions <> ''
GROUP BY Descriptions
ORDER BY total_quantity_sold DESC
LIMIT 10;
-- Top Customers 
select customerID, round(sum(quantity*unitprice)) as total_spending_cost
from online_retail
where quantity>0
AND customerID <> ''
group by customerid
order by total_spending_cost desc
limit 10;
-- adding column invoice_datetime
ALTER TABLE online_retail
ADD COLUMN invoice_datetime DATETIME;
-- switching off safe update mode 
SET SQL_SAFE_UPDATES = 0;
-- assigned value to the added column
UPDATE online_retail
SET invoice_datetime = STR_TO_DATE(invoice_date, '%d-%m-%Y %H:%i');
-- checking the assigned value
SELECT invoice_datetime
FROM online_retail
LIMIT 5;
-- monthly revenue trend
SELECT 
DATE_FORMAT(invoice_datetime,'%Y-%m') AS months,
ROUND(SUM(quantity * unitPrice),2) AS monthly_revenue
FROM online_retail
WHERE quantity > 0
GROUP BY months
ORDER BY months;
-- cancelled order analysis
SELECT 
COUNT(*) AS cancelled_orders
FROM online_retail
WHERE Invoice_No LIKE 'C%';