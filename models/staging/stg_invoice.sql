--{{ config(materialized='view') }}

WITH stg_invoice AS(
    SELECT
        id,
        customer_id
    FROM billing_data.invoice
    WHERE id NOT LIKE "id"
)

SELECT
    id,
    customer_id
FROM stg_invoice