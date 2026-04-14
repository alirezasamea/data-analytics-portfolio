-- ============================================================
-- Query 1: Total Trips and Revenue by Taxi Type
-- ============================================================
-- Business question: How do Yellow and Green taxis compare
-- in total trip volume and revenue?
-- ============================================================
-- Tables: fact_trips
-- Columns to return:
--   - taxi type
--   - total trips
--   - total revenue
--   - average revenue per trip (rounded to 2 decimal places)
-- Sort: total trips descending
-- ============================================================
SELECT 
    taxi_type,
    COUNT(trip_id)            AS total_trips,
    SUM(total_amount)         AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_revenue_per_trip
FROM fact_trips
GROUP BY taxi_type
ORDER BY total_trips DESC;

-- ============================================================
-- Query 2: Trips by Month and Year
-- ============================================================
-- Business question: How does trip volume change across months
-- and years? Which months are busiest?
-- ============================================================
-- Tables: fact_trips, dim_datetime
-- Columns to return:
--   - year
--   - month number
--   - month name
--   - taxi type
--   - total trips
-- Sort: year and month ascending
-- ============================================================
SELECT
    d.year,
    d.month,
    d.month_name,
    f.taxi_type,
    COUNT(f.trip_id) AS total_trips
FROM fact_trips f
JOIN dim_datetime d ON f.datetime_id = d.datetime_id
GROUP BY d.year, d.month, d.month_name, f.taxi_type
ORDER BY d.year, d.month ASC;

-- ============================================================
-- PERFORMANCE NOTE: Before running the remaining queries,
-- add a composite index to speed up joins on fact_trips.
-- This only needs to be run once.
-- Expected time: 5-10 minutes on 51M rows.
-- After this, queries drop from 17-20 minutes to less than 8 minutes.
-- ============================================================
ALTER TABLE fact_trips ADD INDEX idx_datetime_taxi (datetime_id, taxi_type);

-- ============================================================
-- Query 3: Top 10 Busiest Pickup Zones
-- ============================================================
-- Business question: Which pickup locations generate the most
-- trip volume across the city?
-- ============================================================
-- Tables: fact_trips, dim_taxizone
-- Join on: pickup_location_id = location_id
-- Columns to return:
--   - borough
--   - zone name
--   - total trips
-- Filter: top 10 only
-- Sort: total trips descending
-- ============================================================
SELECT
    z.borough,
    z.zone_name,
    COUNT(f.trip_id) AS total_trips
FROM dim_taxizone z
JOIN fact_trips f ON z.location_id = f.pickup_location_id
GROUP BY z.borough, z.zone_name
ORDER BY total_trips DESC
LIMIT 10;

-- ============================================================
-- Query 4: Average Fare, Distance, and Duration by Taxi Type
-- ============================================================
-- Business question: How do Yellow and Green taxis compare
-- on key trip metrics?
-- ============================================================
-- Tables: fact_trips
-- Columns to return:
--   - taxi type
--   - average fare amount (rounded to 2 decimal places)
--   - average trip distance (rounded to 2 decimal places)
--   - average trip duration in minutes (rounded to 2 decimal places)
-- Sort: taxi type ascending
-- ============================================================
SELECT
    taxi_type,
    ROUND(AVG(fare_amount),    2) AS avg_fare,
    ROUND(AVG(trip_distance),  2) AS avg_distance,
    ROUND(AVG(trip_duration_min), 2) AS avg_duration_min
FROM fact_trips
GROUP BY taxi_type
ORDER BY taxi_type;

-- ============================================================
-- Query 5: Revenue Breakdown by Payment Type
-- ============================================================
-- Business question: How do customers prefer to pay, and how
-- does payment method affect revenue?
-- ============================================================
-- Tables: fact_trips, dim_paymenttype
-- Join on: payment_type_id
-- Columns to return:
--   - payment type name
--   - total trips
--   - total revenue (rounded to 2 decimal places)
--   - percentage of total trips (rounded to 2 decimal places)
-- Sort: total trips descending
-- ============================================================
SELECT
    d.payment_type_name,
    COUNT(f.trip_id)                                                    AS total_trips,
    ROUND(SUM(f.total_amount), 2)                                       AS total_revenue,
    ROUND(COUNT(f.trip_id) * 100.0 / (SELECT COUNT(*) FROM fact_trips), 2) AS pct_of_trips
FROM fact_trips f
JOIN dim_paymenttype d ON f.payment_type_id = d.payment_type_id
GROUP BY d.payment_type_name
ORDER BY total_trips DESC;

-- ============================================================
-- Query 6: Passenger Count Distribution
-- ============================================================
-- Business question: How many passengers typically ride
-- per trip? What is the most common group size?
-- ============================================================
-- Tables: fact_trips
-- Columns to return:
--   - passenger count
--   - total trips
--   - percentage of total trips (rounded to 2 decimal places)
-- Filter: exclude NULL passenger counts
-- Sort: passenger count ascending
-- ============================================================
SELECT
    passenger_count,
    COUNT(trip_id)                                                      AS total_trips,
    ROUND(COUNT(trip_id) * 100.0 / (SELECT COUNT(*) FROM fact_trips), 2) AS pct_of_trips
FROM fact_trips
WHERE passenger_count IS NOT NULL
GROUP BY passenger_count
ORDER BY passenger_count ASC;

-- ============================================================
-- Query 7: Peak Hours by Day of Week
-- ============================================================
-- Business question: When are taxis busiest during the week?
-- Which hours and days see the highest demand?
-- ============================================================
-- Tables: fact_trips, dim_datetime
-- Join on: datetime_id
-- Columns to return:
--   - weekday name
--   - weekday number (for sorting)
--   - hour
--   - total trips
-- Filter: year 2025 only (full year, exclude partial years)
-- Sort: weekday number ascending, hour ascending
-- ============================================================
SELECT
    d.weekday_name,
    d.weekday_num,
    d.hour,
    COUNT(f.trip_id) AS total_trips
FROM fact_trips f
JOIN dim_datetime d ON f.datetime_id = d.datetime_id
WHERE d.year = 2025
GROUP BY d.weekday_name, d.weekday_num, d.hour
ORDER BY d.weekday_num, d.hour;

-- ============================================================
-- Query 8: Top 10 Pickup to Dropoff Routes
-- ============================================================
-- Business question: Which routes do passengers travel most
-- frequently?
-- ============================================================
-- Tables: fact_trips, dim_taxizone (joined twice)
-- Join pickup_location_id and dropoff_location_id
-- both to dim_taxizone.location_id
-- Columns to return:
--   - pickup zone name
--   - dropoff zone name
--   - total trips
--   - average fare (rounded to 2 decimal places)
-- Filter: top 10 only
-- Sort: total trips descending
-- ============================================================
SELECT
    d1.zone_name              AS pickup_zone,
    d2.zone_name              AS dropoff_zone,
    COUNT(f.trip_id)          AS total_trips,
    ROUND(AVG(f.fare_amount), 2) AS avg_fare
FROM fact_trips f
JOIN dim_taxizone d1 ON f.pickup_location_id  = d1.location_id
JOIN dim_taxizone d2 ON f.dropoff_location_id = d2.location_id
GROUP BY pickup_zone, dropoff_zone
ORDER BY total_trips DESC
LIMIT 10;

-- ============================================================
-- PERFORMANCE NOTE: This query joins fact_trips to dim_taxizone
-- twice (pickup and dropoff), making it the heaviest query in
-- this file without proper indexing.
--
-- Without index: ~2,698 seconds (45 minutes)
-- To add the index (run once):
--
-- ALTER TABLE fact_trips ADD INDEX idx_pickup_dropoff
--     (pickup_location_id, dropoff_location_id);
--
-- After index: re-run Query 8 and record the improvement.
-- ============================================================
ALTER TABLE fact_trips ADD INDEX idx_pickup_dropoff (pickup_location_id, dropoff_location_id);

-- ============================================================
-- After adding indexes and running ANALYZE TABLE, query time
-- increased to 90+ minutes -- the optimizer chose a worse
-- execution plan after the statistics update. This is a known
-- MySQL behavior where the query optimizer can make suboptimal
-- decisions on large tables with complex joins.
-- ============================================================
-- ============================================================
-- Query 9: Monthly Revenue Trend with Month-over-Month Change
-- ============================================================
-- Business question: How is total revenue trending month by
-- month? Is the business growing or declining?
-- ============================================================
-- Tables: fact_trips, dim_datetime
-- Join on: datetime_id
-- Columns to return:
--   - year
--   - month
--   - month name
--   - total revenue (rounded to 2 decimal places)
--   - previous month revenue
--   - month over month change percentage (rounded to 2 decimal places)
-- Filter: year 2025 only
-- Sort: month ascending
-- Hint: use LAG() window function for previous month revenue
-- ============================================================
WITH monthly_revenue AS (
    SELECT
        d.year,
        d.month,
        d.month_name,
        ROUND(SUM(f.total_amount), 2) AS total_revenue
    FROM fact_trips f
    JOIN dim_datetime d ON f.datetime_id = d.datetime_id
    WHERE d.year = 2025
    GROUP BY d.year, d.month, d.month_name
)
SELECT
    year,
    month,
    month_name,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month)                    AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY month))
        * 100.0 / LAG(total_revenue) OVER (ORDER BY month)
    , 2)                                                        AS mom_change_pct
FROM monthly_revenue
ORDER BY month;

-- ============================================================
-- Query 10: Top 10 Zones Ranked by Revenue
-- ============================================================
-- Business question: Which pickup zones generate the most
-- revenue, and how do they rank against each other?
-- ============================================================
-- Tables: fact_trips, dim_taxizone
-- Join on: pickup_location_id = location_id
-- Columns to return:
--   - rank
--   - borough
--   - zone name
--   - total revenue (rounded to 2 decimal places)
--   - total trips
-- Filter: top 10 only
-- Sort: rank ascending
-- Hint: use RANK() OVER (ORDER BY total_revenue DESC)
--       wrap in a CTE or subquery since you cant use
--       window functions directly in WHERE clause
-- ============================================================
WITH zone_revenue AS (
    SELECT
        z.borough,
        z.zone_name,
        ROUND(SUM(f.total_amount), 2) AS total_revenue,
        COUNT(f.trip_id)              AS total_trips
    FROM fact_trips f
    JOIN dim_taxizone z ON f.pickup_location_id = z.location_id
    GROUP BY z.borough, z.zone_name
)
SELECT
    RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
    borough,
    zone_name,
    total_revenue,
    total_trips
FROM zone_revenue
ORDER BY revenue_rank
LIMIT 10;

-- ============================================================
-- END OF QUERIES
-- ============================================================
-- As demonstrated by the benchmarks above, query times on this
-- dataset range from minutes to hours in MySQL. This is expected
-- behavior for a row-based database running analytical workloads
-- at scale.
--
-- Phase 2 of this project will rebuild the same star schema and
-- queries in a columnar database (Snowflake, BigQuery, or DuckDB)
-- where these queries execute in seconds. See the README for details.
-- ============================================================
