-- stg_pay_buddy__decisions.sql

WITH

source AS (

    SELECT * FROM {{ source('pay_buddy_schema', 'raw_decisions') }}

),

renamed AS (

    SELECT
        -- ids
        ID AS decision_id,

        --strings
        Type AS decision_type,
        Reason AS decision_reason

    FROM source

)

SELECT * FROM renamed
