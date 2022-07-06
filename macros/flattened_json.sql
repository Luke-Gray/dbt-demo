{% macro flattened_json(model_name, json_column) %}

{% set json_column_query %}
select distinct
    json.key as column_name

from {{ model_name}}

lateral flatten(input => json_column) json 
{% endset %}


{% set results = run_query(json_column_query) %} 

{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}



select
{{json_column}}, 
{% for column_name in results_list %}
{{json_column}}:{{ column_name }}::varchar as {{ column_name }}_flattened{% if not loop.last %}, {% endif %} 
{% endfor %}
sum(amount) as total_amount

from {{ model_name }}

{% endmacro %}