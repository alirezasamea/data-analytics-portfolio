# HR Workforce Analytics Dashboard
A Beginner-Friendly Power BI Project

![Overview](screenshots/Overview.png)

---

## About This Project

This is a guided Power BI project I designed for students who are working on their first business intelligence dashboard. If you follow this guide from start to finish, you will end up with a professional, interactive HR analytics report that you can add to your own portfolio.

The central business question we are trying to answer is: **What drives employee attrition, and where should HR intervene?**

This is one of the most common and valuable use cases in real HR departments, so it is a great first project to work on.

**Dataset:** [IBM HR Analytics Employee Attrition Dataset](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset), publicly available on Kaggle, 1,470 employee records, 35 columns.

---

## What You Will Learn

After finishing this project you will be able to:

- Load and clean data using Power Query
- Create calculated columns and custom groupings
- Build DAX measures organized in a dedicated measures table
- Design a multi-page interactive dashboard
- Use conditional formatting to create live risk indicators
- Build tooltip pages for contextual drill-down
- Apply professional theming and layout principles

---

## Tools Required

- Microsoft Power BI Desktop (free), [Download here](https://powerbi.microsoft.com/desktop/)
- Kaggle account (free), to download the dataset

---

## Project Structure

```
HR-Workforce-Analytics/
├── HR_data.pbix              
├── README.md                 
└── screenshots/
    ├── Overview.png
    ├── Attrition Analysis.png
    ├── Retention Risk.png
    ├── Tooltip - Department.png
    └── Tooltip - Age.png
```

---

## Dashboard Pages

### Page 1 - Overview
![Overview](screenshots/Overview.png)

This is the first page a user lands on. It gives a high-level snapshot of the workforce with 5 KPI cards, headcount by department, and attrition rate by age group. Slicers let the user filter everything by Gender, Department, and Job Role.

**Key numbers on this page:**
- Total Employees: 1,470
- Active Employees: 1,233
- Attrition Rate: 16.12%
- Avg Tenure: 7.01 years
- Avg Monthly Income: $6,503

---

### Page 2 - Attrition Analysis
![Attrition Analysis](screenshots/Attrition%20Analysis.png)

This page digs into the attrition drivers across multiple dimensions. The main question here is: who is leaving and why?

**What the data shows:**
- Sales Representatives have the highest attrition at 39.76%
- Single employees leave at more than double the rate of divorced employees (25.53% vs 10.09%)
- Male employees leave at a slightly higher rate than female (17.01% vs 14.80%)
- The Sales department has the highest overall attrition at 20.63%

---

### Page 3 - Retention Risk
![Retention Risk](screenshots/Retention%20Risk.png)

This page focuses on what HR can actually do about the problem. It includes a written recommendations panel that summarizes the key findings and suggests concrete actions.

**What the data shows:**
- Employees with no stock options leave at nearly 3x the rate of those with options
- Employees earning under $3K monthly leave at 29%
- 36% of employees leave within their first year
- 97 current employees are high risk right now (low satisfaction combined with overtime)

---

## Advanced Features

### Tooltip Pages

When you hover over a department bar or an age group bar, a small popup chart appears giving you more context about that specific segment.

**Department Tooltip** -- shows attrition rate by job role within the selected department:
<img src="screenshots/Tooltip%20-%20Department.png" width="400"/>

**Age Group Tooltip** -- shows average monthly income for the selected age group:
<img src="screenshots/Tooltip%20-%20Age.png" width="400"/>

### Conditional Formatting

The Attrition Rate KPI card changes color based on the current filtered value:
- Green -- below 15% (healthy)
- Orange -- between 15% and 20% (warning)
- Red -- above 20% (critical)

Try filtering to the Sales department and watch the card turn red at 20.63%.

---

## Step-by-Step Guide

### Step 1 - Download the Dataset
1. Go to the [Kaggle IBM HR Dataset](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)
2. Create a free Kaggle account if you do not have one
3. Download and extract the CSV file

---

### Step 2 - Load and Clean Data in Power Query
1. Open Power BI Desktop
2. Home tab -> Get Data -> Text/CSV -> select your file
3. Click **Transform Data** (not Load)
4. In Power Query, delete these 3 columns -- they have the exact same value for every single row and add no analytical value:
   - `EmployeeCount` (always = 1)
   - `Over18` (always = Y)
   - `StandardHours` (always = 80)
5. Rename the table to `HR_Data`
6. Add a conditional column called `AttritionFlag`:
   - Add Column tab -> Conditional Column
   - If `Attrition` equals "Yes" then output 1, otherwise output 0
   - This gives you a numeric column you can SUM in DAX

7. Add a custom column called `Age Group`:
```
if [Age] < 25 then "Under 25"
else if [Age] <= 34 then "25 to 34"
else if [Age] <= 44 then "35 to 44"
else if [Age] <= 54 then "45 to 54"
else "55 and above"
```

8. Add a custom column called `Age Group Sort`:
```
if [Age] < 25 then 1
else if [Age] <= 34 then 2
else if [Age] <= 44 then 3
else if [Age] <= 54 then 4
else 5
```

9. Add a custom column called `Income Band`:
```
if [MonthlyIncome] < 3000 then "Under 3K"
else if [MonthlyIncome] < 6000 then "3K to 6K"
else if [MonthlyIncome] < 9000 then "6K to 9K"
else if [MonthlyIncome] < 12000 then "9K to 12K"
else "Above 12K"
```

10. Add a custom column called `Income Band Sort`:
```
if [MonthlyIncome] < 3000 then 1
else if [MonthlyIncome] < 6000 then 2
else if [MonthlyIncome] < 9000 then 3
else if [MonthlyIncome] < 12000 then 4
else 5
```

11. Click **Close and Apply**

> **Why do we need sort columns?** Power BI sorts text alphabetically by default. Without a sort column, "Under 25" would appear last in your chart instead of first. The numeric sort column tells Power BI the correct order to display the groups.

---

### Step 3 - Set Sort by Column
In Data view, tell Power BI how to sort your custom columns:
1. Click the `Age Group` column -> Column Tools tab -> Sort by Column -> select `Age Group Sort`
2. Click the `Income Band` column -> Column Tools tab -> Sort by Column -> select `Income Band Sort`

---

### Step 4 - Create a Measures Table

Instead of storing your measures inside `HR_Data`, create a dedicated table to keep everything organized. This is standard practice in professional BI work.

1. Home tab -> Enter Data
2. Rename the column to `Measures`
3. Rename the table to `_Measures` (the underscore makes it sort to the top of your Fields pane)
4. Click Load
5. In Data view, delete the dummy row that was auto-created

> **Why a separate measures table?** As your report grows to 10, 15, 20 measures, having them all in one place makes them easy to find and maintain. Anyone who opens your file will immediately see you know how to organize a data model properly.

---

### Step 5 - Create DAX Measures

Always click on the `_Measures` table first before creating a new measure. This ensures the measure gets stored in the right place.

**Foundation measures -- build these first:**
```dax
Total Employees = COUNTROWS(HR_Data)

Total Attrition = SUM(HR_Data[AttritionFlag])

Attrition Rate = DIVIDE([Total Attrition], [Total Employees], 0)

Active Employees = [Total Employees] - [Total Attrition]

Avg Monthly Income = AVERAGE(HR_Data[MonthlyIncome])

Avg Age = AVERAGE(HR_Data[Age])

Avg Tenure = AVERAGE(HR_Data[YearsAtCompany])
```

> **Why DIVIDE instead of just using /?** If a filter makes Total Employees return zero, plain division crashes your visual with an error. DIVIDE handles this gracefully by returning 0 instead.

**Advanced measures -- build these after:**
```dax
Attrition Rate OT = 
CALCULATE([Attrition Rate], HR_Data[OverTime] = "Yes")

Attrition Rate No OT = 
CALCULATE([Attrition Rate], HR_Data[OverTime] = "No")

Avg Satisfaction = 
AVERAGEX(
    HR_Data,
    (HR_Data[JobSatisfaction] + 
     HR_Data[EnvironmentSatisfaction] + 
     HR_Data[RelationshipSatisfaction]) / 3
)

High Risk Lost = 
CALCULATE(
    [Total Attrition],
    HR_Data[JobSatisfaction] <= 2,
    HR_Data[OverTime] = "Yes"
)

High Risk Remaining = 
CALCULATE(
    [Active Employees],
    HR_Data[JobSatisfaction] <= 2,
    HR_Data[OverTime] = "Yes"
)

Retention Rate = 1 - [Attrition Rate]

Attrition Rate Label = 
FORMAT([Attrition Rate], "0.0%") & " attrition rate"
```

> **Understanding CALCULATE:** This is the most important DAX function you will learn. It takes any existing measure and re-evaluates it under a filter you specify. For example, `Attrition Rate OT` asks: "what is the attrition rate, but only looking at overtime employees?" This lets you compare segments side by side without needing extra visuals.

> **Common mistake to avoid:** If you write two filters on the same column like `HR_Data[JobSatisfaction] = 1, HR_Data[JobSatisfaction] = 2`, CALCULATE looks for employees where satisfaction equals 1 AND 2 at the same time -- which is impossible and always returns zero. Use `HR_Data[JobSatisfaction] <= 2` instead to capture both values in a single condition.

---

### Step 6 - Apply a Theme
View tab -> Themes -> select **Frontier**

This immediately gives your report a clean, professional appearance without having to style everything from scratch.

---

### Step 7 - Build Page 1 (Overview)

**Rename the page tab:** Right-click Page 1 -> Rename -> type "Overview"

**Header:** Insert tab -> Text Box -> type your title -> set background color to `#2C5F8A` and font color to white

**KPI Cards:** Add 5 card visuals using these measures:
- Total Employees
- Avg Tenure
- Active Employees
- Attrition Rate
- Avg Monthly Income

**Charts:**
- Clustered Bar Chart: Department (Y-axis) vs Active Employees (X-axis)
- Clustered Column Chart: Age Group (X-axis) vs Attrition Rate (Y-axis)

**Slicers:** Add tile slicers for Gender and Department, and a dropdown slicer for Job Role

---

### Step 8 - Build Page 2 (Attrition Analysis)

**Rename the page:** Right-click -> Rename -> "Attrition Analysis"

Copy the header from Page 1 (Ctrl+C then Ctrl+V on the new page) and update the title text.

**Add these visuals:**
- Attrition Rate card + High Risk Lost card + High Risk Remaining card at the top
- Clustered Bar Chart: Attrition Rate by Marital Status
- Clustered Bar Chart: Attrition Rate by Department
- Clustered Bar Chart: Attrition Rate by Job Role
- Clustered Bar Chart: Attrition Rate by Gender
- Slicers: Gender, Department, OverTime

---

### Step 9 - Build Page 3 (Retention Risk)

**Rename the page:** Right-click -> Rename -> "Retention Risk"

Copy the header and update the title text.

**Add these visuals:**
- Clustered Column Chart: Attrition Rate by Stock Option Level
- Clustered Column Chart: Attrition Rate by Job Satisfaction
- Column Chart: Attrition Rate by Years at Company (add a visual-level filter for YearsAtCompany <= 20 to remove misleading spikes from tiny sample sizes)
- Clustered Column Chart: Attrition Rate by Income Band
- Text Box: Key Findings and Recommendations

> **Why filter Years at Company to 20?** There is only 1 employee with 40 years at the company and they left, making the attrition rate 100% for that data point. This is statistically meaningless. Filtering to 20 years covers 94% of employees and removes the misleading spikes.

---

### Step 10 - Conditional Formatting on Attrition Rate Card

1. Click the Attrition Rate card
2. Format pane -> Callout value -> Color -> click the **fx** button
3. Change Format style to **Rules**
4. Add three rules using whole numbers (Power BI reads percentages as 0-100 in this dialog):
   - If value >= 20 and <= Max -> Red
   - If value >= 15 and < 20 -> Orange
   - If value >= Min and < 15 -> Green
5. Click OK

Test it by filtering to the Sales department -- the card should turn red since Sales attrition is 20.63%.

---

### Step 11 - Create Tooltip Pages

Tooltips show a mini chart when users hover over a visual. This is an advanced feature that makes your report feel much more interactive.

**Tooltip 1 - Department breakdown:**
1. Add a new page and rename it `Tooltip - Department`
2. Format pane -> Canvas settings -> Type -> change to **Tooltip**
3. Format pane -> Page information -> Allow use as tooltip -> turn **On**
4. Add a bar chart: Job Role (Y-axis) vs Attrition Rate (X-axis)
5. Go back to your Department charts -> Format pane -> General -> Tooltips -> Type -> Report page -> select `Tooltip - Department`

**Tooltip 2 - Age group income:**
1. Add a new page and rename it `Tooltip - Age`
2. Repeat the tooltip setup steps above
3. Add a column chart: Age Group (X-axis) vs Avg Monthly Income (Y-axis)
4. Assign it to your Age Group chart the same way

---

## Key Insights Summary

| Finding | Value | Implication |
|---------|-------|-------------|
| Overall attrition rate | 16.12% | Slightly above the typical 10-15% industry benchmark |
| Highest risk job role | Sales Representative | 39.76% attrition -- needs immediate review |
| Overtime impact | 30.5% vs 10.4% | Overtime nearly triples attrition risk |
| Stock option impact | Level 0 vs Level 1 | No options means roughly 3x higher attrition |
| Early tenure risk | Years 0 to 2 | Over 36% attrition in the first 2 years |
| High risk employees still at company | 97 | Immediate intervention opportunity |

---

## Skills Demonstrated

| Skill | Details |
|-------|---------|
| Power Query | Data cleaning, custom columns, sort columns |
| DAX | 13 measures including CALCULATE, AVERAGEX, DIVIDE, FORMAT |
| Data modeling | Dedicated measures table, proper column typing |
| Visualization | 3-page report, 15+ visuals, slicers, KPI cards |
| Advanced features | Tooltip pages, conditional formatting |
| Analytical thinking | Custom groupings, small sample filtering, insight narrative |

---

## About the Author

**Alireza Samea**
- UBC Sauder Business Intelligence with Power BI Certificate
- Professor and Data Analytics Instructor
- GitHub: [alirezasamea](https://github.com/alirezasamea)
- LinkedIn: [alirezasamea](https://www.linkedin.com/in/alirezasamea/)
- Email: alireza.samea@queensu.ca

---

*Dataset: IBM HR Analytics Employee Attrition -- fictional dataset created by IBM data scientists, publicly available on Kaggle.*
