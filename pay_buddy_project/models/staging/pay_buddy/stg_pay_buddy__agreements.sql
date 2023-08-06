-- stg_pay_buddy__agreements.sql

WITH

source AS (

    SELECT * FROM {{ source('pay_buddy_schema', 'raw_agreements') }}

),

renamed AS (

    SELECT
        -- ids
        ID AS agreement_id,
        Merchant_ID AS merchant_id,

        --floats
        CAST(REPLACE(Fee_Percentage, '%', '') AS FLOAT64) AS fee_percentage

    FROM source

)

SELECT * FROM renamed
