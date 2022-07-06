-- though we don't have the data, this is the code you'd use to flatten json in dbt
-- the json column we will flatten is "ARTIST_DATA"
{% set json_column_query %}
select distinct
    json.key as column_name-- refers to the json key, which would also be the column name 

from {{ source ('public', 'hip_hop_artists')}}

lateral flatten(input => ARTIST_DATA) json 
{% endset %}


{% set results = run_query(json_column_query) %} -- jinnja run_query function

{% if execute %}
{# Return the first column #}
{% set results_list = results.columns[0].values() %}
{% else %}
{% set results_list = [] %}
{% endif %}



select
ARTIST_DATA, -- original json key that we will need to reference via column to run for loop following
{% for column_name in results_list %}
ARTIST_DATA:{{ column_name }}::varchar as {{ column_name }}_flattened{% if not loop.last %}, {% endif %} 
-- '::varchar' will get rid of quotes on each value if imported as a string (e.g. "Eminem" to Eminem)
-- loop.last kinja gets rid of trailing commas, 'endif' statement will keep comma if it is last item
-- add '_flattened' to the end of each column iterated through
{% endfor %}
sum(amount) as total_amount

from {{ source('hip_hop_artists') }}

----------------------------------------------------------------------------------
-- WITH A MACRO TO REPLACE THE FLATTEN_JSON LOGIC, WE CAN:

with source_model as (

    {{ flattened_json(
        model_name = source('hip_hop_artists'),
        json_column = 'ARTIST_DATA'
    )
    }}
),

final (
    select
        ARTIST_DATA,
        birth_name as real_name,
        home_city as hometown,
        home_state
    from source_model

    {% if target.name == 'dev' %} --these lines win only run if we specify target
    where home_state Like 'Cal%'      -- e.g. dbt run -m joined_teams --target dev
    (% endif %)
)

select * from final

