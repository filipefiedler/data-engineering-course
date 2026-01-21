#!/usr/bin/env python
# coding: utf-8

import click
import pandas as pd
from sqlalchemy import create_engine

def df_to_sql(df, tablename, engine):
    # Create table schema (no data)
    df.head(0).to_sql(
        name = tablename,
        con=engine,
        if_exists="replace"
    )
    print("Table created")

    # Insert data
    df.to_sql(
        name=tablename,
        con=engine,
        if_exists="append"
    )
    print("Inserted:", len(df))

    return None

@click.command()
@click.option('--user', default='root', help='PostgreSQL user')
@click.option('--password', default='root', help='PostgreSQL password')
@click.option('--host', default='localhost', help='PostgreSQL host')
@click.option('--port', default=5432, help='PostgreSQL port')
@click.option('--db', default='ny_taxi', help='PostgreSQL database name')

def run(user, password, host, port, db):
    """Ingest NYC taxi data into PostgreSQL database."""

    url_zones = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"
    df_zones = pd.read_csv(url_zones)

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    df_to_sql(df_zones, 'zones', engine)

    url = "https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet"
    df = pd.read_parquet(url, engine="pyarrow")

    df_to_sql(df, 'green_taxi_data', engine)

if __name__ == '__main__':
    run()