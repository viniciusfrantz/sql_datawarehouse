{{ config(
    tags=["silver"]
) }}
WITH cte AS
(
    SELECT
       *
    FROM {{source('erp', 'erp__cust_az12')}}
)

SELECT
    CASE 
        WHEN LENGTH(cid)=13 THEN SUBSTRING(cid,4)
        ELSE cid
    END AS cid,
    CASE 
        WHEN bdate > CURRENT_DATE THEN NULL
        ELSE bdate
    END AS bdate,
    CASE
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'n/a'
    END AS gen,
    CURRENT_TIMESTAMP(0) AS dwh_create_date
FROM
    cte




