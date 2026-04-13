#!/usr/bin/env bash
# Use this script to wait for a service to be ready before starting another.
# Original source: https://github.com/vishnubob/wait-for-it

set -e

host="$1"
shift
cmd="$@"

until PAGER=cat pg_isready -h "$host" -U "${POSTGRES_USER:-postgres}"; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec $cmd
