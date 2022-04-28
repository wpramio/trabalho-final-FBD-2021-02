#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE DATABASE ${POSTGRES_DB_NAME};
EOSQL

# Create tables
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_NAME}" -f /etc/postgresql/schema.sql
# Populate the db
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB_NAME}" -f /etc/postgresql/populate.sql
