-- Check to make sure there are only LA teams here

select 
    * 
from {{ ref('la_teams') }} 
where team_locations_names 
not like '%Los Angeles%'