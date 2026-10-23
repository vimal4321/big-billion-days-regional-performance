# Dashboard Specification — Part C

Tool: Tableau Public. Data source: `data/orders_clean.csv` (63 completed orders, INR). All figures below agree with Part A (q05) and Part B (pivot tables).

## 1. Data source

Connect to `data/orders_clean.csv` (text file connection). Keep `order_month` as a string/text field (values such as `2026-09`).

| # | Field | Classification |
|---|---|---|
| 1 | order_id | Dimension |
| 2 | order_month | Dimension |
| 3 | clean_first_name | Dimension |
| 4 | clean_last_name | Dimension |
| 5 | region | Dimension |
| 6 | rep_name | Dimension |
| 7 | item | Dimension |
| 8 | category | Dimension |
| 9 | unit_price | Measure |
| 10 | quantity | Measure |
| 11 | amount | Measure |
| 12 | revenue_calc | Measure |
| 13 | status | Dimension |

Total: 13 fields = 9 Dimensions and 4 Measures. `order_id` is a Dimension because it is an identifier, not something to add up.

## 2. KPI cards

| Card | Calculation | Value shown |
|---|---|---|
| Total Revenue | SUM(amount) | ₹3,46,200 (346200) |
| Total Units Sold | SUM(quantity) | 106 |

The Total Revenue card equals Part A's q05 `total_revenue` of 346200.

## 3. Worksheets

### 3.1 Revenue by Region (bar chart)

- Columns: SUM(amount)
- Rows: region (sorted descending by SUM(amount))
- Colour: single colour (orange); Label: SUM(amount)
- Why a bar chart: it compares one measure across a few discrete categories, and bar length is read accurately.

| region | Revenue (INR) |
|---|---|
| North | 119300 |
| South | 82500 |
| West | 74900 |
| East | 69500 |
| **Total** | **346200** |

### 3.2 Revenue by Category (bar chart)

- Columns: SUM(amount)
- Rows: category (sorted descending by SUM(amount))
- Colour: single colour (teal); Label: SUM(amount)
- Why a bar chart: it compares revenue across three product categories side by side.

| category | Revenue (INR) |
|---|---|
| Electronics | 142300 |
| Home | 126400 |
| Apparel | 77500 |
| **Total** | **346200** |

### 3.3 Revenue Trend by Month and Category (line chart)

- Columns: order_month (discrete)
- Rows: SUM(amount)
- Colour: category (one line per category)
- Why a line chart: lines show how each category changes over time and make the direction of change easy to see.

| order_month | Apparel | Electronics | Home | Month total |
|---|---|---|---|---|
| 2026-09 | 24700 | 43000 | 30600 | 98300 |
| 2026-10 | 30600 | 49900 | 12600 | 93100 |
| 2026-11 | 22200 | 49400 | 83200 | 154800 |
| **Total** | **77500** | **142300** | **126400** | **346200** |

### 3.4 Region x Category Detail (text table)

- Rows: region
- Columns: category
- Text (Label): SUM(amount); Grand Totals switched on for rows and columns
- Why a text table: the reader needs exact values for every region and category combination, not just a visual comparison.

| region | Apparel | Electronics | Home | Grand Total |
|---|---|---|---|---|
| East | 10600 | 21400 | 37500 | 69500 |
| North | 19400 | 73400 | 26500 | 119300 |
| South | 10000 | 28700 | 43800 | 82500 |
| West | 37500 | 18800 | 18600 | 74900 |
| **Grand Total** | **77500** | **142300** | **126400** | **346200** |

## 4. Dashboard layout

Placement order from top to bottom:

1. KPI cards (Total Revenue and Total Units Sold, side by side)
2. Category filter (top band, directly below the KPI cards)
3. Revenue Trend by Month and Category (line chart, full width)
4. Comparison charts: Revenue by Region and Revenue by Category (side by side)
5. Region x Category Detail (text table, full width)
6. Text boxes: Summary analysis, Recommendations, Reconciliation (side by side at the bottom)

Containers:
- One outer **vertical container** holds all rows from top to bottom.
- A **horizontal container** holds the two KPI cards.
- The category filter sits in its own full-width row directly under the KPI cards.
- A **horizontal container** holds the two bar charts.
- A **horizontal container** at the bottom holds the three text boxes.

**Category filter:** add `category` as a filter on one sheet, choose **Apply to Worksheets → All Using This Data Source**, and show it as a filter control in the top band. It then applies to all four worksheets and the KPI cards.

**Use as Filter:** when a user clicks a bar in Revenue by Region with Use as Filter switched on, the other charts, the KPI cards and the detail table are filtered to show only that region (for example, clicking North shows only North's 119300 and its category split); clicking the bar again, or a blank area, clears the filter.

## 5. Insight and recommendation narrative

### Visualization summary

The dashboard shows total completed revenue of ₹3,46,200 from 106 units sold. It compares revenue across the four regions and three product categories, shows how each category's revenue changes from September to November 2026, and gives the exact region-by-category figures in a table. A category filter lets the reader focus on one category.

### Summary analysis

1. **Region comparison:** North generated the highest regional revenue at 119300, compared with South at 82500, West at 74900 and East at 69500. North's lead over South is 36800.
2. **Category comparison:** Electronics was the top category with 142300, followed by Home at 126400 and Apparel at 77500. Electronics in North alone (73400) is the largest single region-category cell.
3. **Change across months:** Home revenue rose from 12600 in October to 83200 in November, a jump of 70600, while Electronics stayed steady (49900 in October, 49400 in November). Total monthly revenue went from 93100 in October to 154800 in November.
4. **Region trend:** North's monthly revenue fell from 53500 in September to 41300 in October and 24500 in November, while East grew from 6400 in September to 50900 in November.

### Recommendations

1. **North – Electronics:** run a targeted promotional campaign, because North Electronics revenue is 73400, the largest region-category figure. Watch Electronics revenue in North per month (and North's total revenue, which fell from 53500 to 24500 between September and November) to see whether the decline stops.
2. **South – Home:** increase Home product stock, because South Home revenue is 43800, the highest Home figure of any region. Watch Home units sold in South and any stock-outs.
3. **West – Apparel:** run an Apparel promotion, because West Apparel revenue is 37500, almost half of all Apparel revenue (77500) and the highest Apparel figure of any region. Watch West Apparel revenue per month against the 37500 baseline.

## 6. Reconciliation

| Source | Total Revenue (INR) |
|---|---|
| Total Revenue KPI | 346200 |
| Sum of Revenue by Region | 346200 |
| Sum of Revenue by Category | 346200 |
| Part B pivot grand total | 346200 |

All four values are equal.
