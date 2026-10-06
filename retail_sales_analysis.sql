-- ============================================================
-- RETAIL SALES ANALYTICS PROJECT
-- PostgreSQL SQL Analysis
-- ============================================================


-- ============================================================
-- 1. DATABASE
-- ============================================================

-- Create the database once from PostgreSQL:
CREATE DATABASE retail_sales;

-- Connect to the database using psql:
-- \c retail_sales


-- ============================================================
-- 2. CREATE TABLE
-- ============================================================

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


-- ============================================================
-- 3. CHECK TABLE
-- ============================================================

SELECT COUNT(*) AS total_records
FROM sales_data;


-- ============================================================
-- 4. VIEW SAMPLE RECORDS
-- ============================================================

SELECT *
FROM sales_data
LIMIT 5;


-- ============================================================
-- 5. OVERALL BUSINESS PERFORMANCE
-- ============================================================

SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM sales_data;


-- ============================================================
-- 6. SALES AND PROFIT BY CATEGORY
-- ============================================================

SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY category
ORDER BY total_sales DESC;


-- ============================================================
-- 7. SALES AND PROFIT BY REGION
-- ============================================================

SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC;


-- ============================================================
-- 8. PROFIT MARGIN BY CATEGORY
-- ============================================================

SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM sales_data
GROUP BY category
ORDER BY profit_margin DESC;


-- ============================================================
-- 9. SALES BY CUSTOMER SEGMENT
-- ============================================================

SELECT
    segment,
    COUNT(*) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY segment
ORDER BY total_sales DESC;


-- ============================================================
-- 10. SALES BY PAYMENT MODE
-- ============================================================

SELECT
    payment_mode,
    COUNT(*) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY payment_mode
ORDER BY total_sales DESC;


-- ============================================================
-- 11. TOP PRODUCTS BY SALES
-- ============================================================

SELECT
    product,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY product
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 12. FURNITURE PRODUCT PERFORMANCE
-- ============================================================

SELECT
    product,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
WHERE category = 'Furniture'
GROUP BY product
ORDER BY total_sales DESC;


-- ============================================================
-- 13. MONTHLY SALES
-- ============================================================

SELECT
    TO_CHAR(
        DATE_TRUNC('month', order_date),
        'Mon-YYYY'
    ) AS order_month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);


-- ============================================================
-- 14. HIGH-VALUE ORDERS
-- ============================================================

SELECT
    order_id,
    customer_name,
    category,
    sales,
    profit,
    CASE
        WHEN sales >= 5000 THEN 'High Value'
        WHEN sales >= 2000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS sales_category
FROM sales_data
ORDER BY sales DESC
LIMIT 20;


-- ============================================================
-- 15. SALES CATEGORY SUMMARY
-- ============================================================

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


-- ============================================================
-- 16. DISCOUNT ANALYSIS
-- ============================================================

SELECT
    CASE
        WHEN discount < 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_category,
    COUNT(*) AS total_orders,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM sales_data
GROUP BY
    CASE
        WHEN discount < 0.10 THEN 'Low Discount'
        WHEN discount <= 0.20 THEN 'Medium Discount'
        ELSE 'High Discount'
    END
ORDER BY profit_margin DESC;


-- ============================================================
-- 17. TOP CITIES BY SALES
-- ============================================================

SELECT
    city,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY city
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- 18. TOP 10 MOST PROFITABLE PRODUCTS
-- ============================================================

SELECT
    product,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM sales_data
GROUP BY product
ORDER BY total_profit DESC
LIMIT 10;