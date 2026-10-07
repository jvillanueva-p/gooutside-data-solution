-- 05_data_studio_queries.sql
-- Custom queries used in the Data Studio dashboard.
-- Enable "date range parameters" in the data source so @DS_START_DATE / @DS_END_DATE work
-- (they arrive as strings in 'YYYYMMDD' format).

-- A. Market classification filtered by the dashboard date range
WITH filtered AS (
  SELECT retailer_name, country, revenue
  FROM `your-project.GoOutside.master_table`
  WHERE date BETWEEN PARSE_DATE('%Y%m%d', @DS_START_DATE)
                 AND PARSE_DATE('%Y%m%d', @DS_END_DATE)
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
  SELECT
    country,
    SUM(retailer_revenue) AS country_revenue,
    COUNT(*) AS num_retailers
  FROM retailer_revenue
  GROUP BY country
)
SELECT
  t.country,
  SUM(IF(r.rank <= 3, r.retailer_revenue, 0)) AS top3_revenue,
  t.country_revenue,
  t.num_retailers,
  SAFE_DIVIDE(SUM(IF(r.rank <= 3, r.retailer_revenue, 0)), t.country_revenue) AS pct_top3,
  IF(SAFE_DIVIDE(SUM(IF(r.rank <= 3, r.retailer_revenue, 0)), t.country_revenue) < 0.75,
     'Competitive', 'Dominated') AS market_type,
  SAFE_DIVIDE(t.country_revenue, t.num_retailers) AS revenue_per_retailer
FROM totals AS t
JOIN ranked AS r USING (country)
GROUP BY t.country, t.country_revenue, t.num_retailers;

-- B. Monthly performance (Yearly Performance page)
SELECT
  DATE_TRUNC(date, MONTH) AS month_date,
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month,
  FORMAT_DATE('%B', date) AS month_name,
  SUM(revenue) AS total_revenue,
  SUM(cost) AS total_cost,
  SUM(profit) AS total_profit,
  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT retailer_name) AS num_retailers,
  SAFE_DIVIDE(SUM(profit), SUM(revenue)) AS profit_margin
FROM `your-project.GoOutside.master_table`
GROUP BY month_date, year, month, month_name;
