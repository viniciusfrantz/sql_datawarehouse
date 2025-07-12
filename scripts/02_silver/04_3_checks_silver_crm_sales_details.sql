-- ===== Quality checks - crm__sales_details table =====
-- 
SELECT * FROM bronze.crm__sales_details
WHERE sls_ord IS NULL
OR sls_ord<>TRIM(sls_ord);
-- no null sls_ord

-- Checking orders with more than 1 row
SELECT sls_ord, COUNT(*) FROM bronze.crm__sales_details 
GROUP BY sls_ord HAVING COUNT(*)>1
-- Understanding
SELECT * FROM bronze.crm__sales_details 
WHERE sls_ord IN ('SO67487', 'SO57523','SO74251');
-- OK each order can have one or more products, each row represents one item from a order

-- checking duplicates,considerring that each order and prd_key makes the primary key
SELECT sls_ord, sls_prd_key, COUNT(*) AS count_duplicates
FROM bronze.crm__sales_details 
GROUP BY sls_ord, sls_prd_key
HAVING COUNT(*)>1
--OK, no duplicates rows



-- Checking sls_prd_key column
SELECT * FROM bronze.crm__sales_details
WHERE sls_prd_key<>TRIM(sls_prd_key);

SELECT COUNT(*) AS total_count FROM bronze.crm__sales_details
UNION ALL
SELECT COUNT(*) FROM bronze.crm__sales_details
WHERE sls_prd_key IN (SELECT prd_key FROM silver.crm__prd_info)
--Testing the relation:
-- crm__sales_details(sls_prd_key) 
-- crm__prd_info(prd_key). Test OK


-- Checking sls_cust_id column
SELECT * FROM bronze.crm__sales_details WHERE sls_prd_key IS NULL;
-- OK, no null values
SELECT * FROM bronze.crm__sales_details
WHERE sls_cust_id IN (SELECT cst_id FROM silver.crm__cust_info);
-- OK all sls_cust_id has a correspond code on cust_info


-- Checking sls_order_dt, sls_ship_dt and sls_due_dt
-- The values are INT and it's making necessary one more step to transform to string, 
-- maybe is better to change Bronze Layer to String
--iT'S AN int VALUE, SHOULD BE DATE
SELECT * FROM bronze.crm__sales_details 
WHERE sls_ship_dt<sls_order_dt OR sls_due_dt<sls_order_dt;
-- OK no ship_dates< order_dt
-- OK no sls_due_dt<sls_order_dt


-- Checking sls_sales
----SUM of sales is quantity*price
----negatives, zeros, nulls are not allowed

SELECT 
    sls_sales,
    sls_quantity,
    sls_price
FROM bronze.crm__sales_details
WHERE 
    sls_sales <= 0 
    OR sls_sales IS NULL 
    OR sls_quantity <= 0
    OR sls_quantity IS NULL
    OR sls_price <= 0
    OR sls_price IS NULL
    OR sls_sales <> sls_quantity * sls_price;
-- Difference, problems in calculations, null values...
-- 1. Correct in source system
-- 2. Correct in datawarehouse
---- Sales is master, when not valid calculate from sls_price*quantity
----

select * from silver.crm__prd_info
where prd_key = 'PK-7098'

SELECT 
    sls_sales as old_sls_sales,
    CASE 
        WHEN sls_sales<0 OR sls_sales IS NULL OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_price as old_sls_price,
    CASE
        WHEN sls_price>0 THEN sls_price
        ELSE sls_sales/sls_quantity
    END AS sls_price,
    sls_quantity
FROM bronze.crm__sales_details
WHERE 
    sls_sales <= 0 
    OR sls_sales IS NULL 
    OR sls_quantity <= 0
    OR sls_quantity IS NULL
    OR sls_price <= 0
    OR sls_price IS NULL
    OR sls_sales <> sls_quantity * sls_price
    OR sls_sales=40;

SELECT * FROM bronze.crm__sales_details WHERE sls_quantity>1


SELECT * FROM bronze.crm__sales_details WHERE sls_ship_dt<sls_order_dt;

SELECT
    TRIM(sls_ord),
    TRIM(sls_prd_key),
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
    bronze.crm__sales_details



