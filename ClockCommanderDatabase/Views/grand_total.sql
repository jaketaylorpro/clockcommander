create view grand_total as
select
	sum(duration*modifier) as grand_total
from clock c
join clock_time ct
	on ct.clock_id=c.clock_id;