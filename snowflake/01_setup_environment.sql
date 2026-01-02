-- ============================================================================
-- Worksheet: 01_setup_environment
-- Purpose  : Set up the Snowflake environment for the project.
--            - Create and configure the warehouse
--            - Create the database and schemas (raw, staging, analytics)
--            - Verify objects creation
-- ============================================================================

-- Create a small warehouse to run queries and load data
CREATE OR REPLACE WAREHOUSE wh_transport
WITH
  WAREHOUSE_SIZE = 'XSMALL'    -- Small size to reduce costs
  AUTO_SUSPEND = 60            -- Suspend after 60 seconds of inactivity
  AUTO_RESUME = TRUE           -- Automatically resume when a query runs
  INITIALLY_SUSPENDED = TRUE;  -- Start in suspended state

-- Set the warehouse to execute queries
USE WAREHOUSE wh_transport;

-- Create the main database for the transport project
CREATE OR REPLACE DATABASE stockholm_transport;

-- Create schema for raw data loaded from AWS S3
CREATE OR REPLACE SCHEMA stockholm_transport.raw;

-- Create schema for cleaned and transformed data
CREATE OR REPLACE SCHEMA stockholm_transport.staging;

-- Create schema for analytics and business queries
CREATE OR REPLACE SCHEMA stockholm_transport.analytics;

-- Verify that the database was created
SHOW DATABASES LIKE 'STOCKHOLM_TRANSPORT';

-- Verify schemas inside the database
SHOW SCHEMAS IN DATABASE stockholm_transport;
