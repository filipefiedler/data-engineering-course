# Centralized Configuration Management

This directory uses a centralized `.env` file as the single source of truth for all configuration values used across Terraform, Kestra, dbt, and Docker Compose.

## Quick Start

1. **Copy the example configuration:**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` with your values:**
   ```bash
   nano .env
   # or
   code .env
   ```

3. **Sync all configurations:**
   ```bash
   make sync-all
   ```

That's it! All your tools will now use the values from `.env`.

## Configuration File

The `.env` file contains all the configuration values you need to modify:

- `GCP_PROJECT_ID` - Your GCP project ID
- `GCP_REGION` - GCP region (e.g., us-central1)
- `GCP_LOCATION` - GCP location for resources
- `GCP_DATASET` - BigQuery dataset name
- `GCP_BUCKET_NAME` - Cloud Storage bucket name
- `GCS_STORAGE_CLASS` - Storage class (STANDARD, NEARLINE, etc.)
- `KESTRA_NAMESPACE` - Kestra namespace for workflows

## How It Works

When you run `make sync-all`, the following happens:

1. **Terraform**: Generates `terraform/terraform.tfvars` from `.env`
2. **Kestra**: Generates `kestra/set_kvs.yaml` from `.env`
3. **dbt**: Updates `ny_taxi/models/staging/sources.yml` with database/schema from `.env`
4. **Docker Compose**: Reads `.env` automatically (no sync needed)

## Make Commands

- `make sync-all` - Sync all configurations from .env
- `make sync-terraform` - Sync only Terraform configuration
- `make sync-kestra` - Sync only Kestra configuration
- `make sync-dbt` - Sync only dbt configuration
- `make start` - Sync configs, set up infrastructure, and start services

## Manual Sync Scripts

You can also run the sync scripts directly:

```bash
# Sync all configurations
./utils/sync_all.sh

# Sync individual tools
./utils/sync_terraform_config.sh
./utils/sync_kestra_config.sh
./utils/sync_dbt_config.sh
```

## Files Modified by Sync

The following files are **auto-generated** and should not be edited directly:

- `terraform/terraform.tfvars` - Generated from .env
- `kestra/set_kvs.yaml` - Generated from .env
- `ny_taxi/models/staging/sources.yml` - Database and schema fields updated from .env

**Always edit `.env` instead** and run `make sync-all` to propagate changes.

## Workflow

1. Edit `.env` with your desired configuration
2. Run `make sync-all` to propagate changes to all tools
3. For Kestra, run `./kestra/run_set_kvs.sh` to upload the KV values
4. For Terraform, run `cd terraform && terraform plan` to verify changes
5. For Docker Compose, just run `docker compose up -d` (reads .env automatically)

## Benefits

- ✅ **Single source of truth** - All config in one file
- ✅ **No duplication** - Change once, sync everywhere
- ✅ **Version control friendly** - Easy to track config changes
- ✅ **Environment-specific** - Different .env for dev/staging/prod
- ✅ **Consistent** - No more config drift between tools

## Troubleshooting

**Q: Changes not taking effect?**
Run `make sync-all` after editing `.env`

**Q: Kestra still using old values?**
Run `./kestra/run_set_kvs.sh` after syncing

**Q: Need to restore original files?**
Each sync creates `.backup` files you can restore from

**Q: Want to see what will change?**
Check the generated files after running `make sync-all`
