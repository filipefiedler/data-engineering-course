
# Homework 4 – Data Warehouse Workflow on BigQuery

This project demonstrates a data engineering workflow using [Kestra](https://kestra.io/) for orchestration and [Google Cloud Platform (GCP)](https://cloud.google.com/) for data storage and processing. The repository provides infrastructure-as-code setup with Terraform, workflow definitions for Kestra, and utility scripts to automate data ingestion and management. Questions are defined in `questions.md` and can be answered using the provided `answers.sql` file.

## Project Structure

- **kestra/**: Contains Kestra workflow YAMLs and shell scripts for uploading flows, running backfills, and setting key-value secrets.
- **terraform/**: Infrastructure-as-code for GCP resources (BigQuery, Storage, etc.) using Terraform.
- **sql/**: (If present) SQL scripts for data transformation or querying.
- **utils/**: Utility scripts for setting up secrets and answering questions.
- **docker-compose.yaml**: Local orchestration for running Kestra and related services.
- **makefile**: Automation for setup and workflow execution.

## Setup Instructions
Disclaimer: The instructions below assume you have a GCP account and that you are going to use Github Codespaces for this homework. Adjust accordingly if using a different environment.

1. **Create GCP Service Accounts:**
   - `terraform-sa`: For Terraform resource creation (BigQuery Admin, Storage Admin, Compute Admin).
   - `kestra-sa`: For Kestra workflow execution (BigQuery Job User, BigQuery Data Editor, Storage Admin).
   - `dbt-sa`: For dbt connection (BigQuery Data Editor, BigQuery Job User, BigQuery User).

2. **Download and Configure Keys:**
   - Download JSON key files for both service accounts.
   - Set them as workspace secrets:
     - `GCP_CREDENTIALS_TERRAFORM`: Key for `terraform-sa`
     - `GCP_CREDENTIALS_KESTRA`: Key for `kestra-sa`
     - `GCP_CREDENTIALS_DBT`: Key for `dbt-sa`

3. **Configure Environment Variables:**
   - Copy `.env.example` to `.env`: `cp .env.example .env`
   - Edit `.env` with your GCP project ID, region, bucket, and dataset names.
   - This single file configures Terraform, Kestra, dbt, and Docker Compose.
   - See [CONFIG.md](CONFIG.md) for detailed configuration instructions.

4. **Sync Configurations:**
   - Run `make sync-all` to propagate `.env` values to all tools.
   - This generates Terraform variables, Kestra KV configs, and updates dbt sources.

5. **Initialize Infrastructure:**
   - Run `make start` from the `homework4/` directory to initialize Terraform and create GCP resources.

6. **Load Data and Run dbt:**
   - **Full Pipeline (with data ingestion from source):** Run `make full-pipeline` to execute everything including Kestra-based ingestion
   - **Quick Pipeline (using existing parquet files):** Run `make pipeline` for infrastructure + data loading + dbt
   - **Individual Steps:**
     - `make ingest-data`: Download NYC Taxi data from web and upload to GCS using Kestra workflows
     - `make load-data`: Load parquet files from GCS into BigQuery tables
     - `make run-dbt`: Run dbt models to transform data
   
   Note: The data loading handles schema inconsistencies in green taxi data by loading months separately and combining them in dbt.

7. **Get Answers:**
   - Copy `answers.sql` to BigQuery UI and run or select the queries to answer the quiz questions provided in the file `questions.md`

## Available Make Commands

- `make sync-all`: Sync all configurations from .env to Terraform, Kestra, and dbt
- `make start`: Set up infrastructure with Terraform
- `make ingest-data`: Download NYC Taxi data from web and ingest to GCS via Kestra (includes Docker Compose + Kestra workflows)
- `make load-data`: Load NYC taxi parquet files from GCS into BigQuery
- `make run-dbt`: Run dbt models to transform raw data
- `make pipeline`: Execute quick pipeline (infrastructure + data loading + dbt) - assumes data already in GCS
- `make full-pipeline`: Execute complete pipeline including data ingestion from source (infrastructure + ingestion + loading + dbt)
- `make stop`: Stop Docker Compose services

## Data Architecture

The project handles NYC Taxi data with the following approach:

### Data Flow
1. **Ingestion (via Kestra)**: Download parquet files from NYC TLC website → Upload to GCS bucket
2. **Loading (Python scripts)**: Read parquet files from GCS → Load into BigQuery native tables
3. **Transformation (dbt)**: Transform raw data → Create analytics-ready staging and mart tables

### Table Structure
- **Yellow Taxi**: Loaded from parquet files using wildcard patterns
- **Green Taxi**: Loaded month-by-month due to schema inconsistencies
  - Jan-Aug 2019: Loaded into `green_tripdata` table
  - Sep-Dec 2019: Loaded into `green_tripdata_q4` table
  - Combined in dbt using UNION for complete dataset
- **dbt Models**: Standardize schemas, apply transformations, and create analytics-ready tables

### Why Split Approach?
- **Kestra workflows** handle data ingestion from external sources (download + upload to GCS)
- **Python scripts** handle BigQuery loading with schema flexibility for parquet files with inconsistent types
- **dbt** handles transformations and creates the final analytics layer

## Notes

- Ensure Docker is installed and running for local orchestration.
- Kestra UI will be available at [http://localhost:8080](http://localhost:8080) after starting the services.
- All GCP resource names and credentials must be updated to match your own project.