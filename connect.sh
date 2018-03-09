#!/bin/bash
# Will run supplied command in the database container. Default command is to
# connect to the local database with psql
COMMAND="${1:-psql -h localhost -U postgres}"

docker-compose exec database $COMMAND
