alter table flybys
add speed_kms numeric(10,3),
add target_altitude numeric(10,3),
add transit_distance numeric(10,3);

-- calculate b
-- select id,
--   altitude,
--   (altitude + 252) as total_altitude, -- this is b
--   ((altitude + 252) / sind(73)) - 252 as target_altitude -- c
-- from flybys;
update flybys
set target_altitude=(
  (altitude + 252) / sind(73)
) - 252;
update flybys
set transit_distance=(
  (target_altitude + 252) * sind(17) * 2
);
