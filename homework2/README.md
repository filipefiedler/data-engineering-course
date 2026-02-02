# Homework 2

This directory contains the files for Homework 2.


## Setup
1. Create two service accounts (SA) in your GCP project:
    - `terraform-sa`: for Terraform to create resources with permissions
      - BigQuery Admin
      - Storage Admin
      - Compute Admin
    - `kestra-sa`: for Kestra to run data workflows with permissions
      - BigQuery Job User
      - BigQuery Data Editor
      - Storage Admin
2. Download the JSON key files and set as secrets in your workspace:
   - `GCP_TERRAFORM_KEY`: JSON key file for `terraform-sa`
   - `GCP_KESTRA_KEY`: JSON key file for `kestra-sa`
3. Set the terraform variables in `homework2/terraform/variables.tf`:
   - `project_id`: GCP project ID
   - `region`: GCP region
   - `zone`: GCP zone
4. Update the `GCP_PROJECT_ID`, `GCP_LOCATION`, and `GCP_BUCKET_NAME` and `GCP_DATASET` names in the docker-compose.yml to match the values in `homework2/terraform/variables.tf`
5. Run `make start` from the `homework2/` directory to initialize Terraform and create the GCP resources.