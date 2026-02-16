# NYC Taxi Data Transformation with dbt

This dbt project transforms raw NYC Taxi trip data (Yellow, Green, and FHV) into analytics-ready models.

## Project Structure

```
models/
├── staging/          # Cleaned and standardized source data
│   ├── stg_yellow_tripdata.sql
│   ├── stg_green_tripdata.sql
│   └── stg_fhv_tripdata.sql
├── intermediate/     # Business logic transformations
│   ├── int_trips_unioned.sql
│   └── int_trips.sql
├── marts/           # Final analytics models
│   ├── core/
│   │   └── fct_trips.sql
│   └── reporting/
│       ├── fct_monthly_zone_revenue.sql
│       ├── dim_vendors.sql
│       └── dim_zones.sql
```

## Getting Started

### Build All Models

Build all models from scratch (full refresh):

```bash
dbt build --full-refresh
```

Run models incrementally (recommended after initial build):

```bash
dbt build
```

### Run Specific Models

```bash
# Run only staging models
dbt run --select staging

# Run a specific model and its dependencies
dbt run --select fct_monthly_zone_revenue+
```

### Run Tests

```bash
dbt test
```

## Homework Questions

### Question 3: Count of Records in fct_monthly_zone_revenue

To get the total count of records in the `fct_monthly_zone_revenue` model:

**Option 1: Using dbt show (recommended)**
```bash
dbt show --select question_3_record_count
```

**Option 2: Using the shell script**
```bash
bash analyses/hw_answers.sh
```

**Option 3: Run the SQL directly**
```bash
dbt show --inline "SELECT COUNT(*) FROM {{ ref('fct_monthly_zone_revenue') }}"
```

The analysis file is located at: `analyses/question_3_record_count.sql`

**Answer: 11,814 records**

This represents the monthly revenue aggregated by:
- Pickup zone (265 taxi zones)
- Service type (Green and Yellow)
- Revenue month (2019-2020)

---

### Question 4: Pickup Zone with Highest Green Taxi Revenue in 2020

To find the pickup zone with the highest total revenue for Green taxi trips in 2020:

**Using dbt show:**
```bash
dbt show --select question_4_top_green_zone --limit 5
```

**Run the SQL directly:**
```bash
dbt show --inline "
SELECT 
    pickup_zone,
    SUM(revenue_monthly_total_amount) AS total_revenue
FROM {{ ref('fct_monthly_zone_revenue') }}
WHERE service_type = 'Green'
    AND EXTRACT(YEAR FROM revenue_month) = 2020
GROUP BY pickup_zone
ORDER BY total_revenue DESC
" --limit 5
```

The analysis file is located at: `analyses/question_4_top_green_zone.sql`

**Answer: East Harlem North**

Top 5 Green taxi pickup zones by revenue in 2020:
1. **East Harlem North** - $1,817,052.55
2. East Harlem South - $1,653,078.31
3. Central Harlem - $1,097,346.12
4. Washington Heights North - $880,111.80
5. Morningside Heights - $764,454.64

---

### Question 5: Total Green Taxi Trips in October 2019

To find the total number of trips for Green taxis in October 2019:

**Using dbt show:**
```bash
dbt show --select question_5_green_oct_2019
```

**Run the SQL directly:**
```bash
dbt show --inline "
SELECT 
    SUM(total_monthly_trips) AS total_trips
FROM {{ ref('fct_monthly_zone_revenue') }}
WHERE service_type = 'Green'
    AND revenue_month = '2019-10-01'
"
```

The analysis file is located at: `analyses/question_5_green_oct_2019.sql`

**Answer: 384,624 trips**

This represents the sum of all Green taxi trips across all pickup zones in October 2019.

---

### Question 6: Count of Records in stg_fhv_tripdata

To get the total count of records in the `stg_fhv_tripdata` staging model:

**Using dbt show:**
```bash
dbt show --select question_6_fhv_count
```

**Run the SQL directly:**
```bash
dbt show --inline "SELECT COUNT(*) FROM {{ ref('stg_fhv_tripdata') }}"
```

The analysis file is located at: `analyses/question_6_fhv_count.sql`

**Answer: 43,244,693 records**

This represents all FHV (For-Hire Vehicle) trips in 2019-2020 after filtering out records with NULL dispatching_base_num.

## Model Descriptions

### Staging Models
- **stg_yellow_tripdata**: Yellow taxi trips with standardized column names and types
- **stg_green_tripdata**: Green taxi trips with standardized column names and types
- **stg_fhv_tripdata**: For-Hire Vehicle trips with standardized column names and types

### Intermediate Models
- **int_trips_unioned**: Union of Yellow and Green taxi trips
- **int_trips**: Enhanced trips with calculated metrics (duration, distance validation)

### Fact Tables
- **fct_trips**: All trips with enriched attributes and metrics
- **fct_monthly_zone_revenue**: Monthly revenue aggregated by pickup zone and service type

### Dimension Tables
- **dim_zones**: NYC Taxi Zones with borough and service zone information
- **dim_vendors**: Taxi technology vendors

## Resources
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support

