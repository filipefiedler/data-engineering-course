echo "Question 3"
dbt show -q --inline "select count(*) from {{ ref('fct_monthly_zone_revenue') }}"