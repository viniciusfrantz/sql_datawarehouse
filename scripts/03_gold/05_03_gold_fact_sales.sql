SELECT
    fs.*,
    dp.*
FROM dwh_silver.crm__sales_details fs
LEFT JOIN
    dim_products dp
    ON fs.sls_prd_key=dp.prd_key
    AND fs.sls_order_dt BETWEEN dp.prd_start_dt AND prd_end_dt


--The dim_products table has hystorical information, for this readson, will be necessary apply join based on 2 
-- conditions, product_key and dates
SELECT
    fs.sls_ord AS order_number,
    fs.sls_cust_id AS customer_id,
    dp.product_id AS product_id,
    fs.sls_order_dt AS order_date,
    fs.sls_ship_dt AS ship_date,
    fs.sls_due_dt AS due_date, 
    fs.sls_quantity as quantity,
    fs.sls_price AS price,
    fs.sls_sales AS sales_amount
    
FROM dwh_silver.crm__sales_details fs

LEFT JOIN dwh_gold.dim_products dp
    ON
        fs.sls_prd_key=dp.product_key
        AND fs.sls_order_dt BETWEEN dp.product_start_date AND dp.product_end_date


