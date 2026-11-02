/*=========================================================
 DataCo Smart Supply Chain Analysis
 Exploratory Data Analysis (EDA)
=========================================================*/

-- =====================================================
-- 1. Select Database
-- =====================================================

USE dataco_supply_chain_analysis;

-- =====================================================
-- 2. Total Sales
-- =====================================================

SELECT
    ROUND(SUM(Sales),2) AS total_sales
FROM dataco_cleaned_supply_chain;

-- =====================================================
-- 3. Total Profit
-- =====================================================

SELECT
    ROUND(SUM(`Order Profit Per Order`),2) AS total_profit
FROM dataco_cleaned_supply_chain;

-- =====================================================
-- 4. Average Order Value
-- =====================================================

SELECT
    ROUND(AVG(Sales),2) AS average_order_value
FROM dataco_cleaned_supply_chain;

-- =====================================================
-- 5. Total Orders
-- =====================================================

SELECT
    COUNT(DISTINCT `Order Id`) AS total_orders
FROM dataco_cleaned_supply_chain;

-- =====================================================
-- 6. Total Customers
-- =====================================================

SELECT
    COUNT(DISTINCT `Customer Id`) AS total_customers
FROM dataco_cleaned_supply_chain;

-- =====================================================
-- 7. Total Products
-- =====================================================

SELECT
    COUNT(DISTINCT `Product Card Id`) AS total_products
FROM dataco_cleaned_supply_chain;

-- =====================================================
-- 8. Orders by Shipping Mode
-- =====================================================

SELECT
    `Shipping Mode`,
    COUNT(*) AS total_orders
FROM dataco_cleaned_supply_chain
GROUP BY `Shipping Mode`
ORDER BY total_orders DESC;

-- =====================================================
-- 9. Orders by Delivery Status
-- =====================================================

SELECT
    `Delivery Status`,
    COUNT(*) AS total_orders
FROM dataco_cleaned_supply_chain
GROUP BY `Delivery Status`
ORDER BY total_orders DESC;

-- =====================================================
-- 10. Orders by Order Status
-- =====================================================

SELECT
    `Order Status`,
    COUNT(*) AS total_orders
FROM dataco_cleaned_supply_chain
GROUP BY `Order Status`
ORDER BY total_orders DESC;

-- =====================================================
-- 11. Customer Distribution by Segment
-- =====================================================

SELECT
    `Customer Segment`,
    COUNT(*) AS customers
FROM dataco_cleaned_supply_chain
GROUP BY `Customer Segment`
ORDER BY customers DESC;

-- =====================================================
-- 12. Orders by Market
-- =====================================================

SELECT
    Market,
    COUNT(*) AS total_orders
FROM dataco_cleaned_supply_chain
GROUP BY Market
ORDER BY total_orders DESC;

-- =====================================================
-- 13. Top 10 Countries by Orders
-- =====================================================

SELECT
    `Order Country`,
    COUNT(*) AS total_orders
FROM dataco_cleaned_supply_chain
GROUP BY `Order Country`
ORDER BY total_orders DESC
LIMIT 10;

-- =====================================================
-- 14. Top 10 Product Categories
-- =====================================================

SELECT
    `Category Name`,
    COUNT(*) AS total_orders
FROM dataco_cleaned_supply_chain
GROUP BY `Category Name`
ORDER BY total_orders DESC
LIMIT 10;

-- =====================================================
-- 15. Average Shipping Days
-- =====================================================

SELECT
    ROUND(AVG(`Days for shipping (real)`),2) AS avg_shipping_days
FROM dataco_cleaned_supply_chain;

-- =====================================================
-- 16. Average Scheduled Shipping Days
-- =====================================================

SELECT
    ROUND(AVG(`Days for shipment (scheduled)`),2) AS avg_scheduled_days
FROM dataco_cleaned_supply_chain;

-- =====================================================
-- 17. Late Delivery Percentage
-- =====================================================

SELECT
    ROUND(
        SUM(Late_delivery_risk = 1) * 100.0 / COUNT(*),
        2
    ) AS late_delivery_percentage
FROM dataco_cleaned_supply_chain;

-- =====================================================
-- 18. Total Sales by Shipping Mode
-- =====================================================

SELECT
    `Shipping Mode`,
    ROUND(SUM(Sales),2) AS total_sales
FROM dataco_cleaned_supply_chain
GROUP BY `Shipping Mode`
ORDER BY total_sales DESC;

-- =====================================================
-- 19. Total Profit by Shipping Mode
-- =====================================================

SELECT
    `Shipping Mode`,
    ROUND(SUM(`Order Profit Per Order`),2) AS total_profit
FROM dataco_cleaned_supply_chain
GROUP BY `Shipping Mode`
ORDER BY total_profit DESC;