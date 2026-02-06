1. Run uv sync to synchronize the dependencies.
2. Create a service account in GCP and save it under Github Codespaces secrets as GCP_CREDENTIALS_DBT and give permissions as Bigquery Data Editor, Bigquery Job User, Bigquery User
3. Run `bash utils/set_keys.sh` to set the environment variables for dbt.
4. Run dbt init and answer the questions using the values from the service account you created in step 2.
5. Run `dbt debug` to check if the connection is successful in the folder created by dbt init.
6. Install the VS code dbt power user (optional)
7. Run `dbt run --select green_tripdata` to run the model and check if the data is loaded in BigQuery.
7. In case of error, change the location in `/home/codespace/.dbt/profiles.yml` to match the exact location of your BigQuery dataset. For example, if your dataset is in `uscentral1`, change the location to `uscentral1`.
