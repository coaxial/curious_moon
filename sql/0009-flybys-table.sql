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
  select year,
  week,
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

-- The method suggested in the book results in E-xx names that
-- aren't in chronological order
-- for reference, it is:
-- update flybys set name='E-'|| id-1;
-- use a CTE instead to order the rows and add a pos column that is the position
-- in chronological order, and then set the name from the pos column rather
-- than from the id column. The where clause ensures that we are updating the same rows in each table.
with ordered as (
  select id,
  row_number() over(order by time_stamp) as pos
  from flybys
)
update flybys
set name='E-'||ordered.pos-1
from ordered
where flybys.id=ordered.id;
