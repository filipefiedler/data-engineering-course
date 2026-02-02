
# Homework 2 – Data Engineering Workflow on GCP with Kestra

This project demonstrates a data engineering workflow using [Kestra](https://kestra.io/) for orchestration and [Google Cloud Platform (GCP)](https://cloud.google.com/) for data storage and processing. The repository provides infrastructure-as-code setup with Terraform, workflow definitions for Kestra, and utility scripts to automate data ingestion and management.

## Project Structure

- **kestra/**: Contains Kestra workflow YAMLs and shell scripts for uploading flows, running backfills, and setting key-value secrets.
- **terraform/**: Infrastructure-as-code for GCP resources (BigQuery, Storage, etc.) using Terraform.
- **sql/**: (If present) SQL scripts for data transformation or querying.
- **utils/**: Utility scripts for setting up secrets and answering questions.
- **docker-compose.yaml**: Local orchestration for running Kestra and related services.
- **makefile**: Automation for setup and workflow execution.

## Setup Instructions

1. **Create GCP Service Accounts:**
   - `terraform-sa`: For Terraform resource creation (BigQuery Admin, Storage Admin, Compute Admin).
   - `kestra-sa`: For Kestra workflow execution (BigQuery Job User, BigQuery Data Editor, Storage Admin).

2. **Download and Configure Keys:**
   - Download JSON key files for both service accounts.
   - Set them as workspace secrets:
     - `GCP_TERRAFORM_KEY`: Key for `terraform-sa`
     - `GCP_KESTRA_KEY`: Key for `kestra-sa`

3. **Configure Terraform Variables:**
   - Edit `terraform/variables.tf` to set your GCP `project_id`, `region`, and `zone`.

4. **Update Environment Variables:**
   - Edit `docker-compose.yaml` to match your GCP project, region, bucket, and dataset names.

5. **Configure Workflow Scripts:**
   - Update `kestra/run_backfills.sh` for your desired backfill date range.
   - Edit `kestra/set_kvs.yaml` with your GCP project ID, dataset, and bucket.

6. **Initialize Infrastructure:**
   - Run `make start` from the `homework2/` directory to initialize Terraform and create GCP resources.

7. **Show Quiz Answers:**
   - Run `make answers` after the homework flows have completed.
   - The answers to the quiz questions will appear directly in the command prompt after running this command.

## Usage

- **Upload and Execute Kestra Flows:**  
  Use scripts in `kestra/` to upload workflows and trigger executions.
- **Run Backfills:**  
  Use `run_backfills.sh` to backfill data for specified date ranges.
- **Manage Secrets and Keys:**  
  Use scripts in `utils/` to set up required secrets.

## Notes

- Ensure Docker is installed and running for local orchestration.
- Kestra UI will be available at [http://localhost:8080](http://localhost:8080) after starting the services.
- All GCP resource names and credentials must be updated to match your own project.