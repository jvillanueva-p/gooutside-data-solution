-- 01_master_table.sql
-- Joins the four source tables into one analysis-ready view.
-- Replace `your-project` with your own BigQuery project ID.

CREATE OR REPLACE VIEW `your-project.GoOutside.master_table` AS
SELECT
  -- Estimated order ID: retailer + date + order method (product excluded on purpose)
  CONCAT(CAST(ds.`Retailer code` AS STRING), '-', CAST(ds.Date AS STRING), '-', CAST(ds.`Order method code` AS STRING)) AS order_id,
  ds.Date AS date,
  EXTRACT(YEAR FROM ds.Date) AS year,
  EXTRACT(MONTH FROM ds.Date) AS month,
  EXTRACT(QUARTER FROM ds.Date) AS quarter,
  ds.`Retailer code` AS retailer_code,
  r.`Retailer name` AS retailer_name,
  r.`type` AS retailer_type,
  r.`Country` AS country,
  ds.`Product number` AS product_number,
  p.`Product line` AS product_line,
  p.`Product type` AS product_type,
  p.`Product` AS product_name,
  p.`Product brand` AS product_brand,
  p.`Product color` AS product_color,
  ds.`Order method code` AS order_method_code,
  m.`Order method type` AS order_method_type,
  ds.`Quantity` AS quantity,
  p.`Unit cost` AS unit_cost,
  ds.`Unit price` AS unit_price,
  ds.`Unit sale price` AS unit_sale_price,
  ds.`Unit price` - ds.`Unit sale price` AS unit_price_discount,
  SAFE_DIVIDE(ds.`Unit price` - ds.`Unit sale price`, ds.`Unit price`) AS pct_discount,
  ds.Quantity * ds.`Unit sale price` AS revenue,
  ds.Quantity * p.`Unit cost` AS cost,
  (ds.Quantity * ds.`Unit sale price`) - (ds.Quantity * p.`Unit cost`) AS profit,
  SAFE_DIVIDE(
    (ds.Quantity * ds.`Unit sale price`) - (ds.Quantity * p.`Unit cost`),
    ds.Quantity * ds.`Unit sale price`
  ) AS profit_margin,
  ds.Quantity * (ds.`Unit price` - ds.`Unit sale price`) AS total_discount
FROM `your-project`.GoOutside.daily_sales AS ds
JOIN `your-project`.GoOutside.methods AS m USING (`Order method code`)
JOIN `your-project`.GoOutside.products AS p USING (`Product number`)
JOIN `your-project`.GoOutside.retailers AS r USING (`Retailer code`);
