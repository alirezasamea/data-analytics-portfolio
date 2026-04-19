# Superstore Sales Analysis
A Beginner Python Project

---

## About This Project

This is a beginner-level Python project that walks through a complete exploratory data analysis (EDA) workflow using a real-world retail dataset. If you follow along from start to finish, you will end up with a clean, well-documented notebook that covers data loading, cleaning, exploration, visualization, and business recommendations.

The central business question we are trying to answer is: **Which products, regions, and customer segments drive the most sales and profit -- and where is the business losing money?**

This is one of the most common analytical tasks in retail and e-commerce, making it a practical first project for anyone learning data analysis with Python.

**Dataset:** [Sample Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final), publicly available on Kaggle. 9,994 orders, 21 columns, covering 2014 to 2017 across the United States.

---

## What You Will Learn

After finishing this project you will be able to:

- Load a CSV file into a pandas DataFrame
- Explore dataset structure using shape, dtypes, and head()
- Check for and handle missing values and duplicates
- Convert columns to the correct data types (e.g. string to datetime)
- Group and aggregate data using groupby()
- Create visualizations using matplotlib and seaborn
- Extract business insights from raw data and communicate them clearly

---

## Tools Required

- Python 3 with the following libraries: pandas, numpy, matplotlib, seaborn
- Jupyter Notebook or any Python environment (e.g. VS Code, Google Colab)

To install the required libraries, run:

```
pip install pandas numpy matplotlib seaborn
```

---

## Project Structure

```
Superstore-Sales-Analysis/
├── Superstore Sales Dataset analysis.ipynb    
├── README.md                                  
└── data/
    └── Sample - Superstore.csv                
```

---

## Analysis Sections

### Section 1 - Data Loading and Exploration

Load the dataset and inspect its basic structure: shape, column names, and the first few rows. This step gives you a clear picture of what data is available before any analysis begins.

**Key facts about the dataset:**
- 9,994 rows and 21 columns
- Covers orders from January 2014 to December 2017
- Includes order details, customer info, product categories, sales, discount, and profit

---

### Section 2 - Data Cleaning and Preparation

Check data quality before drawing any conclusions.

**Steps covered:**
- Check data types for each column
- Identify missing values (none found in this dataset)
- Check for duplicate rows
- Convert Order Date and Ship Date from string to datetime format
- Review statistical summary of numerical columns

---

### Section 3 - Exploratory Data Analysis (EDA)

Analyze the data across five dimensions to uncover patterns and answer the business question.

**3.1 Sales Analysis Over Time**
- Total Sales: $2,297,200.86
- Total Profit: $286,397.02
- Total Orders: 5,009
- Average Order Value: $458.61
- Sales grew year over year from 2014 to 2017

**3.2 Category and Sub-Category Performance**
- Technology leads in sales ($836K), followed by Furniture ($742K) and Office Supplies ($719K)
- Phones, Chairs, and Storage are the top three sub-categories by sales

**3.3 Regional Analysis**
- West region has the highest sales ($725K) and profit ($108K)
- Central region ranks third in sales but fourth in profit -- suggesting margin issues

**3.4 Customer Segment Analysis**
- Consumer segment generates the most sales ($1.16M) and profit ($134K)
- All three segments (Consumer, Corporate, Home Office) are profitable

**3.5 Profitability Analysis**
- Technology is the most profitable category ($145K), followed by Office Supplies ($122K)
- Furniture generates $742K in sales but only $18K in profit -- a 2.5% margin
- The Canon imageCLASS 2200 Copier is the single most profitable product ($25K)

---

### Section 4 - Data Visualization

Six charts that communicate the key findings visually.

- **Sales Trend Over Time** -- monthly line chart showing growth from 2014 to 2017
- **Sales by Category** -- bar chart comparing Technology, Furniture, and Office Supplies
- **Top 10 Sub-Categories** -- horizontal bar chart ranked by total sales
- **Regional Performance** -- bar chart comparing the four US regions
- **Customer Segment Analysis** -- bar chart showing sales by Consumer, Corporate, Home Office
- **Profit vs Sales Scatter Plot** -- shows the relationship between sales volume and profit, with visible negative-profit outliers

---

### Section 5 - Key Insights and Recommendations

**1. Furniture profitability is a serious problem**
Furniture has $742K in sales but only $18K in profit (2.5% margin), compared to Technology at 17%. The most likely cause is excessive discounting. A discount audit on Furniture sub-categories -- especially Tables -- is the first step.

**2. The West region is the strongest market**
West leads in both sales and profit. Understanding what makes it successful (product mix, customer base, pricing) and applying those lessons to the Central and South regions could improve overall performance.

**3. Technology products drive disproportionate profit**
Despite not being the highest in sales volume, Technology delivers the highest profit. Investing in expanding Technology offerings, especially high-margin products like copiers and accessories, would improve overall margins.

**4. Discounting behavior needs review**
Several transactions show negative profit despite generating sales -- a clear sign that some discounts are too aggressive. Setting minimum margin thresholds before discounts are applied would protect profitability.

---

## Skills Demonstrated

| Skill | Details |
|-------|---------|
| Data loading | Reading CSV files with pandas, handling encoding |
| Data cleaning | Type conversion, missing value checks, duplicate detection |
| Exploratory analysis | groupby(), agg(), sort_values(), nunique() |
| Time series | Datetime conversion, period extraction, monthly aggregation |
| Visualization | Line charts, bar charts, scatter plots with matplotlib and seaborn |
| Business thinking | Connecting data findings to actionable recommendations |

---

## About the Author

**Alireza Samea**
- Assistant Professor, University Canada West
- Lecturer, Northeastern University Vancouver
- GitHub: [alirezasamea](https://github.com/alirezasamea)
- LinkedIn: [alirezasamea](https://www.linkedin.com/in/alirezasamea/)

---

*Dataset: Sample Superstore -- a fictional retail dataset widely used for data analysis practice, publicly available on Kaggle.*
