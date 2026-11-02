/*=========================================================
        DataCo Smart Supply Chain Analysis
              Advanced SQL Analysis
=========================================================*/

-- =====================================================
-- Select Database
-- =====================================================

USE dataco_supply_chain_analysis;

-- =====================================================
-- WINDOW FUNCTIONS
-- =====================================================

-- 1. Rank Products by Total Sales

SELECT
    `Product Name`,
    ROUND(SUM(Sales),2) AS total_sales,
    RANK() OVER(ORDER BY SUM(Sales) DESC) AS sales_rank
FROM dataco_cleaned_supply_chain
GROUP BY `Product Name`;



-- 2. Dense Rank Products by Profit

SELECT
    `Product Name`,
    ROUND(SUM(`Order Profit Per Order`),2) AS total_profit,
    DENSE_RANK() OVER(ORDER BY SUM(`Order Profit Per Order`) DESC) AS profit_rank
FROM dataco_cleaned_supply_chain
GROUP BY `Product Name`;



-- 3. Row Number for Customers by Sales

SELECT
    `Customer Id`,
    CONCAT(`Customer Fname`,' ',IFNULL(`Customer Lname`,'')) AS customer_name,
    ROUND(SUM(Sales),2) AS total_sales,
    ROW_NUMBER() OVER(ORDER BY SUM(Sales) DESC) AS row_num
FROM dataco_cleaned_supply_chain
GROUP BY `Customer Id`, customer_name;



-- 4. Top 5 Products in Each Category

WITH product_sales AS
(
    SELECT
        `Category Name`,
        `Product Name`,
        ROUND(SUM(Sales),2) AS total_sales,

        ROW_NUMBER() OVER(
            PARTITION BY `Category Name`
            ORDER BY SUM(Sales) DESC
        ) AS rn

    FROM dataco_cleaned_supply_chain
    GROUP BY `Category Name`,`Product Name`
)

SELECT *
FROM product_sales
WHERE rn <= 5
ORDER BY `Category Name`, rn;



-- 5. Top 3 Customers in Every Market

WITH customer_market_sales AS
(
    SELECT

        Market,

        `Customer Id`,

        CONCAT(`Customer Fname`,' ',IFNULL(`Customer Lname`,'')) AS customer_name,

        ROUND(SUM(Sales),2) AS total_sales,

        DENSE_RANK() OVER
        (
            PARTITION BY Market
            ORDER BY SUM(Sales) DESC
        ) AS sales_rank

    FROM dataco_cleaned_supply_chain

    GROUP BY
        Market,
        `Customer Id`,
        customer_name
)

SELECT *
FROM customer_market_sales
WHERE sales_rank <= 3
ORDER BY Market,sales_rank;



-- 6. Divide Customers into Sales Quartiles

SELECT

    `Customer Id`,

    ROUND(SUM(Sales),2) AS total_sales,

    NTILE(4) OVER
    (
        ORDER BY SUM(Sales) DESC
    ) AS sales_quartile

FROM dataco_cleaned_supply_chain

GROUP BY `Customer Id`;



-- =====================================================
-- COMMON TABLE EXPRESSIONS (CTEs)
-- =====================================================

-- 7. Average Sales by Market

WITH market_sales AS
(
SELECT
    Market,
    SUM(Sales) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY Market
)

SELECT
    Market,
    ROUND(total_sales,2) AS total_sales
FROM market_sales
ORDER BY total_sales DESC;



-- 8. Categories Above Average Sales

WITH category_sales AS
(
SELECT
    `Category Name`,
    SUM(Sales) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY `Category Name`
)

SELECT *
FROM category_sales
WHERE total_sales >
(
SELECT AVG(total_sales)
FROM category_sales
)
ORDER BY total_sales DESC;



-- =====================================================
-- SUBQUERIES
-- =====================================================

-- 9. Products Above Overall Average Sales

SELECT
    `Product Name`,
    ROUND(SUM(Sales),2) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY `Product Name`
HAVING SUM(Sales) >
(
SELECT AVG(Sales)
FROM dataco_cleaned_supply_chain
)
ORDER BY total_sales DESC;



-- 10. Customers with Above Average Profit

SELECT

    `Customer Id`,

    CONCAT(`Customer Fname`,' ',IFNULL(`Customer Lname`,'')) AS customer_name,

    ROUND(SUM(`Order Profit Per Order`),2) AS total_profit

FROM dataco_cleaned_supply_chain

GROUP BY
    `Customer Id`,
    customer_name

HAVING total_profit >
(
SELECT AVG(`Order Profit Per Order`)
FROM dataco_cleaned_supply_chain
);




-- =====================================================
-- RUNNING TOTAL
-- =====================================================

-- 11. Running Monthly Sales

WITH monthly_sales AS
(
SELECT

DATE_FORMAT(`order date (DateOrders)`,'%Y-%m') AS month,

SUM(Sales) AS monthly_sales

FROM dataco_cleaned_supply_chain

GROUP BY month
)

SELECT

month,

ROUND(monthly_sales,2) AS monthly_sales,

ROUND(
SUM(monthly_sales)
OVER(ORDER BY month),2
) AS running_total

FROM monthly_sales;



-- =====================================================
-- MOVING AVERAGE
-- =====================================================

-- 12. 3-Month Moving Average Sales

WITH monthly_sales AS
(
SELECT

DATE_FORMAT(`order date (DateOrders)`,'%Y-%m') AS month,

SUM(Sales) AS monthly_sales

FROM dataco_cleaned_supply_chain

GROUP BY month
)

SELECT

month,

ROUND(monthly_sales,2) AS monthly_sales,

ROUND(

AVG(monthly_sales)
OVER(
ORDER BY month
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
)

,2) AS moving_average

FROM monthly_sales;



-- =====================================================
-- CUSTOMER LIFETIME VALUE (CLV)
-- =====================================================

-- 13. Top Customers by Lifetime Sales

SELECT

`Customer Id`,

CONCAT(`Customer Fname`,' ',IFNULL(`Customer Lname`,'')) AS customer_name,

COUNT(DISTINCT `Order Id`) AS total_orders,

ROUND(SUM(Sales),2) AS lifetime_sales,

ROUND(AVG(Sales),2) AS avg_order_value

FROM dataco_cleaned_supply_chain

GROUP BY
`Customer Id`,
customer_name

ORDER BY lifetime_sales DESC

LIMIT 20;



-- =====================================================
-- ABC PRODUCT ANALYSIS
-- =====================================================

-- 14. Product Revenue Classification

WITH product_sales AS
(
SELECT

`Product Name`,

SUM(Sales) AS total_sales

FROM dataco_cleaned_supply_chain

GROUP BY `Product Name`
)

SELECT

`Product Name`,

ROUND(total_sales,2) AS total_sales,

CASE

WHEN total_sales >=100000 THEN 'A'

WHEN total_sales >=50000 THEN 'B'

ELSE 'C'

END AS product_class

FROM product_sales

ORDER BY total_sales DESC;



-- =====================================================
-- VIEWS
-- =====================================================

-- 15. Create Sales Summary View

CREATE OR REPLACE VIEW vw_sales_summary AS

SELECT

Market,

ROUND(SUM(Sales),2) AS total_sales,

ROUND(SUM(`Order Profit Per Order`),2) AS total_profit,

COUNT(DISTINCT `Order Id`) AS total_orders

FROM dataco_cleaned_supply_chain

GROUP BY Market;



-- View Results

SELECT *
FROM vw_sales_summary;



-- =====================================================
-- FINAL BUSINESS KPIs
-- =====================================================

-- 16. Executive KPI Dashboard Query

SELECT

ROUND(SUM(Sales),2) AS total_sales,

ROUND(SUM(`Order Profit Per Order`),2) AS total_profit,

COUNT(DISTINCT `Order Id`) AS total_orders,

COUNT(DISTINCT `Customer Id`) AS total_customers,

COUNT(DISTINCT `Product Card Id`) AS total_products,

ROUND(AVG(Sales),2) AS average_order_value,

ROUND(AVG(`Order Profit Per Order`),2) AS average_profit_per_order,

ROUND(AVG(Late_delivery_risk)*100,2) AS late_delivery_percentage

FROM dataco_cleaned_supply_chain;