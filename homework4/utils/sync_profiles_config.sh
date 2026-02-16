#!/bin/bash
# Script to generate dbt profiles.yml from .env file

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

# Set DBT_DATASET to GCP_DATASET if not explicitly set
if [ -z "$DBT_DATASET" ]; then
    DBT_DATASET="${GCP_DATASET}"
fi

# Set DBT_PROFILE_NAME if not set
if [ -z "$DBT_PROFILE_NAME" ]; then
    DBT_PROFILE_NAME="ny_taxi"
fi

# Create .dbt directory if it doesn't exist
mkdir -p ~/.dbt

PROFILES_FILE="$HOME/.dbt/profiles.yml"

# Backup existing profiles.yml if it exists
if [ -f "$PROFILES_FILE" ]; then
    cp "$PROFILES_FILE" "${PROFILES_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "✓ Backed up existing profiles.yml"
fi

# Generate profiles.yml
cat > "$PROFILES_FILE" << EOF
${DBT_PROFILE_NAME}:
  outputs:
    dev:
      dataset: ${DBT_DATASET}
      job_execution_timeout_seconds: 300
      job_retries: 1
      keyfile: ${GCP_CREDENTIALS_DBT}
      location: ${GCP_LOCATION}
      method: service-account
      priority: interactive
      project: ${GCP_PROJECT_ID}
      threads: 4
      type: bigquery
  target: dev
EOF

echo "✓ Generated $PROFILES_FILE from .env"
echo "  - profile: ${DBT_PROFILE_NAME}"
echo "  - project: ${GCP_PROJECT_ID}"
echo "  - dataset: ${DBT_DATASET}"
echo "  - keyfile: ${GCP_CREDENTIALS_DBT}"
echo "  - location: ${GCP_LOCATION}"

