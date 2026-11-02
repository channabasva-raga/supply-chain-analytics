# DataCo Smart Supply Chain Analytics

End-to-end supply chain analytics on **180K+ orders** using **Python, SQL (MySQL), and Power BI**. The project covers data cleaning, exploratory analysis, fraud and delivery analysis, correlation analysis, advanced SQL (window functions, CTEs, customer lifetime value), and an interactive multi-page dashboard tracking sales, profit, and logistics performance.

---

## Table of Contents
1. [Overview](#overview)
2. [Business Problem](#business-problem)
3. [Dataset](#dataset)
4. [Tools & Technologies](#tools--technologies)
5. [Project Workflow](#project-workflow)
6. [Key Results](#key-results)
7. [Business Recommendations](#business-recommendations)
8. [Repository Structure](#repository-structure)
9. [How to Run](#how-to-run)
10. [Skills Demonstrated](#skills-demonstrated)

---

## Overview

DataCo Global generates large volumes of transaction data across customers, products, orders, and shipping. Without analysis, it is hard to spot delivery bottlenecks, loss-making products, high-value customers, or fraud risk.

This project follows a complete analytics workflow:

**Raw data → Python (cleaning, feature engineering, EDA) → MySQL (business & advanced SQL) → Power BI (dashboard) → insights & recommendations**

---

## Business Problem

Analyze sales, profitability, customer behavior, shipping performance, and fraud patterns to help the business:
- Identify top-performing products, categories, markets, and customers
- Find and reduce loss-making orders
- Improve delivery performance and reduce late deliveries
- Flag fraud-prone markets, shipping modes, and customer segments
- Support data-driven decisions through KPIs and a dashboard

---

## Dataset

**Source:** [DataCo Smart Supply Chain for Big Data Analysis](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis) (Kaggle)

| Property | Detail |
|---|---|
| Raw size | 180,519 rows × 53 columns |
| Cleaned size | 180,519 rows × 61 columns (after dropping 5 and adding 13) |
| Granularity | One row per order line item (about 65.7K unique orders, about 20.6K unique customers) |
| Industry | Supply chain & logistics |

**Column groups**
- **Orders & sales:** Order Id, Order Date, Sales, Order Profit Per Order, Order Item Quantity, Order Item Discount, Order Status
- **Products:** Product Name, Category Name, Department Name
- **Customers:** Customer Id, Customer Segment, City, Country
- **Geography:** Market, Order Region, Order Country
- **Shipping & delivery:** Shipping Mode, Days for shipping (real vs. scheduled), Delivery Status, Late_delivery_risk

---

## Tools & Technologies

| Stage | Tools |
|---|---|
| Data cleaning, feature engineering, EDA | Python (Pandas, NumPy, Matplotlib, Seaborn), Jupyter Notebook |
| Database & querying | MySQL (window functions, CTEs, subqueries, views) |
| Visualization | Power BI |
| Data source | Kaggle (`kagglehub`) |

---

## Project Workflow

### 1. Data Understanding & Quality Checks (Python)
- Inspected shape, data types, summary statistics, and memory usage
- Checked missing values, duplicate rows, and unique values per column
- **Findings:** `Product Description` was 100% empty, `Order Zipcode` was 86% missing, and `Customer Email`, `Customer Password`, and `Product Status` held one constant value each. There were no fully duplicated rows. Repeated Order IDs are expected because each order can have several line items.

### 2. Data Cleaning
- Dropped the 5 unusable columns listed above (53 → 48 columns)
- Converted order and shipping dates to datetime format

### 3. Feature Engineering (13 new features)
| Feature | Purpose |
|---|---|
| Order Year / Month / Month Name / Quarter / Day / Day Name | Time-based and seasonal analysis |
| Shipping Duration | Actual days between order and shipment |
| Weekend Order | Weekday vs. weekend behavior |
| High Value Order | Above/below median sales |
| Sales Category | Low / Medium / High (terciles) |
| Profit Category | Profit vs. Loss orders |
| Profit Margin (%) | Profitability per order item |
| Shipping Performance | On Time vs. Delayed, compared against recorded Delivery Status |

### 4. Exploratory Data Analysis (Python)
23 analyses, each with a business question, chart, insight, and recommendation:
- **Sales:** sales and profit distributions, monthly and yearly trends, sales vs. profit
- **Products:** top categories, top products, sales by department
- **Geography:** sales by market, region, and country
- **Customers:** sales by segment, top customers
- **Logistics:** shipping modes, delivery status, late delivery risk, engineered vs. recorded delivery performance
- **Fraud:** suspected fraud by market, shipping mode, and customer segment
- **Correlation analysis:** heatmap across sales, profit, discount, quantity, and shipping variables

### 5. SQL Analysis (MySQL)
The cleaned dataset was loaded into MySQL and analyzed in four scripts, run in order:

| Script | What it covers |
|---|---|
| `01_Data_Validation.sql` | Row and column counts, table structure, null checks, duplicate checks, sales and profit ranges, distinct markets, countries, categories, and shipping modes |
| `02_Exploratory_Data_Analysis.sql` | KPIs (sales, profit, orders, customers, products), orders by shipping mode, delivery status, and market, top countries and categories, average shipping days, late delivery % |
| `03_Business_Analysis.sql` | Sales performance, profitability and loss-making products, customer segments and top customers, shipping performance, fraud analysis, monthly sales trend |
| `04_Advance_sql_analysis.sql` | Advanced techniques (below) |

**Advanced SQL techniques used**
- **Window functions:** `RANK`, `DENSE_RANK`, `ROW_NUMBER`, `NTILE` (customer sales quartiles), and `PARTITION BY` for top 5 products per category and top 3 customers per market
- **CTEs:** category and market sales comparisons, multi-step logic
- **Subqueries:** products and customers above average
- **Running total and 3-month moving average** of sales
- **Customer lifetime value (CLV):** orders, lifetime sales, and average order value per customer
- **ABC product classification** by revenue
- **View:** `vw_sales_summary` (sales, profit, and orders by market)
- **Executive KPI query** that feeds the dashboard

### 6. Dashboard (Power BI)
Built an interactive, multi-page Power BI dashboard on the cleaned data to track sales, profit, and logistics performance.

---

## Key Results

Figures below come directly from the notebook outputs.

- **Late deliveries are the biggest operational issue.** About **54.8%** of orders (98,977 of 180,519) were flagged as late. Actual shipping averaged **3.5 days** against **2.9 days** scheduled.
- **About 1 in 5 orders loses money.** **33,784 orders (18.7%)** had negative profit, and the worst single order lost over $4,200.
- **Healthy overall, but uneven.** Most orders are profitable, with a median profit margin of about 27%, but margins range from −275% to +50%.
- **Revenue is concentrated** in a small number of categories, products, markets, and customers, which makes them priority areas for inventory and retention.
- **Higher sales don't always mean higher profit.** Some high-sales orders are loss-making, which points to pricing and discount issues.
- **Fraud is rare but uneven.** Suspected fraud is a small share of orders and varies by market, shipping mode, and customer segment.
- **Seasonality exists.** Monthly sales fluctuate, which supports seasonal planning for inventory and marketing.
- **Engineered vs. recorded delivery metrics largely agree**, which validates the feature engineering approach.

---

## Business Recommendations

- **Logistics:** Reduce late deliveries through better warehouse coordination, route planning, and proactive shipment tracking.
- **Profitability:** Investigate recurring loss-making orders and products, and review pricing, discounts, and shipping costs.
- **Products:** Keep best sellers well stocked, and review low performers for repricing, promotion, or removal.
- **Customers:** Build loyalty programs and personalized offers for high-value customers and segments.
- **Fraud:** Add risk-based verification in markets, shipping modes, and segments with higher fraud counts.
- **Planning:** Align marketing and inventory with seasonal demand patterns.

---

## Repository Structure

```
├── data/
│   └── DataCo_Cleaned_Supply_Chain.csv        # Cleaned dataset (exported from the notebook)
├── DataCo_Supply_Chain_Analytics.ipynb        # Python: cleaning, feature engineering, EDA, correlation
├── sql/
│   ├── 01_Data_Validation.sql
│   ├── 02_Exploratory_Data_Analysis.sql
│   ├── 03_Business_Analysis.sql
│   └── 04_Advance_sql_analysis.sql
└── README.md
```

---

## How to Run

> You don't need to run anything to evaluate this project. The notebook already contains all outputs and charts. These steps are for anyone who wants to reproduce it.

**Prerequisites:** Python 3.8+, MySQL 8.0+ (window functions require 8.0)

1. **Clone the repository**
   ```bash
   git clone <your-repo-url>
   cd <your-repo-folder>
   ```

2. **Install Python dependencies**
   ```bash
   pip install pandas numpy matplotlib seaborn jupyter kagglehub
   ```

3. **Run the notebook**
   - Open `DataCo_Supply_Chain_Analytics.ipynb` in Jupyter or Kaggle
   - The notebook downloads the raw dataset from Kaggle with `kagglehub`. If you run it locally, update the file path in the data-loading cell.
   - Run all cells. The last cell exports `DataCo_Cleaned_Supply_Chain.csv`.
   - You can also skip this step and use the cleaned CSV in the `data/` folder.

4. **Load the data into MySQL**
   ```sql
   CREATE DATABASE dataco_supply_chain_analysis;
   ```
   Import `DataCo_Cleaned_Supply_Chain.csv` into a table named `dataco_cleaned_supply_chain` (for example with the MySQL Workbench Table Data Import Wizard).

5. **Run the SQL scripts in order**
   - `01_Data_Validation.sql`
   - `02_Exploratory_Data_Analysis.sql`
   - `03_Business_Analysis.sql`
   - `04_Advance_sql_analysis.sql`

---

## Skills Demonstrated

- Data cleaning, data quality assessment, and feature engineering with Pandas
- Exploratory analysis and storytelling: business question → chart → insight → recommendation
- Fraud, delivery, and correlation analysis
- Advanced SQL: window functions, CTEs, subqueries, views, running totals, moving averages, CLV, ABC analysis
- Multi-page dashboard design and KPI selection in Power BI
- Translating data into clear business recommendations
