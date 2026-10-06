1. Create database and connect
CREATE DATABASE retail_sales;

\c retail_sales

SELECT current_database();
2. First sales_data table creation
CREATE TABLE sales_data (
    row_id INTEGER,
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    city VARCHAR(50),
    region VARCHAR(50),
    category VARCHAR(50),
    product VARCHAR(150),
    quantity INTEGER,
    discount DECIMAL(5,2),
    sales DECIMAL(12,2),
    profit DECIMAL(12,2),
    payment_mode VARCHAR(50),
    order_month VARCHAR(20)
);
\d sales_data
SELECT COUNT(*) FROM sales_data;
3. First CSV import attempt
\copy sales_data FROM 'C:\Users\juana\Downloads\Retail_Sales_Analytics_Dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');

This one produced an error because the CSV had a different number/order of columns.

4. Drop and recreate the table
DROP TABLE sales_data;
CREATE TABLE sales_data (
    row_id INTEGER,
    order_id VARCHAR(20),
    order_date TIMESTAMP,
    order_month VARCHAR(20),
    ship_date TIMESTAMP,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    city VARCHAR(50),
    region VARCHAR(50),
    category VARCHAR(50),
    product VARCHAR(150),
    quantity INTEGER,
    discount DECIMAL(5,2),
    sales DECIMAL(12,2),
    profit DECIMAL(12,2),
    payment_mode VARCHAR(50)
);

Then another import attempt:

\copy sales_data FROM 'C:\Users\juana\Downloads\Retail_Sales_Analytics_Dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');
5. Drop/recreate again
DROP TABLE sales_data;

Then this command was attempted before the table existed:

\copy sales_data FROM 'C:\Users\juana\Downloads\Retail_Sales_Analytics_Dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');

Then:

\dt
6. Create the final table
CREATE TABLE sales_data (
    row_id INTEGER,
    order_id VARCHAR(20),
    order_date TIMESTAMP,
    order_month VARCHAR(20),
    ship_date TIMESTAMP,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(20),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    city VARCHAR(50),
    region VARCHAR(50),
    category VARCHAR(50),
    product VARCHAR(150),
    quantity INTEGER,
    discount DECIMAL(5,2),
    sales DECIMAL(12,2),
    profit DECIMAL(12,2),
    payment_mode VARCHAR(50)
);

Then another import:

\copy sales_data FROM 'C:\Users\juana\Downloads\Retail_Sales_Analytics_Dataset.csv' WITH (FORMAT csv, HEADER true, NULL '');

This time the problem was a literal "NULL" in the CSV's numeric sales column.

7. Successful CSV import
\copy sales_data FROM 'C:\Users\juana\Downloads\Retail_Sales_Cleaned_For_PostgreSQL.csv' WITH (FORMAT csv, HEADER true, NULL '');

This successfully imported 1,000 rows.

8. View first 5 rows
SELECT *
FROM sales_data
LIMIT 5;
9. Overall sales information
SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM sales_data;
10. Sales by category
SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY category
ORDER BY total_sales DESC;
11. Sales by region
SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC;
12. Profit margin by category
SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin
FROM sales_data
GROUP BY category
ORDER BY profit_margin DESC;
13. Furniture products
SELECT
    product,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
WHERE category = 'Furniture'
GROUP BY product
ORDER BY total_sales DESC;
14. Categories with sales above 500,000
SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY category
HAVING SUM(sales) > 500000
ORDER BY total_sales DESC;
15. Orders by customer segment
SELECT
    segment,
    COUNT(*) AS total_orders
FROM sales_data
GROUP BY segment
ORDER BY total_orders DESC;
16. Classify orders by sales value
SELECT
    order_id,
    sales,
    CASE
        WHEN sales >= 5000 THEN 'High Value'
        WHEN sales >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS sales_category
FROM sales_data
LIMIT 20;
17. Sales category summary
SELECT
    CASE
        WHEN sales >= 5000 THEN 'High Value'
        WHEN sales >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS sales_category,
    COUNT(*) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY
    CASE
        WHEN sales >= 5000 THEN 'High Value'
        WHEN sales >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END
ORDER BY total_sales DESC;
18. Monthly sales — first attempt
SELECT
    TO_CHAR(order_date, 'Mon-YYYY') AS order_month,
    SUM(sales) AS total_sales
FROM sales_data
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);

This produced a PostgreSQL GROUP BY error.

19. Correct monthly sales query
SELECT
    TO_CHAR(DATE_TRUNC('month', order_date), 'Mon-YYYY') AS order_month,
    SUM(sales) AS total_sales
FROM sales_data
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);
20. Discount category analysis
SELECT
    CASE
        WHEN discount < 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_category,
    COUNT(*) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / SUM(sales) * 100, 2) AS profit_margin
FROM sales_data
GROUP BY
    CASE
        WHEN discount < 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Medium Discount'
        ELSE 'High Discount'
    END
ORDER BY profit_margin DESC;