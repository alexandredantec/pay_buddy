-- stg_pay_buddy__invoices.sql

WITH

source AS (

    SELECT * FROM {{ source('pay_buddy_schema', 'raw_invoices') }}

),

renamed AS (

    SELECT
        -- ids
        ID AS invoice_id,
        Buyer_ID AS buyer_id,
        CONCAT('PP-', Payment_Plan_ID) AS payment_plan_id,

        -- strings
        Currency AS invoice_currency,

        -- floats
        CAST(Amount AS FLOAT64) AS invoice_amount,

        --dates
        PARSE_DATE('%d/%m/%Y',  Due_Date) AS repayment_due_date

    FROM source

)

SELECT * FROM renamed
