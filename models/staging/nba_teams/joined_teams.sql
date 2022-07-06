{{ config(
    tags=["special"]
)}}


with base_teams as (
    select * from {{ ref('more_teams') }}
),


final as 
(
    select * 
    from base_teams as a
    left join {{ ref('la_teams') }} as b
    on a.team = b.team_name

)

select * from final