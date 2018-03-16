drop materialized view if exists flyby_altitudes;
create materialized view flyby_altitudes as
select
  (sclk::timestamp) as time_stamp,
  date_part('year', (sclk::timestamp)) as year,
  date_part('week', (sclk::timestamp)) as week,
  alt_t::numeric(10,3) as altitude
from import.inms
where target='ENCELADUS'
and alt_t is not null;

-- Monster CTE here
with lows_by_week as (
  select date_part('year', time_stamp) as year,
    date_part('week', time_stamp) as week,
    min(altitude) as altitude
  from flyby_altitudes
  group by
    date_part('year', time_stamp),
    date_part('week', time_stamp)
),
nadirs as (
  -- median timestamp to try and pinpoint nadir moment
  select (
    min(time_stamp) + (max(time_stamp) - min(time_stamp))/2
  ) as nadir,
  lows_by_week.altitude
  from flyby_altitudes, lows_by_week
  where flyby_altitudes.altitude=lows_by_week.altitude
    and date_part('year', time_stamp)=lows_by_week.year
    and date_part('week', time_stamp)=lows_by_week.week
  group by lows_by_week.altitude
  order by nadir
)
select nadir at time zone 'UTC' as nadir, altitude
from nadirs;
