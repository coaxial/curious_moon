#!/bin/bash
# Will run supplied command in the database container. Default command is to
# connect to the local database with psql
COMMAND=${1:-psql enceladus -h localhost -U postgres}

# shellcheck disable=SC2086
docker-compose exec database $COMMAND
