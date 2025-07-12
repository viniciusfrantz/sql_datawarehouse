--Quality checks
SELECT * FROM bronze.crm__cust_info LIMIT 100;
-- Checking data
--  -Correct columns
--  - position in columnss
SELECT COUNT(*) FROM bronze.crm__cust_info;
-- 18494
-- The csv gile has 18495 rows, counting header, so it's good

SELECT * FROM bronze.crm__prd_info LIMIT 100;
SELECT COUNT(*) FROM bronze.crm__prd_info;
--
-- 397 rows vs 398 csv

SELECT * FROM bronze.crm__sales_details LIMIT 100;
SELECT COUNT(*) FROM bronze.crm__sales_details
--
-- 60398 vs 60399 csv

SELECT * FROM bronze.erp__cust_az12 LIMIT 100;
SELECT COUNT(*) FROM bronze.erp__cust_az12;
--
-- 18484 vs 18485 csv

SELECT * FROM bronze.erp__loc_a101 LIMIT 100;
SELECT COUNT(*) FROM bronze.erp__loc_a101;
-- 
-- 18484 cs 18485 csv 


SELECT * FROM bronze.erp__px_cat_g1v2;
SELECT COUNT(*) FROM bronze.erp__px_cat_g1v2;
-- 
--  37 rows vs 38 csv

--OK every data looks good