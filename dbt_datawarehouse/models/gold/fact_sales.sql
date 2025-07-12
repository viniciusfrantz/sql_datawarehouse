{{ config(
    tags=["gold"]
) }}

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
    
FROM {{ref('crm__sales_details')}} fs

LEFT JOIN {{ref('dim_products')}} dp
    ON
        fs.sls_prd_key=dp.product_key
        AND COALESCE(fs.sls_order_dt, DATE('2025-01-01')) BETWEEN dp.product_start_date AND dp.product_end_date