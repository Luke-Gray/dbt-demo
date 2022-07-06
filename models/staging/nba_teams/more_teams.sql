{{ config(
    materialized = "ephemeral"
)}}


with teams as (
    select
        'Warriors' as team

    union all 

    select
        'Grizzles' as team
        
    union all 

    select
        'Heat' as team
        
    union all 

    select
        'Spurs' as team
)

select * from teams
    

