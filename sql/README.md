# SQL

BigQuery scripts for the GoOutside case study. Replace `your-project` with your own project ID before running, and run the files in order.

| File | What it does |
|---|---|
| `01_master_table.sql` | Joins the four source tables into one view with revenue, cost, profit and margin |
| `02_exploration.sql` | Guide questions to get to know the data |
| `03_dustin_market_classification.sql` | Top 3 retailers by country and market classification (Competitive / Dominated) with growth targets |
| `04_sarah_order_methods.sql` | Revenue, profit, estimated orders and margin per order method |
| `05_data_studio_queries.sql` | Custom queries for the dashboard, with date range parameters |
| `06_connected_sheets_queries.sql` | Parameterised queries for Google Sheets |

Source tables: `daily_sales`, `products`, `retailers`, `methods` (dataset `GoOutside`).
