-- 04_sarah_order_methods.sql
-- Order method analysis: revenue, share, profit, estimated orders and margin.

CREATE OR REPLACE VIEW `your-project.GoOutside.sarah_order_method_analysis` AS
SELECT
  order_method_type AS order_method,
  SUM(revenue) AS total_revenue,
  SAFE_DIVIDE(SUM(revenue), SUM(SUM(revenue)) OVER ()) AS pct_revenue,
  SUM(profit) AS total_profit,
  COUNT(DISTINCT order_id) AS total_orders,
  SAFE_DIVIDE(SUM(profit), SUM(revenue)) AS margin
FROM `your-project.GoOutside.master_table`
GROUP BY order_method_type
ORDER BY total_revenue DESC;
