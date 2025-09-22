/*
===============================================================================
Script Name     : ddl_silver.sql
Layer           : Silver Layer
Schema          : silver
Description     : 
    This DDL script defines the structure of the Silver Layer tables 
    for the Data Warehouse in PostgreSQL.

    The Silver Layer contains cleansed and standardized data extracted 
    from the Bronze Layer. These tables are used as the staging zone 
    for business logic transformations and enrichment, before final loading 
    into the Gold Layer (analytics-ready tables).

Key Features:
    - Drops existing Silver tables if they exist (ensures idempotency).
    - Creates new Silver tables with appropriate columns and data types.
    - Includes `dwh_create_date` column in all tables to capture load timestamps.

Tables Created:
    - silver.crm_cust_info
    - silver.crm_prd_info
    - silver.crm_sales_details
    - silver.erp_loc_a101
    - silver.erp_cust_az12
    - silver.erp_px_cat_g1v2

Usage:
    Run this script before loading data into the Silver Layer.
*/

-- ===========================
-- CRM Customer Info Table
-- ===========================
DROP TABLE IF EXISTS silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            VARCHAR(50),
    cst_first_name     VARCHAR(50),
    cst_last_name      VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr           VARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- CRM Product Info Table
-- ===========================
DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          VARCHAR(50),
    prd_key         VARCHAR(50),
    prd_nm          VARCHAR(50),
    prd_cost        INT,
    prd_line        VARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- CRM Sales Details Table
-- ===========================
DROP TABLE IF EXISTS silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details (
    sls_ord_num     VARCHAR(50),
    sls_prd_key     VARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- ERP Location Table
-- ===========================
DROP TABLE IF EXISTS silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101 (
    cid             VARCHAR(50),
    cntry           VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- ERP Customer Table
-- ===========================
DROP TABLE IF EXISTS silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12 (
    cid             VARCHAR(50),
    bdate           DATE,
    gen             VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===========================
-- ERP Product Category Table
-- ===========================
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2 (
    id              VARCHAR(50),
    cat             VARCHAR(50),
    subcat          VARCHAR(50),
    maintenance     VARCHAR(50),
    dwh_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
