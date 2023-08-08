-- fact_orders.sql

WITH payment_plan_decisions AS (

SELECT * 
FROM {{ref('int_pay_buddy__payment_plan_decisions')}}
)

, orders AS (

SELECT *
FROM {{ref('stg_pay_buddy__orders')}}
)

, payment_plan_decisions_grouped_by_order AS (
SELECT 
order_id,
agreement_id,
SUM(IF(decision_type = 'Accept',1,0)) AS is_accepted
FROM payment_plan_decisions 
GROUP BY 1,2
)

, orders_decisions AS (
SELECT 
o.order_id,
o.buyer_id,
o.merchant_id,
p.agreement_id,
o.order_amount,
o.order_date,
IF(is_accepted >= 1, TRUE, FALSE) AS is_accepted
FROM orders AS o
INNER JOIN payment_plan_decisions_grouped_by_order AS p ON p.order_id = o.order_id
)

SELECT
*
FROM orders_decisions
