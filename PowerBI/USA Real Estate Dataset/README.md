# USA Real Estate Market Dashboard
A Beginner-Friendly Power BI Project

![Market Overview](screenshots/Market%20Overview.png)

---

## About This Project

This is a guided Power BI project I designed for students who are working on their second or third business intelligence dashboard. If you follow this guide from start to finish, you will end up with a professional, interactive real estate analytics report that you can add to your own portfolio.

The central business question we are trying to answer is: **What does the US real estate market look like, and which states and cities represent the most valuable and active markets?**

This is a highly relevant use case for real estate analysts, investors, and urban planners, making it a strong portfolio piece.

**Dataset:** [USA Real Estate Dataset](https://www.kaggle.com/datasets/ahmedshahriarsakib/usa-real-estate-dataset), publicly available on Kaggle, 2.2M+ listings, 12 columns. Data as of early 2024.

---

## What You Will Learn

After finishing this project you will be able to:

- Load and clean a large dataset (2.2M rows) using Power Query
- Handle nulls, outliers, and bad data professionally
- Create custom grouping columns and sort columns
- Build DAX measures including derived metrics and composite scores
- Design a 4-page interactive dashboard with consistent theming
- Use conditional formatting on KPI cards
- Build dynamic chart titles that respond to slicer selections
- Create a market quadrant analysis using a scatter chart
- Build tooltip pages for contextual drill-down
- Apply professional layout principles across multiple pages

---

## Tools Required

- Microsoft Power BI Desktop (free), [Download here](https://powerbi.microsoft.com/desktop/)
- Kaggle account (free), to download the dataset

---

## Project Structure

```
USA-Real-Estate-Dashboard/
├── USA_Real_Estate.pbix              
├── README.md                 
└── screenshots/
    ├── Market Overview.png
    ├── Property Analysis.png
    ├── Location Intelligence.png
    ├── Market Intelligence.png
    ├── Tooltip - State Cities.png
    └── Tooltip - Affordability.png
```

---

## Dashboard Pages

### Page 1 - Market Overview
![Market Overview](screenshots/Market%20Overview.png)

This is the first page a user lands on. It gives a high-level snapshot of the entire US real estate market with 5 KPI cards, avg price by state, total listings by state, and a listing status breakdown. Slicers let the user filter everything by Status and State.

**Key numbers on this page:**
- Total Listings: 2,207,986
- For Sale Listings: 1,374,105
- Sold Listings: 809,429
- Average Price: $488,863
- Median Price: $325,000

The Average Price card uses conditional formatting:
- Green -- below $400K (affordable market)
- Orange -- between $400K and $700K (moderate market)
- Red -- above $700K (expensive market)

---

### Page 2 - Property Analysis
![Property Analysis](screenshots/Property%20Analysis.png)

This page digs into property characteristics. The main question here is: what types of properties exist and how does price vary by property features?

**Key visuals:**
- Total Listings by Number of Bedrooms
- Avg Price by Number of Bedrooms
- Total Listings by Price Band
- KPI cards for Avg House Size, Avg Beds, Avg Baths

**What the data shows:**
- 3-bedroom homes are the most common property type with 752,991 listings
- 5+ bedroom homes command an average price of $1.08M
- The $200K to $500K price band dominates with 904,851 listings (41% of total)
- Average house size is 2,014 sq ft with an average of 3.27 beds and 2 baths

---

### Page 3 - Location Intelligence
![Location Intelligence](screenshots/Location%20Intelligence.png)

This page focuses on geographic patterns. The main question here is: where are the most expensive and most active markets?

**Key visuals:**
- Filled map: Avg Price by State
- Avg Price per Sq Ft by State (Top 7)
- Total Listings by City (Top 7)
- Top 7 Cities by Avg Price

**What the data shows:**
- Hawaii leads in avg price at $1,036,002 and price per sq ft at $687
- California and DC follow with $487 and $540 per sq ft respectively
- Houston, Chicago, and New York City lead in total listing volume
- Luxury city markets include Rancho Santa Fe ($4.58M avg) and Corona Del Mar ($4.1M avg)

> **Note on city-state data quality:** The source dataset contains some city records assigned to incorrect states due to data entry errors. For example, some Houston records appear under Alaska or Alabama instead of Texas. This causes inconsistent behavior when cross-filtering the map by city. The map cross-filtering has been left enabled but this limitation should be kept in mind. This is a known issue with the public dataset and not something that can be cleanly fixed without custom city-state validation logic.

---

### Page 4 - Market Intelligence
![Market Intelligence](screenshots/Market%20Intelligence.png)

This is the most analytically advanced page. It answers: which states are the most strategically valuable markets, and how is affordability distributed across the country?

**Key visuals:**
- Market Heat Quadrant -- scatter chart plotting states by Total Listings (X) vs Avg Price (Y) with quadrant reference lines
- Total Listings by Affordability Band
- Market Competitiveness Score (Top 10 states)
- KPI cards for Avg Price per Sq Ft, Total Listings, Average Price, Median Price

**Quadrant guide:**
- Top Left -- Exclusive Markets: high price, low volume (e.g. Hawaii, DC, Utah)
- Top Right -- Premium Active Markets: high price, high volume (e.g. California, New York)
- Bottom Left -- Emerging Markets: low price, low volume (e.g. Iowa, Alabama)
- Bottom Right -- Mass Market States: low price, high volume (e.g. Florida, Texas)

**What the data shows:**
- California scores 84/100 on the Market Competitiveness Score, the highest of any state
- 46% of all listings fall in the Affordable band (under $300K)
- Luxury listings (above $750K) slightly outnumber Premium listings ($500K-$750K), suggesting a polarized market

---

## Advanced Features

### Tooltip Pages

When you hover over a state on the map or a bar in the Total Listings by State chart, a small popup chart appears giving you more context about that specific state.

**Tooltip 1 - State Cities** -- shows the top 5 cities by avg price within the hovered state:
- Assigned to the filled map on Page 3
- Uses the `Avg Price (Major Cities)` measure to exclude cities with fewer than 100 listings

**Tooltip 2 - Affordability Breakdown** -- shows the distribution of listings by affordability band for the hovered state:
- Assigned to the Total Listings by State bar chart on Page 1
- Displayed as a donut chart with percentage labels

---

### Dynamic Chart Titles

Chart titles on Pages 3 and 4 update automatically when a status filter is applied. For example, selecting "For Sale" changes "Total Listings by City" to "Total Listings by City — For Sale". This is achieved using DAX measures connected to the title fx field.

### Conditional Formatting

The Average Price KPI card changes color based on the current filtered value:
- Green -- below $400K
- Orange -- between $400K and $700K
- Red -- above $700K

Try filtering to Hawaii in the state slicer and watch the card turn red at $1,036,002.

### Market Competitiveness Score

This is a composite DAX measure that ranks states by combining three normalized metrics:
- Total Listings (volume)
- Avg Price per Sq Ft (demand intensity)
- Avg Price (market value)

Each metric is normalized to 0-1 against the maximum value across all states, then averaged and multiplied by 100. This produces a single score where 100 represents the theoretically perfect market across all three dimensions.

---

## Step-by-Step Guide

### Step 1 - Download the Dataset
1. Go to the [Kaggle USA Real Estate Dataset](https://www.kaggle.com/datasets/ahmedshahriarsakib/usa-real-estate-dataset)
2. Create a free Kaggle account if you do not have one
3. Download and extract the CSV file

> **Note:** The file is over 100MB. Do not commit it to GitHub -- add it to your `.gitignore` file.

---

### Step 2 - Load and Clean Data in Power Query
1. Open Power BI Desktop
2. Home tab -> Get Data -> Text/CSV -> select your file
3. Click **Transform Data** (not Load)
4. Rename the table to `USA Real Estate Dataset`
5. Delete these 2 columns -- they are free-text identifiers with no analytical value:
   - `brokered_by` (broker name or ID -- too granular to group)
   - `street` (unique per property -- not usable for analysis)
6. Delete `prev_sold_date` -- over 99% of values are null, making it unusable

7. Remove rows where all four of these columns are null simultaneously -- these are empty records with no property details:
   - Add Column tab -> Custom Column -> name it `AllNullFlag`
   ```
   if [bed] = null and [bath] = null and [house_size] = null and [acre_lot] = null then 1 else 0
   ```
   - Filter `AllNullFlag` to exclude 1s
   - Delete the `AllNullFlag` column

8. Filter `price` to remove zeros and extreme outliers:
   - Click dropdown on `price` -> Number Filters -> Between
   - Set: greater than or equal to 1 and less than or equal to 10,000,000
   - Prices of $0 are bad data. The maximum of $2.1B is a 32-bit integer overflow error, not a real price. $10M was chosen as a reasonable cap for residential real estate.

9. Clean the `bath` column -- cap extreme values:
   - Add Column tab -> Conditional Column -> name it `Bath Clean`
   - If `bath` equals null then null
   - Else if `bath` is greater than or equal to 10 then null
   - Else `bath`
   - Delete original `bath` column and rename `Bath Clean` to `bath`

10. Clean the `house_size` column -- cap extreme values:
    - Same approach as bath -- add conditional column `House Size Clean`
    - Cap at 20,000 sq ft (covers large luxury homes without retaining obvious data errors)
    - Delete original and rename

11. Clean the `acre_lot` column -- cap extreme values:
    - Same approach -- cap at 100 acres
    - Delete original and rename

> **Why keep remaining nulls?** Rows with nulls in `bed`, `bath`, or `house_size` still have valid price, state, and city data. They are useful for location and price analysis. Power BI and DAX exclude nulls from aggregations automatically, so there is no need to drop or fill them.

12. Add a custom column called `Price Band`:
```
if [price] < 100000 then "Under 100K"
else if [price] < 200000 then "100K to 200K"
else if [price] < 500000 then "200K to 500K"
else if [price] < 1000000 then "500K to 1M"
else if [price] < 5000000 then "1M to 5M"
else "5M+"
```

13. Add a custom column called `Price Band Sort`:
```
if [price] < 100000 then 1
else if [price] < 200000 then 2
else if [price] < 500000 then 3
else if [price] < 1000000 then 4
else if [price] < 5000000 then 5
else 6
```

14. Add a custom column called `Bed Group`:
```
if [bed] = null then "Not Reported"
else if [bed] <= 1 then "1 or fewer"
else if [bed] = 2 then "2"
else if [bed] = 3 then "3"
else if [bed] = 4 then "4"
else "5+"
```

15. Add a custom column called `Bed Group Sort`:
```
if [bed] = null then 99
else if [bed] <= 1 then 1
else if [bed] = 2 then 2
else if [bed] = 3 then 3
else if [bed] = 4 then 4
else 5
```

16. Add a custom column called `Affordability Band`:
```
if [price] < 300000 then "Affordable"
else if [price] < 500000 then "Moderate"
else if [price] < 750000 then "Premium"
else "Luxury"
```

17. Add a custom column called `Affordability Band Sort`:
```
if [price] < 300000 then 1
else if [price] < 500000 then 2
else if [price] < 750000 then 3
else 4
```

18. Clean the `status` column -- replace underscores with readable labels:
    - Transform tab -> Replace Values
    - Replace `for_sale` with `For Sale`
    - Replace `ready_to_build` with `Ready to Build`
    - Replace `sold` with `Sold`

19. Click **Close and Apply**

> **Why do we need sort columns?** Power BI sorts text alphabetically by default. Without a sort column, "Under 100K" would appear last in your chart. The numeric sort column tells Power BI the correct order.

---

### Step 3 - Set Sort by Column
In Data view, tell Power BI how to sort your custom columns:
1. Click `Price Band` -> Column Tools tab -> Sort by Column -> select `Price Band Sort`
2. Click `Bed Group` -> Column Tools tab -> Sort by Column -> select `Bed Group Sort`
3. Click `Affordability Band` -> Column Tools tab -> Sort by Column -> select `Affordability Band Sort`

---

### Step 4 - Create a Measures Table

1. Home tab -> Enter Data
2. Rename the column to `Measures`
3. Rename the table to `_Measures`
4. Click Load
5. In Data view, delete the dummy row that was auto-created

---

### Step 5 - Create DAX Measures

Always click on the `_Measures` table first before creating a new measure.

**Foundation measures -- build these first:**
```dax
Total Listings = COUNTROWS('USA Real Estate Dataset')

Avg Price = AVERAGE('USA Real Estate Dataset'[price])

Median Price = MEDIAN('USA Real Estate Dataset'[price])

Avg House Size = ROUND(AVERAGE('USA Real Estate Dataset'[House Size]), 0)

Avg Beds = AVERAGE('USA Real Estate Dataset'[bed])

Avg Baths = AVERAGE('USA Real Estate Dataset'[bath])

Avg Acre Lot = AVERAGE('USA Real Estate Dataset'[acre_lot])
```

**Status measures:**
```dax
For Sale Listings = CALCULATE([Total Listings], 'USA Real Estate Dataset'[status] = "For Sale")

Sold Listings = CALCULATE([Total Listings], 'USA Real Estate Dataset'[status] = "Sold")

For Sale % = DIVIDE([For Sale Listings], [Total Listings], 0)

Sold % = DIVIDE([Sold Listings], [Total Listings], 0)
```

> **Important:** If you rename status values in Power Query (e.g. from `for_sale` to `For Sale`), you must update your DAX measures to use the new text values. Otherwise the measure will return blank.

**Derived metrics:**
```dax
Avg Price per SqFt = DIVIDE([Avg Price], [Avg House Size], 0)
```

**Dynamic title measures:**
```dax
Selected Status = 
IF(
    ISFILTERED('USA Real Estate Dataset'[status]),
    "— " & SELECTEDVALUE('USA Real Estate Dataset'[status], "All Statuses"),
    ""
)

Title Total Listings City = "Total Listings by City " & [Selected Status]

Title Avg Price City = "Top 7 Cities by Avg Price " & [Selected Status]

Title Avg Price State = "Avg Price by State " & [Selected Status]

Title Avg PriceSqFt State = "Avg Price per SqFt by State " & [Selected Status]
```

**Advanced composite measure:**
```dax
Avg Listings per State = AVERAGEX(VALUES('USA Real Estate Dataset'[state]), [Total Listings])

Market Competitiveness Score = 
VAR MaxListings = MAXX(ALL('USA Real Estate Dataset'[state]), [Total Listings])
VAR MaxPriceSqFt = MAXX(ALL('USA Real Estate Dataset'[state]), [Avg Price per SqFt])
VAR MaxAvgPrice = MAXX(ALL('USA Real Estate Dataset'[state]), [Avg Price])

VAR ListingsScore = DIVIDE([Total Listings], MaxListings, 0)
VAR PriceSqFtScore = DIVIDE([Avg Price per SqFt], MaxPriceSqFt, 0)
VAR AvgPriceScore = DIVIDE([Avg Price], MaxAvgPrice, 0)

RETURN
ROUND((ListingsScore + PriceSqFtScore + AvgPriceScore) / 3 * 100, 1)
```

> **Understanding the Market Competitiveness Score:** This measure normalizes each of the three metrics (listings volume, price per sq ft, avg price) to a 0-1 scale by dividing by the maximum value across all states. It then averages the three scores and multiplies by 100. A state that leads in all three metrics would score 100. This is a custom composite index -- you can adjust the weights or add more metrics to make it more sophisticated.

---

### Step 6 - Apply a Theme
View tab -> Themes -> select **Executive**

---

### Step 7 - Build Page 1 (Market Overview)

**Rename the page tab:** Right-click Page 1 -> Rename -> "Market Overview"

**Header:** Insert tab -> Text Box -> type your title -> set background to dark green

**KPI Cards:** Add 5 card visuals:
- Total Listings
- For Sale Listings
- Sold Listings
- Average Price (apply conditional formatting -- see Step 11)
- Median Price

**Charts:**
- Horizontal Bar Chart: State (Y-axis) vs Avg Price (X-axis) -- Top 7 by Avg Price
- Horizontal Bar Chart: State (Y-axis) vs Total Listings (X-axis) -- Top 7 by Total Listings
- Donut Chart: Status (Legend) vs Total Listings (Values)

**Slicers:** Tile slicer for Status, dropdown slicer for State

**Key Insights text box:** Add a text box summarizing 4-5 key findings from the data

---

### Step 8 - Build Page 2 (Property Analysis)

**Rename the page:** Right-click -> Rename -> "Property Analysis"

**KPI Cards:** Avg House Size, Avg Beds, Avg Baths

**Charts:**
- Clustered Column Chart: Bed Group (X-axis) vs Total Listings (Y-axis)
- Clustered Column Chart: Bed Group (X-axis) vs Avg Price (Y-axis)
- Horizontal Bar Chart: Price Band (Y-axis) vs Total Listings (X-axis)

**Slicers:** Status (tile), Bed Group (dropdown), State (dropdown)

---

### Step 9 - Build Page 3 (Location Intelligence)

**Rename the page:** Right-click -> Rename -> "Location Intelligence"

**Visuals:**
- Filled Map: State (Location) vs Avg Price (Color saturation)
- Horizontal Bar Chart: State (Y-axis) vs Avg Price per SqFt (X-axis) -- Top 7
- Clustered Column Chart: City (X-axis) vs Total Listings (Y-axis) -- Top 7
- Clustered Column Chart: City (X-axis) vs Avg Price (Y-axis) -- use `Avg Price (Major Cities)` measure with Top 7 filter

**Dynamic titles:** Connect each chart title to its corresponding title measure using the fx button in Format pane -> General -> Title

**Slicers:** Status (tile), State (dropdown)

> **Avg Price by City filter:** To avoid small towns with 1-2 listings skewing the top cities chart, create a measure that returns BLANK() for cities with fewer than 100 listings, then use that measure on the Y-axis with a Top N filter.
```dax
Avg Price (Major Cities) = 
IF([Total Listings] >= 100, [Avg Price], BLANK())
```

---

### Step 10 - Build Page 4 (Market Intelligence)

**Rename the page:** Right-click -> Rename -> "Market Intelligence"

**Visuals:**
- Scatter Chart: State (Values), Total Listings (X-axis), Avg Price (Y-axis) -- add data labels and quadrant reference lines
- Horizontal Bar Chart: State (Y-axis) vs Market Competitiveness Score (X-axis) -- Top 10
- Clustered Column Chart: Affordability Band (X-axis) vs Total Listings (Y-axis)
- KPI Cards: Avg Price per SqFt, Total Listings, Average Price, Median Price

**Quadrant reference lines:**
- Analytics pane -> X-axis constant line: set to your `Avg Listings per State` measure value (~39,430)
- Analytics pane -> Y-axis constant line: set to your overall `Avg Price` value (~$489,000)

**Quadrant legend text box:** Add a text box explaining the four quadrants

**Slicers:** Status (tile), State (dropdown)

---

### Step 11 - Conditional Formatting on Average Price Card

1. Click the Average Price card
2. Format pane -> General -> Effects -> Background -> click the **fx** button
3. Change Format style to **Rules**
4. Set field to `Avg Price`
5. Add three rules:
   - If value >= 0 and < 400000 -> Green (`#1E8449`)
   - If value >= 400000 and < 700000 -> Orange (`#D4820A`)
   - If value >= 700000 and <= Max -> Red (`#C0392B`)
6. Click OK

Test by filtering to Hawaii -- the card should turn red at $1,036,002.

---

### Step 12 - Create Tooltip Pages

Tooltips show a mini chart when users hover over a visual. This is an advanced feature that makes your report feel much more interactive.

**Tooltip 1 - State Cities:**
1. Add a new page and rename it `Tooltip - State Cities`
2. Format pane -> Canvas settings -> Type -> change to **Tooltip**
3. Format pane -> Page information -> Allow use as tooltip -> turn **On**
4. Add a horizontal bar chart:
   - Y-axis: `city`
   - X-axis: `Avg Price (Major Cities)` measure
   - Top N filter: Top 5 by `Avg Price (Major Cities)`
5. Update the chart title to "Top Cities by Avg Price"
6. Go to Page 3 -> click the map visual -> Format pane -> General -> Tooltips -> Type -> Report page -> select `Tooltip - State Cities`

**Tooltip 2 - Affordability Breakdown:**
1. Add a new page and rename it `Tooltip - Affordability`
2. Format pane -> Canvas settings -> Type -> change to **Tooltip**
3. Format pane -> Page information -> Allow use as tooltip -> turn **On**
4. Add a donut chart:
   - Legend: `Affordability Band`
   - Values: `Total Listings`
5. Title: "Affordability Breakdown"
6. Go to Page 1 -> click the Total Listings by State bar chart -> Format pane -> General -> Tooltips -> Type -> Report page -> select `Tooltip - Affordability`

> **Why use `Avg Price (Major Cities)` instead of `Avg Price` in the tooltip?** Using plain `Avg Price` with a Top N filter conflicts with a separate Total Listings filter. The `Avg Price (Major Cities)` measure returns BLANK() for cities under 100 listings, which naturally excludes small towns without needing a second filter.

---

### Step 13 - Connect Dynamic Titles



For each chart on Pages 3 and 4:
1. Click the chart
2. Format pane -> General -> Title -> click the **fx** button
3. Change Format style to **Field value**
4. Select the corresponding title measure from `_Measures`
5. Click OK

Test by clicking "For Sale" in the status slicer -- titles should update automatically.

---

## Key Insights Summary

| Finding | Value | Implication |
|---------|-------|-------------|
| Total listings | 2,207,986 | Large, active dataset covering the full US market |
| For Sale vs Sold | 62% vs 37% | Active inventory is nearly double sold listings |
| Most expensive state | Hawaii ($1,036,002 avg) | 2x the national average price |
| Highest price per sq ft | Hawaii ($687/sqft) | Most expensive space in the country |
| Most active city | Houston (23,819 listings) | Followed by Chicago and New York City |
| Most common property | 3-bedroom (752,991) | Represents 34% of all listings |
| Dominant price band | $200K to $500K (904,851) | 41% of all listings in this range |
| Top competitiveness score | California (84/100) | Combines high volume, high price, high price/sqft |

---

## Data Quality Notes

- **Price outliers:** Prices of $0 and values up to $2.1B (32-bit integer overflow) were removed. Price was capped at $10M.
- **Null values:** 28-32% of bed, bath, and house_size records are null. These were kept as-is since they still contain valid price and location data.
- **City-state mismatches:** Some city records are assigned to incorrect states in the source data (e.g. Houston records appearing under Alaska). This causes inconsistent map behavior when cross-filtering by city. This is a known limitation of the public dataset.
- **Date field:** `prev_sold_date` was dropped due to 99%+ null values.
- **Dataset date:** Data reflects the US real estate market as of early 2024.

---

## Skills Demonstrated

| Skill | Details |
|-------|---------|
| Power Query | Large dataset cleaning, null handling, outlier capping, value replacement, custom columns, sort columns |
| DAX | 20+ measures including CALCULATE, DIVIDE, MEDIAN, AVERAGEX, MAXX, VAR, composite scoring |
| Data modeling | Dedicated measures table, proper column typing, sort by column |
| Visualization | 4-page report, 20+ visuals, slicers, KPI cards, filled map, scatter chart |
| Advanced features | Dynamic titles, conditional formatting, quadrant analysis, market scoring, tooltip pages |
| Analytical thinking | Custom groupings, outlier investigation, data quality documentation, composite index design |

---

## About the Author

**Alireza Samea**
- UBC Sauder Business Intelligence with Power BI Certificate
- Professor and Data Analytics Instructor
- GitHub: [alirezasamea](https://github.com/alirezasamea)
- LinkedIn: [alirezasamea](https://www.linkedin.com/in/alirezasamea/)
- Email: alireza.samea@queensu.ca

---

*Dataset: USA Real Estate Dataset -- publicly available on Kaggle, sourced from Realtor.com listings. Data as of early 2024.*
