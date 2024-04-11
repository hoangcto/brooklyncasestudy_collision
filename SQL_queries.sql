-- QUERY 1
-- What is the most common factor in a motor vehicle collision in Brooklyn? 
-- This query counts the number of collisions for each collision type, in descending order.

SELECT
  contributing_factor_vehicle_1 AS collision_factor,
  COUNT(*) num_collisions
FROM
  `bigquery-public-data.new_york.nypd_mv_collisions`
WHERE
  contributing_factor_vehicle_1 != "Unspecified"
  AND contributing_factor_vehicle_1 != ""
  AND borough = "BROOKLYN"
  AND cast(timestamp as date) between "2014-01-01" AND "2017-12-31"
GROUP BY
  1
ORDER BY
  num_collisions DESC

-- QUERY 2
-- What are the most dangerous streets for motor vehicle collisions in Brooklyn? 
-- This query counts the number of fatalities and injured by streets. 
#standardSQL
SELECT
  on_street_name,
  SUM(number_of_persons_killed) AS deaths,
  SUM(number_of_persons_injured) AS injuries
FROM
  `bigquery-public-data.new_york.nypd_mv_collisions`
WHERE
  on_street_name <> ''
  AND borough = "BROOKLYN"
  AND cast(timestamp as date) between "2014-01-01" AND "2017-12-31"
GROUP BY
  on_street_name
ORDER BY
  deaths DESC
LIMIT
  10


-- QUERY 3
-- What is the most common factor in a motor vehicle collision in NYC's Brooklyn? and what other details can we garner from Brooklyn incidents when looking at primary collision factors? 
-- This query counts the number of fatalities by streets. 


-- check for weird spelling of Brooklyn
#standardSQL
SELECT
  DISTINCT(borough)
FROM
  `bigquery-public-data.new_york.nypd_mv_collisions`

SELECT
  *
FROM
  `bigquery-public-data.new_york.nypd_mv_collisions`
WHERE
  borough = "BROOKLYN"
  AND cast(timestamp as date) between "2014-01-01" AND "2017-12-31"