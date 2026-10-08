
-- Enterprise Sales & Operations Analytics
-- SQL Sales and Profitability Analysis
-- Database: MySQL
-- Data: Synthetic business transactions

-- 1. Sales Revenue, COGS, and Gross Profit
SELECT
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue,
    ROUND(SUM(quantity * unit_cost), 2) AS total_cogs,
    ROUND(SUM(quantity * (unit_price - unit_cost)), 2)
        AS gross_profit
FROM sales_data;

-- 2. Gross Margin Percentage
SELECT
    ROUND(
        100.0 * SUM(quantity * (unit_price - unit_cost))
        / NULLIF(SUM(quantity * unit_price), 0),
        2
    ) AS gross_margin_pct
FROM sales_data;

-- 3. Sales Performance by Store
SELECT
    store_id,
    SUM(quantity) AS units_sold,
    ROUND(SUM(quantity * unit_price), 2) AS revenue,
    ROUND(SUM(quantity * unit_cost), 2) AS cogs,
    ROUND(SUM(quantity * (unit_price - unit_cost)), 2)
        AS gross_profit
FROM sales_data
GROUP BY store_id
ORDER BY revenue DESC;

-- 4. Product-Level Sales Performance
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(s.quantity) AS units_sold,
    ROUND(SUM(s.quantity * s.unit_price), 2)
        AS revenue,
    ROUND(SUM(s.quantity * s.unit_cost), 2)
        AS cogs,
    ROUND(SUM(s.quantity *
        (s.unit_price - s.unit_cost)), 2)
        AS gross_profit
FROM sales_data s
JOIN product_data p
    ON s.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY revenue DESC;

-- 5. Daily Revenue Trend
SELECT
    date,
    ROUND(SUM(quantity * unit_price), 2)
        AS daily_revenue,
    ROUND(SUM(quantity * unit_cost), 2)
        AS daily_cogs
FROM sales_data
GROUP BY date
ORDER BY date;

-- 6. COGS Percentage by Product Category
SELECT
    p.category,
    ROUND(SUM(s.quantity * s.unit_price), 2)
        AS revenue,
    ROUND(SUM(s.quantity * s.unit_cost), 2)
        AS cogs,
    ROUND(
        100.0 * SUM(s.quantity * s.unit_cost)
        / NULLIF(SUM(s.quantity * s.unit_price), 0),
        2
    ) AS cogs_pct
FROM sales_data s
JOIN product_data p
    ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY cogs_pct DESC;
