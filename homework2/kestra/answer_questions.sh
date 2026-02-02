#!/bin/bash

# Get the last execution
LAST_EXECUTION=$(curl -s -u "admin@kestra.io:Admin1234" \
  "http://localhost:8080/api/v1/main/executions/search?size=1&sort=state.startDate:DESC" | jq '.results[0]')

echo "Question 3 answer:"
echo "$LAST_EXECUTION" \
| jq -r '.taskRunList[] | select(.taskId=="question_3") | .outputs.row.row_count'

echo "Question 4 answer:"
echo "$LAST_EXECUTION" \
| jq -r '.taskRunList[] | select(.taskId=="question_4") | .outputs.row.row_count'

echo "Question 5 answer:"
echo "$LAST_EXECUTION" \
| jq -r '.taskRunList[] | select(.taskId=="question_5") | .outputs.row.row_count'