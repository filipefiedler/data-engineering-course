{{
  config(
    materialized='table',
    partition_by={
      "field": "pickup_datetime",
      "data_type": "timestamp",
      "granularity": "day"
    },
    cluster_by=["dispatching_base_num", "pickup_location_id"]
  )
}}

with source as (
    select * from {{ source('raw', 'fhv_tripdata') }}
),

renamed as (
    select
        -- identifiers
        cast(dispatching_base_num as string) as dispatching_base_num,
        cast(Affiliated_base_number as string) as affiliated_base_number,
        {{ safe_cast('PUlocationID', 'integer') }} as pickup_location_id,
        {{ safe_cast('DOlocationID', 'integer') }} as dropoff_location_id,

        -- timestamps
        cast(pickup_datetime as timestamp) as pickup_datetime,
        cast(dropOff_datetime as timestamp) as dropoff_datetime,

        -- trip info
        {{ safe_cast('SR_Flag', 'integer') }} as sr_flag
    from source
    -- Filter out records with null dispatching_base_num (data quality requirement)
    where dispatching_base_num is not null
)

select * from renamed
-- Filter to only 2019-2020 data (homework scope)
where extract(year from pickup_datetime) between 2019 and 2020
