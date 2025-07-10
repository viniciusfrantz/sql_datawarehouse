WITH cte AS
(
    SELECT * 
    FROM {{source('erp', 'erp__loc_a101')}}
)

    SELECT
        REPLACE(cid, '-', '') as cid,
        CASE
            WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
            WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
            WHEN TRIM(cntry) = '' OR  cntry IS NULL THEN 'n/a'
            ELSE TRIM(cntry)
        END AS cntry,
        CURRENT_TIMESTAMP(0) AS dwh_create_date
    FROM
        bronze.erp__loc_a101