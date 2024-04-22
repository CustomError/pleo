{% macro get_date_parts(date_column) %}

   ( SELECT STRUCT (
        --DAY
        {{ date_column }} AS original_date,
        EXTRACT(DAY FROM {{ date_column }}) AS day,
        
        --WEEK
        FORMAT_DATE('%Y-%m-%d', DATE_TRUNC({{ date_column }}, WEEK(MONDAY))) AS start_of_week,
        EXTRACT(WEEK FROM {{ date_column }}) AS week,
        EXTRACT(DAYOFWEEK FROM {{ date_column }}) AS day_of_week,
        FORMAT_DATE('%A', {{ date_column }}) AS day_of_week_name,
        CASE
            WHEN EXTRACT(DAYOFWEEK FROM {{ date_column }}) IN (1,7) THEN TRUE
            ELSE FALSE
        END AS is_weekend,
        
        --MONTH
        FORMAT_DATE('%Y-%m-%d', DATE_TRUNC({{ date_column }}, MONTH)) AS start_of_month,
        EXTRACT(MONTH FROM {{ date_column }}) AS month,
        FORMAT_DATE('%B', {{ date_column }}) AS month_name,
        
        --QUARTER
        FORMAT_DATE('%Y-%m-%d', DATE_TRUNC({{ date_column }}, QUARTER)) AS start_of_quarter,
        EXTRACT(QUARTER FROM {{ date_column }}) AS quarter,
        
        --YEAR
        FORMAT_DATE('%Y-%m-%d', DATE_TRUNC({{ date_column }}, YEAR)) AS start_of_year,
        EXTRACT(YEAR FROM {{ date_column }}) AS year,
        EXTRACT(DAYOFYEAR FROM {{ date_column }}) AS day_of_year
   ) AS extract_date
   )
{% endmacro %}
