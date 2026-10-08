# GoOutside Data Solution

End-to-end analytics case study for **GoOutside**, a fictional outdoor-gear company selling through retailers in 21 countries. Built as a project for the WBS Coding School Data Analytics bootcamp.

**Author:** Javier Villanueva

**Demo:** [Dashboard video](https://youtu.be/7l1mBp-JYhI) · [Dashboard PDF](dashboard/gooutside_dashboard.pdf) · [Presentation](presentation/gooutside_presentation.pdf)

## The problem

Management needed a data solution to answer questions from three stakeholders. This repo covers the two analytical requests built in SQL and dashboards:

- **Market concentration by country:** how much of each market is controlled by its top 3 retailers, and what growth target fits each market type.
- **Order methods:** which sales channels bring the most revenue, profit and orders.

A third view (Yearly Performance) shows revenue, profit and margin over time.

## Solution flow

```
CSV files → BigQuery (tables) → master_table view → Google Sheets (Connected Sheets) → Data Studio dashboard
```

1. Four CSVs (daily sales, products, retailers, order methods) loaded to BigQuery.
2. A single `master_table` view joins them and adds revenue, cost, profit, margin and discount fields.
3. Analysis views and parameterised queries feed Google Sheets and Data Studio, with a date range control.

## Key results

| Metric | Value |
|---|---|
| Order lines | 149,257 |
| Estimated orders | 22,721 |
| Countries / retailers | 21 / 289 |
| Revenue | €1,251.5M |
| Profit | €527.7M |
| Profit margin | 42.17% |
| Web share of revenue | 72.7% |
| Market types | 6 Competitive / 15 Dominated |
| Period | 12 Jan 2015 – 20 Jul 2018 |

## Method

- **Market classification:** share of country revenue held by the top 3 retailers. Below 75% = *Competitive*, otherwise *Dominated* (the 75% threshold is a business assumption).
- **Targets:** Dominated markets → +10% revenue per retailer. Competitive markets → +15% number of retailers (rounded up).
- **Order method analysis:** revenue, share, profit, estimated orders and margin per method.

## Decisions and limitations

- The data has no order ID, so one was **estimated** as retailer + date + order method. Product is excluded on purpose, so it is an approximation.
- "Sales volume" is measured as **revenue in euros**, not units.
- No personnel cost data is available, so profit only considers product cost.
- 2018 is incomplete (data ends 20 Jul 2018), so year comparisons need care.

## Repository structure

```
sql/            BigQuery views and queries (run in order)
sheets/         Google Sheets screenshots, formulas and Connected Sheets notes
dashboard/      Dashboard video link and PDF
presentation/   Final slides
```

## How to reproduce

1. Create a BigQuery dataset named `GoOutside` and load the four CSVs as tables: `daily_sales`, `products`, `retailers`, `methods`.
2. In every SQL file, replace `your-project` with your project ID.
3. Run the files in `sql/` in order (`01` to `06`).
4. Connect Data Studio to the views, or use the custom queries in `05_data_studio_queries.sql`.

> Note: BigQuery Sandbox (no billing) deletes tables and views after 60 days. The data files are not included in this repo.

## Tools

BigQuery (SQL), Google Sheets, Data Studio.
