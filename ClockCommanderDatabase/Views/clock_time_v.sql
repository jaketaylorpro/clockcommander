create view clock_time_v as
select
	ct.clock_time_id
	,c.clock_id
	,c.name as clock_name
	,ct.start_time
	,ct.start_day
	,d.seconds_from_epoch as start_day_seconds
	,ct.duration
from clock c
join clock_time ct
	on ct.clock_id=c.clock_id
join Date_Dimension d
	on d.date_key=ct.start_day;
