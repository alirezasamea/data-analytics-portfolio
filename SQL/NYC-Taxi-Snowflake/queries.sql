-- =============================================================================
-- NYC Taxi Analytics - Snowflake Phase 2
-- queries.sql: 10 analytical queries benchmarked against MySQL Phase 1
-- Run after load_data.sql
-- =============================================================================

USE DATABASE nyc_taxi;
USE SCHEMA main;

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
    COUNT(trip_id)              AS total_trips,
    SUM(total_amount)           AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_revenue_per_trip
FROM fact_trips
GROUP BY taxi_type
ORDER BY total_trips DESC;

-- MySQL Phase 1 (local):     ~64 sec
-- Snowflake Phase 2 (cloud): ~469 ms

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

-- MySQL Phase 1 (local):     ~456 sec (7.5 min)
-- Snowflake Phase 2 (cloud): ~2.4 sec

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

-- MySQL Phase 1 (local):     ~371 sec (6 min)
-- Snowflake Phase 2 (cloud): ~624 ms

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
    ROUND(AVG(fare_amount),       2) AS avg_fare,
    ROUND(AVG(trip_distance),     2) AS avg_distance,
    ROUND(AVG(trip_duration_min), 2) AS avg_duration_min
FROM fact_trips
GROUP BY taxi_type
ORDER BY taxi_type;

-- MySQL Phase 1 (local):     ~75 sec
-- Snowflake Phase 2 (cloud): ~607 ms

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
    COUNT(f.trip_id)                                                       AS total_trips,
    ROUND(SUM(f.total_amount), 2)                                          AS total_revenue,
    ROUND(COUNT(f.trip_id) * 100.0 / (SELECT COUNT(*) FROM fact_trips), 2) AS pct_of_trips
FROM fact_trips f
JOIN dim_paymenttype d ON f.payment_type_id = d.payment_type_id
GROUP BY d.payment_type_name
ORDER BY total_trips DESC;

-- MySQL Phase 1 (local):     ~585 sec (10 min)
-- Snowflake Phase 2 (cloud): ~564 ms

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
    COUNT(trip_id)                                                        AS total_trips,
    ROUND(COUNT(trip_id) * 100.0 / (SELECT COUNT(*) FROM fact_trips), 2) AS pct_of_trips
FROM fact_trips
WHERE passenger_count IS NOT NULL
GROUP BY passenger_count
ORDER BY passenger_count ASC;

-- MySQL Phase 1 (local):     ~39 sec
-- Snowflake Phase 2 (cloud): ~327 ms

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
-- Filter: year 2025 only
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

-- MySQL Phase 1 (local):     ~387 sec (6.5 min)
-- Snowflake Phase 2 (cloud): ~1.7 sec

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
    d1.zone_name                 AS pickup_zone,
    d2.zone_name                 AS dropoff_zone,
    COUNT(f.trip_id)             AS total_trips,
    ROUND(AVG(f.fare_amount), 2) AS avg_fare
FROM fact_trips f
JOIN dim_taxizone d1 ON f.pickup_location_id  = d1.location_id
JOIN dim_taxizone d2 ON f.dropoff_location_id = d2.location_id
GROUP BY pickup_zone, dropoff_zone
ORDER BY total_trips DESC
LIMIT 10;

-- MySQL Phase 1 (local):     ~2,698 sec (45 min)
-- Snowflake Phase 2 (cloud): ~495 ms

-- Note: This is the most dramatic result in the benchmark. The double JOIN
-- across 53M rows crushed MySQL's query optimizer, taking 45 minutes even
-- with indexes. Snowflake's columnar storage and micro-partition pruning
-- reduced the same query to under half a second -- a 5,450x improvement.

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

-- MySQL Phase 1 (local):     ___
-- Snowflake Phase 2 (cloud): ~1.7 sec

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

-- MySQL Phase 1 (local):     ~7267 sec
-- Snowflake Phase 2 (cloud): ~329 ms