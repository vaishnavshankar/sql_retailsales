# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `retailsales`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retailsales`.
- **Table Creation**: A table named `retailsales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retailsales;

CREATE TABLE retailsales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(35) ,
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retailsales;
SELECT COUNT(DISTINCT customer_id) FROM retailsales;
SELECT DISTINCT category FROM retailsales;

SELECT * FROM retailsales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retailsales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT 
    *
FROM
    retailsales.retailsales
WHERE
    sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
    *
FROM
    retailsales.retailsales
WHERE
    category = 'clothing' AND quantity >= 4
        AND YEAR(sale_date) = 2022
        AND MONTH(sale_date) = 11;
```

3. **Write SQL querry to calculate the total orders and sales for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) AS totalsales,
    COUNT(*) AS total_orders
FROM
    retailsales
GROUP BY category;
```

4. **Find the average price per unit for each category.**:
```sql
SELECT 
    category, AVG(price_per_unit) AS avg_price
FROM
    retailsales
GROUP BY category;
```

5. **List the total sales for each gender.**:
```SELECT 
    gender, SUM(total_sale) AS totalsales
FROM
    retailsales
GROUP BY gender;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category, gender, COUNT(*) AS total_trans
FROM
    retailsales
GROUP BY category , gender
ORDER BY 1
```

7. **Find the maximum, minimum and average age of customers**:
```sql
SELECT 
    MAX(age) AS max_age,
    MIN(age) AS min_age,
    AVG(age) AS avg_age
FROM
    retailsales;
```

8. **Calculate the profit margin for each transaction **:
```sql
SELECT 
    transactions_id,
    ROUND((total_sale - cogs) / total_sale * 100,
            2) AS profit_margin
FROM
    retailsales.retailsales;
```

9. **Find the average total sales for transcations made by customers aged 30 and above.**:
```sql
SELECT 
    ROUND(AVG(total_sale), 2) AS avg_sales
FROM
    retailsales
WHERE
    age >= 30;
```

10. **Identify the category with the highest average quantity sold per transaction**:
```sql
SELECT 
    category, AVG(quantity) AS avg_quantity
FROM
    retailsales
GROUP BY category
ORDER BY avg_quantity DESC
LIMIT 1;
```
11. **Calculate the Customer Lifetim Value(CLV) by gender**:
```sql
SELECT 
    gender,
    ROUND(AVG(total_sale), 2) AS avg_sale_per_customer,
    COUNT(DISTINCT customer_id) AS num_customers,
    ROUND(AVG(total_sale), 2) * COUNT(DISTINCT customer_id) AS CLV
FROM
    retailsales
GROUP BY gender;
```
12. ** Identify the sales distribution across different age groups**:
```sql
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
```
13. **Identify trends in sales by calculating the Year-Over_Year(YoY) growth for each category**:
```sql
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
```
13. **Identify Which categories are often purchased together**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

