-- ============================================================================
-- Worksheet: 05_load_raw_data
-- Purpose  : Load raw data from AWS S3 into Snowflake RAW tables.
--            - Use COPY INTO from external stage
--            - Validate row counts after load
-- ============================================================================
-- Context setup: use admin role, warehouse, database, and raw schema
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE wh_transport;
USE DATABASE stockholm_transport;
USE SCHEMA raw;

-- Load routes data from S3 into RAW.ROUTES table
COPY INTO raw.routes
FROM @stockholm_transport.raw.s3_raw_stage/routes/routes.txt
FILE_FORMAT = (FORMAT_NAME = stockholm_transport.raw.csv_format)
ON_ERROR = 'ABORT_STATEMENT';

-- Load stops data from S3 into RAW.STOPS table
COPY INTO raw.stops
FROM @stockholm_transport.raw.s3_raw_stage/stops/stops.txt
FILE_FORMAT = (FORMAT_NAME = stockholm_transport.raw.csv_format)
ON_ERROR = 'ABORT_STATEMENT';

-- Load trips data from S3 into RAW.TRIPS table
COPY INTO raw.trips
FROM @stockholm_transport.raw.s3_raw_stage/trips/trips.txt
FILE_FORMAT = (FORMAT_NAME = stockholm_transport.raw.csv_format)
ON_ERROR = 'ABORT_STATEMENT';

-- Load stop times data allowing column count mismatch
COPY INTO raw.stop_times
FROM @stockholm_transport.raw.s3_raw_stage/stop_times/stop_times.txt
FILE_FORMAT = (
  FORMAT_NAME = stockholm_transport.raw.csv_format,
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE
)
ON_ERROR = 'ABORT_STATEMENT';

-- Load service calendar data from S3 into RAW.CALENDAR table
COPY INTO raw.calendar
FROM @stockholm_transport.raw.s3_raw_stage/calendar/calendar.txt
FILE_FORMAT = (FORMAT_NAME = stockholm_transport.raw.csv_format)
ON_ERROR = 'ABORT_STATEMENT';

-- Validate data load by counting rows per RAW table
SELECT 'routes'      AS table_name, COUNT(*) AS row_count FROM raw.routes
UNION ALL
SELECT 'stops',      COUNT(*) FROM raw.stops
UNION ALL
SELECT 'trips',      COUNT(*) FROM raw.trips
UNION ALL
SELECT 'stop_times', COUNT(*) FROM raw.stop_times
UNION ALL
SELECT 'calendar',   COUNT(*) FROM raw.calendar;