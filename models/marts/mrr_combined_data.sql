-- Creating a new table using invoice_items and currency_conversion tables
-- Transformations --> all the columns from invoice_items table + conversion_rate matching to currency + amount_eur + date parts (period_start)

WITH mrr_combined_data AS(
    SELECT 
        ii.invoice_id,
        ii.invoice_item_id,
        ii.type,
        ii.period_start,
        ii.period_end,
        DATE_DIFF(ii.period_end, ii.period_start, DAY) AS days_between,
        ii.amount,
        ii.currency,
        cc.conversion_rate,
        (ii.amount / cc.conversion_rate) AS amount_eur,
        {{get_date_parts('period_start')}} AS date_extract

    FROM {{ ref("stg_invoice_items") }} ii
    JOIN {{ ref("currency_conversion")}} cc ON cc.currency = ii.currency
)

SELECT *
FROM mrr_combined_data
ORDER BY period_start ASC