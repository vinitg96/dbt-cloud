SELECT
    order_id,
    SUM(total_amount) AS total_amount
FROM {{ ref('int_payment_type_amount_per_order') }}
GROUP BY 1
HAVING total_amount < 0
