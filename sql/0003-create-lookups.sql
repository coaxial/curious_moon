drop table if exists teams cascade;
select distinct(team)
as description
into teams
from import.master_plan;

alter table teams
add id serial primary key;

drop table if exists spass_types cascade;
select distinct(spass_type)
as description
into spass_types
from import.master_plan;

alter table spass_types
add id serial primary key;

drop table if exists targets cascade;
select distinct(target)
as description
into targets
from import.master_plan;


alter table targets
add id serial primary key;

drop table if exists event_types cascade;
select distinct(library_definition)
as description
into event_types
from import.master_plan;


alter table event_types
add id serial primary key;

drop table if exists requests cascade;
select distinct(request_name)
as description
into requests
from import.master_plan;

alter table requests
add id serial primary key;
