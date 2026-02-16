#!/bin/bash
# Script to update dbt sources.yml with values from .env file

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

SOURCES_FILE="ny_taxi/models/staging/sources.yml"

if [ ! -f "$SOURCES_FILE" ]; then
    echo "Error: $SOURCES_FILE not found!"
    exit 1
fi

# Backup the original file
cp "$SOURCES_FILE" "${SOURCES_FILE}.backup"

# Update database and schema in sources.yml
sed -i "s/^    database: .*$/    database: ${GCP_PROJECT_ID}/" "$SOURCES_FILE"
sed -i "s/^    schema: .*$/    schema: ${GCP_DATASET}/" "$SOURCES_FILE"

echo "✓ Updated $SOURCES_FILE with values from .env"
echo "  - database: ${GCP_PROJECT_ID}"
echo "  - schema: ${GCP_DATASET}"
echo ""
echo "Backup saved to ${SOURCES_FILE}.backup"
