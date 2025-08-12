create database myproject;
use myproject;
show tables;
select * from superstore;
desc superstore;

1. Basic SQL Queries

-- 1. Retrieve all columns from the table
SELECT * 
FROM superstore;

-- 2. Select only Order ID, Order Date, Customer Name, and Sales
SELECT `Order ID`, `Order Date`, `Customer Name`, Sales
FROM superstore;

-- 3. Filter orders where Region = 'West'
SELECT * 
FROM superstore
WHERE Region = 'West';

-- 4. Show orders with Sales > 500 and Profit > 0
SELECT * 
FROM superstore
WHERE Sales > 500 
  AND Profit > 0;

-- 5. List unique Ship Mode values
SELECT DISTINCT `Ship Mode`
FROM superstore;

-- 6. Count total number of orders (distinct Order IDs)
SELECT COUNT(DISTINCT `Order ID`) AS Total_Orders
FROM superstore;

-- 7. Count orders for each Region
SELECT Region, COUNT(DISTINCT `Order ID`) AS Orders_Count
FROM superstore
GROUP BY Region;

-- 8. Sort products by highest Profit
SELECT `Product Name`, Profit
FROM superstore
ORDER BY Profit DESC;

2. Aggregations & Grouping

-- 9. Total sales per Category
SELECT Category, SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Category;

-- 10. Average discount per Region
SELECT Region, AVG(Discount) AS Avg_Discount
FROM superstore
GROUP BY Region;

-- 11. Total profit per State, sorted by highest profit
SELECT State, SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY State
ORDER BY Total_Profit DESC;

-- 12. Top 5 cities by total sales
SELECT City, SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY City
ORDER BY Total_Sales DESC
LIMIT 5;

-- 13. Number of orders per Customer ID
SELECT `Customer ID`, COUNT(DISTINCT `Order ID`) AS Orders_Count
FROM superstore
GROUP BY `Customer ID`;

-- 14. Highest sales month per year
WITH parsed_dates AS (
    SELECT 
        YEAR(
            CASE 
                WHEN `Order Date` LIKE '%-%' THEN STR_TO_DATE(`Order Date`, '%m-%d-%y')
                WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Year,
        MONTH(
            CASE 
                WHEN `Order Date` LIKE '%-%' THEN STR_TO_DATE(`Order Date`, '%m-%d-%y')
                WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Month_Num,
        MONTHNAME(
            CASE 
                WHEN `Order Date` LIKE '%-%' THEN STR_TO_DATE(`Order Date`, '%m-%d-%y')
                WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y')
            END
        ) AS Month_Name,
        Sales
    FROM superstore
)
SELECT 
    Year,
    Month_Name,
    SUM(Sales) AS Monthly_Sales
FROM parsed_dates
GROUP BY Year, Month_Num, Month_Name
ORDER BY Year, Month_Num;



-- 15. Total quantity sold per Sub-Category with more than 500 units sold
SELECT `Sub-Category`, SUM(Quantity) AS Total_Quantity
FROM superstore
GROUP BY `Sub-Category`
HAVING SUM(Quantity) > 500;

3. Date & Time Functions
WITH parsed_dates AS (
    SELECT 
        `Order ID`,
        `Ship Date`,
        `Order Date`,
        Region,
        Sales,
        Profit,
        
        -- Parse Order Date dynamically
        CASE 
            WHEN `Order Date` LIKE '%-%' THEN STR_TO_DATE(`Order Date`, '%m-%d-%y')
            WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        END AS OrderDateParsed,
        
        -- Parse Ship Date dynamically
        CASE 
            WHEN `Ship Date` LIKE '%-%' THEN STR_TO_DATE(`Ship Date`, '%m-%d-%y')
            WHEN `Ship Date` LIKE '%/%' THEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y')
        END AS ShipDateParsed
    FROM superstore
)

-- 16. Extract Year, Month from Order Date
SELECT 
    `Order ID`,
    YEAR(OrderDateParsed) AS Year,
    MONTH(OrderDateParsed) AS Month
FROM parsed_dates;

-- 17. Calculate days to ship for each order

WITH parsed_dates AS (
    SELECT 
        `Order ID`,
        `Ship Date`,
        `Order Date`,
        Region,
        Sales,
        Profit,
        
        -- Parse Order Date dynamically
        CASE 
            WHEN `Order Date` LIKE '%-%' THEN STR_TO_DATE(`Order Date`, '%m-%d-%y')
            WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        END AS OrderDateParsed,
        
        -- Parse Ship Date dynamically
        CASE 
            WHEN `Ship Date` LIKE '%-%' THEN STR_TO_DATE(`Ship Date`, '%m-%d-%y')
            WHEN `Ship Date` LIKE '%/%' THEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y')
        END AS ShipDateParsed
    FROM superstore
)
SELECT 
    `Order ID`,
    DATEDIFF(ShipDateParsed, OrderDateParsed) AS Days_To_Ship
FROM parsed_dates;

-- 18. Average shipping time per Region
WITH parsed_dates AS (
    SELECT 
        `Order ID`,
        `Ship Date`,
        `Order Date`,
        Region,
        Sales,
        Profit,
        
        -- Parse Order Date dynamically
        CASE 
            WHEN `Order Date` LIKE '%-%' THEN STR_TO_DATE(`Order Date`, '%m-%d-%y')
            WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        END AS OrderDateParsed,
        
        -- Parse Ship Date dynamically
        CASE 
            WHEN `Ship Date` LIKE '%-%' THEN STR_TO_DATE(`Ship Date`, '%m-%d-%y')
            WHEN `Ship Date` LIKE '%/%' THEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y')
        END AS ShipDateParsed
    FROM superstore
)
SELECT 
    Region,
    AVG(DATEDIFF(ShipDateParsed, OrderDateParsed)) AS Avg_Shipping_Days
FROM parsed_dates
GROUP BY Region;

-- 19. Sales trends by month
WITH parsed_dates AS (
    SELECT 
        `Order ID`,
        `Ship Date`,
        `Order Date`,
        Region,
        Sales,
        Profit,
        
        -- Parse Order Date dynamically
        CASE 
            WHEN `Order Date` LIKE '%-%' THEN STR_TO_DATE(`Order Date`, '%m-%d-%y')
            WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        END AS OrderDateParsed,
        
        -- Parse Ship Date dynamically
        CASE 
            WHEN `Ship Date` LIKE '%-%' THEN STR_TO_DATE(`Ship Date`, '%m-%d-%y')
            WHEN `Ship Date` LIKE '%/%' THEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y')
        END AS ShipDateParsed
    FROM superstore
)
SELECT 
    YEAR(OrderDateParsed) AS Year,
    MONTH(OrderDateParsed) AS Month,
    SUM(Sales) AS Total_Sales
FROM parsed_dates
GROUP BY Year, Month
ORDER BY Year, Month;

-- 20. Identify the quarter with the highest profit
WITH parsed_dates AS (
    SELECT 
        `Order ID`,
        `Ship Date`,
        `Order Date`,
        Region,
        Sales,
        Profit,
        
        -- Parse Order Date dynamically
        CASE 
            WHEN `Order Date` LIKE '%-%' THEN STR_TO_DATE(`Order Date`, '%m-%d-%y')
            WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y')
        END AS OrderDateParsed,
        
        -- Parse Ship Date dynamically
        CASE 
            WHEN `Ship Date` LIKE '%-%' THEN STR_TO_DATE(`Ship Date`, '%m-%d-%y')
            WHEN `Ship Date` LIKE '%/%' THEN STR_TO_DATE(`Ship Date`, '%m/%d/%Y')
        END AS ShipDateParsed
    FROM superstore
)
SELECT 
    YEAR(OrderDateParsed) AS Year,
    QUARTER(OrderDateParsed) AS Quarter,
    SUM(Profit) AS Total_Profit
FROM parsed_dates
GROUP BY Year, Quarter
ORDER BY Total_Profit DESC
LIMIT 1;


4. String Functions

-- 21. Extract first name of the customer
SELECT `Customer Name`,
       SUBSTRING_INDEX(`Customer Name`, ' ', 1) AS First_Name
FROM superstore;

-- 22. Extract last name of the customer
SELECT `Customer Name`,
       SUBSTRING_INDEX(`Customer Name`, ' ', -1) AS Last_Name
FROM superstore;

-- 23. Convert city names to uppercase
SELECT City,
       UPPER(City) AS City_Upper
FROM superstore;

-- 24. Find length of each product name
SELECT `Product Name`,
       LENGTH(`Product Name`) AS Name_Length
FROM superstore;

-- 25. Concatenate Category and Sub-Category
SELECT CONCAT(Category, ' - ', `Sub-Category`) AS Full_Category  -- whenever u have column names with spaces use back quote sign ` [backticks (`…`) to avoid syntax errors.]
FROM superstore;

5. Aggregations

-- 26. Total sales
SELECT SUM(Sales) AS Total_Sales
FROM superstore;

-- 27. Average profit
SELECT AVG(Profit) AS Avg_Profit
FROM superstore;

-- 28. Total quantity sold per category
SELECT Category,
       SUM(Quantity) AS Total_Quantity
FROM superstore
GROUP BY Category;

-- 29. Highest sales sub-category
SELECT `Sub-Category`,
       SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY `Sub-Category`
ORDER BY Total_Sales DESC
LIMIT 1;

-- 30. Region-wise profit
SELECT Region,
       SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Region;

6. Advanced Aggregations & Analysis

-- 31. Top 5 customers by total sales
SELECT `Customer Name`,
       SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 5;

-- 32. Average sales per order
SELECT AVG(Sales) AS Avg_Sales_Per_Order
FROM superstore;

-- 33. State with the highest average profit
SELECT State,
       AVG(Profit) AS Avg_Profit
FROM superstore
GROUP BY State
ORDER BY Avg_Profit DESC
LIMIT 1;

-- 34. Category-wise highest selling product
WITH CategorySales AS (
    SELECT Category,
           `Product Name`,
           SUM(Sales) AS Total_Sales,
           ROW_NUMBER() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS rn
    FROM superstore
    GROUP BY Category, `Product Name`
)
SELECT Category, `Product Name`, Total_Sales
FROM CategorySales
WHERE rn = 1;

-- 35. Region-wise sales and profit
SELECT Region,
       SUM(Sales) AS Total_Sales,
       SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY Region;

7. Joins & Subqueries (Self-join example)

-- 36. Find customers who have placed more than 5 orders
SELECT `Customer ID`, COUNT(DISTINCT `Order ID`) AS Orders_Count
FROM superstore
GROUP BY `Customer ID`
HAVING COUNT(DISTINCT `Order ID`) > 5;

-- 37. Customers and their first order date
SELECT `Customer ID`,
       MIN(
           CASE 
               WHEN `Order Date` LIKE '%-%' THEN STR_TO_DATE(`Order Date`, '%m-%d-%y')
               WHEN `Order Date` LIKE '%/%' THEN STR_TO_DATE(`Order Date`, '%m/%d/%Y')
           END
       ) AS First_Order_Date
FROM superstore
GROUP BY `Customer ID`;

-- 38. Orders with above average sales
SELECT *
FROM superstore
WHERE Sales > (SELECT AVG(Sales) FROM superstore);

-- 39. States with profit less than zero
SELECT State, SUM(Profit) AS Total_Profit
FROM superstore
GROUP BY State
HAVING SUM(Profit) < 0;

-- 40. Category with the highest total sales
SELECT Category,
       SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC
LIMIT 1;

