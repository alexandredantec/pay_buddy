-- fees.sql

WITH orders AS (

SELECT * 
FROM {{ref('orders')}}
)

, agreements AS (

SELECT *
FROM {{ref('stg_pay_buddy__agreements')}}
)

, order_fees AS (
SELECT
GENERATE_UUID() AS fee_id,
o.merchant_id,
o.order_amount,
p.fee_percentage,
ROUND(fee_percentage / 100 * order_amount, 2) AS fee_amount
FROM orders AS o
LEFT JOIN agreements AS p ON p.agreement_id = o.agreement_id
WHERE TRUE AND o.is_accepted IS TRUE
)


SELECT
*
FROM order_fees
