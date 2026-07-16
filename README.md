# SQL Olist E-Commerce Analysis

SQL analysis of the Olist Brazilian E-Commerce dataset (Kaggle) — an original, self-directed project answering real business questions across a normalized relational schema of 100k+ orders.

Unlike my other SQL repo (layoffs dataset, tutorial-based), the business questions, dataset selection, and query design here are my own.

## Dataset
- Source: [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)
- Tables used: `olist_customers_dataset`, `olist_orders_dataset`, `olist_order_items_dataset`, `olist_products_dataset`
- Join path: customers → orders → order_items → products

## Data Quality Checks
Before running any analysis, I checked for:
- Null values in key columns (price, product_id, category)
- Duplicate rows at the order/item/product grain

## Business Questions & Key Findings

**1. Which product categories generate the most revenue?**
`beleza_saude` (health & beauty) is the top category at ~$1.26M in total revenue.

**2. Which states have the most customers and highest revenue?**
São Paulo (SP) dominates both metrics — 41,746 customers and ~$5.2M in revenue, more than double the next closest state (RJ).

**3. What's the monthly revenue trend?**
Revenue grew from a few hundred dollars in Sept 2016 to consistent growth through 2017–2018, tracked using a rolling total via window functions (`SUM() OVER(ORDER BY...)`).

**4. What percentage of orders are delivered vs. canceled vs. still processing?**
97.02% of orders are successfully delivered; only 0.63% are canceled — a strong fulfillment rate.

**5. What's the average delivery time by state?**
Delivery time varies significantly by region — remote northern states like Roraima (RR) average ~29 days, compared to much faster delivery in states closer to major distribution hubs.

## Skills Demonstrated
- Multi-table joins across a normalized schema
- Window functions (rolling totals via CTEs)
- CASE-based bucketing and percentage calculations
- Date arithmetic (DATEDIFF) for delivery time analysis
- Data quality validation before analysis (nulls, duplicate checks)

## Tools
MySQL Workbench
