-- ============================================================================
-- Worksheet: 03_create_stage_and_format
-- Purpose  : Define how Snowflake reads data from S3.
--            - Create CSV file format
--            - Create external stage pointing to S3 raw data
--            - Validate access to S3 using LIST command
-- ============================================================================

-- Set the warehouse to execute queries
USE WAREHOUSE wh_transport;

-- Create file format for CSV files stored in S3
CREATE OR REPLACE FILE FORMAT stockholm_transport.raw.csv_format
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
NULL_IF = ('', 'NULL')
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- Create external stage pointing to S3 raw data
CREATE OR REPLACE STAGE stockholm_transport.raw.s3_raw_stage
URL = 's3://stockholm-transport-data-rma/raw/'
STORAGE_INTEGRATION = s3_transport_int
FILE_FORMAT = stockholm_transport.raw.csv_format;

-- Verify that Snowflake can list files from S3
LIST @stockholm_transport.raw.s3_raw_stage;
