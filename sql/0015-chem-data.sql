drop schema if exists inms cascade;
create schema inms;
create table inms.chem_data(
  name text,
  formula varchar(10),
  molecular_weight integer,
  peak integer,
  sensitivity numeric
);

copy inms.chem_data
from '/repo/data/chem_data.csv'
with delimiter ',' header csv;

drop function if exists pythag(
  numeric,
  numeric,
  numeric
);
create function pythag(
  x numeric,
  y numeric,
  z numeric,
  out numeric
) as $$
  select sqrt(
    (x * x) +
    (y * y) +
    (z * z)
  )::numeric(10,2);
$$
language sql;

select
  sclk::timestamp as time_stamp,
  source::text,
  mass_table,
  alt_t::numeric(9,2) as altitude,
  mass_per_charge::numeric(6,3),
  p_energy::numeric(7,3),
  pythag(
    sc_vel_t_scx::numeric,
    sc_vel_t_scy::numeric,
    sc_vel_t_scz::numeric
  ) as relative_speed,
  c1counts::integer as high_counts,
  c2counts::integer as low_counts
into inms.readings
from import.inms
order by time_stamp;

alter table inms.readings
add id serial primary key;

-- note that for a query to use this index, it has to have
-- matching predicates, i.e. `where altitude is not null` here
create index concurrently idx_stamps
on inms.readings(time_stamp)
where altitude is not null;
