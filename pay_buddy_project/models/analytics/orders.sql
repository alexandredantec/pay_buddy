-- orders.sql

WITH payment_plan_decisions AS (
SELECT * 
FROM {{ref('int_pay_buddy__payment_plan_decisions')}}
)

, orders AS (
SELECT *
FROM {{ref('stg_pay_buddy__orders')}}
)

-- retrieve whether an order has at least one accepted payment plan
, payment_plan_decisions_grouped_by_order AS (
SELECT
order_id,
agreement_id,
SUM(IF(decision_type = 'Accept',1,0)) AS is_accepted
FROM payment_plan_decisions
GROUP BY 1,2
)

-- an order with no decision row has not yet been through the credit engine, and is distinct from one that was refused
, orders_decisions AS (
SELECT
o.order_id,
o.buyer_id,
o.merchant_id,
p.agreement_id,
o.order_amount,
o.order_date,
CASE
  WHEN p.order_id IS NULL THEN 'pending'
  WHEN p.is_accepted >= 1 THEN 'accepted'
  ELSE 'refused'
END AS order_status
FROM orders AS o
LEFT JOIN payment_plan_decisions_grouped_by_order AS p ON p.order_id = o.order_id
)

SELECT
*
FROM orders_decisions
