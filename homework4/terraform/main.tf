terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}


resource "google_storage_bucket" "ny-taxi-bucket" {
  name          = var.gcs_bucket_name
  location      = var.location
  force_destroy = true
}

resource "google_bigquery_dataset" "ny-taxi-dataset" {
  dataset_id                = var.bq_dataset_name
  location                  = var.location
  delete_contents_on_destroy = true
}

resource "google_bigquery_dataset" "dbt-dataset" {
  dataset_id                = var.dbt_dataset_name
  location                  = var.location
  delete_contents_on_destroy = true
}

# Note: Tables (yellow_tripdata, green_tripdata, fhv_tripdata) are created and managed
# by the Kestra workflow (ingest_data.yaml) which:
# - Downloads CSV files from https://github.com/DataTalksClub/nyc-tlc-data/releases
# - Uploads to GCS bucket
# - Creates BigQuery tables using external tables + merge pattern
# - Handles deduplication via MD5 hash unique_row_id
# This approach provides consistent schemas and prevents duplicate data.
#
# dbt models are built on top of these raw tables and stored in the dbt dataset.