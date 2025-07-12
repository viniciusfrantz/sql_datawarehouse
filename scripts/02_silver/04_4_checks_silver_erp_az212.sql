SELECT * FROM bronze.erp__cust_az12;
-- cid is close to cst_key in crm__cust_info
-- NASAW000011000
SELECT cst_key from silver.crm__cust_info
--AW00011000


-- checking cid column
SELECT *
FROM bronze.erp__cust_az12
WHERE LENGTH(cid)=13;
--NASAW00011000
SELECT *
FROM bronze.erp__cust_az12
WHERE LENGTH(cid)>13;
--no values
SELECT *
FROM  bronze.erp__cust_az12
WHERE LENGTH(cid)<13;
--AW00022042

-- There are 2 patterns in cid 
---- NASAW00011000 and
----    AW00022042
--- The difference are the first 3 digits, when there is 10 digits

SELECT * FROM bronze.erp__cust_az12
WHERE cid IS NULL;
-- No null values


-- Checking bdate column
SELECT * FROM bronze.erp__cust_az12
WHERE
    bdate IS NULL OR
    bdate < DATE('1900-01-01') OR
    bdate > CURRENT_DATE
--cst_key AW00011000
-- no null values and no values before 1900
--there are data out of boundaries, with bdate greater then current_date what is impossible

SELECT DISTINCT gen FROM bronze.erp__cust_az12;
-- There are 9 diffent ways that Male and Female are descripts, 
-- includin null values and empty, this should be fixed

WITH cte AS
(
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
bronze.erp__cust_az12
)

SELECT
    *
FROM cte



SELECT * FROM silver.erp__cust_az12