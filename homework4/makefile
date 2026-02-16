.PHONY: start check stop restart logs clean sync-all sync-terraform sync-kestra sync-dbt sync-profiles load-data run-dbt pipeline ingest-data full-pipeline

# Configuration sync targets
sync-all:
	@echo "Syncing all configurations from .env..."
	@bash utils/sync_all.sh

sync-terraform:
	@echo "Syncing Terraform configuration from .env..."
	@bash utils/sync_terraform_config.sh

sync-kestra:
	@echo "Syncing Kestra configuration from .env..."
	@bash utils/sync_kestra_config.sh

sync-dbt:
	@echo "Syncing dbt configuration from .env..."
	@bash utils/sync_dbt_config.sh

sync-profiles:
	@echo "Syncing dbt profiles from .env..."
	@bash utils/sync_profiles_config.sh

start:
	@echo "Syncing configurations from .env..."
	@bash utils/sync_all.sh
	@echo "Setting up GCP credentials..."
	@bash utils/set_keys.sh
	@echo "✅ GCP credentials set!"
	@echo "Setting up infrastructure with Terraform..."
	@echo "Checking Terraform installation..."
	@bash terraform/install_terraform.sh
	@echo "Initializing Terraform..."
	@cd terraform && terraform init
	@echo "Applying Terraform configuration..."
	@cd terraform && terraform apply -auto-approve
	@echo "✅ Infrastructure is set up!"

load-data:
	@echo "Loading taxi data into BigQuery..."
	@python load_data_to_bq.py
	@echo "Loading green taxi Q4 data..."
	@python load_green_q4.py
	@echo "✅ All data loaded!"

run-dbt:
	@echo "Running dbt models..."
	@cd ny_taxi && dbt run
	@echo "✅ dbt models built!"

pipeline: start load-data run-dbt
	@echo "================================================"
	@echo "✅ Complete pipeline executed successfully!"
	@echo "================================================"
	@echo ""
	@echo "Infrastructure: ✅ Created (Terraform)"
	@echo "Data Loading:   ✅ Completed (BigQuery)"
	@echo "dbt Models:     ✅ Built"
	@echo ""
	@echo "Next steps:"
	@echo "  - Query tables in BigQuery"
	@echo "  - Run dbt tests: cd ny_taxi && dbt test"
	@echo "  - Generate docs: cd ny_taxi && dbt docs generate"
	@echo "================================================"

ingest-data: start
	@echo "================================================"
	@echo "Starting data ingestion to GCS using Kestra..."
	@echo "================================================"
	@echo "Starting Docker Compose..."
	@docker compose up -d
	@echo "✅ Services started!"
	@echo "Waiting for Kestra to be ready..."
	@until curl -s -u "admin@kestra.io:Admin1234" http://localhost:8080/api/v1/configs > /dev/null 2>&1; do \
		echo "  Still waiting..."; \
		sleep 5; \
	done
	@echo "✅ Kestra is ready!"
	@echo "Setting keys in Kestra..."
	@bash kestra/run_set_kvs.sh
	@echo "Uploading gcp_taxi flow to Kestra..."
	@bash kestra/run_ingest_data.sh
	@echo "Starting backfills for Yellow and Green taxis (2019-2020)..."
	@bash kestra/run_backfill_all.sh
	@echo "================================================"
	@echo "✅ Data ingestion started!"
	@echo "================================================"
	@echo ""
	@echo "Check Kestra UI at http://localhost:8080 to monitor progress"
	@echo "Credentials: admin@kestra.io / Admin1234"
	@echo ""
	@echo "Once ingestion is complete, run: make load-data"
	@echo "================================================"

full-pipeline: ingest-data load-data run-dbt
	@echo "================================================"
	@echo "✅ Complete pipeline executed successfully!"
	@echo "================================================"
	@echo ""
	@echo "Infrastructure: ✅ Created (Terraform)"
	@echo "Data Ingestion: ✅ Completed (to GCS via Kestra)"
	@echo "Data Loading:   ✅ Completed (to BigQuery)"
	@echo "dbt Models:     ✅ Built"
	@echo ""
	@echo "Next steps:"
	@echo "  - Query tables in BigQuery"
	@echo "  - Run dbt tests: cd ny_taxi && dbt test"
	@echo "  - Generate docs: cd ny_taxi && dbt docs generate"
	@echo "  - Stop services: make stop"
	@echo "================================================"

stop:
	@docker compose down