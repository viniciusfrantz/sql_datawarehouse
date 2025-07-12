WITH cte AS (
SELECT 
*  FROM dwh_gold.fact_sales
)

SELECT
    SUM(sales_amount),
    EXTRACT(YEAR FROM order_date) AS year
FROM
    cte
GROUP BY
    EXTRACT(YEAR FROM order_date)






