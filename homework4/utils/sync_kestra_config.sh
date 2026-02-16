#!/bin/bash
# Script to generate Kestra KV configuration from .env file

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "Error: .env file not found!"
    echo "Please copy .env.example to .env and configure your values."
    exit 1
fi

# Load environment variables from .env
set -a
source .env
set +a

# Generate set_kvs.yaml
cat > kestra/set_kvs.yaml << EOF
id: set_gcp_kvs
namespace: ${KESTRA_NAMESPACE}
description: Set GCP configuration values in KV store

tasks:
  - id: set_project_id
    type: io.kestra.plugin.core.kv.Set
    key: GCP_PROJECT_ID
    value: ${GCP_PROJECT_ID}
    namespace: ${KESTRA_NAMESPACE}
    overwrite: true

  - id: set_location
    type: io.kestra.plugin.core.kv.Set
    key: GCP_LOCATION
    value: ${GCP_LOCATION}
    namespace: ${KESTRA_NAMESPACE}
    overwrite: true

  - id: set_bucket_name
    type: io.kestra.plugin.core.kv.Set
    key: GCP_BUCKET_NAME
    value: ${GCP_BUCKET_NAME}
    namespace: ${KESTRA_NAMESPACE}
    overwrite: true

  - id: set_dataset
    type: io.kestra.plugin.core.kv.Set
    key: GCP_DATASET
    value: ${GCP_DATASET}
    namespace: ${KESTRA_NAMESPACE}
    overwrite: true

  - id: verify_kvs
    type: io.kestra.plugin.core.log.Log
    message: |
      KVs have been set successfully:
      - GCP_PROJECT_ID: {{ kv('GCP_PROJECT_ID') }}
      - GCP_LOCATION: {{ kv('GCP_LOCATION') }}
      - GCP_BUCKET_NAME: {{ kv('GCP_BUCKET_NAME') }}
      - GCP_DATASET: {{ kv('GCP_DATASET') }}
      
      Note: GCP credentials should be referenced directly as:
      serviceAccount: /app/gcp-key.json
EOF

echo "✓ Generated kestra/set_kvs.yaml from .env"
echo "Run './kestra/run_set_kvs.sh' to upload to Kestra"
