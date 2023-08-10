-- invoices.sql

WITH invoices_and_repayments AS (
SELECT * 
FROM {{ref('int_pay_buddy__invoices_and_repayments')}}
)

, payment_plans AS (
SELECT *
FROM {{ref('int_pay_buddy__payment_plan_decisions')}}
)

, invoices_with_terms AS (
    SELECT 
  i.invoice_id,
  i.buyer_id,
  i.payment_plan_id,
  i.invoice_currency,
  i.invoice_amount,
  i.repayment_amount,
  i.outstanding_amount,
  p.term_in_days,
  IF(outstanding_amount = 0, 0, DATE_DIFF(CURRENT_DATE(),  i.repayment_due_date, DAY)) AS overdue_duration_in_days,
  i.repayment_due_date,
  DATE_SUB(i.repayment_due_date, INTERVAL p.term_in_days DAY) AS invoice_creation_date,
  i.latest_repayment_date
  FROM invoices_and_repayments AS i
  JOIN payment_plans AS p ON p.payment_plan_id = i.payment_plan_id 
)

SELECT *
 
FROM invoices_with_terms