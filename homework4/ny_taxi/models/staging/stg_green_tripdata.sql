{{
  config(
    materialized='table',
    partition_by={
      "field": "pickup_datetime",
      "data_type": "timestamp",
      "granularity": "day"
    },
    cluster_by=["vendor_id", "pickup_location_id"]
  )
}}

with source as (
    select * from {{ source('raw', 'green_tripdata') }}
),

renamed as (
    select
        -- identifiers
        {{ safe_cast('vendorid', 'integer') }} as vendor_id,
        {{ safe_cast('ratecodeid', 'integer') }} as rate_code_id,
        {{ safe_cast('pulocationid', 'integer') }} as pickup_location_id,
        {{ safe_cast('dolocationid', 'integer') }} as dropoff_location_id,

        -- timestamps
        cast(lpep_pickup_datetime as timestamp) as pickup_datetime,  -- lpep = Licensed Passenger Enhancement Program (green taxis)
        cast(lpep_dropoff_datetime as timestamp) as dropoff_datetime,

        -- trip info
        cast(store_and_fwd_flag as string) as store_and_fwd_flag,
        {{ safe_cast('passenger_count', 'integer') }} as passenger_count,
        {{ safe_cast('trip_distance', 'numeric') }} as trip_distance,
        {{ safe_cast('trip_type', 'integer') }} as trip_type,

        -- payment info
        {{ safe_cast('fare_amount', 'numeric') }} as fare_amount,
        {{ safe_cast('extra', 'numeric') }} as extra,
        {{ safe_cast('mta_tax', 'numeric') }} as mta_tax,
        {{ safe_cast('tip_amount', 'numeric') }} as tip_amount,
        {{ safe_cast('tolls_amount', 'numeric') }} as tolls_amount,
        {{ safe_cast('ehail_fee', 'numeric') }} as ehail_fee,
        {{ safe_cast('improvement_surcharge', 'numeric') }} as improvement_surcharge,
        {{ safe_cast('total_amount', 'numeric') }} as total_amount,
        {{ safe_cast('payment_type', 'integer') }} as payment_type
    from source
    -- Filter out records with null vendor_id (data quality requirement)
    where vendorid is not null
)

select * from renamed
-- Filter to only 2019-2020 data (homework scope)
where extract(year from pickup_datetime) between 2019 and 2020