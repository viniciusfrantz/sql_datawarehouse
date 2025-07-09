SELECT * FROM bronze.crm__cust_info;

-- quality checks

----------------
-- cst_id column
----------------
SELECT 
*
FROM bronze.crm__cust_info
WHERE cst_id IS NULL;
-- there are 4 null cst_id values, the cst_key in this rows are not 
--the standard and all other columns are null for these rows
-- need to check with Maters
-- checking duplicates

SELECT 
*
FROM 
bronze.crm__cust_info
WHERE (cst_id) IN 
    (SELECT
        cst_id
    FROM    
        bronze.crm__cust_info
    GROUP BY
        cst_id
    HAVING COUNT(cst_id)>1)
ORDER by cst_id;
-- The difference is in the firs and last name, one duplicated
-- register have one register complete and other with null values 
-- in columns cst_first_name, cst_last_name, gender... 
-- to all given data, the last register is the better filled 
-- dupliates 29433, 29449, 29466, 29473, 29483



------ cst_key column quality checks----- 
SELECT 
*
FROM bronze.crm__cust_info
WHERE cst_key IS NULL;
-- No problems

SELECT
    cst_key,
    COUNT(*)
FROM
    bronze.crm__cust_info
GROUP BY
    cst_key
HAVING
    COUNT(*)>1
-- Same duplicates then cst_id


SELECT cst_key
FROM bronze.crm__cust_info
WHERE
    cst_key=NULL
    OR cst_key=''
    OR cst_key=' '
    OR TRIM(cst_key)<>cst_key
;
--OK, no problems

SELECT
    cst_id,
    cst_first_name
FROM
    bronze.crm__cust_info
WHERE
   cst_id IS NULL


-- Checking column cst_first_name

SELECT
    cst_id,
    cst_first_name
FROM
    bronze.crm__cust_info
WHERE
    cst_first_name IS NULL
    OR cst_first_name<>TRIM(cst_first_name)
-- the first_name is null just in the same duplicates cst_id that already had issues
-- There are a lot of first_names with a blan space before or after the name

----checking cst_lastname(need to standarize trhe column name)
SELECT
    cst_id,
    cst_lastname
FROM
    bronze.crm__cust_info
WHERE
    cst_lastname IS NULL
    OR cst_lastname<>TRIM(cst_lastname)
-- Same problem that from first_name


----- checking marital status column:

SELECT
    *
FROM
    bronze.crm__cust_info
WHERE
    cst_marital_status IS NULL
-- the issues occur in the same rows that we have troubles before

SELECT
    DISTINCT cst_marital_status
FROM
    bronze.crm__cust_info
-- The dataset has just S, M and NULL values
-- To standarizxed we will use SINGLE and Married and Use T

-- checking cst_gender column
SELECT
    DISTINCT cst_gndr
FROM
    bronze.crm__cust_info
-- Just M, F and null values
-- need to standarized M to Male and F to Female


SELECT 
    MIN(cst_create_date),
    MAX(cst_create_date)
FROM bronze.crm__cust_info
-- ALl the date are in future
-- Checking the csv, the csv has the same info, so no problems during load

----------------------------------------------------------
-- ==================================================== --
----------------------------------------------------------

-- It's necessary apply trim to cst_first_name column
-- It's necessary apply trim to cst_lastname column