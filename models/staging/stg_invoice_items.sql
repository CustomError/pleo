--{{ config(materialized='view') }}

WITH stg_invoice_items AS(
    SELECT *
    FROM billing_data.invoice_items
)

SELECT
    invoice_id,
    id AS invoice_item_id,
    type,
    DATE(period_start) AS period_start,
    DATE(period_end) AS period_end,
    amount,
    currency
FROM stg_invoice_items