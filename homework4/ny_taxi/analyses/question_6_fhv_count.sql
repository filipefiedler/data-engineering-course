-- Question 6: What is the count of records in stg_fhv_tripdata?
-- This query counts the total number of records in the stg_fhv_tripdata staging model
-- after filtering out NULL dispatching_base_num and limiting to 2019-2020 data.

SELECT 
    COUNT(*) AS total_records
FROM {{ ref('stg_fhv_tripdata') }}
