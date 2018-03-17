drop table if exists flybys cascade;
create table flybys(
  id int primary key,
  name text not null,
  date date not null,
  altitude numeric(7,1),
  speed numeric(7,1)
);

copy flybys
from '/repo/data/jpl_flybys.csv'
with delimiter ',' header csv;
