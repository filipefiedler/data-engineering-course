#!/bin/bash

echo "Running backfills for Yellow, Green, and FHV taxis..."
echo ""

./kestra/run_backfill_yellow.sh
echo ""
echo "Waiting 5 seconds before starting green taxi backfill..."
sleep 5
echo ""
./kestra/run_backfill_green.sh
echo ""
echo "Waiting 5 seconds before starting FHV taxi backfill..."
sleep 5
echo ""
./kestra/run_backfill_fhv.sh

echo ""
echo "==========================================="
echo "All backfills started!"
echo "Yellow (2019-2020): 24 months"
echo "Green (2019-2020):  24 months"
echo "FHV (2019 only):    12 months"
echo "Total:              60 files"
echo ""
echo "Check Kestra UI to monitor progress"
echo "==========================================="
