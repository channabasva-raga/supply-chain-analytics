/*=========================================================
  DataCo Smart Supply Chain Analysis
  Project: Data Validation & Quality Checks
=========================================================*/


-- 1. Select Database

USE dataco_supply_chain_analysis;

-- 2. Total Number of Records
SELECT
    COUNT(*) AS total_rows
FROM dataco_cleaned_supply_chain;


-- 3. Preview Dataset
SELECT *
FROM dataco_cleaned_supply_chain
LIMIT 10;


-- 4. Total Number of Columns
SELECT
    COUNT(*) AS total_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dataco_supply_chain_analysis'
AND TABLE_NAME = 'dataco_cleaned_supply_chain';

-- 5. View Table Structure
DESCRIBE dataco_cleaned_supply_chain;

-- 6. Verify Date Columns
SELECT
    `order date (DateOrders)`,
    `shipping date (DateOrders)`
FROM dataco_cleaned_supply_chain
LIMIT 5;

-- 7. Check Missing Customer Zipcodes
SELECT
    SUM(`Customer Zipcode` IS NULL) AS customer_zip_nulls
FROM dataco_cleaned_supply_chain;


-- 8. Compare Total Rows vs Non-Null Customer Zipcodes
SELECT
    COUNT(*) AS total_rows,
    COUNT(`Customer Zipcode`) AS non_null_customer_zipcodes
FROM dataco_cleaned_supply_chain;

-- 9. Check Duplicate Order IDs
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT `Order Id`) AS unique_orders,
    COUNT(*) - COUNT(DISTINCT `Order Id`) AS duplicate_orders
FROM dataco_cleaned_supply_chain;

-- 10. Check Duplicate Customer IDs
SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT `Customer Id`) AS unique_customers,
    COUNT(*) - COUNT(DISTINCT `Customer Id`) AS duplicate_customer_records
FROM dataco_cleaned_supply_chain;

-- 11. Verify Sales Range
SELECT
    MIN(Sales) AS minimum_sales,
    MAX(Sales) AS maximum_sales,
    AVG(Sales) AS average_sales
FROM dataco_cleaned_supply_chain;

-- 12. Verify Profit Range
SELECT
    MIN(`Order Profit Per Order`) AS minimum_profit,
    MAX(`Order Profit Per Order`) AS maximum_profit,
    AVG(`Order Profit Per Order`) AS average_profit
FROM dataco_cleaned_supply_chain;

-- 13. Count Distinct Markets
SELECT
    COUNT(DISTINCT Market) AS total_markets
FROM dataco_cleaned_supply_chain;

-- 14. Count Distinct Countries
SELECT
    COUNT(DISTINCT `Order Country`) AS total_countries
FROM dataco_cleaned_supply_chain;

-- 15. Count Distinct Product Categories
SELECT
    COUNT(DISTINCT `Category Name`) AS total_categories
FROM dataco_cleaned_supply_chain;

-- 16. Count Distinct Shipping Modes
SELECT
    COUNT(DISTINCT `Shipping Mode`) AS shipping_modes
FROM dataco_cleaned_supply_chain;