SELECT * FROM bronze.erp__px_cat_g1v2;
-- id = AC_BC
SELECT * FROM silver.crm__prd_info;
-- cat_id - AC_BC

SELECT
    id
FROM
    bronze.erp__px_cat_g1v2
WHERE id NOT IN (SELECT cat_id FROM silver.crm__prd_info)
-- There is one value that is not in CRM system, maybe it
-- CO_PD is the only one different checking the osite CO_PE should be CO_


SELECT
    DISTINCT subcat
FROM bronze.erp__px_cat_g1v2
ORDER BY subcat;
-- ok, 4 categories distincts

SELECT DISTINCT maintenence FROM bronze.erp__px_cat_g1v2;
-- ok just 2 values



SELECT
    CASE 
        WHEN id = 'CO_PD' THEN 'CO_PE'
        ELSE id
    END AS id,
    TRIM(cat) AS cat,
    TRIM(subcat) AS subcat,
    TRIM(maintenence) AS maintenence
FROM
    bronze.erp__px_cat_g1v2



