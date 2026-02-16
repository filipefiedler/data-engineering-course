#!/bin/bash

echo "Running backfills for both Yellow and Green taxis..."
echo ""

./kestra/run_backfill_yellow.sh
echo ""
echo "Waiting 5 seconds before starting green taxi backfill..."
sleep 5
echo ""
./kestra/run_backfill_green.sh

echo ""
echo "==========================================="
echo "Both backfills started!"
echo "Yellow + Green = 48 total files (24 months x 2 types)"
echo "Check Kestra UI to monitor progress"
echo "==========================================="
