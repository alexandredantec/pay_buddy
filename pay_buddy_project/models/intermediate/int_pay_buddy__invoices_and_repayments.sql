-- int_pay_buddy__invoices_and_repayments.sql

WITH invoices AS (

SELECT * 
FROM {{ref('stg_pay_buddy__invoices')}}
)

, repayments AS (

SELECT *
FROM {{ref('stg_pay_buddy__repayments')}}
)

-- group repayments by invoice
, grouped_repayments AS (

SELECT invoice_id
, SUM(repayment_amount) AS repayment_amount
, MAX(repayment_date) AS latest_repayment_date
FROM repayments
GROUP BY 1
)

-- cross invoice and repayment information
, invoices_with_repayments AS (
  SELECT 
  i.invoice_id,
  i.buyer_id,
  i.payment_plan_id,
  i.invoice_currency,
  i.invoice_amount,
  COALESCE(repayment_amount, 0) AS repayment_amount,
  invoice_amount - COALESCE(repayment_amount, 0) AS outstanding_amount,
  i.repayment_due_date,
  r.latest_repayment_date
  FROM invoices AS i
  LEFT JOIN grouped_repayments AS r ON r.invoice_id = i.invoice_id
  
)

SELECT *
 
FROM invoices_with_repayments
