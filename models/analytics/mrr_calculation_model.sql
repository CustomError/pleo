-- Calculating mrr per day, week, month, quarter, and year

WITH converted_invoice_items AS(
SELECT
    cd.invoice_id,
    cd.type,
    cd.period_end,
    cd.days_between,
    DATE(cd.date_extract.original_date) AS period_start,
    DATE(cd.date_extract.start_of_week) AS start_week,
    DATE(cd.date_extract.start_of_month) AS start_month,
    DATE(cd.date_extract.start_of_quarter) AS start_quarter,
    DATE(cd.date_extract.start_of_year) AS start_year,
    cd.amount_eur,
    --i.customer_id
    
FROM {{ ref("mrr_combined_data") }} cd
--JOIN {{ ref('stg_invoice') }} i ON i.id = cd.invoice_id
--WHERE LOWER(type) LIKE "subscriptions"
),

mrr_per_day AS(
    SELECT 
        period_start,
        'Day' AS calculation_granularity,
        SUM(amount_eur) AS total_amount_eur,
        SUM(days_between) AS total_days,
        ROUND(SUM(amount_eur)/NULLIF(SUM(days_between),0)) AS mrr

    FROM converted_invoice_items
    GROUP BY 1
),

mrr_per_week AS(
    SELECT 
        start_week AS period_start,
        'Week' AS calculation_granularity,
        SUM(amount_eur) AS total_amount_eur,
        SUM(days_between) AS total_days,
        ROUND(SUM(amount_eur)/NULLIF(SUM(days_between),0)) AS mrr

    FROM converted_invoice_items
    GROUP BY 1
),

mrr_per_month AS(
    SELECT 
        start_month AS period_start,
        'Month' AS calculation_granularity,
        SUM(amount_eur) AS total_amount_eur,
        SUM(days_between) AS total_days,
        ROUND(SUM(amount_eur)/NULLIF(SUM(days_between),0)) AS mrr

    FROM converted_invoice_items
    GROUP BY 1
),

mrr_per_quarter AS(
    SELECT 
        start_quarter AS period_start,
        'Quarter' AS calculation_granularity,
        SUM(amount_eur) AS total_amount_eur,
        SUM(days_between) AS total_days,
        ROUND(SUM(amount_eur)/NULLIF(SUM(days_between),0)) AS mrr

    FROM converted_invoice_items
    GROUP BY 1
),

mrr_per_year AS(
    SELECT 
        start_year AS period_start,
        'Year' AS calculation_granularity,
        SUM(amount_eur) AS total_amount_eur,
        SUM(days_between) AS total_days,
        ROUND(SUM(amount_eur)/NULLIF(SUM(days_between),0)) AS mrr

    FROM converted_invoice_items
    GROUP BY 1
)

SELECT * FROM mrr_per_day
UNION ALL
SELECT * FROM mrr_per_week
UNION ALL
SELECT * FROM mrr_per_month
UNION ALL
SELECT * FROM mrr_per_quarter
UNION ALL
SELECT * FROM mrr_per_year