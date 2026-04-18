-- =============================================================================
-- NYC Taxi Analytics - Snowflake Phase 2
-- nyc_taxi_snowflake_ddl.sql: Creates the star schema (6 tables)
-- Run after setup.sql
-- =============================================================================

USE DATABASE nyc_taxi;
USE SCHEMA main;
-- Dim_Vendor
CREATE OR REPLACE TABLE dim_vendor (
    vendor_id    SMALLINT    NOT NULL,
    vendor_name  VARCHAR(50) NOT NULL,
    CONSTRAINT pk_vendor PRIMARY KEY (vendor_id)
);

-- Dim_RateCode
CREATE OR REPLACE TABLE dim_ratecode (
    rate_code_id   SMALLINT    NOT NULL,
    rate_code_name VARCHAR(30) NOT NULL,
    CONSTRAINT pk_ratecode PRIMARY KEY (rate_code_id)
);

-- Dim_PaymentType
CREATE OR REPLACE TABLE dim_paymenttype (
    payment_type_id   SMALLINT    NOT NULL,
    payment_type_name VARCHAR(30) NOT NULL,
    CONSTRAINT pk_paymenttype PRIMARY KEY (payment_type_id)
);

-- Dim_TaxiZone
CREATE OR REPLACE TABLE dim_taxizone (
    location_id  SMALLINT    NOT NULL,
    borough      VARCHAR(20),
    zone_name    VARCHAR(60),
    service_zone VARCHAR(20),
    CONSTRAINT pk_taxizone PRIMARY KEY (location_id)
);

-- Dim_DateTime
CREATE OR REPLACE TABLE dim_datetime (
    datetime_id  NUMBER        NOT NULL AUTOINCREMENT,
    pickup_dt    TIMESTAMP_NTZ NOT NULL,
    year         SMALLINT      NOT NULL,
    month        SMALLINT      NOT NULL,
    day          SMALLINT      NOT NULL,
    hour         SMALLINT      NOT NULL,
    weekday_num  SMALLINT      NOT NULL,
    weekday_name VARCHAR(10)   NOT NULL,
    is_weekend   BOOLEAN       NOT NULL,
    month_name   VARCHAR(10)   NOT NULL,
    CONSTRAINT pk_datetime PRIMARY KEY (datetime_id)
)
CLUSTER BY (year, month);

-- Snowflake organizes data into micro-partitions.
-- CLUSTER BY tells Snowflake to co-locate rows with similar values,
-- allowing it to skip irrelevant partitions during query execution.
-- This replaces the row-level indexes used in MySQL Phase 1.

-- Fact_Trips
CREATE OR REPLACE TABLE fact_trips (
    trip_id               NUMBER      NOT NULL AUTOINCREMENT,
    datetime_id           NUMBER      NOT NULL,
    vendor_id             SMALLINT,
    pickup_location_id    SMALLINT,
    dropoff_location_id   SMALLINT,
    rate_code_id          SMALLINT,
    payment_type_id       SMALLINT,
    taxi_type             VARCHAR(10) NOT NULL,
    passenger_count       SMALLINT,
    trip_distance         FLOAT,
    trip_duration_min     FLOAT,
    fare_amount           FLOAT,
    extra                 FLOAT,
    mta_tax               FLOAT,
    tip_amount            FLOAT,
    tolls_amount          FLOAT,
    improvement_surcharge FLOAT,
    airport_fee           FLOAT,
    cbd_congestion_fee    FLOAT,
    total_amount          FLOAT,
    store_and_fwd_flag    VARCHAR(1),
    trip_type             SMALLINT,
    CONSTRAINT pk_trips    PRIMARY KEY (trip_id),
    CONSTRAINT fk_datetime FOREIGN KEY (datetime_id)         REFERENCES dim_datetime(datetime_id),
    CONSTRAINT fk_vendor   FOREIGN KEY (vendor_id)           REFERENCES dim_vendor(vendor_id),
    CONSTRAINT fk_pickup   FOREIGN KEY (pickup_location_id)  REFERENCES dim_taxizone(location_id),
    CONSTRAINT fk_dropoff  FOREIGN KEY (dropoff_location_id) REFERENCES dim_taxizone(location_id),
    CONSTRAINT fk_ratecode FOREIGN KEY (rate_code_id)        REFERENCES dim_ratecode(rate_code_id),
    CONSTRAINT fk_payment  FOREIGN KEY (payment_type_id)     REFERENCES dim_paymenttype(payment_type_id)
)
CLUSTER BY (datetime_id);
-- Snowflake organizes data into micro-partitions.
-- CLUSTER BY tells Snowflake to co-locate rows with similar values,
-- allowing it to skip irrelevant partitions during query execution.
-- This replaces the row-level indexes used in MySQL Phase 1.