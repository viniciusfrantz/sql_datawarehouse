WITH cte AS
(
    SELECT *
    FROM {{source('erp', 'erp__px_cat_g1v2')}}
)

SELECT
    CASE 
        WHEN id = 'CO_PD' THEN 'CO_PE'
        ELSE id
    END AS id,
    TRIM(cat) AS cat,
    TRIM(subcat) AS subcat,
    TRIM(maintenence) AS maintenence,
    CURRENT_TIMESTAMP AS dwh_create_date
FROM
    bronze.erp__px_cat_g1v2