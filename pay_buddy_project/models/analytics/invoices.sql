-- invoices.sql

WITH invoices AS (

SELECT * 
FROM {{ref('stg_pay_buddy__invoices')}}
)

, repayments AS (

SELECT *
FROM {{ref('stg_pay_buddy__repayments')}}
)

, grouped_repayments AS (

SELECT invoice_id
, SUM(repayment_amount) AS repayment_amount
, MAX(repayment_date) AS repayment_date
FROM repayments
GROUP BY 1
)

, invoices_with_repayments AS (
  SELECT 
  i.invoice_id,
  i.buyer_id,
  i.payment_plan_id,
  i.invoice_amount,
  COALESCE(repayment_amount, 0) AS repayment_amount,
  invoice_amount - COALESCE(repayment_amount, 0) AS outstanding_amount,
  i.invoice_currency,
  i.repayment_due_date,
  r.repayment_date
  FROM invoices AS i
  LEFT JOIN grouped_repayments AS r ON r.invoice_id = i.invoice_id
  
)

SELECT *
 
FROM invoices_with_repayments