WITH check_duplicates AS
(
SELECT
    *,
    ROW_NUMBER()OVER(PARTITION BY cst_id
                    ORDER BY cst_create_date DESC) AS rn
    FROM {{source('crm', 'crm__cust_info')}}
WHERE
    cst_id IS NOT NULL
)

SELECT
     cst_id,
     cst_key,
     TRIM(cst_first_name) AS cst_first_name,
     TRIM(cst_lastname) AS cst_last_name,
     CASE 
        WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
        WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
        ELSE 'n/a'
    END AS cst_marital_status,
    CASE 
        WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
        WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
        ELSE 'n/a'
        END AS cst_gndr,
     cst_create_date
FROM
    check_duplicates
WHERE
    rn=1