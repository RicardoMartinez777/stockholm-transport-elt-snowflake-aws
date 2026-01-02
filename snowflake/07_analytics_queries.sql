-- ============================================================================
-- Worksheet: 07_analytics_queries
-- Purpose  : Perform analytical queries and generate insights.
--            - Analyze routes and trips by transport mode
--            - Identify busiest stops and routes
--            - Include basic data quality checks
-- ============================================================================

-- Context setup: use admin role, warehouse, database, and analytics schema
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE wh_transport;
USE DATABASE stockholm_transport;
USE SCHEMA analytics;

-- ----------------------------------------------------------------------------
-- Base view: routes dimension for analytics
-- ----------------------------------------------------------------------------
CREATE OR REPLACE VIEW analytics.v_routes AS
SELECT
  route_id,
  route_short_name,
  route_long_name,
  transport_mode
FROM staging.routes;

-- ============================================================================
-- KPI 1) Trips per Route
-- Question: How many trips are scheduled for each route?
-- ============================================================================
SELECT
  r.transport_mode,
  r.route_id,
  r.route_short_name,
  r.route_long_name,
  COUNT(*) AS total_trips
FROM staging.trips t
JOIN analytics.v_routes r
  ON t.route_id = r.route_id
GROUP BY
  r.transport_mode, r.route_id, r.route_short_name, r.route_long_name
ORDER BY total_trips DESC
LIMIT 20;

-- ============================================================================
-- KPI 2) Stops per Route (distinct stop coverage)
-- Question: How many distinct stops does each route serve?
-- ============================================================================
SELECT
  r.transport_mode,
  r.route_id,
  r.route_short_name,
  r.route_long_name,
  COUNT(DISTINCT st.stop_id) AS distinct_stops_served
FROM staging.stop_times st
JOIN staging.trips t
  ON st.trip_id = t.trip_id
JOIN analytics.v_routes r
  ON t.route_id = r.route_id
GROUP BY
  r.transport_mode, r.route_id, r.route_short_name, r.route_long_name
ORDER BY distinct_stops_served DESC
LIMIT 20;

-- ============================================================================
-- KPI 3) Most Served Stops
-- Question: Which stops appear most frequently in the schedule?
-- ============================================================================
SELECT
  s.stop_id,
  s.stop_name,
  COUNT(*) AS total_stop_events
FROM staging.stop_times st
JOIN staging.stops s
  ON st.stop_id = s.stop_id
GROUP BY s.stop_id, s.stop_name
ORDER BY total_stop_events DESC
LIMIT 20;

-- ============================================================================
-- KPI 4) Average Stops per Trip by Route
-- Question: On average, how many stops does a trip have for each route?
-- ============================================================================
WITH stops_per_trip AS (
  SELECT
    t.route_id,
    st.trip_id,
    COUNT(*) AS stops_in_trip
  FROM staging.stop_times st
  JOIN staging.trips t
    ON st.trip_id = t.trip_id
  GROUP BY t.route_id, st.trip_id
)
SELECT
  r.transport_mode,
  r.route_id,
  r.route_short_name,
  r.route_long_name,
  AVG(spt.stops_in_trip) AS avg_stops_per_trip
FROM stops_per_trip spt
JOIN analytics.v_routes r
  ON spt.route_id = r.route_id
GROUP BY
  r.transport_mode, r.route_id, r.route_short_name, r.route_long_name
ORDER BY avg_stops_per_trip DESC
LIMIT 20;

-- ============================================================================
-- KPI 5) Service Date Range per Route
-- Question: What is the service validity range (start/end) for each route?
-- Notes:
-- - Converts YYYYMMDD strings into DATE.
-- ============================================================================
SELECT
  r.transport_mode,
  r.route_id,
  r.route_short_name,
  r.route_long_name,
  MIN(TO_DATE(c.start_date, 'YYYYMMDD')) AS service_start_date,
  MAX(TO_DATE(c.end_date,   'YYYYMMDD')) AS service_end_date
FROM staging.trips t
JOIN staging.calendar c
  ON t.service_id = c.service_id
JOIN analytics.v_routes r
  ON t.route_id = r.route_id
GROUP BY
  r.transport_mode, r.route_id, r.route_short_name, r.route_long_name
ORDER BY service_start_date ASC;

-- ----------------------------------------------------------------------------
-- Basic data quality check (kept from your original version)
-- Trips without a matching route
-- ----------------------------------------------------------------------------
SELECT COUNT(*) AS trips_without_route
FROM staging.trips t
LEFT JOIN staging.routes r
  ON t.route_id = r.route_id
WHERE r.route_id IS NULL;