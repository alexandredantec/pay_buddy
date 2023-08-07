-- int_pay_buddy__payment_plan_decisions.sql

WITH payment_plan_templates AS (

SELECT * 
FROM {{ref('stg_pay_buddy__payment_plan_templates')}}
)

, payment_plans AS (

SELECT *
FROM {{ref('stg_pay_buddy__payment_plans')}}
)

, decisions AS (

SELECT *
FROM {{ref('stg_pay_buddy__decisions')}}
)

, payment_plans_and_decisions AS (
SELECT 
p.payment_plan_id,
p.order_id,
pp.agreement_id,
d.decision_type,
d.decision_reason,
pp.term_in_days
FROM payment_plans AS p
LEFT JOIN decisions AS d ON d.decision_id = p.decision_id
LEFT JOIN payment_plan_templates AS pp ON pp.payment_plan_template_id = p.payment_plan_template_id

)

SELECT * FROM payment_plans_and_decisions