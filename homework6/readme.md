# Homework 6 – PySpark Data Engineering Workflow

This project demonstrates a data engineering workflow using [PySpark](https://spark.apache.org/docs/latest/api/python/) for data processing and Jupyter Notebooks for interactive analysis. The workflow ingests NYC Taxi trip data, processes it with PySpark, and explores the data using notebooks.

## Quick Start

To launch the Jupyter environment with Spark and access the notebooks:

```bash
docker run --rm -it \
  -p 8888:8888 \
  -p 4040:4040 \
  -v "$PWD":/home/jovyan/work \
  my-pyspark-notebook
```

## Project Structure

- **data/**: Raw and processed data files
  - **raw/**: Downloaded parquet files (e.g., yellow_tripdata_2025-11.parquet)
  - **pt/**: (Reserved for partitioned or processed data)
  - **taxi_zone_lookup.csv**: NYC taxi zone lookup table
- **notebooks/**: Jupyter notebooks for data exploration and analysis
  - `03_test.ipynb`, `04_pyspark.ipynb`, `05_taxi_schema.ipynb`, `06_spark_sql.ipynb`, `questions_answers.ipynb`
  - `homework6_answers.html`: Exported notebook with answers
- **dockerfile**: Custom Docker image for Jupyter + PySpark
- **download_data.sh**: Script to download required datasets
- **readme.md**: This file

## Setup Instructions

1. Build the Docker image (if not using a prebuilt one):

   ```bash
   docker build -t my-pyspark-notebook .
   ```

2. Download the data:

   ```bash
   bash download_data.sh
   ```

3. Start the Jupyter Notebook server:

   ```bash
   docker run --rm -it \
     -p 8888:8888 \
     -p 4040:4040 \
     -v "$PWD":/home/jovyan/work \
     my-pyspark-notebook
   ```

4. Open the notebooks in your browser and follow the instructions inside each notebook to complete the homework tasks.