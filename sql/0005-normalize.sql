insert into events(
  time_stamp,
  title,
  description,
  event_type_id,
  spass_type_id,
  target_id,
  team_id,
  request_id
)
select
  import.master_plan.start_time_utc::timestamp,
  import.master_plan.title,
  import.master_plan.description,
  event_types.id as event_type_id,
  spass_types.id as spass_types_id,
  targets.id as target_id,
  teams.id as teams_id,
  requests.id as requests_id
from import.master_plan
left join event_types
  on event_types.description
  = import.master_plan.library_definition
left join targets
  on targets.description
  = import.master_plan.target
left join teams
  on teams.description
  = import.master_plan.team
left join requests
  on requests.description
  = import.master_plan.request_name
left join spass_types
  on spass_types.description
  = import.master_plan.spass_type;
