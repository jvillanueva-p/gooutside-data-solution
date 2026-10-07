-- 06_connected_sheets_queries.sql
-- Parameterised queries for Google Sheets (Connected Sheets).
-- Parameters are linked to cells: @start_date and @end_date, plain text 'YYYY-MM-DD'.
-- Connected Sheets cannot be formatted, so rounding is done here in SQL.

-- A. Market classification + targets for a date range
WITH filtered AS (
  SELECT retailer_name, country, revenue
  FROM `your-project.GoOutside.master_table`
  WHERE date BETWEEN PARSE_DATE('%Y-%m-%d', CAST(@start_date AS STRING))
                 AND PARSE_DATE('%Y-%m-%d', CAST(@end_date AS STRING))
),
retailer_revenue AS (
  SELECT country, retailer_name, SUM(revenue) AS retailer_revenue
  FROM filtered
  GROUP BY country, retailer_name
),
ranked AS (
  SELECT
    country,
    retailer_revenue,
    RANK() OVER (PARTITION BY country ORDER BY retailer_revenue DESC) AS rank
  FROM retailer_revenue
),
totals AS (
  SELECT country, SUM(retailer_revenue) AS country_revenue, COUNT(*) AS num_retailers
  FROM retailer_revenue
  GROUP BY country
),
classified AS (
  SELECT
    t.country,
    SUM(IF(r.rank <= 3, r.retailer_revenue, 0)) AS top3_revenue,
    t.country_revenue,
    t.num_retailers,
    SAFE_DIVIDE(SUM(IF(r.rank <= 3, r.retailer_revenue, 0)), t.country_revenue) AS pct_top3
  FROM totals AS t
  JOIN ranked AS r USING (country)
  GROUP BY t.country, t.country_revenue, t.num_retailers
)
SELECT
  country,
  ROUND(top3_revenue, 2) AS top3_revenue,
  ROUND(country_revenue, 2) AS country_revenue,
  num_retailers,
  ROUND(pct_top3 * 100, 1) AS top3_share_pct,
  IF(pct_top3 < 0.75, 'Competitive', 'Dominated') AS market_type,
  ROUND(SAFE_DIVIDE(country_revenue, num_retailers), 2) AS revenue_per_retailer,
  IF(pct_top3 >= 0.75, ROUND(SAFE_DIVIDE(country_revenue, num_retailers) * 1.10, 2), NULL) AS target_revenue_per_retailer,
  IF(pct_top3 < 0.75, CAST(CEIL(num_retailers * 115 / 100) AS INT64), NULL) AS target_num_retailers
FROM classified
ORDER BY pct_top3 DESC;

-- B. Order method analysis for a date range
WITH filtered AS (
  SELECT order_id, order_method_type, quantity, revenue, profit
  FROM `your-project.GoOutside.master_table`
  WHERE date BETWEEN PARSE_DATE('%Y-%m-%d', CAST(@start_date AS STRING))
                 AND PARSE_DATE('%Y-%m-%d', CAST(@end_date AS STRING))
)
SELECT
  order_method_type AS order_method,
  COUNT(*) AS order_lines,
  COUNT(DISTINCT order_id) AS estimated_orders,
  SUM(quantity) AS total_units,
  ROUND(SUM(revenue), 2) AS total_revenue,
  ROUND(SAFE_DIVIDE(SUM(revenue), SUM(SUM(revenue)) OVER ()), 4) AS pct_revenue,
  ROUND(SUM(profit), 2) AS total_profit,
  ROUND(SAFE_DIVIDE(SUM(profit), SUM(revenue)), 4) AS margin
FROM filtered
GROUP BY order_method_type
ORDER BY total_revenue DESC;
