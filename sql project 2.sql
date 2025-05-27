 create database projects;
 use projects;
 select * from train_info;
 select * from train_schedule;
 select count(train_no) FROM train_schedule;
 
 select * from train_schedule where station_code is null;
 select * from train_schedule where station_code is not null;
 
 select distinct train_no from train_schedule;
 
 
 -- Total number of trains:

select count(distinct train_no) as total_trains from train_info;

-- Top 10 trains with the longest routes

select train_no,count(*)as total_stations from train_schedule
group by train_no
order by total_stations desc
limit 10;

-- Stations with the most train stops
select station_name,count(distinct train_no) as train_stopped
from train_schedule
group by station_name
order by train_stopped desc limit 15;

-- Trains stopping at ‘chennai’
select distinct train_no from train_schedule 
where station_name like "%chennai%";

-- Trains that pass through more than one state capital
select train_no from train_schedule
where station_name in ("chennai","mumbai","kolkata","bengaluru","delhi")
group by train_no having count(distinct station_name)>1;

-- Trains having same source and destination
select * from train_info where source_station_name=destination_station_name ;

-- 

