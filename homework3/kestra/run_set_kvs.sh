#!/bin/bash

echo "Uploading/updating flow to Kestra..."
curl -X POST "http://localhost:8080/api/v1/main/flows" \
  -H "Content-Type: application/x-yaml" \
  -u "admin@kestra.io:Admin1234" \
  --data-binary @kestra/set_kvs.yaml | jq '.'

echo -e "\n\nExecuting flow..."
curl -X POST "http://localhost:8080/api/v1/main/executions/ingestion_homework3/set_gcp_kvs" \
  -u "admin@kestra.io:Admin1234" | jq '.'