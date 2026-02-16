#!/bin/bash

echo "Uploading/updating flow to Kestra..."
curl -X PUT "http://localhost:8080/api/v1/main/flows/ingestion_homework4/gcp_taxi_ingestion_hw4" \
  -H "Content-Type: application/x-yaml" \
  -u "admin@kestra.io:Admin1234" \
  --data-binary @kestra/ingest_data.yaml | jq '.'

echo ""
echo "Flow uploaded successfully!"
echo "To ingest data, run:"
echo "  ./kestra/run_backfill_all.sh      # Both yellow and green for 2019-2020"
echo "  ./kestra/run_backfill_yellow.sh   # Yellow only"
echo "  ./kestra/run_backfill_green.sh    # Green only"