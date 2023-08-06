-- stg_pay_buddy__payment_plans.sql

WITH

source AS (

    SELECT * FROM {{ source('pay_buddy_schema', 'raw_payment_plans') }}

),

renamed AS (

    SELECT
        -- ids
        ID AS payment_plan_id,
        Payment_Plan_ID AS payment_plan_template_id,
        Order_ID AS order_id,
        Decision_Code AS decision_id

    FROM source

)

SELECT * FROM renamed
