SELECT * FROM dwh_silver.crm__prd_info;

SELECT * FROM dwh_silver.erp__px_cat_g1v2;

SELECT * FROM dwh_silver.crm__sales_details;

--The cat_id from dwh_silver.crm__prd_info
-- The id dwh_silver.erp__px_cat_g1v2

WITH 
cte_dim AS
(
SELECT
    prd_id,
    prd_key,
    cat_id,
    prd_nm,
    ep.cat,
    ep.subcat,
    ep.maintenence,
    prd_line,
    prd_cost,
    prd_start_dt,
    prd_end_dt,
    ROW_NUMBER()OVER(PARTITION BY prd_key
                    ORDER BY prd_start_dt) AS rn
FROM
    dwh_silver.crm__prd_info cp
LEFT JOIN
    dwh_silver.erp__px_cat_g1v2 ep
    ON cp.cat_id=ci.id
),

dim_products AS
(
SELECT
    prd_id AS product_id,
    prd_key AS product_key,
    cat_id AS category_id,
    prd_nm AS product_name,
    cat AS category,
    subcat AS subcategory,
    maintenence AS maintenance,
    prd_line AS product_line,
    prd_cost AS product_cost,
    CASE
        WHEN rn=1 THEN DATE('2000-01-01')
        ELSE prd_start_dt
    END AS product_start_date,
    product_end_date
FROM
    cte_dim
)

SELECT
    fs.*,
    dp.*
FROM dwh_silver.crm__sales_details fs
LEFT JOIN
    dim_products dp
    ON fs.sls_prd_key=dp.prd_key
    AND fs.sls_order_dt BETWEEN dp.prd_start_dt AND prd_end_dt
