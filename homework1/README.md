# Module 1 Homework: Docker & SQL

This repository contains the solutions for Module 1 homework covering Docker, PostgreSQL, and Terraform fundamentals.

## Quick Start

1. **Start the environment:**
   ```bash
   docker-compose up -d
   ```

2. **Access pgAdmin:**
   - URL: http://localhost:8085
   - Email: `admin@admin.com`
   - Password: `root`

3. **Stop the environment:**
   ```bash
   docker-compose down
   ```

## Project Structure

```
homework1/
├── docker-compose.yaml    # Docker services configuration
├── Dockerfile            # Custom Docker image definition
├── ingest_data.py        # Data ingestion script
├── pyproject.toml        # Python dependencies
└── README.md            # This file
```

---

## Question 1. Understanding Docker images

Run docker with the `python:3.13` image. Use an entrypoint `bash` to interact with the container.

What's the version of `pip` in the image?

- 25.3
- 24.3.1
- 24.2.1
- 23.3.1

### Solution

**Command:**
```bash
docker run -it --entrypoint bash python:3.13
pip --version
```

**Answer:** 25.3

## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that pgadmin should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

- postgres:5433
- localhost:5432
- db:5433
- postgres:5432
- db:5432

### Solution

**Answer:** db:5432

**Explanation:** 
- **Hostname:** `db` (the service name in docker-compose, not the container_name)
- **Port:** `5432` (internal container port, not the host-mapped port 5433)
- When containers communicate within the same Docker network, they use service names as hostnames and internal container ports, not the host-mapped ports.

## Data Setup

### Loading the NYC Green Taxi Data

1. **Start the services:**
   ```bash
   docker-compose up -d
   ```

2. **Verify in pgAdmin:**
   - Open http://localhost:8085
   - Connect to the database using credentials above
   - Execute the SQL queries below to answer the questions

## Question 3. Counting short trips

For the trips in November 2025 (lpep_pickup_datetime between '2025-11-01' and '2025-12-01', exclusive of the upper bound), how many trips had a `trip_distance` of less than or equal to 1 mile?

- 7,853
- 8,007
- 8,254
- 8,421

### Solution

**SQL Query:**
```sql
SELECT COUNT(*) AS trip_count
FROM green_taxi_data
WHERE lpep_pickup_datetime >= TIMESTAMP '2025-11-01 00:00:00'
  AND lpep_pickup_datetime <  TIMESTAMP '2025-12-01 00:00:00'
  AND trip_distance <= 1;
```

**Answer:** 8,007

## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance? Only consider trips with `trip_distance` less than 100 miles (to exclude data errors).

Use the pick up time for your calculations.

- 2025-11-14
- 2025-11-20
- 2025-11-23
- 2025-11-25

### Solution

**SQL Query:**
```sql
SELECT lpep_pickup_datetime, trip_distance
FROM green_taxi_data
WHERE trip_distance < 100
ORDER BY trip_distance DESC
LIMIT 1;
```

**Answer:** 2025-11-14

## Question 5. Biggest pickup zone

Which was the pickup zone with the largest `total_amount` (sum of all trips) on November 18th, 2025?

- East Harlem North
- East Harlem South
- Morningside Heights
- Forest Hills

### Solution

**SQL Query:**
```sql
SELECT
    zpu."Zone" AS pickup_zone,
    SUM(t.total_amount) AS total_amount
FROM green_taxi_data AS t
JOIN zones AS zpu
  ON t."PULocationID" = zpu."LocationID"
WHERE t.lpep_pickup_datetime >= TIMESTAMP '2025-11-18 00:00:00'
  AND t.lpep_pickup_datetime <  TIMESTAMP '2025-11-19 00:00:00'
GROUP BY zpu."Zone"
ORDER BY total_amount DESC
LIMIT 1;
```

**Answer:** East Harlem North

## Question 6. Largest tip

For the passengers picked up in the zone named "East Harlem North" in November 2025, which was the drop off zone that had the largest tip?

Note: it's `tip` , not `trip`. We need the name of the zone, not the ID.

- JFK Airport
- Yorkville West
- East Harlem North
- LaGuardia Airport

### Solution

**SQL Query:**
```sql
SELECT
    t.tip_amount,
    zpu."Zone" AS pickup_zone,
    zdo."Zone" AS dropoff_zone
FROM green_taxi_data AS t
JOIN zones AS zpu
  ON t."PULocationID" = zpu."LocationID"
JOIN zones AS zdo
  ON t."DOLocationID" = zdo."LocationID"
WHERE t.lpep_pickup_datetime >= TIMESTAMP '2025-11-01 00:00:00'
  AND t.lpep_pickup_datetime <  TIMESTAMP '2025-12-01 00:00:00'
  AND zpu."Zone" = 'East Harlem North'
ORDER BY t.tip_amount DESC
LIMIT 1;
```

**Answer:** Yorkville West

---

## Terraform Section

## Question 7. Terraform Workflow

Which of the following sequences, respectively, describes the workflow for:
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

Answers:
- terraform import, terraform apply -y, terraform destroy
- teraform init, terraform plan -auto-apply, terraform rm
- terraform init, terraform run -auto-approve, terraform destroy
- terraform init, terraform apply -auto-approve, terraform destroy
- terraform import, terraform apply -y, terraform rm

### Solution

**Answer:** `terraform init`, `terraform apply -auto-approve`, `terraform destroy`