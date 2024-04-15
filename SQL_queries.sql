-- QUERY 1
-- Get the data in scope for the analysis

WITH brookyn_data_2014_2017 AS (
  SELECT*
  FROM
    `bigquery-public-data.new_york.nypd_mv_collisions`
  WHERE
    borough = "BROOKLYN"
    AND cast(timestamp as date) between "2014-01-01" AND "2017-12-31"
)

-- QUERY 2
-- What is the most common factor in a motor vehicle collision in Brooklyn? 
-- This query counts the number of collisions for each collision type, in descending order.

SELECT
  contributing_factor_vehicle_1 AS collision_factor,
  COUNT(*) num_collisions
FROM
  brookyn_data_2014_2017
WHERE
  contributing_factor_vehicle_1 != "Unspecified"
  AND contributing_factor_vehicle_1 != ""
GROUP BY
  1
ORDER BY
  2 DESC;

-- QUERY 3
-- What are the most dangerous streets for motor vehicle collisions in Brooklyn? 
-- This query counts the number of fatalities and injured by streets. 
WITH brookyn_data_2014_2017 AS (
  SELECT*
  FROM
    `bigquery-public-data.new_york.nypd_mv_collisions`
  WHERE
    borough = "BROOKLYN"
    AND cast(timestamp as date) between "2014-01-01" AND "2017-12-31"
)
SELECT
  on_street_name,
  SUM(number_of_persons_killed) AS deaths,
  SUM(number_of_persons_injured) AS injuries
FROM
  brookyn_data_2014_2017
WHERE
  on_street_name <> ''
GROUP BY
  on_street_name
ORDER BY
  deaths DESC
LIMIT
  10;


-- QUERY 4
-- (a) When do most accidents happen in NYC's Brooklyn?  
-- This query counts the number of accidents by hour throughout the day and rank them
WITH brookyn_data_2014_2017 AS (
  SELECT*
  FROM
    `bigquery-public-data.new_york.nypd_mv_collisions`
  WHERE
    borough = "BROOKLYN"
    AND cast(timestamp as date) between "2014-01-01" AND "2017-12-31"
)

SELECT
  EXTRACT(HOUR from timestamp) AS hour_of_day,
  COUNT(*) AS num_accidents,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS number_accident_rank
FROM
  brookyn_data_2014_2017
GROUP BY
  hour_of_day
ORDER BY
  hour_of_day;

--(b) How about when we look at this between day of week and hours?

WITH brookyn_data_2014_2017 AS (
  SELECT *
  FROM `bigquery-public-data.new_york.nypd_mv_collisions`
  WHERE borough = "BROOKLYN"
    AND CAST(timestamp AS DATE) BETWEEN "2014-01-01" AND "2017-12-31"
)
SELECT
  EXTRACT(HOUR FROM timestamp) AS hour_of_day,
  COUNT(CASE WHEN EXTRACT(DAYOFWEEK FROM timestamp) = 1 THEN 1 END) AS sunday,
  COUNT(CASE WHEN EXTRACT(DAYOFWEEK FROM timestamp) = 2 THEN 1 END) AS monday,
  COUNT(CASE WHEN EXTRACT(DAYOFWEEK FROM timestamp) = 3 THEN 1 END) AS tuesday,
  COUNT(CASE WHEN EXTRACT(DAYOFWEEK FROM timestamp) = 4 THEN 1 END) AS wednesday,
  COUNT(CASE WHEN EXTRACT(DAYOFWEEK FROM timestamp) = 5 THEN 1 END) AS thursday,
  COUNT(CASE WHEN EXTRACT(DAYOFWEEK FROM timestamp) = 6 THEN 1 END) AS friday,
  COUNT(CASE WHEN EXTRACT(DAYOFWEEK FROM timestamp) = 7 THEN 1 END) AS saturday
FROM
  brookyn_data_2014_2017
GROUP BY
  hour_of_day
ORDER BY
  hour_of_day;



-- check for weird spelling of Brooklyn
SELECT
  DISTINCT(borough)
FROM
  `bigquery-public-data.new_york.nypd_mv_collisions`;

SELECT
  *
FROM
  `bigquery-public-data.new_york.nypd_mv_collisions`
WHERE
  borough = "BROOKLYN"
  AND cast(timestamp as date) between "2014-01-01" AND "2017-12-31";


