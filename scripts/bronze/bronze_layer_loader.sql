/*
===============================================================================
Stored Procedure: bronze.load_bronze
===============================================================================
Purpose:
    Loads raw source data into the 'bronze' layer of the data warehouse.

Description:
    This stored procedure performs a full refresh of all staging (bronze) tables
    by:
      - Truncating all existing data in the bronze tables.
      - Bulk loading data from local CSV files using the PostgreSQL `COPY` command.
      - Logging the duration of each table load using `RAISE NOTICE`.
      - Wrapping each table load in a separate BEGIN...EXCEPTION block to handle
        errors gracefully and continue loading remaining tables.

Key Features:
    - Table-level error isolation (individual errors won't stop the full run).
    - Duration logging for each load step.
    - Designed for local development and testing environments.

Important Notes:
    - The file paths are absolute and local to the PostgreSQL server environment.
    - Ensure the PostgreSQL service account has read permissions on the CSV files.
    - This script assumes the bronze tables already exist with appropriate structure.

Parameters:
    None.
    This procedure does not accept any input parameters or return any output.

Execution:
    CALL bronze.load_bronze();

===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE 
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    duration NUMERIC;
	total_start_time TIMESTAMP;
	total_end_time TIMESTAMP;
	total_duration NUMERIC;
BEGIN
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Starting Bronze Layer Load...';
    RAISE NOTICE '================================================';

    -- ==========================
    -- Step 1: Truncate Tables
    -- ==========================
    BEGIN
        RAISE NOTICE '>> Truncating all bronze tables';
        TRUNCATE TABLE bronze.crm_cust_info;
        TRUNCATE TABLE bronze.crm_prd_info;
        TRUNCATE TABLE bronze.crm_sales_details;
        TRUNCATE TABLE bronze.erp_cust_az12;
        TRUNCATE TABLE bronze.erp_loc_a101;
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'Error truncating tables: %', SQLERRM;
    END;

    -- ==========================
    -- Step 2: Load CRM Tables
    -- ==========================
	
	RAISE NOTICE '================================================';
    RAISE NOTICE 'Load CRM Tables';
    RAISE NOTICE '================================================';
    
	-- crm_cust_info

	total_start_time := NOW();
    BEGIN
        start_time := NOW();
        RAISE NOTICE '>> Loading bronze.crm_cust_info';
        COPY bronze.crm_cust_info 
        FROM 'C:\Users\Dell\Documents\Sql\sql-data-warehouse-project\datasets\source_crm/cust_info.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );    
        end_time := NOW();
        duration := EXTRACT(SECOND FROM (end_time - start_time));
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN 
        RAISE WARNING 'Error loading bronze.crm_cust_info: %', SQLERRM;
    END;

	RAISE NOTICE '------------------------------------';
    
	-- crm_prd_info
    BEGIN
        start_time := NOW();
        RAISE NOTICE '>> Loading bronze.crm_prd_info';    
        COPY bronze.crm_prd_info 
        FROM 'C:\Users\Dell\Documents\Sql\sql-data-warehouse-project\datasets\source_crm/prd_info.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );
        end_time := NOW();
        duration := EXTRACT(SECOND FROM (end_time - start_time));
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'Error loading bronze.crm_prd_info: %', SQLERRM;                
    END;

	RAISE NOTICE '------------------------------------';
    
	-- crm_sales_details
    BEGIN
        start_time := NOW();
        RAISE NOTICE '>> Loading bronze.crm_sales_details';        
        COPY bronze.crm_sales_details 
        FROM 'C:\Users\Dell\Documents\Sql\sql-data-warehouse-project\datasets\source_crm/sales_details.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );
        end_time := NOW();
        duration := EXTRACT(SECOND FROM (end_time - start_time));
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN 
        RAISE WARNING 'Error loading bronze.crm_sales_details: %', SQLERRM;
    END;

    -- ==========================
    -- Step 3: Load ERP Tables
    -- ==========================
		
	RAISE NOTICE '================================================';
    RAISE NOTICE 'Load ERP Tables';
    RAISE NOTICE '================================================';
   
   -- erp_cust_az12
    BEGIN
        start_time := NOW();
        RAISE NOTICE '>> Loading bronze.erp_cust_az12';
        COPY bronze.erp_cust_az12 
        FROM 'C:\Users\Dell\Documents\Sql\sql-data-warehouse-project\datasets\source_erp/cust_az12.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );
        end_time := NOW();
        duration := EXTRACT(SECOND FROM (end_time - start_time));
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN 
        RAISE WARNING 'Error loading bronze.erp_cust_az12: %', SQLERRM;
    END;
	
	RAISE NOTICE '------------------------------------';
    
	-- erp_loc_a101
    BEGIN
        start_time := NOW();
        RAISE NOTICE '>> Loading bronze.erp_loc_a101';
        COPY bronze.erp_loc_a101 
        FROM 'C:\Users\Dell\Documents\Sql\sql-data-warehouse-project\datasets\source_erp/loc_a101.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );
        end_time := NOW();
        duration := EXTRACT(SECOND FROM (end_time - start_time));
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN 
        RAISE WARNING 'Error loading bronze.erp_loc_a101: %', SQLERRM;
    END;
	
	RAISE NOTICE '------------------------------------';
    -- erp_px_cat_g1v2
    BEGIN
        start_time := NOW();
        RAISE NOTICE '>> Loading bronze.erp_px_cat_g1v2';
        COPY bronze.erp_px_cat_g1v2 
        FROM 'C:\Users\Dell\Documents\Sql\sql-data-warehouse-project\datasets\source_erp/px_cat_g1v2.csv'
        WITH (
            FORMAT csv,
            HEADER true,
            DELIMITER ','
        );
        end_time := NOW();
        duration := EXTRACT(SECOND FROM (end_time - start_time));
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN 
        RAISE WARNING 'Error loading bronze.erp_px_cat_g1v2: %', SQLERRM;
    END;
	
	RAISE NOTICE '------------------------------------';
	
	total_end_time := NOW();
	total_duration := EXTRACT(SECOND FROM (total_end_time - total_start_time));
	
	RAISE NOTICE '>> Total Duration: % seconds', total_duration; 
    
	RAISE NOTICE '================================================';
    RAISE NOTICE 'Bronze Layer Load Completed Successfully!';
    RAISE NOTICE '================================================';

END;
$$;



