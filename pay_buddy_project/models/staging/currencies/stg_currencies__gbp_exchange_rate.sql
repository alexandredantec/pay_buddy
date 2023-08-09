-- stg_currencies__gbp_exchange_rates.sql

WITH

source AS (

    SELECT * FROM {{ source('pay_buddy_schema', 'exchange_rates_base_gbp') }}

),

renamed AS (

    SELECT
        -- ids 
        GENERATE_UUID() AS unique_id,

        -- strings
        Currency AS base_currency,

        --floats
        Price AS gbp_exchange_rate,

        --dates
        PARSE_DATE('%m/%d/%Y',  Date) AS exchange_rate_date
    FROM source

)

SELECT * FROM renamed
