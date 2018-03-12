drop table if exists events;
create table events(
  id serial primary key,
  time_stamp timestamptz not null,
  title varchar(500),
  description text,
  event_type_id int references event_types(id),
  spass_type_id int references spass_types(id),
  target_id int references targets(id),
  team_id int references teams(id),
  request_id int references requests(id)
);
