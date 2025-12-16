# Stockholm Transport ELT Pipeline (AWS S3 + Snowflake)

## Overview
This project demonstrates an end-to-end ELT data pipeline using public transport data from Stockholm.
Raw files are stored in AWS S3, loaded into Snowflake, transformed into clean tables, and analyzed through analytical queries.

The purpose of this project is to showcase practical Data Engineering skills using Snowflake and AWS with a clear architecture.

---

## Architecture
The pipeline follows a classic ELT approach:

→ AWS S3 (raw files)  
→ Snowflake RAW layer (COPY INTO)  
→ Snowflake STAGING layer (cleaned tables)  
→ Snowflake ANALYTICS layer (analysis queries)

### AWS S3 Raw Data Structure
![AWS S3 Raw Data Structure](docs/images/s3_raw_bucket_structure.png)

### Snowflake Database and Schema Structure
![Snowflake Database and Schema Structure](docs/images/snowflake_database_and_schemas.png)

### Snowflake Staging Tables
![Snowflake Staging Tables](docs/images/snowflake_staging_tables.png)

### Analytical Queries Example
![Analytical Queries Example](docs/images/snowflake_analytics_query.png)

---

## Data
The dataset follows the GTFS (General Transit Feed Specification) format and includes:

- Routes
- Stops
- Trips
- Stop times
- Service calendar

This type of data is commonly used in real-world public transportation systems.

---

## Project Structure

![](docs/images/Project Structure.png)

---

## Snowflake Scripts Description

**01_context.sql**  
Sets the Snowflake execution context, including role, warehouse, and database.

**02_raw_load.sql**  
Loads raw files from AWS S3 into the RAW schema using `COPY INTO`.
This layer stores data without transformation.

**03_staging_transform.sql**  
Cleans and standardizes raw data into tables.
Includes transport mode classification, data trimming, filtering invalid records,
and basic data quality validations.

**04_analytics.sql**  
Creates analytical business-oriented queries, such as:
- Routes and trips by transport mode
- Most frequently used stops
- Routes with the highest number of stop events
- Data quality checks (e.g. trips without matching routes)

---

## Technologies Used
- AWS S3
- Snowflake
- SQL

---

## How to Run
Execute the Snowflake scripts in the following order:

1. `snowflake/01_context.sql`
2. `snowflake/02_raw_load.sql`
3. `snowflake/03_staging_transform.sql`
4. `snowflake/04_analytics.sql`

---

## Notes
- AWS credentials and secrets are **not included** in this repository.
- This project focuses on SQL-based transformations inside Snowflake.

---

## Author
Ricardo Martinez 
Data Engineer
