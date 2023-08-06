-- stg_pay_buddy__companies.sql

WITH

source AS (

    SELECT * FROM {{ source('pay_buddy_schema', 'raw_companies') }}

),

renamed AS (

    SELECT
        -- ids
        ID AS company_id,
        Type_Code AS company_type_id,

        -- strings
        Name AS company_name,
        Country AS company_country,
        Ref AS company_reference

    FROM source

)

SELECT * FROM renamed
