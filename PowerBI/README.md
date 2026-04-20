# Power BI Projects

This folder contains three Power BI dashboard projects, each built around a real business question using a publicly available dataset. They are designed to be completed in order. Each one introduces new concepts that build on the previous.

---

## Recommended Order

### 1. HR Workforce Analytics (Start Here)
**Difficulty:** Beginner
**Business Question:** What drives employee attrition, and where should HR intervene?

A great first project. The dataset is small and clean (1,470 rows), the business question is clear, and the focus is on learning the fundamentals: Power Query cleaning, DAX measures, and building a multi-page report with slicers and KPI cards.

**What you will learn:**
- Loading and cleaning data in Power Query
- Creating DAX measures with CALCULATE, DIVIDE, and AVERAGEX
- Building a 3-page interactive dashboard
- Conditional formatting and tooltip pages


---

### 2. USA Real Estate Dashboard (Intermediate)
**Difficulty:** Intermediate
**Business Question:** What does the US real estate market look like, and which states and cities represent the most valuable and active markets?

A step up in scale and complexity. The dataset has 2.2M rows with real data quality issues including nulls, outliers, and bad values that require careful cleaning decisions. You will also build more advanced visuals including a filled map, a scatter chart quadrant analysis, and a composite scoring measure.

**What you will learn:**
- Cleaning a large dataset with nulls and outliers
- Dynamic chart titles using DAX measures
- Building a market quadrant analysis with reference lines
- Creating a composite index measure using VAR and MAXX
- Conditional formatting on KPI cards


---

### 3. Customer Churn Revenue Risk (Advanced)
**Difficulty:** Advanced
**Business Question:** What drives customer churn, and how can we reduce its revenue impact?

The most technically demanding project. You will build a star schema data model from a flat file, use RELATED() to pull dimension attributes into fact table calculations, implement rule-based customer segmentation with SWITCH(TRUE(), ...), and build a live what-if scenario simulator.

**What you will learn:**
- Designing a star schema with fact and dimension tables
- Using RELATED() across table relationships
- Rule-based segmentation with SWITCH(TRUE(), ...)
- Building a what-if parameter for scenario analysis
- Revenue-weighted analytical thinking


---

### 4. NYC Taxi Analytics - Power BI on Snowflake (Cloud Project)
**Difficulty:** Advanced | Cloud (Snowflake)
**Business Question:** What patterns drive NYC taxi demand, revenue, and rider behavior across time, location, and trip type?

The most architecturally advanced project in this folder. Rather than loading a CSV file, Power BI connects directly to a Snowflake cloud data warehouse using DirectQuery, sitting on top of a star schema loaded with 53.6 million real taxi trips. This project is Phase 3 of a three-part series - complete Phase 1 (MySQL) and Phase 2 (Snowflake) first.

**What you will learn:**
- Connecting Power BI to Snowflake using DirectQuery
- Understanding DirectQuery vs Import mode and when each is appropriate
- Building relationships manually from a star schema with an inactive relationship
- Writing DAX measures that filter across dimension and fact tables
- Understanding which DAX patterns are restricted in DirectQuery mode
- Designing a multi-page dashboard with left panel navigation

**Prerequisites:** NYC Taxi SQL Analytics (Phase 1) and NYC Taxi Analytics - Snowflake (Phase 2)

---

More projects will be added to this folder as the portfolio grows.

---


