-- ============================================================================
-- Worksheet: 02_s3_integration
-- Purpose  : Configure secure access between Snowflake and AWS S3.
--            - Create the storage integration
--            - Retrieve IAM user ARN and external ID for AWS trust policy
--            - Enable Snowflake to assume an AWS IAM role
-- ============================================================================

-- Set the warehouse to execute queries
USE WAREHOUSE wh_transport;

-- Create a storage integration to allow Snowflake to access AWS S3
CREATE OR REPLACE STORAGE INTEGRATION s3_transport_int
TYPE = EXTERNAL_STAGE                 -- Used for external stages (S3)
STORAGE_PROVIDER = S3                 -- Cloud provider is Amazon S3
ENABLED = TRUE                        -- Enable the integration
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::929368845825:role/snowflake_s3_stockholm_transport_role'  -- IAM role assumed by Snowflake
STORAGE_ALLOWED_LOCATIONS = (
  's3://stockholm-transport-data-rma/raw/'      -- Restrict access to this S3 path
);

-- It is used to view the internal details of the integration between Snowflake and AWS.
DESC INTEGRATION s3_transport_int;