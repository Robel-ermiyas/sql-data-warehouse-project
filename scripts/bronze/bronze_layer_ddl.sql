/*
=============================================================
Bronze Layer: Raw Ingestion Tables
=============================================================

Description:
    This script creates the raw ingestion tables for the bronze layer.
    It uses IF NOT EXISTS checks to avoid errors if tables already exist.
    These tables store source system data in its raw format.

Notes:
    - No primary keys on business columns (keeping raw data intact)
    - Add ingest_timestamp if needed to track row ingestion times
=============================================================
*/

-- ===========================
-- CRM Customer Info Table
-- ===========================
CREATE TABLE IF NOT EXISTS bronze.crm_cust_info( 
    cst_id INT,
    cst_key VARCHAR(50),
    cst_first_name VARCHAR(50),
    cst_last_name VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date DATE
);

-- ===========================
-- CRM Product Info Table
-- ===========================
CREATE TABLE IF NOT EXISTS bronze.crm_prd_info(
    prd_id INT,
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt TIMESTAMP,
    prd_end_dt TIMESTAMP
);

-- ===========================
-- CRM Sales Details Table
-- ===========================
CREATE TABLE IF NOT EXISTS bronze.crm_sales_details(
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
);

-- ===========================
-- ERP Customer Table
-- ===========================
CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12(
    CID VARCHAR(50),
    BDATE DATE,
    GEN VARCHAR(50)
);

-- ===========================
-- ERP Location Table
-- ===========================
CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101(
    cid VARCHAR(50),
    cntry VARCHAR(50)
);

-- ===========================
-- ERP Product Category Table
-- ===========================
CREATE TABLE IF NOT EXISTS bronze.erp_px_cat_g1v2(
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50)
);
