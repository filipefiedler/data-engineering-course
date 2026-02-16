#!/usr/bin/env python3
"""
Load the remaining green taxi months (Sep-Dec 2019) that have different schemas.
These will be loaded into a separate table and can be unioned in dbt.
"""

from google.cloud import bigquery
from google.oauth2 import service_account

# Configuration
PROJECT_ID = "data-engineering-course-486123"
DATASET_ID = "ny_taxi_dataset_homework4"
BUCKET_NAME = "data-engineering-course-486123-homework4-bucket"
CREDENTIALS_PATH = "/tmp/gcp-key-terraform.json"

def load_remaining_months(client):
    """Load months 9-12 into a separate table."""
    
    table_id = "green_tripdata_q4"
    table_ref = f"{PROJECT_ID}.{DATASET_ID}.{table_id}"
    
    print(f"\n{'='*70}")
    print(f"Loading green taxi Q4 2019 (months with different schema)")
    print(f"{'='*70}")
    
    total_rows = 0
    successful_months = []
    failed_months = []
    
    # Load months 9-12
    for month in range(9, 13):
        month_str = f"{month:02d}"
        source_uri = f"gs://{BUCKET_NAME}/green_tripdata_2019-{month_str}.parquet"
        
        # Use WRITE_TRUNCATE for first month (9), WRITE_APPEND for others
        write_disposition = (
            bigquery.WriteDisposition.WRITE_TRUNCATE if month == 9
            else bigquery.WriteDisposition.WRITE_APPEND
        )
        
        job_config = bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.PARQUET,
            write_disposition=write_disposition,
            autodetect=True,
            schema_update_options=[
                bigquery.SchemaUpdateOption.ALLOW_FIELD_ADDITION,
                bigquery.SchemaUpdateOption.ALLOW_FIELD_RELAXATION,
            ] if month > 9 else None,
        )
        
        print(f"\n[{month-8:2d}/4] Loading 2019-{month_str}...", end=" ")
        
        try:
            load_job = client.load_table_from_uri(
                source_uri,
                table_ref,
                job_config=job_config
            )
            
            load_job.result()
            table = client.get_table(table_ref)
            
            if month == 9:
                month_rows = table.num_rows
            else:
                month_rows = table.num_rows - total_rows
            
            total_rows = table.num_rows
            successful_months.append(month)
            print(f"✓ {month_rows:,} rows")
            
        except Exception as e:
            failed_months.append(month)
            error_msg = str(e).split('\n')[0][:100]
            print(f"✗ FAILED: {error_msg}")
    
    print(f"\n{'='*70}")
    print(f"Summary for Q4 months:")
    print(f"  ✓ Successful: {len(successful_months)}/4")
    print(f"  ✗ Failed: {failed_months if failed_months else 'None'}")
    print(f"  📊 Total rows: {total_rows:,}")
    print(f"{'='*70}")
    
    if successful_months:
        print(f"\n✅ Created table: {table_id}")
        print(f"\nNext step: Update dbt to UNION green_tripdata and green_tripdata_q4")
    
    return successful_months

def main():
    credentials = service_account.Credentials.from_service_account_file(
        CREDENTIALS_PATH,
        scopes=["https://www.googleapis.com/auth/cloud-platform"],
    )
    client = bigquery.Client(credentials=credentials, project=PROJECT_ID)
    
    load_remaining_months(client)

if __name__ == "__main__":
    main()
