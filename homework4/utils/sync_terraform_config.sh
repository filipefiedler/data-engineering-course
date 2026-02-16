#!/bin/bash
# Script to generate Terraform variables from .env file

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "Error: .env file not found!"
    echo "Please copy .env.example to .env and configure your values."
    exit 1
fi

# Load environment variables from .env
set -a
source .env
set +a

# Generate terraform.tfvars
cat > terraform/terraform.tfvars << EOF
# Auto-generated from .env - DO NOT EDIT DIRECTLY
# Run 'make sync-terraform' or './utils/sync_terraform_config.sh' to regenerate

credentials         = "${GCP_CREDENTIALS_TERRAFORM}"
project            = "${GCP_PROJECT_ID}"
region             = "${GCP_REGION}"
location           = "${GCP_LOCATION}"
bq_dataset_name    = "${GCP_DATASET}"
gcs_bucket_name    = "${GCP_BUCKET_NAME}"
gcs_storage_class  = "${GCS_STORAGE_CLASS}"
EOF

echo "✓ Generated terraform/terraform.tfvars from .env"
echo "You can now run 'cd terraform && terraform plan' to verify"
