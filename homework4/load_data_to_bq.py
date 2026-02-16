#!/usr/bin/env python3
"""
Load parquet files from GCS into native BigQuery tables.
Native tables handle type conversions during load, unlike external tables.
"""

from google.cloud import bigquery
from google.oauth2 import service_account
import os

# Configuration
PROJECT_ID = "data-engineering-course-486123"
DATASET_ID = "ny_taxi_dataset_homework4"
BUCKET_NAME = "data-engineering-course-486123-homework4-bucket"
CREDENTIALS_PATH = "/tmp/gcp-key-terraform.json"

def load_table(client, table_id, source_uris):
    """Load parquet files from GCS into a BigQuery table."""
    
    table_ref = f"{PROJECT_ID}.{DATASET_ID}.{table_id}"
    
    job_config = bigquery.LoadJobConfig(
        source_format=bigquery.SourceFormat.PARQUET,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,  # Replace existing data
        autodetect=True,  # Let BigQuery auto-detect schema
    )
    
    print(f"\nLoading {table_id} from {source_uris}...")
    
    load_job = client.load_table_from_uri(
        source_uris,
        table_ref,
        job_config=job_config
    )
    
    # Wait for the job to complete
    try:
        load_job.result()
        
        # Get the loaded table
        table = client.get_table(table_ref)
        print(f"✓ Loaded {table.num_rows:,} rows into {table_id}")
        
        return table
    except Exception as e:
        print(f"✗ Error loading {table_id}: {e}")
        return None

def load_table_monthly(client, table_id, bucket_name, file_prefix, year):
    """Load parquet files month-by-month to handle schema inconsistencies."""
    
    table_ref = f"{PROJECT_ID}.{DATASET_ID}.{table_id}"
    
    print(f"\n{'='*70}")
    print(f"Loading {table_id} month-by-month (handling schema variations)")
    print(f"{'='*70}")
    
    total_rows = 0
    successful_months = []
    failed_months = []
    
    # First month: WRITE_TRUNCATE to clear table
    for month in range(1, 13):
        month_str = f"{month:02d}"
        source_uri = f"gs://{bucket_name}/{file_prefix}_{year}-{month_str}.parquet"
        
        # Use WRITE_TRUNCATE for first load, WRITE_APPEND for subsequent
        write_disposition = (
            bigquery.WriteDisposition.WRITE_TRUNCATE if month == 1 
            else bigquery.WriteDisposition.WRITE_APPEND
        )
        
        job_config = bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.PARQUET,
            write_disposition=write_disposition,
            autodetect=True,  # Let BigQuery detect schema for each file
            schema_update_options=[
                bigquery.SchemaUpdateOption.ALLOW_FIELD_ADDITION,
                bigquery.SchemaUpdateOption.ALLOW_FIELD_RELAXATION,  # Allow type changes (e.g., INT64 -> FLOAT64)
            ] if month > 1 else None,  # Allow schema updates after first month
        )
        
        print(f"\n[{month:2d}/12] Loading {year}-{month_str}...", end=" ")
        
        try:
            load_job = client.load_table_from_uri(
                source_uri,
                table_ref,
                job_config=job_config
            )
            
            # Wait for the job to complete
            load_job.result()
            
            # Get row count for this load
            if month == 1:
                table = client.get_table(table_ref)
                month_rows = table.num_rows
            else:
                # For appends, calculate difference
                table = client.get_table(table_ref)
                month_rows = table.num_rows - total_rows
            
            total_rows = table.num_rows
            successful_months.append(month)
            print(f"✓ {month_rows:,} rows")
            
        except Exception as e:
            failed_months.append(month)
            error_msg = str(e).split('\n')[0][:100]
            print(f"✗ FAILED: {error_msg}")
            
            # If first month fails, we can't continue
            if month == 1:
                print("\n❌ First month failed - cannot continue. Please investigate the issue.")
                return None
    
    # Summary
    print(f"\n{'='*70}")
    print(f"Summary for {table_id}:")
    print(f"  ✓ Successful months: {len(successful_months)}/12")
    print(f"  ✗ Failed months: {failed_months if failed_months else 'None'}")
    print(f"  📊 Total rows loaded: {total_rows:,}")
    print(f"{'='*70}")
    
    return client.get_table(table_ref) if successful_months else None

def main():
    # Initialize BigQuery client with credentials
    credentials = service_account.Credentials.from_service_account_file(
        CREDENTIALS_PATH,
        scopes=["https://www.googleapis.com/auth/cloud-platform"],
    )
    client = bigquery.Client(credentials=credentials, project=PROJECT_ID)
    
    print("\n" + "="*70)
    print("BigQuery Data Loader for NYC Taxi Data")
    print("="*70)
    
    # Load yellow taxi data (works with wildcard)
    yellow_source_uris = f"gs://{BUCKET_NAME}/yellow_tripdata_2019-*.parquet"
    yellow_table = load_table(client, "yellow_tripdata", yellow_source_uris)
    
    # Load green taxi data month-by-month (handles schema inconsistencies)
    green_table = load_table_monthly(
        client, 
        "green_tripdata", 
        BUCKET_NAME, 
        "green_tripdata",
        2019
    )
    
    # Final summary
    print("\n" + "="*70)
    print("FINAL SUMMARY")
    print("="*70)
    
    if yellow_table:
        print(f"✅ Yellow taxi: {yellow_table.num_rows:,} rows loaded")
    else:
        print("❌ Yellow taxi: FAILED")
    
    if green_table:
        print(f"✅ Green taxi: {green_table.num_rows:,} rows loaded")
    else:
        print("❌ Green taxi: FAILED")
    
    if yellow_table and green_table:
        print("\n🎉 All data loaded successfully!")
        print("\nNext steps:")
        print("  cd ny_taxi")
        print("  dbt run")
    else:
        print("\n⚠️  Some tables failed to load. Check errors above.")
    
    print("="*70)

if __name__ == "__main__":
    main()
