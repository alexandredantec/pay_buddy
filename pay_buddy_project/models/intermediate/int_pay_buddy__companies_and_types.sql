-- int_pay_buddy__companies_and_types.sql

WITH companies AS (
  SELECT *
  FROM {{ref('stg_pay_buddy__companies')}}
)

, company_types AS (
  SELECT *
  FROM {{ref('stg_pay_buddy__company_type')}} 
)

, companies_and_company_types AS (
  SELECT
  c.company_id,
  c.company_name,
  c.company_country,
  c.company_reference,
  ct.company_type
  FROM companies AS c 
  INNER JOIN company_types AS ct ON ct.company_type_id = c.company_type_id
)

SELECT * FROM companies_and_company_types
