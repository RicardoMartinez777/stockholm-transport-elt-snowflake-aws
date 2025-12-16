-- Context setup: role, warehouse, database, and staging schema
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE wh_transport;
USE DATABASE stockholm_transport;
USE SCHEMA staging;

-- Transform routes data and classify transport mode
CREATE OR REPLACE TABLE staging.routes AS
SELECT
    route_id,
    agency_id,
    route_short_name,
    route_long_name,
    route_type,
    CASE
        WHEN route_type = 700  THEN 'Bus'
        WHEN route_type = 401  THEN 'Metro'
        WHEN route_type = 900  THEN 'Train'
        WHEN route_type = 100  THEN 'Tram'
        WHEN route_type = 1000 THEN 'Ferry'
        ELSE 'Other'
    END AS transport_mode
FROM raw.routes;

-- Validate routes transformation by transport mode distribution
SELECT transport_mode, COUNT(*) 
FROM staging.routes
GROUP BY transport_mode
ORDER BY COUNT(*) DESC;

-- Clean and standardize stops data
CREATE OR REPLACE TABLE staging.stops AS
SELECT
  stop_id,
  TRIM(stop_name) AS stop_name,
  stop_lat,
  stop_lon
FROM raw.stops
WHERE stop_id IS NOT NULL;

-- Validate stops table row count
SELECT COUNT(*) AS stops_count FROM staging.stops;

-- Prepare trips data for analytical use
CREATE OR REPLACE TABLE staging.trips AS
SELECT
  trip_id,
  route_id,
  service_id
FROM raw.trips
WHERE trip_id IS NOT NULL;

-- Validate trips table row count
SELECT COUNT(*) AS trips_count FROM staging.trips;

-- Clean stop times data and remove invalid records
CREATE OR REPLACE TABLE staging.stop_times AS
SELECT
  trip_id,
  TRIM(arrival_time)   AS arrival_time,
  TRIM(departure_time) AS departure_time,
  stop_id,
  stop_sequence
FROM raw.stop_times
WHERE trip_id IS NOT NULL
  AND stop_id IS NOT NULL;

-- Validate stop times table row count
SELECT COUNT(*) AS stop_times_count FROM staging.stop_times;

-- Prepare service calendar data for time-based analysis
CREATE OR REPLACE TABLE staging.calendar AS
SELECT
  service_id,
  monday, tuesday, wednesday, thursday, friday, saturday, sunday,
  start_date,
  end_date
FROM raw.calendar
WHERE service_id IS NOT NULL;

-- Validate calendar table row count
SELECT COUNT(*) AS calendar_count FROM staging.calendar;
