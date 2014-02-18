create view weekly_totals as
select
	sum(duration*modifier) as total
	,clock_name
	,week_begin_date
from clock c
join clock_time ct
	on ct.clock_id=c.clock_id
join Date_Dimension d
	on d.date_key=ct.start_day
group by clock_name
	,week_begin_date;