create view weekly_grand_totals as
select
	sum(total) as grand_total
	,week_begin_date
from weekly_totals
group by week_begin_date;
