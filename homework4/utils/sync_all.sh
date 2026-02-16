#!/bin/bash
# Master script to sync all configuration files from .env

set -e  # Exit on error

echo "=== Syncing Configuration from .env ==="
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "Error: .env file not found!"
    echo "Please copy .env.example to .env and configure your values."
    exit 1
fi

# Sync Terraform configuration
echo "1. Syncing Terraform configuration..."
./utils/sync_terraform_config.sh
echo ""

# Sync Kestra configuration
echo "2. Syncing Kestra configuration..."
./utils/sync_kestra_config.sh
echo ""

# Sync dbt configuration
echo "3. Syncing dbt configuration..."
./utils/sync_dbt_config.sh
echo ""

# Sync dbt profiles
echo "4. Syncing dbt profiles..."
./utils/sync_profiles_config.sh
echo ""

echo "=== All configurations synced successfully! ==="
echo ""
echo "Next steps:"
echo "  - Docker Compose: Run 'docker compose up -d' (reads .env automatically)"
echo "  - Terraform: Run 'cd terraform && terraform plan'"
echo "  - Kestra: Run './kestra/run_set_kvs.sh' to upload KV values"
echo "  - dbt: Configuration updated in ny_taxi/models/staging/sources.yml"
echo "  - dbt profiles: Configuration updated in ~/.dbt/profiles.yml"
