-- macros/create_datasets.sql

{% macro create_datasets() %}
  {% set datasets = ["staging", "marts", "ref", "analytics"] %}
  {% for dataset in datasets %}
     CREATE SCHEMA IF NOT EXISTS  `billing-421008`.`dbt_billing_data_{{ dataset }}`;
  {% endfor %}
{% endmacro %}
