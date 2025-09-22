/*
===============================================================================
Stored Procedure : silver.load_silver
===============================================================================
Purpose:
    Loads cleaned and transformed data into the 'silver' layer from the 'bronze' layer.

Description:
    This procedure performs the following ETL actions:
    - Truncates silver tables.
    - Loads and transforms data from bronze schema using SQL logic (e.g., trim, replace, case).
    - Logs execution time per table using RAISE NOTICE.
    - Wraps each section with EXCEPTION blocks to ensure table-level error isolation.

Parameters:
    None

Usage:
    CALL silver.load_silver();

Author:
    Robel Ermiyas
===============================================================================
*/

CREATE OR REPLACE PROCEDURE silver.load_silver()
LANGUAGE plpgsql
AS $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    duration NUMERIC;
BEGIN
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Starting Silver Layer Load...';
    RAISE NOTICE '================================================';

    -- ========== CRM Tables ==========

    -- crm_cust_info
    BEGIN
        start_time := now();
        RAISE NOTICE '>> Truncating silver.crm_cust_info';
        TRUNCATE TABLE silver.crm_cust_info;

        RAISE NOTICE '>> Inserting into silver.crm_cust_info';
        INSERT INTO silver.crm_cust_info (
            cst_id, cst_key, cst_first_name, cst_last_name,
            cst_marital_status, cst_gndr, cst_create_date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_first_name),
            TRIM(cst_last_name),
            CASE 
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                ELSE 'n/a'
            END,
            CASE 
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END,
            cst_create_date
        FROM (
            SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE flag_last = 1;

        end_time := now();
        duration := EXTRACT(SECOND FROM end_time - start_time);
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'Error loading crm_cust_info: %', SQLERRM;
    END;

    -- crm_prd_info
    BEGIN
        start_time := now();
        RAISE NOTICE '>> Truncating silver.crm_prd_info';
        TRUNCATE TABLE silver.crm_prd_info;

        RAISE NOTICE '>> Inserting into silver.crm_prd_info';
        INSERT INTO silver.crm_prd_info (
            prd_id, prd_key, prd_nm, prd_cost,
            prd_line, prd_start_dt, prd_end_dt
        )
        SELECT
            prd_id,
            SUBSTRING(prd_key FROM 7) AS prd_key,
            prd_nm,
            COALESCE(prd_cost, 0),
            CASE 
                WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                ELSE 'n/a'
            END,
            prd_start_dt::date,
            (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day')::date
        FROM bronze.crm_prd_info;

        end_time := now();
        duration := EXTRACT(SECOND FROM end_time - start_time);
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'Error loading crm_prd_info: %', SQLERRM;
    END;

    -- crm_sales_details
    BEGIN
        start_time := now();
        RAISE NOTICE '>> Truncating silver.crm_sales_details';
        TRUNCATE TABLE silver.crm_sales_details;

        RAISE NOTICE '>> Inserting into silver.crm_sales_details';
        INSERT INTO silver.crm_sales_details (
            sls_ord_num, sls_prd_key, sls_cust_id,
            sls_order_dt, sls_ship_dt, sls_due_dt,
            sls_sales, sls_quantity, sls_price
        )
        SELECT 
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            CASE 
                WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt::text) != 8 THEN NULL
                ELSE TO_DATE(sls_order_dt::text, 'YYYYMMDD')
            END,
            CASE 
                WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt::text) != 8 THEN NULL
                ELSE TO_DATE(sls_ship_dt::text, 'YYYYMMDD')
            END,
            CASE 
                WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt::text) != 8 THEN NULL
                ELSE TO_DATE(sls_due_dt::text, 'YYYYMMDD')
            END,
            CASE 
                WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
                    THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END,
            sls_quantity,
            CASE 
                WHEN sls_price IS NULL OR sls_price <= 0 
                    THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END
        FROM bronze.crm_sales_details;

        end_time := now();
        duration := EXTRACT(SECOND FROM end_time - start_time);
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'Error loading crm_sales_details: %', SQLERRM;
    END;

    -- erp_cust_az12
    BEGIN
        start_time := now();
        RAISE NOTICE '>> Truncating silver.erp_cust_az12';
        TRUNCATE TABLE silver.erp_cust_az12;

        RAISE NOTICE '>> Inserting into silver.erp_cust_az12';
        INSERT INTO silver.erp_cust_az12 (
            cid, bdate, gen
        )
        SELECT
            CASE
                WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid FROM 4)
                ELSE cid
            END,
            CASE 
                WHEN bdate > CURRENT_DATE THEN NULL
                ELSE bdate
            END,
            CASE 
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a'
            END
        FROM bronze.erp_cust_az12;

        end_time := now();
        duration := EXTRACT(SECOND FROM end_time - start_time);
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'Error loading erp_cust_az12: %', SQLERRM;
    END;

    -- erp_loc_a101
    BEGIN
        start_time := now();
        RAISE NOTICE '>> Truncating silver.erp_loc_a101';
        TRUNCATE TABLE silver.erp_loc_a101;

        RAISE NOTICE '>> Inserting into silver.erp_loc_a101';
        INSERT INTO silver.erp_loc_a101 (
            cid, cntry
        )
        SELECT
            REPLACE(cid, '-', ''),
            CASE
                WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM(cntry) IS NULL OR TRIM(cntry) = '' THEN 'n/a'
                ELSE TRIM(cntry)
            END
        FROM bronze.erp_loc_a101;

        end_time := now();
        duration := EXTRACT(SECOND FROM end_time - start_time);
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'Error loading erp_loc_a101: %', SQLERRM;
    END;

    -- erp_px_cat_g1v2
    BEGIN
        start_time := now();
        RAISE NOTICE '>> Truncating silver.erp_px_cat_g1v2';
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        RAISE NOTICE '>> Inserting into silver.erp_px_cat_g1v2';
        INSERT INTO silver.erp_px_cat_g1v2 (
            id, cat, subcat, maintenance
        )
        SELECT id, cat, subcat, maintenance
        FROM bronze.erp_px_cat_g1v2;

        end_time := now();
        duration := EXTRACT(SECOND FROM end_time - start_time);
        RAISE NOTICE '>> Duration: % seconds', duration;
    EXCEPTION WHEN OTHERS THEN
        RAISE WARNING 'Error loading erp_px_cat_g1v2: %', SQLERRM;
    END;

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Silver Layer Load Completed Successfully!';
    RAISE NOTICE '================================================';
END;
$$;
