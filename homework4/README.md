
# Homework 4 – Data Warehouse Workflow on BigQuery

This project demonstrates a data engineering workflow using [Kestra](https://kestra.io/) for data orchestration, [Google BigQuery](https://cloud.google.com/bigquery) for data warehousing, and [dbt](https://www.getdbt.com/) for data transformation. The workflow ingests NYC Taxi trip data (Yellow, Green, and FHV) from 2019-2020, loads it into BigQuery, and transforms it into analytics-ready models.

## Quick Start - Answering Homework Questions

All homework questions can be answered using the dbt analysis files in `ny_taxi/analyses/`:

```bash
cd ny_taxi

# Answer all questions at once
bash analyses/hw_answers.sh

# Or run individual questions:
dbt show --select question_3_record_count    # Q3: Record count
dbt show --select question_4_top_green_zone  # Q4: Top Green zone
dbt show --select question_5_green_oct_2019  # Q5: Green trips Oct 2019
dbt show --select question_6_fhv_count       # Q6: FHV record count
```

See [ny_taxi/README.md](ny_taxi/README.md) for detailed instructions and answers.

## Project Structure

- **kestra/**: Kestra workflow YAMLs for data ingestion (download from NYC TLC → upload to GCS)
- **terraform/**: Infrastructure-as-code for GCP resources (BigQuery, Cloud Storage)
- **ny_taxi/**: dbt project for data transformations and analytics
  - **analyses/**: SQL queries for homework questions 3-6
  - **models/staging/**: Cleaned and standardized source data
  - **models/intermediate/**: Business logic transformations
  - **models/marts/**: Final analytics models (facts and dimensions)
- **utils/**: Configuration sync utilities
- **docker-compose.yaml**: Local Kestra orchestration
- **makefile**: Automation commands for setup and execution
- **.env**: Central configuration file (copy from `.env.example`)

## Setup Instructions

### Prerequisites
- GCP account with billing enabled
- Docker installed and running
- GitHub Codespaces (recommended) or local development environment

### 1. Create GCP Service Accounts

Create three service accounts with appropriate permissions:

- **terraform-sa**: BigQuery Admin, Storage Admin, Compute Admin
- **kestra-sa**: BigQuery Job User, BigQuery Data Editor, Storage Admin
- **dbt-sa**: BigQuery Data Editor, BigQuery Job User, BigQuery User

Download JSON key files and set as workspace secrets:
- `GCP_CREDENTIALS_TERRAFORM`
- `GCP_CREDENTIALS_KESTRA`
- `GCP_CREDENTIALS_DBT`

### 2. Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your GCP project details
# See CONFIG.md for detailed configuration instructions
```

### 3. Sync Configurations

```bash
# Propagate .env values to Terraform, Kestra, and dbt
make sync-all
```

### 4. Initialize Infrastructure

```bash
# Create GCP resources (BigQuery dataset, Cloud Storage bucket)
make start
```

### 5. Data Pipeline

**Option A: Complete Pipeline (from source)**
```bash
make full-pipeline
```
This executes:
1. Infrastructure setup (Terraform)
2. Data ingestion (Kestra: download from NYC TLC → GCS)
3. Data transformation (dbt: GCS → BigQuery → analytics models)

**Option B: Quick Pipeline (assumes data already in GCS)**
```bash
make pipeline
```

**Option C: Individual Steps**
```bash
make ingest-data  # Kestra workflows: Download NYC Taxi data → Upload to GCS
make run-dbt      # dbt: Transform raw data → Analytics models
```

### 6. Answer Homework Questions

```bash
cd ny_taxi

# Run all analyses
bash analyses/hw_answers.sh

# Or run specific question
dbt show --select question_3_record_count
```

## Data Architecture

### Data Flow
```
NYC TLC Website → Kestra → GCS → BigQuery (Raw) → dbt → BigQuery (Analytics)
```

1. **Ingestion (Kestra)**: Download CSV files from NYC TLC → Upload to GCS
2. **Loading (Kestra)**: Create external tables → Load into native BigQuery tables with deduplication
3. **Transformation (dbt)**: Raw tables → Staging → Intermediate → Marts (facts & dimensions)

### BigQuery Tables

**Raw Tables** (created by Kestra, in `ny_taxi_dataset_homework4`):
- `yellow_tripdata`: Yellow taxi 2019-2020 (~108M rows)
- `green_tripdata`: Green taxi 2019-2020 (~6.8M rows)  
- `fhv_tripdata`: For-Hire Vehicle 2019-2020 (~43.2M rows)

**dbt Models** (in `dbt_filipefiedler` dataset):
- **Staging**: `stg_yellow_tripdata`, `stg_green_tripdata`, `stg_fhv_tripdata`
- **Intermediate**: `int_trips_unioned`, `int_trips`
- **Marts**: `fct_trips`, `fct_monthly_zone_revenue`, `dim_zones`, `dim_vendors`

### Key Features

- **Idempotent Loading**: Kestra uses MERGE statements with unique_row_id to prevent duplicates
- **Schema Handling**: External tables handle CSV schema variations, native tables enforce consistency
- **Data Quality**: dbt tests validate data integrity and relationships
- **Partitioning**: Tables partitioned by pickup_datetime for efficient querying
- **Clustering**: Tables clustered by vendor_id and location_id for optimized performance

## dbt Project

The `ny_taxi/` dbt project contains:

### Models
- **Staging**: Standardize column names, filter bad data, apply type casting
- **Intermediate**: Union Yellow/Green taxis, calculate trip metrics
- **Marts**: Final analytics models for reporting

### Analyses (Homework Questions)
- `question_3_record_count.sql`: Count of records in fct_monthly_zone_revenue
- `question_4_top_green_zone.sql`: Top Green taxi zone by revenue (2020)
- `question_5_green_oct_2019.sql`: Total Green taxi trips (Oct 2019)
- `question_6_fhv_count.sql`: Count of records in stg_fhv_tripdata

### Running dbt

```bash
cd ny_taxi

# Build all models from scratch
dbt build --full-refresh

# Run models incrementally
dbt build

# Run specific model
dbt run --select fct_monthly_zone_revenue

# Run tests
dbt test

# View documentation
dbt docs generate
dbt docs serve
```

## Homework Questions - Quick Reference

| Question | Description | Answer |
|----------|-------------|--------|
| Q3 | Records in fct_monthly_zone_revenue | **11,814** |
| Q4 | Top Green zone by revenue (2020) | **East Harlem North** ($1.8M) |
| Q5 | Green taxi trips (Oct 2019) | **384,624** |
| Q6 | Records in stg_fhv_tripdata | **43,244,693** |

See [ny_taxi/README.md](ny_taxi/README.md) for detailed instructions on running each query.

## Available Make Commands

- `make sync-all`: Sync .env to Terraform, Kestra, and dbt configs
- `make start`: Initialize infrastructure with Terraform
- `make ingest-data`: Run Kestra workflows to ingest data from NYC TLC to GCS
- `make run-dbt`: Build dbt models and run tests
- `make pipeline`: Quick pipeline (infrastructure + dbt) - assumes data in GCS
- `make full-pipeline`: Complete pipeline (infrastructure + ingestion + dbt)
- `make stop`: Stop Docker Compose services

## Cleanup - Destroying GCP Resources

To avoid incurring GCP costs, destroy all resources when you're done:

### Complete Cleanup

```bash
# Stop Docker services
docker compose down

# Destroy all GCP resources (BigQuery datasets, GCS buckets)
cd terraform
terraform destroy -auto-approve
```

This will delete:
- **GCS Bucket**: `data-engineering-course-486123-homework4-bucket` (and all files)
- **BigQuery Dataset**: `ny_taxi_dataset_homework4` (raw tables: yellow_tripdata, green_tripdata, fhv_tripdata)
- **BigQuery Dataset**: `dbt_filipefiedler` (dbt models: staging, intermediate, marts)

### Partial Cleanup

To destroy only specific resources:

```bash
cd terraform

# Destroy only the dbt dataset
terraform destroy -target=google_bigquery_dataset.dbt-dataset -auto-approve

# Destroy only the raw data dataset
terraform destroy -target=google_bigquery_dataset.ny-taxi-dataset -auto-approve

# Destroy only the GCS bucket
terraform destroy -target=google_storage_bucket.ny-taxi-bucket -auto-approve
```

### Important Notes

- **delete_contents_on_destroy** is enabled for BigQuery datasets, so all tables will be deleted automatically
- **force_destroy** is enabled for the GCS bucket, so all objects will be deleted automatically
- Make sure you have backups if you need to preserve any data
- You can recreate everything by running `make start` and `make full-pipeline` again

## Notes

- Ensure Docker is running before starting Kestra workflows
- Kestra UI available at [http://localhost:8080](http://localhost:8080)
- Default credentials: `admin@kestra.io` / `Admin1234`
- All GCP resource names must match your project configuration in `.env`
- dbt models are materialized as tables for optimal query performance
