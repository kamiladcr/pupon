#!/usr/bin/env bash

docker run --network=host --name postgres -d mdillon/postgres

psql -h localhost -p 5432 -U kamila -d postgres -f db-init.sql
