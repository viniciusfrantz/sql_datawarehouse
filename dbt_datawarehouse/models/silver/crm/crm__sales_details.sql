WITH silver_crm__sales_detals AS
(
SELECT * 
FROM {{source('crm', 'crm__sales_details')}}
)

SELECT
    TRIM(sls_ord) AS sls_ord,
    TRIM(sls_prd_key) AS sls_prd_key,
    sls_cust_id,
    CASE
        WHEN sls_order_dt <19000101 THEN NULL
        ELSE
        (
            SUBSTRING(sls_order_dt::TEXT, 1,4)|| '-' || 
            SUBSTRING(sls_order_dt::TEXT, 5,2)|| '-' ||
            SUBSTRING(sls_order_dt::TEXT, 7,2)
        )::DATE 
    END AS sls_order_dt,
    CASE
        WHEN sls_ship_dt <19000101 THEN NULL
        ELSE
        (
            SUBSTRING(sls_ship_dt::TEXT, 1,4)|| '-' ||
            SUBSTRING(sls_ship_dt::TEXT, 5,2)|| '-' ||
            SUBSTRING(sls_ship_dt::TEXT, 7,2)
        )::DATE 
    END AS sls_ship_dt, 
    CASE
        WHEN sls_due_dt <19000101 THEN NULL
        ELSE
        (
            SUBSTRING(sls_due_dt::TEXT, 1,4)|| '-' ||
            SUBSTRING(sls_due_dt::TEXT, 5,2)|| '-' ||
            SUBSTRING(sls_due_dt::TEXT, 7,2)
        )::DATE 
    END AS sls_due_dt,
    CASE 
        WHEN sls_sales<0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    CASE
        WHEN sls_price>0 THEN sls_price
        ELSE sls_sales/NULLIF(sls_quantity, 0)
    END AS sls_price,
    sls_quantity,
    CURRENT_TIMESTAMP(0) AS dwh_create_date
FROM
    silver_crm__sales_detals
--the sls_prd_key is connect to crm__prd_info using prd_key