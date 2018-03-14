drop table if exists import.cda;
create table import.cda(
  event_id text,
  impact_event_time text,
  impact_event_julian_time text,
  qp_amplitude text,
  qi_amplitude text,
  qt_amplitude text,
  qc_amplitude text,
  spacecraft_sun_distance text,
  spacecraft_saturn_distance text,
  spacecraft_x_velocity text,
  spacecraft_y_velocity text,
  spacecraft_z_velocity text,
  counter_number text,
  particle_mass text,
  particle_charge text
);

copy import.cda
from '/repo/data/cda.csv'
with delimiter ',' header csv;

drop schema if exists cda cascade;
create schema cda;
select
  event_id::integer as id,
  impact_event_time::timestamp as time_stamp,
  impact_event_time::date as impact_date,
  case counter_number
    when '**' then null
    else counter_number::integer
  end as counter,
  spacecraft_sun_distance::numeric(6,4) as sun_distance_au,
  spacecraft_saturn_distance::numeric(8,2) as saturn_distance_rads,
  spacecraft_x_velocity::numeric(6,2) as x_velocity,
  spacecraft_y_velocity::numeric(6,2) as y_velocity,
  spacecraft_z_velocity::numeric(6,2) as z_velocity,
  particle_charge::numeric(4,1),
  particle_mass::numeric(4,1)
into cda.impacts
from import.cda
order by impact_event_time::timestamp;

-- can't use the `add id serial primary key;` shorthand because the colum
-- already has an id column
create sequence cda.impacts_id_seq;
alter table cda.impacts
alter column id set default nextval('cda.impacts_id_seq');
alter table cda.impacts
add constraint impacts_pk primary key (id);
