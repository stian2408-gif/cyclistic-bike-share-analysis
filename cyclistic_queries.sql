-- ============================================================
-- Cyclistic Bike Share Analysis
-- Google Data Analytics Capstone Project
-- Author: Stian Landell
--
-- Source table:
-- project-6c6094a1-6e2a-4f19-822.cyclistic.all_trips_final
-- ============================================================


-- ============================================================
-- 1. TOTAL NUMBER OF TRIPS BY RIDER TYPE
-- Creates the data used to compare the total number of trips
-- made by casual riders and annual members.
-- ============================================================

CREATE OR REPLACE TABLE
  `project-6c6094a1-6e2a-4f19-822.cyclistic.trip_count_summary` AS

SELECT
  member_casual,
  COUNT(*) AS trip_count
FROM
  `project-6c6094a1-6e2a-4f19-822.cyclistic.all_trips_final`
GROUP BY
  member_casual
ORDER BY
  trip_count DESC;


-- ============================================================
-- 2. AVERAGE RIDE LENGTH BY RIDER TYPE
-- Calculates the average ride duration in minutes for casual
-- riders and annual members.
-- ============================================================

CREATE OR REPLACE TABLE
  `project-6c6094a1-6e2a-4f19-822.cyclistic.avg_ride_length` AS

SELECT
  member_casual,
  ROUND(
    AVG(TIMESTAMP_DIFF(ended_at, started_at, SECOND)) / 60,
    1
  ) AS avg_ride_length_minutes
FROM
  `project-6c6094a1-6e2a-4f19-822.cyclistic.all_trips_final`
GROUP BY
  member_casual
ORDER BY
  member_casual;


-- ============================================================
-- 3. TRIPS BY DAY OF WEEK
-- Counts trips for each rider type by weekday.
-- weekday_number is included so Tableau can sort the days
-- Monday is set to 1 and Sunday to 7 for correct Tableau sorting.
-- ============================================================

CREATE OR REPLACE TABLE
  `project-6c6094a1-6e2a-4f19-822.cyclistic.weekday_summary` AS

SELECT
  member_casual,
  FORMAT_TIMESTAMP('%A', started_at) AS day_of_week,
  CASE
    WHEN EXTRACT(DAYOFWEEK FROM started_at) = 1 THEN 7
    ELSE EXTRACT(DAYOFWEEK FROM started_at) - 1
  END AS weekday_number,
  COUNT(*) AS trip_count
FROM
  `project-6c6094a1-6e2a-4f19-822.cyclistic.all_trips_final`
GROUP BY
  member_casual,
  day_of_week,
  weekday_number
ORDER BY
  weekday_number,
  member_casual;


-- ============================================================
-- 4. BIKE TYPE PREFERENCE
-- Counts how many trips each rider group made with each
-- available type of bicycle.
-- ============================================================

CREATE OR REPLACE TABLE
  `project-6c6094a1-6e2a-4f19-822.cyclistic.bike_type_summary` AS

SELECT
  member_casual,
  rideable_type AS bike_type,
  COUNT(*) AS trip_count
FROM
  `project-6c6094a1-6e2a-4f19-822.cyclistic.all_trips_final`
GROUP BY
  member_casual,
  bike_type
ORDER BY
  bike_type,
  member_casual;


-- ============================================================
-- 5. MONTHLY RIDERSHIP TREND
-- Counts trips by rider type and month.
--
-- The date filter gives an exact 12-month analysis period:
-- July 1, 2025 through June 30, 2026.
--
-- month_start allows Tableau to display the months in the
-- correct chronological order.
-- ============================================================

CREATE OR REPLACE TABLE
  `project-6c6094a1-6e2a-4f19-822.cyclistic.seasonality_summary` AS

SELECT
  member_casual,
  DATE_TRUNC(DATE(started_at), MONTH) AS month_start,
  FORMAT_DATE('%B', DATE(started_at)) AS month_name,
  FORMAT_DATE('%Y-%m', DATE(started_at)) AS year_month,
  COUNT(*) AS trip_count
FROM
  `project-6c6094a1-6e2a-4f19-822.cyclistic.all_trips_final`
WHERE
  started_at >= TIMESTAMP('2025-07-01 00:00:00')
  AND started_at < TIMESTAMP('2026-07-01 00:00:00')
GROUP BY
  member_casual,
  month_start,
  month_name,
  year_month
ORDER BY
  month_start,
  member_casual;
