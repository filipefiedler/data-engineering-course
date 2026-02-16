-- Question 3: What is the count of records in the fct_monthly_zone_revenue model?
-- This query counts the total number of records in the fct_monthly_zone_revenue fact table
-- which aggregates monthly revenue by pickup zone and service type (Green/Yellow).

SELECT 
    COUNT(*) AS total_records
FROM {{ ref('fct_monthly_zone_revenue') }}
