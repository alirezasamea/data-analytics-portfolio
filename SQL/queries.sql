-- ============================================================
-- Query 1: Total Trips and Revenue by Taxi Type
-- ============================================================
-- Business question: How do Yellow and Green taxis compare
-- in total trip volume and revenue?
-- ============================================================
SELECT 
    taxi_type,
    COUNT(trip_id)            AS total_trips,
    SUM(total_amount)         AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_revenue_per_trip
FROM fact_trips
GROUP BY taxi_type
ORDER BY total_trips DESC;