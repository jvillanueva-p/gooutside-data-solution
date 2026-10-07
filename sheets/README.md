# Google Sheets notes

First version of the master table was built in Google Sheets (before moving to BigQuery).
Column letters depend on your layout; adjust them.

## Estimated order ID
```
=ARRAYFORMULA(IF(B2:B="","",B2:B&"-"&TEXT(E2:E,"yyyymmdd")&"-"&D2:D))
```
Retailer code + date + order method. Product is excluded on purpose, so one order can have several lines.
Count unique orders with `=COUNTUNIQUE(A2:A)`.

## Lookups (no dragging needed)
```
=ARRAYFORMULA(VLOOKUP(B2:B, Retailers!$A$2:$D$563, {2,3,4}, FALSE))
=ARRAYFORMULA(VLOOKUP(C2:C, Products!$A$2:$H$275, {2,3,4,5,6,7}, FALSE))
```

## Calculated columns
```
Margin:     =IF(X2=0,"",Z2/X2)
Year:       =YEAR(D2)
Month:      =MONTH(D2)
Quarter:    ="Q"&ROUNDUP(MONTH(D2)/3,0)
Month name: =TEXT(D2,"mmmm")
Share in country (helper): =D2/SUMIF($A:$A, A2, $D:$D)
```

## Pivot tables
Rows: order method / country. Values: SUM of revenue and profit, COUNTUNIQUE of order ID,
and a calculated field for margin.

## Connected Sheets (BigQuery) parameters
Two cells with plain text dates (`YYYY-MM-DD`), linked as `@start_date` and `@end_date`.
Queries are in `sql/06_connected_sheets_queries.sql`.
