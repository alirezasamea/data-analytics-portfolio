# Data Analytics Portfolio
**Alireza Samea**

This repository showcases my data analytics projects across Power BI, Python, and R.
Each project follows a full analytical workflow from raw data to business recommendations.

## About Me

I am an Assistant Professor at University Canada West and a Lecturer at Northeastern
University Vancouver. Beyond my academic work, I build these projects as practical 
learning resources for my students. Each project is designed to be reproducible, 
well-documented, and beginner-friendly so students can follow along, practice, and 
adapt the work for their own portfolios.

- GitHub: [alirezasamea](https://github.com/alirezasamea)
- LinkedIn: [alirezasamea](https://www.linkedin.com/in/alirezasamea/)
- Email: alireza.samea@queensu.ca

## Tools and Skills

- **Power BI** - DAX, Power Query, data modeling, interactive dashboards
- **Tableau** - parameters, LOD expressions, dashboard actions, choropleth maps, multi-source workbooks
- **R** - tidyverse, ggplot2, hypothesis testing, logistic regression, R Markdown
- **Python** - pandas, numpy, matplotlib, seaborn, scikit-learn, exploratory data analysis, classification models, preprocessing pipelines
- **SQL / Snowflake** - star schema design, ETL pipelines, window functions, CTEs, columnar data warehousing

## Projects

### Power BI

| Project | Description | Level |
|---------|-------------|-------|
| [HR Workforce Analytics](PowerBI/HR%20Workforce%20Analytics) | Attrition analysis across 1,470 employee records. KPI cards, conditional formatting, tooltip pages. | Beginner |
| [USA Real Estate Dashboard](PowerBI/USA%20Real%20Estate%20Dataset) | Market analysis across US property listings. Dynamic titles, market quadrant analysis, Market Competitiveness Score. | Intermediate |
| [Customer Churn Revenue Risk](PowerBI/Customer%20Churn%20Revenue%20Risk) | Churn prediction dashboard with risk segmentation and retention recommendations. | Advanced |
| [NYC Taxi Analytics - Power BI on Snowflake](PowerBI/NYC%20Taxi%20Analytics) | 4-page dashboard on 53.6M real taxi trips via DirectQuery to Snowflake. Demand patterns, revenue intelligence, and geographic analysis. [Live dashboard](https://app.powerbi.com/links/sy3GHn2AaW?ctid=a8eec281-aaa3-4dae-ac9b-9a398b9215e7&pbi_source=linkShare) | Advanced - Cloud (Snowflake) |

### SQL / Snowflake

| Project | Description | Level |
|---------|-------------|-------|
| [NYC Taxi SQL Analytics](SQL/NYC-Taxi-SQL-Analytics) | Star schema database with 51.5M real taxi trips. Data pipeline, analytical queries, window functions, CTEs, and performance benchmarking. | Advanced |
| [NYC Taxi Analytics - Snowflake](SQL/NYC-Taxi-Snowflake) | Same star schema rebuilt in Snowflake. Queries that took hours in MySQL run in under 3 seconds. DirectQuery foundation for Phase 3. | Advanced - Cloud (Snowflake) |

### Python

| Project | Description | Level |
|---------|-------------|-------|
| [Superstore Sales Analysis](Python/Superstore%20Sales%20Analysis) | EDA on 9,994 sales records covering trends, profitability, regional performance, and customer segments. | Beginner |
| [Bank Marketing Classification](Python/Bank%20Marketing%20Classification) | Binary classification on 41,188 bank customer records. Five models compared including Logistic Regression, Random Forest, SVM, and Neural Network. Covers class imbalance, data leakage, and preprocessing pipelines. Project 1 of the ML series. | Intermediate |

### R

| Project | Description |
|---------|-------------|
| [Hotel Booking Demand Analysis](R/Hotel%20booking%20demand) | EDA, hypothesis testing, and logistic regression on 119,390 hotel booking records to identify cancellation drivers. |

### Tableau

| Project | Description | Level |
|---------|-------------|-------|
| [Canadian Housing Market Intelligence Dashboard](Tableau/Canadian%20Housing%20Market) | 20 years of housing price data across 59 Canadian markets. Parameters, LOD expressions, dual-axis charts, and a reproducible Python data pipeline. [Live dashboard](https://public.tableau.com/app/profile/alireza.samea7416/viz/CanadianHousingMarketIntelligenceDashboardJan2005Feb2026/NationalOverview) | Advanced |
| [Canadian Labour Market Dashboard](Tableau/Canadian%20Labour%20Market) | 26 years of labour force data across 4 Statistics Canada datasets. Provincial comparison, industry snapshot, demographics, and a cover page with live KPIs. [Live dashboard](https://public.tableau.com/views/CanadianLabourMarketDashboard/CoverPage) | Advanced |

## More Projects Coming

I aim to add new projects every term across different tools and domains. Check back 
regularly for updates.

## Repository Structure

```
data-analytics-portfolio/
├── PowerBI/
│   ├── HR Workforce Analytics/
│   ├── USA Real Estate Dataset/
│   ├── Customer Churn Revenue Risk/
│   └── NYC Taxi Analytics/
├── Python/
│   ├── Superstore Sales Analysis/
│   └── Bank Marketing Classification/
├── R/
│   └── Hotel booking demand/
├── SQL/
│   ├── NYC-Taxi-SQL-Analytics/
│   └── NYC-Taxi-Snowflake/
└── Tableau/
    ├── Canadian Housing Market/
    └── Canadian Labour Market/
```
