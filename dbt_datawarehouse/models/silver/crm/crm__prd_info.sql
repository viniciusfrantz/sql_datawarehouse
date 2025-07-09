
WITH cte AS
(SELECT * FROM {{source('crm','crm__prd_info')}})

SELECT
    prd_id,
    prd_key AS prd_key_original,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7) AS prd_key,
    TRIM(prd_nm) AS prd_nm, -- Just to make sure that 
    COALESCE(prd_cost, 0) AS prd_cost, --Improve calculations
    CASE TRIM(UPPER(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'T' THEN 'Touring'
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
FROM cte
