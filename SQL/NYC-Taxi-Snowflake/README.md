# NYC Taxi Analytics -- Snowflake Phase 2
A Cloud Data Warehouse Project

![ERD](screenshots/ERD-V2.png)

---

## About This Project

This is Phase 2 of the NYC Taxi Analytics project. In Phase 1 we built a star schema in MySQL, loaded 51.5 million real taxi trips using a Python ETL pipeline, and ran 10 analytical queries to answer business questions about New York City taxi patterns.

The problem we ran into was performance. MySQL is a row-based database designed for transactional workloads -- inserting, updating, and deleting individual rows quickly. When you run analytical queries that aggregate millions of rows, it struggles. Our trips-by-month query took 7.5 minutes. Our top routes query took 45 minutes.

In this phase we rebuild the exact same star schema in Snowflake -- a cloud-native columnar data warehouse -- load the same dataset, run the same 10 queries, and measure the difference.

**The result: queries that took minutes to hours in MySQL run in under 3 seconds in Snowflake.**

**Dataset:** [NYC TLC Trip Record Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page), publicly available from the NYC Taxi and Limousine Commission. Yellow and Green taxi trips, January 2025 to February 2026, 53.6 million trips.

**Phase 1:** If you have not completed Phase 1 yet, start there first. This project builds directly on the star schema and queries designed in Phase 1.
[NYC Taxi SQL Analytics -- MySQL Phase 1](https://github.com/alirezasamea/data-analytics-portfolio/tree/main/SQL/NYC-Taxi-SQL-Analytics)

---

## What is Snowflake?

Snowflake is a cloud-native data warehouse. Before we go further, it helps to understand three things that make Snowflake fundamentally different from MySQL.

**1. Columnar storage**

MySQL stores data row by row. When you run a query like `SELECT SUM(total_amount) FROM fact_trips`, MySQL reads every column of every row -- even columns you did not ask for -- and then extracts the values it needs.

Snowflake stores data column by column. The same query only reads the `total_amount` column. It skips everything else entirely. On a table with 20 columns and 53 million rows, that is an enormous difference.

**2. Micro-partitions**

Snowflake automatically divides every table into small chunks called micro-partitions, each storing roughly 50 to 500 MB of compressed data. Every micro-partition stores metadata about the minimum and maximum values of each column it contains.

When you run a query with a filter like `WHERE year = 2025`, Snowflake checks the metadata first and skips every micro-partition that cannot possibly contain 2025 data. This is called partition pruning, and it is why Snowflake can scan billions of rows in seconds.

**3. Separation of compute and storage**

In MySQL, your data and your query engine live together on the same machine. More data means slower queries. In Snowflake, storage and compute are completely separate. You pay for storage once, and you can spin up as much or as little compute as you need. A virtual warehouse (the compute layer) can be paused when you are not using it so you are not charged.

> **Why does this matter for your portfolio?** Most large companies run analytical workloads on columnar databases like Snowflake, BigQuery, or Redshift -- not MySQL. Understanding the difference and being able to explain it is a genuine skill that separates junior from mid-level analysts.

---

## What You Will Learn

After finishing this project you will be able to:

- Create a Snowflake account and navigate the Snowsight interface
- Understand the difference between row-based and columnar databases
- Create databases, schemas, and tables in Snowflake
- Understand what a virtual warehouse is and how Snowflake separates compute from storage
- Create an internal stage and upload files through the browser
- Use COPY INTO to load CSV and Parquet files into tables
- Understand how micro-partitions and CLUSTER BY replace traditional indexes
- Run analytical SQL queries on 53 million rows and benchmark performance
- Compare real query times between MySQL and Snowflake on the same dataset

---

## Tools Required

- Snowflake account (free 30-day trial with $400 credits), [Sign up here](https://signup.snowflake.com)
- The 28 Parquet files and taxi_zone_lookup.csv from Phase 1
- A browser -- no local software installation required

> **Snowflake for Education:** If you are a student or instructor, Snowflake offers free academic accounts at [snowflake.com/edu](https://www.snowflake.com/edu/). Apply with your university email for extended access beyond the 30-day trial.

---

## Project Structure

```
NYC-Taxi-Snowflake/
├── screenshots/
│   └── ERD-V2.png
├── setup.sql
├── nyc_taxi_snowflake_ddl.sql
├── load_data.sql
├── queries.sql
└── README.md
```

---

## Star Schema Design

The schema is identical to Phase 1 -- the same 5 dimension tables and 1 fact table. The diagram below shows the relationships between tables.

![ERD](screenshots/ERD-V2.png)

| Table | Type | Rows | Description |
|---|---|---|---|
| fact_trips | Fact | 53.6M | One row per taxi trip |
| dim_datetime | Dimension | 25.1M | Unique pickup timestamps with date parts |
| dim_taxizone | Dimension | 265 | NYC taxi zones with borough and service area |
| dim_vendor | Dimension | 4 | Taxi technology vendors |
| dim_ratecode | Dimension | 7 | Rate code types (standard, JFK, Newark, etc.) |
| dim_paymenttype | Dimension | 6 | Payment methods (credit card, cash, etc.) |

---

## DDL Differences from MySQL

The Snowflake schema mirrors the MySQL Phase 1 schema exactly in terms of tables, columns, and relationships. Only the syntax differs.

| MySQL | Snowflake | Reason |
|---|---|---|
| `TINYINT` | `SMALLINT` | Snowflake does not have TINYINT |
| `AUTO_INCREMENT` | `AUTOINCREMENT` | Different keyword, same concept |
| `DATETIME` | `TIMESTAMP_NTZ` | NTZ means No Time Zone -- cleaner for analytical data |
| Row-level indexes | `CLUSTER BY` | Snowflake uses micro-partition pruning instead of indexes |
| FK constraints enforced | FK constraints not enforced | Snowflake defines FKs for documentation only -- referential integrity is the ETL's responsibility |
| `DECIMAL(8,2)` | `FLOAT` | Both work for analytics; FLOAT is simpler in Snowflake |
| `ENGINE=InnoDB` | Not needed | Snowflake handles storage automatically |

> **Understanding CLUSTER BY:** In MySQL we added indexes on FK columns in fact_trips to speed up joins and aggregations. Even with indexes, queries on 51M rows took minutes. Snowflake does not use row-level indexes. Instead, `CLUSTER BY (datetime_id)` tells Snowflake to physically organize micro-partitions so that rows with similar datetime_id values are stored together. When a query joins or filters on datetime_id -- which almost every analytical query does -- Snowflake skips all micro-partitions that cannot contain the relevant values. This is why the same queries that took 7.5 minutes in MySQL run in under 3 seconds in Snowflake.

---

## Step-by-Step Guide

### Step 1 - Create a Snowflake Account

1. Go to [signup.snowflake.com](https://signup.snowflake.com)
2. Fill in your details
3. Choose **Standard** edition
4. Choose **AWS** as your cloud provider and **Canada Central** or **US East** as your region
5. Check your email and activate your account
6. Log into Snowsight -- the Snowflake web interface

> **Snowsight vs classic UI:** Snowflake's web interface is called Snowsight. It uses the term **Workspaces** where older documentation may say **Worksheets** -- these are the same thing. SQL files live under Projects -> Workspaces.

---

### Step 2 - Create the Database and Schema

1. Click **Projects** in the left sidebar
2. Click **Workspaces**
3. Click **+ Add new -> SQL File** to open a new SQL editor
4. Confirm **COMPUTE_WH** is selected as your warehouse in the top right
5. Name this file `setup.sql` and run:

```sql
CREATE DATABASE nyc_taxi;
USE DATABASE nyc_taxi;
CREATE SCHEMA main;
USE SCHEMA main;
```

6. Verify by running:

```sql
SHOW SCHEMAS IN DATABASE nyc_taxi;
```

You should see `MAIN` listed with `is_current = Y`. You will also notice `INFORMATION_SCHEMA` and `PUBLIC` -- these are created automatically by Snowflake.

> **What is a schema?** In MySQL you rarely think about schemas -- you just USE a database and write table names directly. In Snowflake every table lives inside a schema, which lives inside a database. The full path is always `database.schema.table`, for example `nyc_taxi.main.fact_trips`. Once you run `USE DATABASE` and `USE SCHEMA`, you can write table names directly just like MySQL.

> **What is a virtual warehouse?** In Snowflake, compute and storage are completely separate. A virtual warehouse is the compute engine that runs your queries -- think of it as a virtual machine you turn on when you need it and turn off when you do not. Your trial comes with one called `COMPUTE_WH` already created. When you are not running queries, pause it to avoid using credits.

---

### Step 3 - Create the Star Schema

1. Open a new SQL file and name it `nyc_taxi_snowflake_ddl.sql`
2. Add `USE DATABASE nyc_taxi;` and `USE SCHEMA main;` at the top
3. Run the full DDL from `nyc_taxi_snowflake_ddl.sql`
4. Verify all 6 tables were created:

```sql
SHOW TABLES IN SCHEMA nyc_taxi.main;
```

---

### Step 4 - Load the Small Lookup Tables

The three smallest dimension tables -- dim_vendor, dim_ratecode, and dim_paymenttype -- do not have source files. Their values come directly from the NYC TLC data dictionary and are loaded with INSERT statements.

Open `load_data.sql` and run Step 1 -- the three INSERT blocks. Verify:

```sql
SELECT 'dim_vendor'      AS tbl, COUNT(*) AS row_count FROM dim_vendor
UNION ALL
SELECT 'dim_ratecode',            COUNT(*) FROM dim_ratecode
UNION ALL
SELECT 'dim_paymenttype',         COUNT(*) FROM dim_paymenttype;
```

Expected: 4, 7, 6.

> **Why hardcode these values?** These lookup tables have a small, fixed number of rows defined in the TLC data dictionary -- for example, vendor_id 1 always means Creative Mobile Technologies. There is no source file to load from. Hardcoding them with INSERT is the correct and standard approach for static reference data.

---

### Step 5 - Create the Internal Stage and Upload Files

In MySQL, Python wrote data directly to the database because everything ran on your local machine. In Snowflake, the database lives in the cloud. You cannot write to it directly from your machine. Instead Snowflake uses a stage as a middle step:

```
Your local file → Upload to Stage → COPY INTO table
```

Think of a stage as a loading dock. You put your files there first, then tell Snowflake to load them into the actual table.

Run Step 2 from `load_data.sql`:

```sql
CREATE OR REPLACE STAGE stg_nyc_taxi
    COMMENT = 'Internal stage for NYC taxi CSV and Parquet files';
```

To upload files to the stage:
1. Go to **Catalog -> Database Explorer -> NYC_TAXI -> MAIN -> Stages -> STG_NYC_TAXI**
2. Click **+ Files**
3. Upload `taxi_zone_lookup.csv` first
4. Then upload all 28 Parquet files

> **Internal vs external stage:** Snowflake supports two types of stages. An internal stage stores files inside Snowflake's own managed storage -- this is what we use here. An external stage points to a cloud storage bucket like AWS S3, Google Cloud Storage, or Azure Blob Storage. For a production pipeline you would use an external stage so that new files dropped into S3 can be loaded automatically. For this project the internal stage keeps things simple and requires no cloud storage account.

---

### Step 6 - Create the Parquet File Format

Before Snowflake can read your Parquet files it needs to know the file format. Run Step 4 from `load_data.sql`:

```sql
CREATE OR REPLACE FILE FORMAT ff_parquet
    TYPE = 'PARQUET'
    SNAPPY_COMPRESSION = TRUE;
```

This named file format is referenced in both Step 7 and Step 8, which is why we define it once rather than repeating the definition inline.

---

### Step 7 - Load dim_taxizone

Run Step 3 from `load_data.sql`. The result should show **265 rows loaded, 0 errors**.

> **Understanding COPY INTO:** The `@` symbol means "look in a stage". `@stg_nyc_taxi/taxi_zone_lookup.csv` means: find the file `taxi_zone_lookup.csv` inside the stage called `stg_nyc_taxi`. The FILE_FORMAT block tells Snowflake how to parse the file -- skip the header row, handle quoted fields, and treat empty values as NULL. This same COPY INTO pattern is used for every file load in Snowflake regardless of file type.

---

### Step 8 - Populate dim_datetime

There is no source file for dim_datetime. We generate it by reading the pickup timestamps directly from the Parquet files and extracting the date parts.

Run Step 5 from `load_data.sql`. This reads all 28 Parquet files, extracts every unique pickup timestamp, and populates dim_datetime with the year, month, day, hour, weekday, and month_name for each one.

Verify:

```sql
SELECT COUNT(*) AS row_count FROM dim_datetime;
SELECT MIN(pickup_dt), MAX(pickup_dt) FROM dim_datetime;
```

Expected: ~25.1 million rows, earliest 2025-01-01, latest 2026-02-28.

> **Why populate dim_datetime from the Parquet files?** The Parquet files contain raw timestamps like `2025-03-15 08:32:00`. For analytical queries we need pre-extracted date parts -- year, month, hour, weekday -- so we can write simple WHERE and GROUP BY clauses without recalculating them every time. dim_datetime acts as a calendar table that makes time-based analysis fast and readable.

---

### Step 9 - Load fact_trips

This is the main load. Run Step 6 from `load_data.sql` -- first the Yellow INSERT, then the Green INSERT.

Each INSERT reads from the staged Parquet files, joins to dim_datetime to get the datetime_id foreign key, and loads all trip columns into fact_trips.

Verify:

```sql
SELECT taxi_type, COUNT(*) AS trip_count
FROM fact_trips
GROUP BY taxi_type;
```

Expected: ~52.9M yellow trips, ~667K green trips.

> **Why more rows than Phase 1?** Phase 2 loaded 53.6M trips vs 51.5M in Phase 1. The difference is that the Phase 1 Python ETL pipeline applied additional data quality filters -- negative durations, null vendor IDs, and other checks -- that were not replicated here. Phase 2 applies only minimal filters (fare_amount >= 0, trip_distance >= 0) to keep the loading script simple and focused on demonstrating Snowflake's capabilities.

---

### Step 10 - Run the Analytical Queries

Before opening `queries.sql`, try writing each query yourself first. Each query has a clear business question and a list of columns to return -- that is enough to write the SQL from scratch. This is exactly the kind of exercise you will face in a technical interview.

Once you have attempted a query, check your solution against `queries.sql`. There is rarely one correct answer -- if your query returns the same results, your approach is valid even if the syntax differs.

After verifying your solution, run it and record the execution time shown in the results panel. Compare against the MySQL Phase 1 benchmarks listed in the file. The performance difference is the main point of this phase.

---

## Performance Benchmark Results

These are the exact same 10 queries from MySQL Phase 1, run on the same dataset in Snowflake. MySQL times were measured on a local machine. Snowflake times were measured on a free trial account using an X-Small virtual warehouse.

| Query | MySQL Phase 1 (local) | Snowflake Phase 2 (cloud) | Speedup |
|---|---|---|---|
| Q1: Total trips by taxi type | ~64 sec | ~469 ms | ~136x |
| Q2: Trips by month and year | ~456 sec (7.5 min) | ~2.4 sec | ~190x |
| Q3: Top 10 busiest pickup zones | ~371 sec (6 min) | ~624 ms | ~594x |
| Q4: Avg fare, distance, duration | ~75 sec | ~607 ms | ~123x |
| Q5: Revenue by payment type | ~585 sec (10 min) | ~564 ms | ~1,037x |
| Q6: Passenger count distribution | ~39 sec | ~327 ms | ~119x |
| Q7: Peak hours by day of week | ~387 sec (6.5 min) | ~1.7 sec | ~227x |
| Q8: Top 10 pickup-dropoff routes | ~2,698 sec (45 min) | ~495 ms | ~5,450x |
| Q9: Monthly revenue trend (MoM) | ~670 sec (11 min) | ~1.7 sec | ~394x |
| Q10: Top 10 zones by revenue | ~7,267 sec (121 min) | ~329 ms | ~22,082x |

> **Why are Queries 8 and 10 so much faster?** Both involve heavy aggregations across all 53 million rows combined with joins or window functions. Query 8 joins fact_trips to dim_taxizone twice, taking 45 minutes in MySQL. Query 10 computes total revenue per zone across all rows and then ranks them using RANK() -- taking over 2 hours in MySQL. Snowflake's columnar storage means it only reads the columns actually needed rather than every column in the table. Combined with micro-partition pruning, these same queries complete in under half a second.

> **Important note on benchmarks:** MySQL times were measured on a local machine with limited RAM. Snowflake runs on cloud infrastructure with distributed compute. The comparison demonstrates the architectural difference between row-based and columnar databases, not just hardware differences. Even on identical hardware, columnar databases are orders of magnitude faster for analytical aggregations.

---

## About the Author

**Alireza Samea**
- Professor and Data Analytics Instructor
- GitHub: [alirezasamea](https://github.com/alirezasamea)
- LinkedIn: [alirezasamea](https://www.linkedin.com/in/alirezasamea/)
- Email: alireza.samea@queensu.ca

---

*Dataset: NYC TLC Trip Record Data -- publicly available from the NYC Taxi and Limousine Commission. All figures reflect Yellow and Green taxi trips from January 2025 to February 2026.*
