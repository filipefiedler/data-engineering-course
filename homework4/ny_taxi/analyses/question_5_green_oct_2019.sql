-- Question 5: Total number of trips for Green taxis in October 2019
-- This query uses the fct_monthly_zone_revenue table to sum all trips
-- for Green taxi service type in October 2019.

SELECT 
    SUM(total_monthly_trips) AS total_trips
FROM {{ ref('fct_monthly_zone_revenue') }}
WHERE service_type = 'Green'
    AND revenue_month = '2019-10-01'
