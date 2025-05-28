 create database projects;
 use projects;
 select * from train_info;
 select * from train_schedule;
 select count(train_no) FROM train_schedule;
 
 select * from train_schedule where station_code is null;
 select * from train_schedule where station_code is not null;
 
 select distinct train_no from train_schedule;
 
 
 -- 1 Total number of trains:

select count(distinct train_no) as total_trains from train_info;

-- 2 Top 10 trains with the longest routes

select train_no,count(*)as total_stations from train_schedule
group by train_no
order by total_stations desc
limit 10;

-- 3 Stations with the most train stops
select station_name,count(distinct train_no) as train_stopped
from train_schedule
group by station_name
order by train_stopped desc limit 15;

-- 4 Trains stopping at ‘chennai’
select distinct train_no from train_schedule 
where station_name like "%chennai%";

-- 5  Trains that pass through more than one state capital
select train_no from train_schedule
where station_name in ("chennai","mumbai","kolkata","bengaluru","delhi")
group by train_no having count(distinct station_name)>1;

-- 6 Trains having same source and destination
select * from train_info where source_station_name=destination_station_name ;

-- 7 Trains that start and end at the same station
select t.train_no,t.train_name from train_info t
where t.source_station_name=t.destination_station_name;

-- 8 List all trains that run on Sunday and stop at more than 10 stations 
select t.train_no,t.train_name ,count(s.station_code)as stops 
from train_info t
join train_schedule s
on t.train_no=s.train_no
where t.days like "%sunday%"
group by t.train_no,t.train_name
having count(s.station_code)>10
order by stops desc
limit 10;

-- 9 Trains that do not have any "1A" or "2A" class
select train_no,train_name from train_info
where "1a"=0 and "2a"=0;

-- 10 train only run in weekdays
 select train_no,train_name from train_info
 where days not like "%saturday%" and days not like "%sunday%";	
 
 -- 11  Get all stations covered by the train with the highest total distance:
select station_name from train_schedule
where train_no=(select train_no from train_schedule
group by train_no
order by max(distance)desc limit 1);

--  12 Top 5 longest running trains by station count:
 select s.train_no,t.train_name,count(*) total_stations
 from train_schedule s
 join train_info t
 on t.train_no=s.train_no
 group  by t.train_name,s.train_no
 order by total_stations
 desc limit 5;
 
 -- 13 Latest departure time from each station
 select station_name,max(departure_time ) as latest_departure
 from train_schedule
 group by station_name;
 
