#!/bin/sh
ENV_FILE="env.json"
eval $({ cat ${ENV_FILE} 2>/dev/null || echo '{}'; } | jq -r 'to_entries|map("export \(.key)=\(.value|@sh)")|.[]')