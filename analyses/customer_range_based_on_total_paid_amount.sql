WITH fct_orders AS (
    SELECT * 
    FROM {{ ref('fct_orders') }}
),

dim_customers AS (
    SELECT * 
    FROM {{ ref('dim_customers') }}
),

total_amount_per_customer_on_orders_complete AS (
    SELECT
        cust.customer_id,
        cust.first_name,
        SUM(total_amount) AS global_paid_amount
    FROM fct_orders AS ord
    LEFT JOIN dim_customers AS cust 
        ON ord.customer_id = cust.customer_id
    WHERE ord.is_order_completed = 1
    GROUP BY cust.customer_id, cust.first_name
),

customer_range_per_paid_amount AS (
    SELECT * 
    FROM {{ ref('seed_customer_range_per_paid_amount') }}
)

SELECT
    tac.customer_id,
    tac.first_name,
    tac.global_paid_amount,
    crp.classification
FROM total_amount_per_customer_on_orders_complete AS tac
LEFT JOIN customer_range_per_paid_amount AS crp
    ON tac.global_paid_amount >= crp.min_range
    AND tac.global_paid_amount <= crp.max_range;
