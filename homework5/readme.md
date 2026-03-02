bruin.yml and assets/
# Homework 5 – Bruin Pipeline Quiz

This homework contains a set of questions to test your understanding of Bruin pipeline structure, materialization strategies, variables, dependencies, quality checks, and commands. Read each question carefully and select the best answer.

---

## Questions

### 1. Bruin Pipeline Structure
In a Bruin project, what are the required files/directories? <sup>(1 point)</sup>

- [ ] bruin.yml and assets/
- [x] .bruin.yml and pipeline.yml (assets can be anywhere)
- [ ] .bruin.yml and pipeline/ with pipeline.yml and assets/
- [ ] pipeline.yml and assets/ only

---

### 2. Materialization Strategies
You're building a pipeline that processes NYC taxi data organized by month based on `pickup_datetime`. Which incremental strategy is best for processing a specific interval period by deleting and inserting data for that time period? <sup>(1 point)</sup>

- [ ] append – always add new rows
- [ ] replace – truncate and rebuild entirely
- [x] time_interval – incremental based on a time column
- [ ] view – create a virtual table only

---

### 3. Pipeline Variables
You have a variable defined in `pipeline.yml`:

```yaml
variables:
	taxi_types:
		type: array
		items:
			type: string
		default: ["yellow", "green"]
```

How do you override this when running the pipeline to only process yellow taxis? <sup>(1 point)</sup>

- [ ] bruin run --taxi-types yellow
- [ ] bruin run --var taxi_types=yellow
- [x] bruin run --var 'taxi_types=["yellow"]'
- [ ] bruin run --set taxi_types=["yellow"]

---

### 4. Running with Dependencies
You've modified the `ingestion/trips.py` asset and want to run it plus all downstream assets. Which command should you use? <sup>(1 point)</sup>

- [ ] bruin run ingestion.trips --all
- [x] bruin run ingestion/trips.py --downstream
- [ ] bruin run pipeline/trips.py --recursive
- [ ] bruin run --select ingestion.trips+

---

### 5. Quality Checks
You want to ensure the `pickup_datetime` column in your trips table never has NULL values. Which quality check should you add to your asset definition? <sup>(1 point)</sup>

- [ ] name: unique
- [x] name: not_null
- [ ] name: positive
- [ ] name: accepted_values, value: [not_null]

---

### 6. Lineage and Dependencies
After building your pipeline, you want to visualize the dependency graph between assets. Which Bruin command should you use? <sup>(1 point)</sup>

- [ ] bruin graph
- [ ] bruin dependencies
- [x] bruin lineage
- [ ] bruin show

---

### 7. First-Time Run
You're running a Bruin pipeline for the first time on a new DuckDB database. What flag should you use to ensure tables are created from scratch? <sup>(1 point)</sup>

- [ ] --create
- [ ] --init
- [x] --full-refresh
- [ ] --truncate
