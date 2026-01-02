-- ============================================================================
-- Worksheet: 04_create_raw_tables
-- Purpose  : Create RAW tables that reflect the source files.
--            - No transformations applied
--            - Data is stored as-is for traceability
-- ============================================================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE wh_transport;
USE DATABASE stockholm_transport;
USE SCHEMA raw;

-- Raw table for transport routes (bus, metro, train, ferry)
CREATE OR REPLACE TABLE raw.routes (
    route_id STRING,          -- Unique route identifier
    agency_id STRING,         -- Transport agency identifier
    route_short_name STRING,  -- Short route name (e.g. line number)
    route_long_name STRING,   -- Full route description
    route_type INTEGER        -- Transport type (bus, metro, train, etc.)
);

-- Raw table for transport stops
CREATE OR REPLACE TABLE raw.stops (
    stop_id STRING,        -- Unique stop identifier
    stop_name STRING,      -- Stop name
    stop_lat FLOAT,        -- Latitude
    stop_lon FLOAT,        -- Longitude
    location_type FLOAT,   -- 
    parent_station FLOAT,  --
    platform_code VARCHAR    --
);

-- Raw table for transport trips
CREATE OR REPLACE TABLE raw.trips (
    route_id STRING,        -- Associated route
    service_id STRING,      -- Service schedule identifier
    trip_id STRING,         -- Unique trip identifier
    trip_headsign STRING,
    direction_id STRING, 
    shape_id STRING
    
);

-- Raw table for stop times per trip
CREATE OR REPLACE TABLE raw.stop_times (
    trip_id STRING,          -- Trip identifier
    arrival_time STRING,     -- Arrival time at stop
    departure_time STRING,   -- Departure time from stop
    stop_id STRING,          -- Stop identifier
    stop_sequence INTEGER    -- Order of the stop in the trip
);

-- Raw table for service calendars
CREATE OR REPLACE TABLE raw.calendar (
    service_id STRING,     -- Service identifier
    monday INTEGER,
    tuesday INTEGER,
    wednesday INTEGER,
    thursday INTEGER,
    friday INTEGER,
    saturday INTEGER,
    sunday INTEGER,
    start_date STRING,     -- Service start date (YYYYMMDD)
    end_date STRING        -- Service end date (YYYYMMDD)
);

SHOW TABLES IN SCHEMA raw;
