---- Setup: creation of external table
CREATE OR REPLACE EXTERNAL TABLE `data-engineering-course-486123.ny_taxi_dataset_homework3.table_external`
OPTIONS (
  format = 'parquet',
  uris = ['gs://data-engineering-course-486123-homework3-bucket/yellow_tripdata_2024-*.parquet']
);


---- Question 1
SELECT count(*) FROM `data-engineering-course-486123.ny_taxi_dataset_homework3.table_external`;

---- Question 2
SELECT COUNT(DISTINCT(PULocationID)) FROM `data-engineering-course-486123.ny_taxi_dataset_homework3.table_external`;

---- Setup: creation of materialized table
CREATE OR REPLACE TABLE `data-engineering-course-486123.ny_taxi_dataset_homework3.table_materialized`
AS SELECT * FROM `data-engineering-course-486123.ny_taxi_dataset_homework3.table_external`;

---- Question 3
SELECT PULocationID FROM `data-engineering-course-486123.ny_taxi_dataset_homework3.table_materialized`;

SELECT PULocationID, DOLocationID FROM `data-engineering-course-486123.ny_taxi_dataset_homework3.table_materialized`;

---- Question 4
SELECT COUNT(*) FROM `data-engineering-course-486123.ny_taxi_dataset_homework3.table_materialized`
WHERE fare_amount = 0;

---- Question 5
CREATE OR REPLACE TABLE `data-engineering-course-486123.ny_taxi_dataset_homework3.table_partitioned`
PARTITION BY DATE(tpep_dropoff_datetime) CLUSTER BY VendorID AS
(SELECT * FROM `data-engineering-course-486123.ny_taxi_dataset_homework3.table_external`);

---- Question 6
SELECT DISTINCT VendorID FROM `data-engineering-course-486123.ny_taxi_dataset_homework3.table_materialized`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

SELECT DISTINCT VendorID FROM `data-engineering-course-486123.ny_taxi_dataset_homework3.table_partitioned`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

---- Question 9
SELECT COUNT(*) FROM `data-engineering-course-486123.ny_taxi_dataset_homework3.table_materialized`;
-- Number of rows is saved in the metadata

