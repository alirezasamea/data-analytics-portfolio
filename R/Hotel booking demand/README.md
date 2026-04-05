# Hotel Booking Demand Analysis
### R | Exploratory Data Analysis | Hypothesis Testing | Logistic Regression

## Project Overview

This project analyzes 119,390 hotel booking records to uncover what drives cancellations, 
how pricing varies by season and hotel type, and what factors predict whether a booking 
will be cancelled. The analysis is written in R Markdown and covers the full data science 
workflow from raw data to business recommendations.

**Central Business Question:** What factors influence hotel booking cancellations, pricing, 
and guest behavior and what can hotel managers do about it?

**Dataset:** [Hotel Booking Demand](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand) 
by Jesse Mostipak on Kaggle | 119,390 rows | 32 columns

## Key Findings

| Finding | Detail |
|---------|--------|
| Overall cancellation rate | 27.5% of all bookings were cancelled |
| Strongest cancellation predictor | Non-refundable deposits are 40x more likely to cancel |
| Lead time effect | Longer lead times significantly increase cancellation risk |
| Hotel type difference | Resort hotels have 33% lower cancellation odds than city hotels |
| Customer type risk | Transient customers are nearly 3x more likely to cancel |
| Seasonal pricing | ADR peaks in July and August, drops in January and February |
| Family stays | Family bookings have significantly longer stays than non-family bookings |

## Analysis Structure

1. **Data Loading and Exploration** - import libraries, load data, inspect structure
2. **Data Cleaning and Preparation** - missing values, data types, duplicate removal, new variables
3. **Exploratory Data Analysis** - booking patterns, seasonal trends, cancellation rates, pricing
4. **Hypothesis Testing** - 5 statistical tests using Welch t-tests
5. **Cancellation Analysis** - logistic regression model with odds ratio interpretation
6. **Key Insights and Recommendations** - actionable findings for hotel managers

## Technical Skills Demonstrated

| Skill | Detail |
|-------|--------|
| Data cleaning | Missing value imputation, duplicate removal, type conversion, outlier handling |
| Feature engineering | stay_length, total_guests, arrival_date, family segment |
| Visualization | 9 ggplot2 charts with consistent styling and axis management |
| Hypothesis testing | Two-sample Welch t-tests, one-sample t-test, one-tailed and two-tailed tests |
| Logistic regression | glm() model, odds ratio interpretation, McFadden pseudo R² |
| R Markdown | Reproducible report with inline code, narrative, and embedded visuals |

## Tools and Packages

- **R** and **RStudio**
- **tidyverse** (ggplot2, dplyr, readr)
- **knitr**

## How to Run

1. Clone this repository
2. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/jessemostipak/hotel-booking-demand) 
   and place it in the `Dataset/` folder
3. Open `Hotel Booking Demand Analysis.Rmd` in RStudio
4. Click **Knit** to reproduce the full analysis

Or view the pre-rendered analysis directly: [Hotel Booking Demand Analysis](Hotel-Booking-Demand-Analysis.md)

## About the Author

**Alireza Samea**
- UBC Sauder Business Intelligence with Power BI Certificate
- Professor and Data Analytics Instructor
- GitHub: [alirezasamea](https://github.com/alirezasamea)
- LinkedIn: [alirezasamea](https://www.linkedin.com/in/alirezasamea/)
- Email: alireza.samea@queensu.ca
