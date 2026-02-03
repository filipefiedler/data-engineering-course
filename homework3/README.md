
# Homework 3 – Data Warehouse Workflow on BigQuery

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

2. **Download and Configure Keys:**
   - Download JSON key files for both service accounts.
   - Set them as workspace secrets:
     - `GCP_TERRAFORM_KEY`: Key for `terraform-sa`
     - `GCP_KESTRA_KEY`: Key for `kestra-sa`

3. **Update GCP Variables:**
   - Edit `terraform/variables.tf` to set your GCP `project_id`, `region`, and `zone`.
   - Edit `docker-compose.yaml` to match your GCP project, region, bucket, and dataset names.
   - Edit `kestra/set_kvs.yaml` with your GCP project ID, dataset, and bucket.

4. **Configure Workflow Scripts:**
   - Update `kestra/run_backfills.sh` for your desired backfill date range.
   - Edit `kestra/set_kvs.yaml` with your GCP project ID, dataset, and bucket.

5. **Initialize Infrastructure:**
   - Run `make start` from the `homework3/` directory to initialize Terraform and create GCP resources.

6. **Get Answers:**
   - Copy `answers.sql` to BigQuery UI and run or select the queries to answer the quiz questions provided in the file `questions.md`

## Notes

- Ensure Docker is installed and running for local orchestration.
- Kestra UI will be available at [http://localhost:8080](http://localhost:8080) after starting the services.
- All GCP resource names and credentials must be updated to match your own project.