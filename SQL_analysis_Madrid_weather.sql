-- Daily weather conditions in Madrid from 1997 to 2015
-- PostgreSQL analysis by Adrian Skowronski


-- which month has highest average temperature?
-- a list of months ordered by average temperature declinnig 

select extract(month from date) as month_number
, to_char(date, 'Month') as month_name
, round(avg(temp_mean), 2) as average_temp
from weather w 
group by month_number, month_name
order by average_temp desc;



-- how many days (%) had any precipitation event?

select 
count(case when trim(events) <> '' then 1 end) as count_days_with_precipitation
, count(events) as count_all_days
, round((cast(count(case when trim(events) <> '' then 1 end) 
as decimal(10,2)) / count(events))*100.0, 2) as ratio
from weather w ;



-- when did the gust with the highest speed hit Madrid? 
-- what was the weather on that day?
 
 select * from weather w where gust_max = (select max(gust_max) from weather w);


 
-- compare the average visibility in foggy days and cloudless days

select 
  round(avg(case when cloud_cover = 0 then visibility_mean end), 2) as avg_vis_cloudless_days
, round(avg(case when events like 'Fog%' then visibility_mean end), 2) as avg_vis_foggy_days
from weather w 
where cloud_cover = 0 or events like 'Fog%';

