#!/bin/sh
# wait-for-postgres.sh
set -e
cmd="$@"
timer="5"
echo "Path is: $PATH"
echo "When postgres is available, we will run this command: $cmd"
echo "Waiting for PostgreSQL at: $POSTGRESQL_HOSTNAME"

until pg_isready -h $POSTGRESQL_HOSTNAME 2>/dev/null; do
  echo "Postgres is unavailable - sleeping for $timer seconds"
  sleep $timer
done

echo "Postgres is up - executing command"
/bin/bash $cmd
