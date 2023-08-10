-- merchants.sql

WITH merchant_companies AS (
  SELECT *
  FROM {{ref('int_pay_buddy__companies_and_types')}}
  
)

, merchants AS (
  SELECT
  company_id AS merchant_id,
  company_name,
  company_country,
  company_reference,
  FROM merchant_companies AS c 
  WHERE company_type = 'Merchant'
)

SELECT * FROM merchants