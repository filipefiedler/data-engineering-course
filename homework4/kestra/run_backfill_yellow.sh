#!/bin/bash

echo "Creating backfill for Yellow Taxi (2019-2020)..."
curl -X PUT http://localhost:8080/api/v1/main/triggers \
  -u "admin@kestra.io:Admin1234" \
  -H "Content-Type: application/json" \
  -d '{
    "namespace": "ingestion_homework4",
    "flowId":    "gcp_taxi_ingestion_hw4",
    "triggerId": "yellow_schedule",
    "backfill":  {
      "start": "2019-01-01T00:00:00Z",
      "end":   "2020-12-31T23:59:59Z",
      "labels": [
        {
          "key": "backfill",
          "value": "true"
        }
      ]
    }
  }' | jq '.'

echo ""
echo "Yellow taxi backfill started for 2019-2020 (24 months)"
