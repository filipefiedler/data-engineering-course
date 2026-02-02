#!/bin/bash

echo "Uploading/updating homework questions flow to Kestra..."
curl -X POST "http://localhost:8080/api/v1/main/flows" \
  -H "Content-Type: application/x-yaml" \
  -u "admin@kestra.io:Admin1234" \
  --data-binary @kestra/homework_questions.yaml | jq '.'