-- Context setup: role, warehouse, database, and analytics schema
USE ROLE ACCOUNTADMIN;
USE WAREHOUSE wh_transport;
USE DATABASE stockholm_transport;
USE SCHEMA analytics;

-- Create analytical view for route information
CREATE OR REPLACE VIEW analytics.v_routes AS
SELECT
  route_id,
  route_short_name,
  route_long_name,
  transport_mode
FROM staging.routes;

-- Analyze total number of routes by transport mode
SELECT
  transport_mode,
  COUNT(*) AS total_routes
FROM analytics.v_routes
GROUP BY transport_mode
ORDER BY total_routes DESC;

-- Analyze total number of trips by transport mode
SELECT
  r.transport_mode,
  COUNT(*) AS total_trips
FROM staging.trips t
JOIN staging.routes r
  ON t.route_id = r.route_id
GROUP BY r.transport_mode
ORDER BY total_trips DESC;

-- Identify most frequently used stops based on stop events
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

-- Identify routes with the highest number of stop events
SELECT
  r.transport_mode,
  r.route_id,
  r.route_short_name,
  r.route_long_name,
  COUNT(*) AS total_stop_events
FROM staging.stop_times st
JOIN staging.trips t
  ON st.trip_id = t.trip_id
JOIN staging.routes r
  ON t.route_id = r.route_id
GROUP BY r.transport_mode, r.route_id, r.route_short_name, r.route_long_name
ORDER BY total_stop_events DESC
LIMIT 20;

-- Data quality check for trips without a matching route
SELECT COUNT(*) AS trips_without_route
FROM staging.trips t
LEFT JOIN staging.routes r
  ON t.route_id = r.route_id
WHERE r.route_id IS NULL;
