{{ config(
    tags=["gold"]
) }}


WITH cte AS
(
    SELECT
    
        ci.cst_id AS customer_id,
        ci.cst_key AS customer_key,
        ci.cst_first_name AS first_name,
        ci.cst_last_name AS last_name,
        la.cntry AS country,
        ci.cst_marital_status AS marital_status,
        CASE 
            WHEN ci.cst_gndr <> 'n/a' THEN ci.cst_gndr
            ELSE COALESCE(ca.gen, 'n/a')
        END as gender,
        ca.bdate AS birth_date,
        ci.cst_create_date AS create_date
    
    FROM {{ref('crm__cust_info')}} AS ci -- Master table

    LEFT JOIN {{ref('erp__cust_az12')}} AS ca --avoid using Inner
        ON ci.cst_key = ca.cid

    LEFT JOIN {{ref('erp__loc_a101')}} la
        ON ci.cst_key = la.cid
)

SELECT * FROM cte