SELECT * FROM retailsales.retailsales;
SELECT 
    COUNT(*)
FROM
    retailsales.retailsales;
-- how many customers we have
SELECT 
    COUNT(DISTINCT customer_id) AS total_sales
FROM
    retailsales;
-- How many categories we have
SELECT 
    COUNT(DISTINCT category) AS total_category
FROM
    retailsales;

--  Write an SQL qurry to retrive all column for sales made on '2022-11-05'
SELECT 
    *
FROM
    retailsales.retailsales
WHERE
    sale_date = '2022-11-05';

-- Write an SQL qurry to retrive all transctions where the category is 'Clothing' and the quantity sold is more than 1 in the month of Nov-2022

SELECT 
    *
FROM
    retailsales.retailsales
WHERE
    category = 'clothing' AND quantity >= 4
        AND YEAR(sale_date) = 2022
        AND MONTH(sale_date) = 11;
    
-- Write SQL querry to calculate the total orders and sales for each category

SELECT 
    category,
    SUM(total_sale) AS totalsales,
    COUNT(*) AS total_orders
FROM
    retailsales
GROUP BY category;

-- Find the average price per unit for each category

SELECT 
    category, AVG(price_per_unit) AS avg_price
FROM
    retailsales
GROUP BY category;
        
-- List the total sales for each gender 

SELECT 
    gender, SUM(total_sale) AS totalsales
FROM
    retailsales
GROUP BY gender;

-- Find the maximum, minimum and average age of customers

SELECT 
    MAX(age) AS max_age,
    MIN(age) AS min_age,
    AVG(age) AS avg_age
FROM
    retailsales;

-- Calculate the profit margin for each transaction 

SELECT 
    transactions_id,
    ROUND((total_sale - cogs) / total_sale * 100,
            2) AS profit_margin
FROM
    retailsales.retailsales;

-- Find the average total sales for transcations made by customers aged 30 and above

SELECT 
    ROUND(AVG(total_sale), 2) AS avg_sales
FROM
    retailsales
WHERE
    age >= 30;

-- Identify the category with the highest average quantity sold per transaction

SELECT 
    category, AVG(quantity) AS avg_quantity
FROM
    retailsales
GROUP BY category
ORDER BY avg_quantity DESC
LIMIT 1;

-- Calculate the Customer Lifetim Value(CLV) by gender

SELECT 
    gender,
    ROUND(AVG(total_sale), 2) AS avg_sale_per_customer,
    COUNT(DISTINCT customer_id) AS num_customers,
    ROUND(AVG(total_sale), 2) * COUNT(DISTINCT customer_id) AS CLV
FROM
    retailsales
GROUP BY gender;

-- Identify trends in sales by calculating the Year-Over_Year(YoY) growth for each category

SELECT 
    category,
    YEAR(sale_date) AS year,
    SUM(total_sale) AS total_sales,
lag(sum(total_sale))
 over 
 (partition by category order by year(sale_date))as prev_year_sales,
sum(total_sale)-lag(sum(total_sale)) over (partition by category order by year(sale_date))/
 lag(sum(total_sale)) over (partition by category order by year(sale_date)) *100 as YoY_growth
 from retailsales
 group by category,
 year(sale_date)
 order by category,
 year(sale_date);
 
-- Identify the sales distribution across different age groups

SELECT 
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS age_group,
    SUM(total_sale) AS total_sales,
    COUNT(transactions_id) AS num_transactions,
    ROUND(AVG(total_sale), 2) AS avg_sales_per_transaction
FROM
    retailsales
GROUP BY age_group
ORDER BY age_group;

-- Which categories are often purchased together

SELECT 
    r1.category AS category1,
    r2.category AS category2,
    COUNT(*) AS frequency
FROM 
    retailsales r1
JOIN 
    retailsales r2 
ON 
    r1.customer_id = r2.customer_id AND r1.transactions_id <> r2.transactions_id
WHERE 
    r1.sale_date = r2.sale_date
GROUP BY 
    r1.category, r2.category
HAVING 
    frequency > 1
ORDER BY 
    frequency DESC;



 
