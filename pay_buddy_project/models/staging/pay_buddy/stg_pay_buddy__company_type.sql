-- stg_pay_buddy__company_type.sql

WITH

source AS (

    SELECT * FROM {{ source('pay_buddy_schema', 'raw_company_type') }}

),

renamed AS (

    SELECT
        -- ids
        ID AS company_type_id,

        --strings
        Description AS company_type

    FROM source

)

SELECT * FROM renamed
