-- stg_pay_buddy__orders.sql

WITH

source AS (

    SELECT * FROM {{ source('pay_buddy_schema', 'raw_orders') }}

),

renamed AS (

    SELECT
        -- ids
        ID AS order_id,
        Buyer_ID AS buyer_id,
        Merchant_ID AS merchant_id,

        -- strings
        Currency AS order_currency,

        -- floats
        CAST(Amount AS FLOAT64) AS order_amount,

        --dates
        PARSE_DATE('%d/%m/%Y',  Date) AS order_date

    FROM source

)

SELECT * FROM renamed
