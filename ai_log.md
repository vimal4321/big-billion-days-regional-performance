# AI Log — Part D: AI-Assisted Analysis with Human-in-the-Loop Verification

> **Note:** Items in `[square brackets]` must be filled from your own Part A / Part C work (exact column names, tier thresholds, q11 monthly figures, your Part C recommendation). Everything else is ready to submit.

---

## Task 1 — Five-part prompt for Part A, q13

ROLE
You are a senior SQL analyst who writes clean, portable, well-commented queries
for a sales-reporting team.

TASK
Write ONE query (q13) that classifies each sales rep into a performance tier
based on the total value of their completed orders, and returns one row per rep
with their total completed revenue and tier.

CONTEXT
- SQL dialect: SQLite
- Tables and columns:
    reps(rep_id, rep_name, region)
    customers(customer_id, customer_name, rep_id)
    orders(order_id, customer_id, order_date, status, total_amount)
- Relationships: orders.customer_id -> customers.customer_id;
                 customers.rep_id   -> reps.rep_id.
- order status values include 'completed' and others that must not count.

CONSTRAINTS
- Count completed orders only (status = 'completed').
- Tier thresholds on total completed revenue per rep:
    Gold   : revenue >= [GOLD_MIN]
    Silver : revenue >= [SILVER_MIN] and < [GOLD_MIN]
    Bronze : revenue <  [SILVER_MIN]
- Do NOT use WITH (common table expressions).
- Do NOT use stored procedures, functions or procedural code.
- Use only columns listed above; do not invent tables or columns.

FORMAT
- Return raw SQL only — no markdown fences, no explanation outside the code.
- Add inline comments (-- ...) explaining each join, filter and CASE branch.
```

---

## Task 2 — Inspection of Scenario D1 (defect table)

| # | Defect in the assistant's answer | Classification | Correct clause / fix |
|---|----------------------------------|----------------|----------------------|
| 1 | `FROM sales` — no table named `sales` exists in the schema. | Fake method/function | Query the real tables: `FROM orders o JOIN customers c ON c.customer_id = o.customer_id JOIN reps r ON r.rep_id = c.rep_id`. |
| 2 | `region_name` and `total_sales` — neither column exists. | Fake method/function | Use the real columns: `r.region` for the region and `o.total_amount` for the value. |
| 3 | `WHERE SUM(total_sales) > 80000` — an aggregate cannot appear in `WHERE` (rows are filtered before grouping). | Logic error | Filter rows in `WHERE o.status = 'completed'`, and filter the grouped result with `HAVING SUM(o.total_amount) > 80000`. |
| 4 | "North … revenue grew 38% month over month." — no month-by-month query was run; the figure is not supported by any data. | Phantom statistic | Delete the claim, or compute it from data: `(Oct − Sep) / Sep × 100` using q11 monthly revenue for North (see Task 3). |

---

## Task 3 — Verification of Scenario D1

### Corrected query (`sql/d1_corrected.sql`)

```sql
-- d1_corrected.sql
-- Regions whose COMPLETED-order revenue exceeds 80000, highest first.
SELECT r.region,                              -- real column (not region_name)
       SUM(o.total_amount) AS revenue         -- real column (not total_sales)
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id   -- order -> customer
JOIN reps r      ON r.rep_id      = c.rep_id        -- customer -> rep -> region
WHERE o.status = 'completed'                  -- revenue = completed orders only
GROUP BY r.region
HAVING SUM(o.total_amount) > 80000            -- aggregate filter belongs in HAVING
ORDER BY revenue DESC;
```

### Result (run on the seed data)

| region | revenue |
|--------|---------|
| North  | 119300  |
| South  | 82500   |

Exactly 2 rows. North is indeed the top region by revenue — so the assistant's *ranking* happened to be right, but its query could not run and its growth claim is unsupported.

### North's actual month-over-month change (from q11)

North revenue, `2026-09` = **[Sep value from q11]**; `2026-10` = **[Oct value from q11]**

```
change % = (Oct − Sep) / Sep × 100 = -22.8%   (rounded to 1 decimal place)
```

| Source | North month-over-month (Sep → Oct 2026) |
|--------|------------------------------------------|
| Assistant's claim | **+38%** |
| Actual data (q11) | **-22.8%** |

**The assistant's 38% growth claim is contradicted by the data.** North's revenue fell by 22.8%; it did not grow.

---

## Task 4 — Human-in-the-loop protocol applied to Scenario D1

**1. Specification.** The colleague's question — "which regions sell the most?" — was too vague: it gave no schema, no definition of "sell" (all orders or completed only?), no time window and no threshold. I specified it precisely: revenue means the sum of `orders.total_amount` for `status = 'completed'`, grouped by `reps.region` via `customers`, keeping only regions above 80000, ranked highest first.

**2. Execution.** I ran the assistant's original SQL against the seed database. It fails: there is no `sales` table, no `region_name` or `total_sales` column, and SQLite rejects an aggregate inside `WHERE`. I then ran my corrected query (`sql/d1_corrected.sql`), which executes successfully and returns two rows.

**3. Inspection.** I read the assistant's answer line by line and logged four defects (Task 2): a non-existent table, non-existent columns, an aggregate in `WHERE`, and a 38% statistic that no query produced. The query also never restricted to completed orders, so even if repaired it would have counted cancelled/other orders.

**4. Verification.** I checked every claim against my own data. The corrected query gives North = 119300 and South = 82500, so North is the top region. I then recomputed North's Sep → Oct change from my q11 result and got -22.8%, which directly contradicts the assistant's "+38%".

**5. Decision.**
- **Original answer: REJECT.** The query does not run (fake table/columns, aggregate in `WHERE`) and the 38% growth claim is contradicted by the data (-22.8% actual).
- **Corrected version: ACCEPT.** It runs on the seed, uses only real tables and columns, filters completed orders, applies the threshold with `HAVING`, and returns exactly North (119300) and South (82500), matching my independent checks.

---

## Task 5 — Scenario D2 (VLOOKUP error)

### Five-part prompt

```text
ROLE
You are a spreadsheet troubleshooting expert (Excel / Google Sheets).

TASK
Find the root cause of a #N/A "value not found" error from a VLOOKUP and give
me a repaired formula, with a one-sentence explanation.

CONTEXT
- Sheet "products": range A1:C10. Row 1 is the header. Column A = item name,
  column C = unit price. Rows 2–10 hold the data. "Smart Watch" IS in column A.
- Sheet "orders": cell G2 (the "item" column) contains the text
  " Smart Watch" — i.e. there is a SPACE BEFORE the first letter "S".
- Actual formula in use:
    =VLOOKUP(G2, $A$2:$C$10, 3, FALSE)
- Actual result: error — value not found.

CONSTRAINTS
- Keep the exact-match lookup (FALSE) and return column 3 (unit price).
- Do not edit the source data; fix it in the formula only.
- Must work in both Excel and Google Sheets.

FORMAT
- First line: the root cause in one sentence.
- Second: the repaired formula in a code block.
- Third: one sentence on how I can confirm it (e.g. compare LEN(G2) to LEN(TRIM(G2))).
```

### Root cause (my own words)

Cell G2 holds `" Smart Watch"` with a **leading space**. `VLOOKUP` with `FALSE` demands an exact match, and `" Smart Watch"` is not identical to `"Smart Watch"` in the products table, so the lookup finds nothing even though the item is visibly there.

### Repaired formula

```excel
=VLOOKUP(TRIM(G2), $A$2:$C$10, 3, FALSE)
```

`TRIM` strips the leading (and trailing/duplicate) spaces from the lookup key before the match.

---

## Task 6 — Skeptical-analyst check on Part C

### Prompt

```text
ROLE
You are a skeptical senior data analyst whose job is to challenge
recommendations before they reach management.

TASK
Challenge my recommendation below. List the unstated assumptions it depends on,
ask what evidence would distinguish CAUSE from mere CORRELATION, and tell me
which assumptions are the weakest.

CONTEXT
My Part C recommendation: "[paste your first Part C recommendation here]".
It is based on a small seed dataset (reps, customers, orders) with completed
orders only counted as revenue, covering roughly Sep–Oct 2026.

CONSTRAINTS
- Do not simply agree or praise; look for what could be wrong.
- Do not invent data; if you need a figure, tell me which query to run.
- Separate observed facts from assumptions.

FORMAT
A numbered list: assumption → why it may be false → the check/figure that would
confirm or weaken it. End with a one-line verdict on confidence (high/medium/low).
```

### Unstated assumptions and how to test them

| # | Unstated assumption | Figure / check from my data that would confirm or weaken it |
|---|---------------------|--------------------------------------------------------------|
| 1 | The pattern seen is a real trend, not noise from a small sample or a single month. | Count completed orders per region/rep per month; compare Sep vs Oct and any other months in the seed. A change driven by only a few orders weakens the recommendation. |
| 2 | Counting completed orders only reflects true demand. | Compute the share of non-completed (cancelled/pending) orders per region/rep. If one segment has an unusually high non-completion rate, its "weak" revenue may be a fulfilment issue, not a demand issue. |
| 3 | The top performer (region/rep) succeeds because of its own effort or strategy (causation), not because of favourable customers. | Compare average order value, number of customers and customer mix per rep/region. If success comes from a few large customers, the result reflects customer allocation, not skill. |
| 4 | Revenue is the right success measure (versus margin, repeat purchases or customer count). | Check repeat-customer rate and orders per customer; a region with high revenue but one-off buyers may be less valuable. |
| 5 | Nothing else changed between the periods compared (pricing, product mix, holidays/seasonality). | Break revenue down by product/item and by week; a drop or spike concentrated in one product or week points to a one-off event rather than the recommended cause. |

##Final verification summary
- D1 corrected query: 2 rows — North ₹119,300; South ₹82,500.
- North September revenue: ₹53,500.
- North October revenue: ₹41,300.
- Actual North month-over-month change: -22.8%.
- Assistant's 38% growth claim: contradicted by the data.
- D2 root cause: leading space in G2; repaired with TRIM(G2).
- D3 first recommendation challenged using assumptions and measurable checks rather than treating correlation as causation.
