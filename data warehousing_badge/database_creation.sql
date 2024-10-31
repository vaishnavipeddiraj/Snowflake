use role accountadmin;
GRANT OWNERSHIP ON DATABASE GARDEN_PLANTS TO ROLE sysadmin;
drop schema public;
create or replace   schema VEGGIES;
create or replace   schema FRUITS;
create or replace   schema FLOWERS;

create or replace table ROOT_DEPTH (
   ROOT_DEPTH_ID number(1), 
   ROOT_DEPTH_CODE text(1), 
   ROOT_DEPTH_NAME text(7), 
   UNIT_OF_MEASURE text(2),
   RANGE_MIN number(2),
   RANGE_MAX number(2)
   ); 

   Drop table ROOT_DEPTH;

   
insert into root_depth 
values
(
    3,
    'D',
    'Deep',
    'cm',
    60,
    90
)
;


select * from garden_plants.veggies.root_depth;
