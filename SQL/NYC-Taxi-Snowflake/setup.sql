-- =============================================================================
-- NYC Taxi Analytics - Snowflake Phase 2
-- setup.sql: Creates the database and schema
-- Run this first before any other file
-- =============================================================================

CREATE DATABASE nyc_taxi;
USE DATABASE nyc_taxi;
CREATE SCHEMA main;
USE SCHEMA main;

SHOW SCHEMAS IN DATABASE nyc_taxi;