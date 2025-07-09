SELECT * FROM bronze.crm__cust_info LIMIT 100;
SELECT * FROM bronze.crm__prd_info ORDER BY prd_start_dt ;
SELECT sls_order_dt FROM bronze.crm__sales_details ORDER BY sls_order_dt;
SELECT * FROM bronze.crm__sales_details ORDER BY sls_order_dt;
--CRM prd_key from crm_prd_info and crm__sales_details, looks to connect the tables, but some differences

SELECT * FROM bronze.erp__cust_az12 LIMIT 100;
SELECT * FROM bronze.erp__loc_a101 LIMIT 100;
SELECT * FROM bronze.erp__px_cat_g1v2 LIMIT 100;
-- ERP data is static