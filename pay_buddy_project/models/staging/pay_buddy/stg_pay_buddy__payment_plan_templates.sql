-- stg_pay_buddy__payment_plan_templates.sql

WITH

source AS (

    SELECT * FROM {{ source('pay_buddy_schema', 'raw_payment_plan_templates') }}

),

renamed AS (

    SELECT
        -- ids
        ID AS payment_plan_template_id,
        CONCAT('C',Agreement_ID) AS agreement_id,

        -- integers
        CAST(Term AS INT64) AS term_in_days

    FROM source

)

SELECT * FROM renamed
