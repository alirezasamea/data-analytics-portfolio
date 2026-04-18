-- =============================================================================
-- NYC Taxi Analytics - Snowflake Phase 2
-- load_data.sql: Loads all data into the star schema
-- Run after nyc_taxi_snowflake_ddl.sql
-- Order: lookup tables → dim_taxizone → dim_datetime → fact_trips
-- =============================================================================

USE DATABASE nyc_taxi;
USE SCHEMA main;

-- =============================================================================
-- STEP 1: Load small lookup tables (values from NYC TLC data dictionary)
-- =============================================================================

-- 4 rows: taxi technology vendors (source: NYC TLC data dictionary)
INSERT INTO dim_vendor VALUES
    (1, 'Creative Mobile Technologies'),
    (2, 'Curb Mobility'),
    (6, 'Myle Technologies'),
    (7, 'Helix');

-- 7 rows: fare rate categories (source: NYC TLC data dictionary)
INSERT INTO dim_ratecode VALUES
    (1, 'Standard rate'),
    (2, 'JFK'),
    (3, 'Newark'),
    (4, 'Nassau or Westchester'),
    (5, 'Negotiated fare'),
    (6, 'Group ride'),
    (99, 'Unknown');

-- 6 rows: payment methods (source: NYC TLC data dictionary)
INSERT INTO dim_paymenttype VALUES
    (1, 'Credit card'),
    (2, 'Cash'),
    (3, 'No charge'),
    (4, 'Dispute'),
    (5, 'Unknown'),
    (6, 'Voided trip');

-- =============================================================================
-- STEP 2: Create internal stage
-- A stage is a temporary holding area for files before loading into tables.
-- Since Snowflake runs in the cloud, files must be staged before COPY INTO.
-- =============================================================================

CREATE OR REPLACE STAGE stg_nyc_taxi
    COMMENT = 'Internal stage for NYC taxi CSV and Parquet files';

-- =============================================================================
-- STEP 3: Load dim_taxizone from CSV
-- 265 rows: NYC taxi zones with borough and service area
-- Source: taxi_zone_lookup.csv (NYC TLC website)
-- Before running: upload taxi_zone_lookup.csv to the stage via
-- Catalog -> Database Explorer -> NYC_TAXI -> MAIN -> Stages -> STG_NYC_TAXI -> + Files
-- =============================================================================
COPY INTO dim_taxizone (location_id, borough, zone_name, service_zone)
FROM @stg_nyc_taxi/taxi_zone_lookup.csv
FILE_FORMAT = (
    TYPE = 'CSV'
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    SKIP_HEADER = 1
    NULL_IF = ('', 'NULL')
);

-- =============================================================================
-- STEP 4: Create Parquet file format
-- Tells Snowflake how to read Parquet files from the stage.
-- Referenced in Step 5 (dim_datetime) and Step 6 (fact_trips).
-- =============================================================================
CREATE OR REPLACE FILE FORMAT ff_parquet
    TYPE = 'PARQUET'
    SNAPPY_COMPRESSION = TRUE;
    
-- =============================================================================
-- STEP 5: Populate dim_datetime
-- Extracts all unique pickup timestamps from the staged Parquet files.
-- Generates date parts (year, month, day, hour, weekday, etc.) from each timestamp.
-- Must be loaded before fact_trips since fact_trips references datetime_id.
-- Before running: ensure all Parquet files are uploaded to STG_NYC_TAXI stage.
-- taxi_zone_lookup.csv and all 28 Parquet files should already be there from Step 3.
-- =============================================================================

INSERT INTO dim_datetime (pickup_dt, year, month, day, hour, weekday_num, weekday_name, is_weekend, month_name)
SELECT DISTINCT
    pickup_dt,
    YEAR(pickup_dt)                                                    AS year,
    MONTH(pickup_dt)                                                   AS month,
    DAY(pickup_dt)                                                     AS day,
    HOUR(pickup_dt)                                                    AS hour,
    DAYOFWEEK(pickup_dt)                                               AS weekday_num,
    DAYNAME(pickup_dt)                                                 AS weekday_name,
    CASE WHEN DAYNAME(pickup_dt) IN ('Saturday','Sunday') THEN TRUE ELSE FALSE END AS is_weekend,
    MONTHNAME(pickup_dt)                                               AS month_name
FROM (
    SELECT TO_TIMESTAMP_NTZ($1:tpep_pickup_datetime::STRING) AS pickup_dt
    FROM @stg_nyc_taxi (FILE_FORMAT => 'ff_parquet', PATTERN => '.*yellow.*\\.parquet')
    UNION ALL
    SELECT TO_TIMESTAMP_NTZ($1:lpep_pickup_datetime::STRING) AS pickup_dt
    FROM @stg_nyc_taxi (FILE_FORMAT => 'ff_parquet', PATTERN => '.*green.*\\.parquet')
) t
WHERE pickup_dt IS NOT NULL
  AND pickup_dt >= '2025-01-01'
  AND pickup_dt <  '2026-03-01';

-- =============================================================================
-- STEP 6: Load fact_trips from Parquet files
-- 51.5M rows: one row per taxi trip, Yellow and Green combined.
-- Joins to dim_datetime to get the datetime_id foreign key.
-- Run after dim_datetime is fully loaded.
-- =============================================================================

-- Yellow taxi trips
INSERT INTO fact_trips (
    datetime_id, vendor_id, pickup_location_id, dropoff_location_id,
    rate_code_id, payment_type_id, taxi_type,
    passenger_count, trip_distance, trip_duration_min,
    fare_amount, extra, mta_tax, tip_amount, tolls_amount,
    improvement_surcharge, airport_fee, cbd_congestion_fee,
    total_amount, store_and_fwd_flag, trip_type
)
SELECT
    d.datetime_id,
    t.vendor_id, t.pickup_location_id, t.dropoff_location_id,
    t.rate_code_id, t.payment_type_id, t.taxi_type,
    t.passenger_count, t.trip_distance, t.trip_duration_min,
    t.fare_amount, t.extra, t.mta_tax, t.tip_amount, t.tolls_amount,
    t.improvement_surcharge, t.airport_fee, t.cbd_congestion_fee,
    t.total_amount, t.store_and_fwd_flag, t.trip_type
FROM (
    SELECT
        TO_TIMESTAMP_NTZ($1:tpep_pickup_datetime::STRING)      AS pickup_dt,
        $1:VendorID::SMALLINT                                  AS vendor_id,
        $1:PULocationID::SMALLINT                              AS pickup_location_id,
        $1:DOLocationID::SMALLINT                              AS dropoff_location_id,
        COALESCE($1:RatecodeID::SMALLINT, 99)                  AS rate_code_id,
        $1:payment_type::SMALLINT                              AS payment_type_id,
        'yellow'                                               AS taxi_type,
        $1:passenger_count::SMALLINT                           AS passenger_count,
        $1:trip_distance::FLOAT                                AS trip_distance,
        DATEDIFF('minute',
            TO_TIMESTAMP_NTZ($1:tpep_pickup_datetime::STRING),
            TO_TIMESTAMP_NTZ($1:tpep_dropoff_datetime::STRING))::FLOAT AS trip_duration_min,
        $1:fare_amount::FLOAT                                  AS fare_amount,
        $1:extra::FLOAT                                        AS extra,
        $1:mta_tax::FLOAT                                      AS mta_tax,
        $1:tip_amount::FLOAT                                   AS tip_amount,
        $1:tolls_amount::FLOAT                                 AS tolls_amount,
        $1:improvement_surcharge::FLOAT                        AS improvement_surcharge,
        $1:Airport_fee::FLOAT                                  AS airport_fee,
        $1:cbd_congestion_surcharge::FLOAT                     AS cbd_congestion_fee,
        $1:total_amount::FLOAT                                 AS total_amount,
        $1:store_and_fwd_flag::VARCHAR(1)                      AS store_and_fwd_flag,
        NULL::SMALLINT                                         AS trip_type
    FROM @stg_nyc_taxi (FILE_FORMAT => 'ff_parquet', PATTERN => '.*yellow.*\\.parquet')
    WHERE $1:fare_amount::FLOAT >= 0
      AND $1:trip_distance::FLOAT >= 0
) t
JOIN dim_datetime d ON d.pickup_dt = t.pickup_dt;

-- Green taxi trips
INSERT INTO fact_trips (
    datetime_id, vendor_id, pickup_location_id, dropoff_location_id,
    rate_code_id, payment_type_id, taxi_type,
    passenger_count, trip_distance, trip_duration_min,
    fare_amount, extra, mta_tax, tip_amount, tolls_amount,
    improvement_surcharge, airport_fee, cbd_congestion_fee,
    total_amount, store_and_fwd_flag, trip_type
)
SELECT
    d.datetime_id,
    t.vendor_id, t.pickup_location_id, t.dropoff_location_id,
    t.rate_code_id, t.payment_type_id, t.taxi_type,
    t.passenger_count, t.trip_distance, t.trip_duration_min,
    t.fare_amount, t.extra, t.mta_tax, t.tip_amount, t.tolls_amount,
    t.improvement_surcharge, t.airport_fee, t.cbd_congestion_fee,
    t.total_amount, t.store_and_fwd_flag, t.trip_type
FROM (
    SELECT
        TO_TIMESTAMP_NTZ($1:lpep_pickup_datetime::STRING)      AS pickup_dt,
        $1:VendorID::SMALLINT                                  AS vendor_id,
        $1:PULocationID::SMALLINT                              AS pickup_location_id,
        $1:DOLocationID::SMALLINT                              AS dropoff_location_id,
        COALESCE($1:RatecodeID::SMALLINT, 99)                  AS rate_code_id,
        $1:payment_type::SMALLINT                              AS payment_type_id,
        'green'                                                AS taxi_type,
        $1:passenger_count::SMALLINT                           AS passenger_count,
        $1:trip_distance::FLOAT                                AS trip_distance,
        DATEDIFF('minute',
            TO_TIMESTAMP_NTZ($1:lpep_pickup_datetime::STRING),
            TO_TIMESTAMP_NTZ($1:lpep_dropoff_datetime::STRING))::FLOAT AS trip_duration_min,
        $1:fare_amount::FLOAT                                  AS fare_amount,
        $1:extra::FLOAT                                        AS extra,
        $1:mta_tax::FLOAT                                      AS mta_tax,
        $1:tip_amount::FLOAT                                   AS tip_amount,
        $1:tolls_amount::FLOAT                                 AS tolls_amount,
        $1:improvement_surcharge::FLOAT                        AS improvement_surcharge,
        $1:Airport_fee::FLOAT                                  AS airport_fee,
        $1:cbd_congestion_surcharge::FLOAT                     AS cbd_congestion_fee,
        $1:total_amount::FLOAT                                 AS total_amount,
        $1:store_and_fwd_flag::VARCHAR(1)                      AS store_and_fwd_flag,
        $1:trip_type::SMALLINT                                 AS trip_type
    FROM @stg_nyc_taxi (FILE_FORMAT => 'ff_parquet', PATTERN => '.*green.*\\.parquet')
    WHERE $1:fare_amount::FLOAT >= 0
      AND $1:trip_distance::FLOAT >= 0
) t
JOIN dim_datetime d ON d.pickup_dt = t.pickup_dt;

SELECT taxi_type, COUNT(*) AS trip_count
FROM fact_trips
GROUP BY taxi_type;