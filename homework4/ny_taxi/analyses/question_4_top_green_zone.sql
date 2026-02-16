-- Question 4: Find the pickup zone with the highest total revenue for Green taxi trips in 2020
-- This query uses the fct_monthly_zone_revenue table to aggregate revenue by pickup zone
-- for Green taxi service type in the year 2020.

SELECT 
    pickup_zone,
    SUM(revenue_monthly_total_amount) AS total_revenue
FROM {{ ref('fct_monthly_zone_revenue') }}
WHERE service_type = 'Green'
    AND EXTRACT(YEAR FROM revenue_month) = 2020
GROUP BY pickup_zone
ORDER BY total_revenue DESC
