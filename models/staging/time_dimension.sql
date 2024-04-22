WITH distinct_periods AS (
    SELECT DISTINCT
        period_end,
        period_start
    FROM {{ ref("stg_invoice_items") }}
)

SELECT
    period_end,
    period_start,
    EXTRACT(DAY FROM period_end) AS day,
    EXTRACT(MONTH FROM period_end) AS month,
    EXTRACT(YEAR FROM period_end) AS year,
    FORMAT_DATE('%A', period_end) AS day_of_week,
    FORMAT_DATE('%B', period_end) AS month_name,
    EXTRACT(QUARTER FROM period_end) AS quarter,
    CASE
        WHEN EXTRACT(DAYOFWEEK FROM period_end) IN (1,7) THEN TRUE
        ELSE FALSE
    END AS is_weekend
FROM distinct_periods