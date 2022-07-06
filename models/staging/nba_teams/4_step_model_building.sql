-- STEP 1: IMPORTS  (import sources/models like you would python packages)

with teams as (
    select * from {{ref('more_teams')}} -- or {{ source ('', '')}}
),

with team_locations as (
    select * from {{ ref('teams_locations') }}
),

-- STEP 2: CUSTOM LOGIC (usually longest section)

condensed_teams as 
(
    select * 
    from teams as a
    left join team_locations as b
    on a.team = b.team_name

),

-- STEP 3: FINAL CTE

final as (
    select 
        team,
        location,
        CITY
    from condensed_teams
),

--STEP 4: SELECT * FROM FINAL   
select * from final
-- this final makes it easy to debug, can swap out final with any cte to see exactly where
-- error occurs



--not runnable, just an example