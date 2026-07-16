USE brazilian_ecommerce;

-- ============================================
-- DATA EXPLORATION
-- ============================================
SELECT *
FROM olist_order_items_dataset
LIMIT 10;

SELECT *
FROM olist_orders_dataset
LIMIT 10;

SELECT *
FROM olist_customers_dataset
LIMIT 10;

SELECT *
FROM olist_products_dataset
LIMIT 10;

-- ============================================
-- DATA QUALITY CHECKS
-- ============================================
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_product_id
FROM olist_order_items_dataset;

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS null_category
FROM olist_products_dataset;

SELECT order_id, order_item_id, product_id, COUNT(*)
FROM olist_order_items_dataset
GROUP BY order_id, order_item_id, product_id
HAVING COUNT(*) > 1;

-- ============================================
-- Q1: Which product categories generate the most total revenue?
-- ============================================
SELECT 
    p.product_category_name, 
    SUM(oi.price) AS Total_Revenue
FROM olist_order_items_dataset AS oi
JOIN olist_products_dataset AS p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY Total_Revenue DESC;

-- ============================================
-- Q2: Which states/cities have the most customers or highest revenue?
-- ============================================
SELECT 
    customer_state, 
    COUNT(*) AS Most_Customers
FROM olist_customers_dataset AS cu
JOIN olist_orders_dataset AS da
    ON cu.customer_id = da.customer_id
GROUP BY customer_state
ORDER BY Most_Customers DESC;

SELECT 
    customer_state, 
    SUM(oi.price) AS State_Revenue
FROM olist_customers_dataset AS cu
JOIN olist_orders_dataset AS da
    ON cu.customer_id = da.customer_id
JOIN olist_order_items_dataset AS oi
    ON da.order_id = oi.order_id
GROUP BY customer_state
ORDER BY State_Revenue DESC;

-- ============================================
-- Q3: What's the monthly revenue trend with rolling total?
-- ============================================
SELECT 
    DATE_FORMAT(da.order_purchase_timestamp, '%Y-%m') AS order_month,
    SUM(oi.price) AS Monthly_Revenue
FROM olist_orders_dataset AS da
JOIN olist_order_items_dataset AS oi
    ON da.order_id = oi.order_id
GROUP BY order_month
ORDER BY order_month;

WITH monthly AS (
    SELECT 
        DATE_FORMAT(da.order_purchase_timestamp, '%Y-%m') AS order_month,
        SUM(oi.price) AS Monthly_Revenue
    FROM olist_orders_dataset AS da
    JOIN olist_order_items_dataset AS oi
        ON da.order_id = oi.order_id
    GROUP BY order_month
)
SELECT 
    order_month,
    Monthly_Revenue,
    SUM(Monthly_Revenue) OVER (ORDER BY order_month) AS Rolling_Total
FROM monthly
ORDER BY order_month;

-- ============================================
-- Q4: What percentage of orders are delivered vs. canceled vs. still shipping/processing?
-- ============================================
SELECT COUNT(*)
FROM olist_orders_dataset;

SELECT 
    order_status, 
    COUNT(*) AS order_count, 
    ROUND(COUNT(*) * 100.0 / 99441, 2) AS pct_of_total
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY order_count DESC;

-- ============================================
-- Q5: What's the average delivery time by state?
-- ============================================
SELECT 
    customer_state, 
    AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS avg_state_delivery_time
FROM olist_orders_dataset AS da
JOIN olist_customers_dataset AS cu
    ON da.customer_id = cu.customer_id
GROUP BY customer_state
ORDER BY avg_state_delivery_time DESC;
