echo "Question 3: Count of records in fct_monthly_zone_revenue"
dbt show -q --inline "select count(*) from {{ ref('fct_monthly_zone_revenue') }}"

echo ""
echo "Question 4: Pickup zone with highest Green taxi revenue in 2020"
dbt show -q --inline "
SELECT 
    pickup_zone,
    SUM(revenue_monthly_total_amount) AS total_revenue
FROM {{ ref('fct_monthly_zone_revenue') }}
WHERE service_type = 'Green'
    AND EXTRACT(YEAR FROM revenue_month) = 2020
GROUP BY pickup_zone
ORDER BY total_revenue DESC
" --limit 1

echo ""
echo "Question 5: Total Green taxi trips in October 2019"
dbt show -q --inline "
SELECT 
    SUM(total_monthly_trips) AS total_trips
FROM {{ ref('fct_monthly_zone_revenue') }}
WHERE service_type = 'Green'
    AND revenue_month = '2019-10-01'
"

echo ""
echo "Question 6: Count of records in stg_fhv_tripdata"
dbt show -q --inline "SELECT COUNT(*) FROM {{ ref('stg_fhv_tripdata') }}"