-- 02_exploration.sql
-- Guide questions used to get to know the data.

-- 1. Period covered
SELECT
  MIN(date) AS first_date,
  MAX(date) AS last_date,
  DATE_DIFF(MAX(date), MIN(date), MONTH) AS months_covered
FROM `your-project.GoOutside.master_table`;

-- 2. Number of retailers and countries
SELECT
  COUNT(DISTINCT retailer_code) AS num_retailers,
  COUNT(DISTINCT country) AS num_countries
FROM `your-project.GoOutside.master_table`;

-- 3. Revenue by country and product line
SELECT country, product_line, ROUND(SUM(revenue), 2) AS total_revenue
FROM `your-project.GoOutside.master_table`
GROUP BY country, product_line
ORDER BY country, total_revenue DESC;

-- 4. Profit by year
SELECT year, ROUND(SUM(profit), 2) AS total_profit
FROM `your-project.GoOutside.master_table`
GROUP BY year
ORDER BY year;

-- 5. Order methods
SELECT
  order_method_type,
  COUNT(DISTINCT order_id) AS estimated_orders,
  ROUND(SUM(revenue), 2) AS total_revenue
FROM `your-project.GoOutside.master_table`
GROUP BY order_method_type
ORDER BY total_revenue DESC;

-- 6a. Revenue by brand
SELECT product_brand, ROUND(SUM(revenue), 2) AS total_revenue
FROM `your-project.GoOutside.master_table`
GROUP BY product_brand
ORDER BY total_revenue DESC;

-- 6b. Revenue by product type
SELECT product_type, ROUND(SUM(revenue), 2) AS total_revenue
FROM `your-project.GoOutside.master_table`
GROUP BY product_type
ORDER BY total_revenue DESC;
