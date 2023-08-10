-- buyers.sql

WITH buyer_companies AS (
    SELECT *
    FROM {{ref('int_pay_buddy__companies_and_types')}}  
)

, orders AS (
  SELECT *
  FROM {{ref('orders')}} 
)

, invoices AS (
  SELECT *
  FROM {{ref('invoices')}} 
)

-- retrieve stats on orders
, aggregated_orders AS (
  SELECT 
  buyer_id,
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

-- retrieve stats on invoices 
, aggregated_invoices AS (
  SELECT 
  buyer_id,
  COUNT(DISTINCT invoice_id) AS total_invoices,
  COUNT(DISTINCT IF(NOT is_outstanding,invoice_id,NULL)) AS total_repaid_invoices,
  COUNT(DISTINCT IF(is_outstanding,invoice_id,NULL)) AS total_outstanding_invoices,
  SUM(invoice_amount) AS total_invoice_amount,
  SUM(repayment_amount) AS total_repayment_amount,
  SUM(outstanding_amount) AS total_outstanding_amount
  FROM invoices 
  GROUP BY 1
)

-- generate buyer level stats
, buyers AS (
  SELECT
  b.company_id AS buyer_id,
  b.company_name,
  b.company_country,
  b.company_reference,
  o.total_orders,
  o.total_accepted_orders,
  o.total_refused_orders,
  i.total_invoices,
  i.total_repaid_invoices,
  i.total_outstanding_invoices,
  o.total_order_amount,
  total_accepted_order_amount,
  i.total_invoice_amount,
  i.total_repayment_amount,
  i.total_outstanding_amount,
  o.first_accepted_order_date,
  o.latest_accepted_order_date
  FROM buyer_companies AS b 
  LEFT JOIN aggregated_orders AS o ON o.buyer_id = b.company_id
  LEFT JOIN aggregated_invoices AS i ON i.buyer_id = b.company_id
  WHERE TRUE AND b.company_type = 'Buyer'
)

SELECT * FROM buyers