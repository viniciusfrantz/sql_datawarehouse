SELECT
    prd_id,
    prd_key AS prd_key_original,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7) AS prd_key,
    TRIM(prd_nm), -- Just to make sure that 
    COALESCE(prd_cost, 0) AS prd_cost, --Improve calculations
    CASE TRIM(UPPER(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'T' THEN 'Touting'
        WHEN 'S' THEN 'Sport'
        WHEN 'R' THEN 'Road'
        ELSE 'n/a'
    END AS prd_line,
    prd_start_dt,
    COALESCE(
        LEAD(prd_start_dt, 1)
            OVER(PARTITION BY prd_key
                 ORDER BY prd_start_dt) - 1, 
        DATE('9999-12-12')
    )  AS prd_end_dt,
    CURRENT_TIMESTAMP(0)AS dwh_create_date --column with metadata
FROM
    bronze.crm__prd_info;

-- prd_key and prd_start_date must form the primary_key, looks like



SELECT * FROM bronze.crm__prd_info;
-- Understanding data
--prd_id numeric
-- prd_key looks to have some correlation with prd_nm
--there are 2 dates, prd_start_dt and prd_end_dt, and more then 1 row to some prd_key, like hystorical information 


-- Checking for duplicates prd_id
SELECT 
    prd_id,
    COUNT(*)
FROM
    bronze.crm__prd_info
GROUP BY
    prd_id
HAVING COUNT(*)>1
-- No duplicated prd_id
SELECT * FROM bronze.crm__prd_info WHERE prd_id IS NULL;
-- no null values

-- checking the prd_key that repeats how does that changes 
SELECT 
*
FROM
    bronze.crm__prd_info
WHERE 
    prd_key IN 
(
    SELECT 
        prd_key
    FROM
        bronze.crm__prd_info
    GROUP BY
        prd_key
    HAVING COUNT(*)>1
)
ORDER BY prd_key;
-- The prd_cost change and date and the unique identifier prd_id... Looks like hystotical information in accordance with cost and date
SELECT * FROM bronze.crm__prd_info WHERE prd_key IS NULL;
-- no null values


SELECT  * FROM bronze.crm__prd_info
SELECT * FROM bronze.erp__px_cat_g1v2 WHERE LENGTH(id)>5
-- the 5 initial digits of prd_key(AC-BC) from CRM is equal to the id from erp (AC_BC) with exception of the '-'
-- Necessary to create a new column to connect both

--Looking the integration_model is necessary to check how to make the relationship with crm__sales_details
SELECT  * FROM bronze.crm__prd_info;
SELECT  * FROM bronze.crm__sales_details WHERE sls_prd_key LIKE '%BK-M18B%';
-- The final sequence of digits from prd_key(crm__prd_info) is equal to sls_prd_key(crm__sales_info)
-- Necessary to create a new column to connect both


-- Checking prd_nm column bronze.crm__prd_info;
SELECT * FROM bronze.crm__prd_info WHERE prd_nm<>TRIM(prd_nm);
SELECT * FROM bronze.crm__prd_info WHERE prd_nm IS NULL;
-- No differences with TRIM
-- No null values

SELECT * FROM bronze.crm__prd_info WHERE prd_cost<0 OR prd_cost IS NULL
-- 2 null values -> thinking in calculation, the null values will be changed to 0

-- General check
SELECT
    *
FROM
    bronze.crm__prd_info
WHERE
    prd_id IS NULL
    OR prd_key IS NULL
    OR prd_nm IS NULL
    OR prd_cost IS NULL
    OR prd_line IS NULL

SELECT
    *
FROM
    bronze.crm__prd_info
WHERE
    prd_cost IS NULL
    OR prd_cost<0
    -- There are just 2 null prd_cost values
    -- There isn't any value smaller then 0
    -- and prd_start_date is smaller then avarage to these 2 rows


--- prd_line column
SELECT
    *
FROM
    bronze.crm__prd_info
WHERE TRIM(prd_line) <> prd_line;
-- 4 possible values M, R, S, T
-- It's necessary to use TRIM, all data from prd_line column is fixed when used trim 
-- Looking
-- In this Layer will be added names with meaning:
-- M - Mountain, S ~ Sport, R ~Road, T~Touring


SELECT
    MIN(prd_start_dt) AS min_prd_start_dt,
    MIN(prd_end_dt) AS min_prd_end_dt,
    MAX(prd_start_dt) AS max_prd_start_dt,
    MAX(prd_end_dt) AS max_prd_end_dt
FROM
    bronze.crm__prd_info

-- History of information
SELECT * FROM bronze.crm__prd_info
WHERE prd_key IN('AC-HE-HL-U509', 'AC-HE-HL-U509-R')
-- The prd_start_dt and prd_end_dt has some kinf of issue
-- e.g 
-- prd_start_dt | prd_end_dt
-- 2011-07-01   | 2007-12-28
-- 2012-07-01   | 2008-12-27
-- 2013-07-07   |  NULL
-- The start date is later than end_dt
-- If change the start by end, there are time overlap
-- figuring out, looks like the better thing to do is consider the start_dt

SELECT
    prd_key,
    prd_start_dt,
    COALESCE(
        LEAD(prd_start_dt, 1)
            OVER(PARTITION BY prd_key
                 ORDER BY prd_start_dt) - 1, 
        DATE('9999-12-12')
    )  AS prd_end_dt
FROM bronze.crm__prd_info


SELECT 
    COUNT(*),
    prd_id
FROM silver.crm__prd_info
GROUP BY prd_id
HAVING COUNT(*)>1


