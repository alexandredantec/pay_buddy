-- payment_plans.sql

WITH payment_plan_decisions AS (

SELECT * 
FROM {{ref('int_pay_buddy__payment_plan_decisions')}}
)

, orders AS (

SELECT *
FROM {{ref('stg_pay_buddy__orders')}}
)

-- add buyer and merchant information
, payment_plans AS (
SELECT 
p.payment_plan_id,
p.order_id,
o.merchant_id,
o.buyer_id,
p.agreement_id,
p.decision_type,
p.decision_reason,
p.term_in_days
FROM payment_plan_decisions AS p
INNER JOIN orders AS o ON o.order_id = p.order_id 
)

SELECT
*
FROM payment_plans
