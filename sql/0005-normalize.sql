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
  master_plan.start_time_utc::timestamp,
  master_plan.title,
  master_plan.description,
  event_types.id as event_type_id,
  spass_types.id as spass_types_id,
  targets.id as target_id,
  teams.id as teams_id,
  requests.id as requests_id
from master_plan
left join event_types
  on event_types.description
  = master_plan.library_definition
left join targets
  on targets.description
  = master_plan.target
left join teams
  on teams.description
  = master_plan.team
left join requests
  on requests.description
  = master_plan.request_name
left join spass_types
  on spass_types.description
  = master_plan.spass_type;
