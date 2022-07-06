{{ config(
    query_tag = "luke_contribution_to_la_teams"
) }}

with team_locations as (
    select * from {{ ref('teams_locations') }}
),

final as (

    SELECT
        CONCAT(team_locations.CITY, ' ', team_locations.NAME) as team_locations_names,
        team_locations.NAME = '{{ var("current_champion") }}' as is_champion,
        team_locations.NAME as team_name,
        team_locations.STATE as team_state
    FROM team_locations
    WHERE TRIM(team_locations.CITY) = 'Los Angeles'
)

select *, '{{ invocation_id }}' as invocation_id from final