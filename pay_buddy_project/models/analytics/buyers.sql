-- buyers.sql

WITH buyer_companies AS (
    SELECT *
    FROM {{ref('int_pay_buddy__companies_and_types')}}
    WHERE company_type = 'Buyer'
)

, buyers AS (
    SELECT
    company_id AS buyer_id,
    company_name,
    company_country,
    company_reference,
    FROM buyer_companies
)

SELECT * FROM buyers