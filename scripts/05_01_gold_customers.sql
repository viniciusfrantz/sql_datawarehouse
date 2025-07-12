
SELECT * FROM dwh_gold.dim_customers;

SELECT * FROM datawarehouse.dwh_gold.dim_customers;

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
    FROM silver.crm__cust_info ci -- Master table
    LEFT JOIN silver.erp__cust_az12 ca --avoid using Inner
        ON ci.cst_key = ca.cid
    LEFT JOIN silver.erp__loc_a101 la
        ON ci.cst_key = la.cid)

SELECT 
    gender, 
    COUNT(*)
FROM cte
GROUP BY (gender)
ORDER BY gender


SELECT customer_id, COUNT(*) FROM
(
SELECT
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_key,
    ci.cst_first_name AS first_name,
    ci.cst_last_name AS last_name,
    ci.cst_marital_status AS marital_status,
    CASE 
        WHEN ci.cst_gndr <> 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END as gender,
    ca.bdate AS birth_date,
    ca.gen AS erp_gender,
    la.cntry AS country
FROM silver.crm__cust_info ci -- Master table
LEFT JOIN silver.erp__cust_az12 ca --avoid using Inner
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp__loc_a101 la
    ON ci.cst_key = la.cid
) t 
GROUP BY customer_id
HAVING COUNT(*)>1
-- OK no duplicates after join

SELECT DISTINCT
    ci.cst_gndr,
    ca.gen 
FROM silver.crm__cust_info ci -- Master table
LEFT JOIN silver.erp__cust_az12 ca --avoid using Inner
    ON ci.cst_key = ca.cid
ORDER BY 
    ci.cst_gndr,
    ca.gen 

/* "cst_gndr","gen"
"Female","Female"
"Female","Male"
"Female","n/a"
"Male","Female"
"Male","Male"
"Male","n/a"
"n/a","Female"
"n/a","Male"
"n/a","n/a"
*/
-- The master is CRM (is more accurate)
