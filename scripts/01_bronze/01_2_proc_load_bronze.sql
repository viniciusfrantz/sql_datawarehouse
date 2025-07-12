CALL bronze.load_bronze();

DROP PROCEDURE IF EXISTS bronze.load_bronze;
CREATE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS
$$

DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;

BEGIN
    start_time := clock_timestamp();
    RAISE NOTICE 'Loading Bronze Layer';

    TRUNCATE bronze.crm__cust_info;
    COPY bronze.crm__cust_info
    FROM 'C:/csv_files/source_crm/cust_info.csv'
    WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ',' 
    );

    TRUNCATE bronze.crm__prd_info;
    COPY bronze.crm__prd_info
    FROM 'C:/csv_files/source_crm/prd_info.csv'
    WITH (
        FORMAT csv,
        HEADER true,
        DELIMITER ','
    );

    TRUNCATE bronze.crm__sales_details;
    COPY bronze.crm__sales_details
    FROM 'C:/csv_files/source_crm/sales_details.csv'
    WITH(
        FORMAT csv,
        HEADER true,
        DELIMITER ','
    );

    TRUNCATE bronze.erp__cust_az12;
    COPY bronze.erp__cust_az12
    FROM 'C:/csv_files/source_erp/cust_az12.csv'
    WITH(
        FORMAT csv,
        HEADER true,
        DELIMITER ','
    );

    TRUNCATE bronze.erp__loc_a101;
    COPY bronze.erp__loc_a101
    FROM 'C:/csv_files/source_erp/loc_a101.csv'
    WITH(
        FORMAT csv,
        HEADER true,
        DELIMITER ','
    );

    TRUNCATE bronze.erp__px_cat_g1v2;
    COPY bronze.erp__px_cat_g1v2
    FROM 'C:/csv_files/source_erp/px_cat_g1v2.csv'
    WITH(
        FORMAT csv,
        HEADER true,
        DELIMITER ','
    );

    RAISE NOTICE 'Load of Bronze Layer Finished';
    end_time := clock_timestamp();
    RAISE NOTICE 'Start Time: %, End Time: %, Duration (seconds): %', 
    start_time, end_time, EXTRACT(EPOCH FROM end_time - start_time);
END;   

$$

