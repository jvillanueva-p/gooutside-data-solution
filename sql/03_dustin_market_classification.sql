-- 03_dustin_market_classification.sql
-- Market concentration by country: share of revenue held by the top 3 retailers.
-- Rule chosen by the team: top-3 share < 75% = Competitive, otherwise Dominated.
-- Targets: Dominated -> +10% revenue per retailer; Competitive -> +15% retailers.

CREATE OR REPLACE VIEW `your-project.GoOutside.top3_retailers_by_country` AS
SELECT *
FROM (
  SELECT
    retailer_name,
    country,
    SUM(revenue) AS total_revenue,
    RANK() OVER (PARTITION BY country ORDER BY SUM(revenue) DESC) AS rank
  FROM `your-project.GoOutside.master_table`
  GROUP BY retailer_name, country
)
WHERE rank <= 3;

CREATE OR REPLACE VIEW `your-project.GoOutside.dustin_market_classification` AS
WITH top3 AS (
  SELECT country, SUM(total_revenue) AS top3_revenue
  FROM `your-project.GoOutside.top3_retailers_by_country`
  GROUP BY country
),
totals AS (
  SELECT
    country,
    SUM(revenue) AS country_revenue,
    COUNT(DISTINCT retailer_name) AS num_retailers
  FROM `your-project.GoOutside.master_table`
  GROUP BY country
),
classified AS (
  SELECT
    t.country,
    t.top3_revenue,
    c.country_revenue,
    c.num_retailers,
    SAFE_DIVIDE(t.top3_revenue, c.country_revenue) AS pct_top3,
    CASE WHEN SAFE_DIVIDE(t.top3_revenue, c.country_revenue) < 0.75
         THEN 'Competitive' ELSE 'Dominated' END AS market_type,
    SAFE_DIVIDE(c.country_revenue, c.num_retailers) AS revenue_per_retailer
  FROM top3 AS t
  JOIN totals AS c USING (country)
)
SELECT
  *,
  IF(market_type = 'Dominated', ROUND(revenue_per_retailer * 1.10, 2), NULL) AS target_revenue_per_retailer,
  IF(market_type = 'Competitive', CAST(CEIL(num_retailers * 115 / 100) AS INT64), NULL) AS target_num_retailers
FROM classified
ORDER BY pct_top3 DESC;
