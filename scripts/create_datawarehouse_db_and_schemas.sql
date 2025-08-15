/*
=============================================================
PostgreSQL Database & Schema Setup Script
=============================================================

Description:
    This script:
      1. Drops the 'data_warehouse' database if it exists.
      2. Creates a fresh 'data_warehouse' database.
      3. Creates three logical schemas within it:
         - bronze : Raw data ingestion layer
         - silver : Cleaned & standardized data
         - gold   : Curated analytics-ready data

Warning:
    ⚠ Running this script will delete ALL data in the existing 
      'data_warehouse' database. Ensure you have backups 
      before executing.

PostgreSQL Notes:
    - The DROP DATABASE statement cannot be run while connected
      to the target database. Start this script from another 
      database connection (e.g., 'postgres').
    - The '\c' command is a psql meta-command for reconnecting.
      In pgAdmin, you may need to run schema creation separately 
      after reconnecting.

=============================================================
*/

-- ================================================
-- 1. Drop the database if it exists
-- ================================================
DROP DATABASE IF EXISTS data_warehouse;

-- ================================================
-- 2. Create the database
-- ================================================
CREATE DATABASE data_warehouse
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    CONNECTION LIMIT = -1;

-- ================================================
-- 3. Connect to the new database
-- ================================================
-- In psql:
\c data_warehouse

-- In pgAdmin:
-- Manually reconnect to 'data_warehouse' before running the schema creation section below.

-- ================================================
-- 4. Create schemas
-- ================================================
CREATE SCHEMA IF NOT EXISTS bronze AUTHORIZATION postgres;
COMMENT ON SCHEMA bronze IS 'Raw data ingestion layer. Stores data as received from source systems.';

CREATE SCHEMA IF NOT EXISTS silver AUTHORIZATION postgres;
COMMENT ON SCHEMA silver IS 'Cleaned and standardized data layer. Data is transformed into consistent formats and structures.';

CREATE SCHEMA IF NOT EXISTS gold AUTHORIZATION postgres;
COMMENT ON SCHEMA gold IS 'Curated analytics-ready data layer. Optimized for reporting, BI, and data science.';
