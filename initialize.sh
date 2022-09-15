#!/usr/bin/env bash

psql -h localhost -p 5432 -U kamila -d postgres -f db-init.sql
