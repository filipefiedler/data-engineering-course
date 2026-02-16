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
  dataset_id = var.bq_dataset_name
  location   = var.location
}

# Note: Tables (yellow_tripdata, green_tripdata) are created and managed
# by the load_data_to_bq.py script using autodetect for schema flexibility.
# This approach handles parquet files with inconsistent schemas.