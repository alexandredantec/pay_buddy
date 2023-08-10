-- merchants.sql

WITH merchant_companies AS (
  SELECT *
  FROM {{ref('int_pay_buddy__companies_and_types')}}  
)

, orders AS (
  SELECT *
  FROM {{ref('orders')}}  
)

, fees AS (
  SELECT *
  FROM {{ref('fees')}} 
)

-- retrieve stats on orders 
, aggregated_orders AS (
  SELECT 
  merchant_id,
  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT IF(is_accepted, order_id, NULL)) AS total_accepted_orders,
  COUNT(DISTINCT IF(NOT is_accepted, order_id, NULL)) AS total_refused_orders,
  SUM(order_amount) AS total_order_amount,
  SUM(IF(is_accepted, order_amount,0)) AS total_accepted_order_amount,
  MIN(IF(is_accepted, order_date, NULL)) AS first_accepted_order_date,
  MAX(IF(is_accepted, order_date, NULL)) AS latest_accepted_order_date
  FROM orders
  GROUP BY 1 
)

-- retrieve stats on fees
, aggregated_fees AS (
  SELECT 
  merchant_id,
  SUM(fee_amount) AS lifetime_value
  FROM fees   
  GROUP BY 1
)

-- generate merchant level stats
, merchants AS (
  SELECT
  c.company_id AS merchant_id,
  c.company_name,
  c.company_country,
  c.company_reference,
  o.total_orders,
  o.total_accepted_orders,
  o.total_refused_orders,
  o.total_order_amount,
  o.total_accepted_order_amount,
  o.first_accepted_order_date,
  o.latest_accepted_order_date,
  f.lifetime_value
  FROM merchant_companies AS c 
  LEFT JOIN aggregated_orders AS o ON o.merchant_id = c.company_id
  LEFT JOIN aggregated_fees AS f ON f.merchant_id = c.company_id
  WHERE TRUE AND c.company_type = 'Merchant'
)

SELECT * FROM merchants