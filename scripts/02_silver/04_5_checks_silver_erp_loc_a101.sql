SELECT * FROM bronze.erp__loc_a101;
-- just CID and country
-- CID has a '-' after AW

-- Checking cid column
SELECT * FROM bronze.erp__loc_a101
WHERE 
    cid IS NULL OR
    LENGTH(cid)<>11
-- All values from cid has the same length

SELECT 
    COUNT(*), 
    cid
FROM bronze.erp__loc_a101 
GROUP BY cid 
HAVING COUNT(*)>1;
-- no duplicate values


WITH cte as
(
SELECT
    REPLACE(cid, '-', '') as cid
FROM  bronze.erp__loc_a101
)
SELECT
    cid
FROM cte
WHERE cid NOT IN (SELECT cst_key FROM bronze.crm__cust_info)
-- cid is ok to link table


-- Checking cntry column
SELECT
    DISTINCT cntry
FROM 
    bronze.erp__loc_a101
ORDER BY cntry

/*
" "
"  "
"   "
"Australia"
"Canada"
"DE"
"France"
"Germany"
"United Kingdom"
"United States"
"US"
"USA"
""
*/
-- 3 differents way to USA


SELECT
    cntry as old_cntry,
    CASE
        WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
        WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
        WHEN TRIM(cntry) = '' OR  cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry
FROM bronze.erp__loc_a101
ORDER by cntry



SELECT
    REPLACE(cid, '-', '') as cid
    CASE
        WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
        WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
        WHEN TRIM(cntry) = '' OR  cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry
FROM
    bronze.erp__loc_a101