drop function if exists low_time(numeric, double precision, double precision);
create function low_time(
  alt numeric,
  yr double precision,
  wk double precision,
  out timestamp without time zone
) as $$
  select
    min(time_stamp) + ((max(time_stamp) - min(time_stamp)) /2)
  as nadir
  from flyby_altitudes
  where flyby_altitudes.altitude=alt
  and flyby_altitudes.year=yr
  and flyby_altitudes.week=wk
$$ language sql;

drop table if exists flybys;

with lows_by_week as (
  select year, week,
  min(altitude) as altitude
  from flyby_altitudes
  group by year, week
), nadirs as (
  select low_time(altitude, year, week) as time_stamp,
  altitude
  from lows_by_week
)

-- exec CTE
select nadirs.*,
  null::varchar as name,
  null::timestamp as start_time,
  null::timestamp as end_time
into flybys
from nadirs;

alter table flybys
add column id serial primary key;

-- create the flyby names using the id/primary key
-- || concatenates strings and coerces to string
update flybys
set name='E-'|| id-1;
