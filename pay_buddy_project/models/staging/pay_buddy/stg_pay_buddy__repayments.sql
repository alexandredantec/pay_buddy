-- stg_pay_buddy__repayments.sql

WITH

source AS (

    SELECT * FROM {{ source('pay_buddy_schema', 'raw_repayments') }}

),

renamed AS (

    SELECT
        -- ids
        ID AS repayment_id,
        Invoice_ID AS invoice_id,

        -- strings
        Currency AS repayment_currency,

        -- floats
        CAST(Amount AS FLOAT64) AS repayment_amount,

        --dates
        PARSE_DATE('%d/%m/%Y',  Date) AS repayment_date

    FROM source

)

SELECT * FROM renamed
