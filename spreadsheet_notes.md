# Part B — Spreadsheet Cleaning and Pivot Layer

## 1. Spreadsheet Tool

The spreadsheet cleaning and enrichment work was completed using Microsoft Excel.

Source file:

`data/orders_enriched.csv`

Output file:

`data/orders_clean.csv`

The cleaned output is used as the data source for Part C dashboard analysis.

---

## 2. Setup

The spreadsheet was imported from `data/orders_enriched.csv`.

The following fields were checked before cleaning:

- Order ID
- Order Month
- Customer
- Region
- Sales Representative
- Item
- Category
- Quantity
- Unit Price
- Amount
- Status
- Revenue-related fields

The workbook was checked for:

- Missing values
- Extra spaces
- Inconsistent capitalization
- Product lookup values
- Order status
- Revenue calculations

### Missing-key XLOOKUP Test

A spare test cell was used with a product/item key that does not exist in the lookup table.

The XLOOKUP formula returned:

`UNKNOWN_ITEM`

This confirms that the fallback value works correctly when the lookup key is missing.

---

## 3. Data Cleaning

### 3.1 Remove Extra Spaces and Standardize Text

Text fields were cleaned using a nested `TRIM` and `PROPER` formula.

Example:

```excel
=PROPER(TRIM(A2))
```

`TRIM` removes unnecessary leading, trailing, and repeated spaces.

`PROPER` standardizes the text into proper case.

The cleaned value was then filled down for the required rows.

---

## 4. VLOOKUP Enrichment

A VLOOKUP was used to retrieve the required lookup value from the product/reference table.

Example:

```excel
=VLOOKUP(G2,$A$2:$C$10,3,FALSE)
```

The formula uses:

- `G2` as the lookup value.
- `$A$2:$C$10` as an absolute lookup range.
- Column `3` as the return column.
- `FALSE` to enforce an exact match.

The absolute `$` references ensure that the lookup range does not move when the formula is copied down.

The `FALSE` argument ensures that only an exact matching key is accepted.

---

## 5. XLOOKUP Enrichment

XLOOKUP was also used for product/reference enrichment.

Example:

```excel
=XLOOKUP(G2,$A$2:$A$10,$C$2:$C$10,"UNKNOWN_ITEM")
```

The formula:

- Searches for the key in the first lookup range.
- Returns the corresponding value from the return range.
- Returns `UNKNOWN_ITEM` when no matching key is found.

### Missing-Key Validation

A deliberately missing lookup key was entered in a spare test cell.

The result was:

```text
UNKNOWN_ITEM
```

This confirms that the fallback condition works as expected.

---

## 6. Revenue Calculation

A `revenue_calc` column was created using spreadsheet cell references.

Example:

```excel
=IF(E2="completed",C2*D2,0)
```

The formula uses the relevant cells for:

- Order status
- Quantity
- Unit price

Only completed orders contribute to calculated revenue.

For non-completed orders, the calculation returns `0`.

The formula was filled down for all applicable rows.

---

## 7. Revenue Validation

The calculated revenue was checked against the original order amount where applicable.

The main business rule is:

> Revenue is based only on completed orders.

Therefore:

```text
Completed order → Quantity × Unit Price
Non-completed order → 0
```

The cleaned dataset was checked to ensure that the revenue calculation follows this rule consistently.

---

## 8. Pivot Table — Revenue by Region

A Pivot Table was created from the cleaned dataset.

### Pivot configuration

**Rows:**
- Region

**Values:**
- Revenue / Amount

The regional revenue totals were checked against the SQL results.

Expected totals:

| Region | Revenue |
|---|---:|
| North | ₹119,300 |
| South | ₹82,500 |
| West | ₹74,900 |
| East | ₹69,500 |
| **Grand Total** | **₹346,200** |

---

## 9. Pivot Table — Revenue by Category

A second Pivot Table was created to analyze revenue by category.

### Pivot configuration

**Rows:**
- Category

**Values:**
- Revenue / Amount

Expected totals:

| Category | Revenue |
|---|---:|
| Electronics | ₹142,300 |
| Home | ₹126,400 |
| Apparel | ₹77,500 |
| **Grand Total** | **₹346,200** |

---

## 10. Pivot Table — Region and Category

A region-by-category Pivot Table was used to validate the detailed revenue breakdown.

### Pivot configuration

**Rows:**
- Region

**Columns:**
- Category

**Values:**
- Revenue / Amount

Expected results:

| Region | Apparel | Electronics | Home | Total |
|---|---:|---:|---:|---:|
| East | ₹10,600 | ₹21,400 | ₹37,500 | ₹69,500 |
| North | ₹19,400 | ₹73,400 | ₹26,500 | ₹119,300 |
| South | ₹10,000 | ₹28,700 | ₹43,800 | ₹82,500 |
| West | ₹37,500 | ₹18,800 | ₹18,600 | ₹74,900 |
| **Grand Total** | **₹77,500** | **₹142,300** | **₹126,400** | **₹346,200** |

---

## 11. Monthly Revenue Validation

Revenue was also checked by order month.

| Month | Revenue |
|---|---:|
| September 2026 | ₹98,300 |
| October 2026 | ₹93,100 |
| November 2026 | ₹154,800 |
| **Grand Total** | **₹346,200** |

November was the strongest month with ₹154,800 in revenue.

---

## 12. Reconciliation with Part A

The spreadsheet results were reconciled against the SQL reporting layer.

| Check | Revenue |
|---|---:|
| Part A q05 total revenue | ₹346,200 |
| Revenue by Region Pivot Grand Total | ₹346,200 |
| Revenue by Category Pivot Grand Total | ₹346,200 |
| Region × Category Pivot Grand Total | ₹346,200 |
| Monthly Revenue Pivot Grand Total | ₹346,200 |

All reconciliation totals agree.

Therefore, the cleaned spreadsheet layer preserves the Part A revenue total.

---

## 13. Data Quality Checks

The following checks were completed:

- Extra spaces were removed from text values.
- Text capitalization was standardized.
- Lookup formulas used exact matching.
- VLOOKUP used an absolute lookup range.
- XLOOKUP included an `UNKNOWN_ITEM` fallback.
- A missing-key test was performed.
- Revenue was calculated using cell references.
- Revenue was restricted to completed orders.
- Pivot totals were reconciled with the SQL results.
- The final revenue total was verified as ₹346,200.

---

## 14. Final Output

The cleaned and enriched spreadsheet data was exported as:

`data/orders_clean.csv`

This file is the data source for the Part C dashboard.

The final validated revenue total is:

**₹346,200**

The spreadsheet layer therefore reconciles successfully with the SQL reporting layer and provides the cleaned dataset required for dashboard analysis.