/*=========================================================
        DataCo Smart Supply Chain Analysis
             Business Analysis Using SQL
=========================================================*/

-- =====================================================
-- Select Database
-- =====================================================

USE dataco_supply_chain_analysis;

-- =====================================================
-- SALES PERFORMANCE ANALYSIS
-- =====================================================

-- 1. Which markets generate the highest revenue?

SELECT
    Market,
    ROUND(SUM(Sales), 2) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY Market
ORDER BY total_sales DESC;


-- 2. Which countries generate the highest revenue?

SELECT
    `Order Country`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY `Order Country`
ORDER BY total_sales DESC
LIMIT 10;


-- 3. Which regions contribute the most revenue?

SELECT
    `Order Region`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY `Order Region`
ORDER BY total_sales DESC;


-- 4. Best performing product categories by sales

SELECT
    `Category Name`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY `Category Name`
ORDER BY total_sales DESC;


-- 5. Top 10 selling products

SELECT
    `Product Name`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY `Product Name`
ORDER BY total_sales DESC
LIMIT 10;

-- =====================================================
-- PROFITABILITY ANALYSIS
-- =====================================================

-- 6. Which markets generate the highest profit?

SELECT
    Market,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM dataco_cleaned_supply_chain
GROUP BY Market
ORDER BY total_profit DESC;


-- 7. Most profitable product categories

SELECT
    `Category Name`,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM dataco_cleaned_supply_chain
GROUP BY `Category Name`
ORDER BY total_profit DESC;


-- 8. Top loss-making products

SELECT
    `Product Name`,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM dataco_cleaned_supply_chain
GROUP BY `Product Name`
HAVING total_profit < 0
ORDER BY total_profit ASC;


-- =====================================================
-- CUSTOMER ANALYSIS
-- =====================================================

-- 9. Sales by customer segment

SELECT
    `Customer Segment`,
    ROUND(SUM(Sales), 2) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY `Customer Segment`
ORDER BY total_sales DESC;


-- 10. Profit by customer segment

SELECT
    `Customer Segment`,
    ROUND(SUM(`Order Profit Per Order`), 2) AS total_profit
FROM dataco_cleaned_supply_chain
GROUP BY `Customer Segment`
ORDER BY total_profit DESC;


-- 11. Top 10 customers by revenue

SELECT
    `Customer Id`,
    CONCAT(`Customer Fname`, ' ', IFNULL(`Customer Lname`, '')) AS customer_name,
    ROUND(SUM(Sales), 2) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY `Customer Id`, customer_name
ORDER BY total_sales DESC
LIMIT 10;


-- =====================================================
-- SHIPPING ANALYSIS
-- =====================================================

-- 12. Average delivery time by shipping mode

SELECT
    `Shipping Mode`,
    ROUND(AVG(`Days for shipping (real)`), 2) AS average_shipping_days
FROM dataco_cleaned_supply_chain
GROUP BY `Shipping Mode`
ORDER BY average_shipping_days;


-- 13. Late delivery percentage by shipping mode

SELECT
    `Shipping Mode`,
    ROUND(AVG(Late_delivery_risk) * 100, 2) AS late_delivery_percentage
FROM dataco_cleaned_supply_chain
GROUP BY `Shipping Mode`
ORDER BY late_delivery_percentage DESC;


-- =====================================================
-- FRAUD ANALYSIS
-- =====================================================

-- 14. Fraud orders by market

SELECT
    Market,
    COUNT(*) AS fraud_orders
FROM dataco_cleaned_supply_chain
WHERE `Order Status` = 'SUSPECTED_FRAUD'
GROUP BY Market
ORDER BY fraud_orders DESC;


-- 15. Fraud orders by customer segment

SELECT
    `Customer Segment`,
    COUNT(*) AS fraud_orders
FROM dataco_cleaned_supply_chain
WHERE `Order Status` = 'SUSPECTED_FRAUD'
GROUP BY `Customer Segment`
ORDER BY fraud_orders DESC;


-- 16. Fraud orders by shipping mode

SELECT
    `Shipping Mode`,
    COUNT(*) AS fraud_orders
FROM dataco_cleaned_supply_chain
WHERE `Order Status` = 'SUSPECTED_FRAUD'
GROUP BY `Shipping Mode`
ORDER BY fraud_orders DESC;


-- =====================================================
-- TIME-BASED ANALYSIS
-- =====================================================

-- 17. Monthly sales trend

SELECT
    DATE_FORMAT(`order date (DateOrders)`, '%Y-%m') AS month,
    ROUND(SUM(Sales), 2) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY month
ORDER BY month;