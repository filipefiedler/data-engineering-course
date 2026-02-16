#!/bin/bash

# Remove any existing keys (files or directories) if necessary
sudo rm -rf /tmp/gcp-key-terraform.json
sudo rm -rf /tmp/gcp-key-kestra.json
sudo rm -rf /tmp/gcp-key-dbt.json

echo $GCP_CREDENTIALS_TERRAFORM > /tmp/gcp-key-terraform.json
chmod 600 /tmp/gcp-key-terraform.json

echo $GCP_CREDENTIALS_KESTRA > /tmp/gcp-key-kestra.json
chmod 600 /tmp/gcp-key-kestra.json

echo $GCP_CREDENTIALS_DBT > "/tmp/gcp-key-dbt.json"
chmod 600 /tmp/gcp-key-dbt.json