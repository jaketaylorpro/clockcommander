insert into clock_time(
	clock_id
	,start_day
	,start_time
	,duration)
values(
	(select clock_id from clock where clock_name='Video Games')
	,20140217
	,39600
	,5400);

insert into clock_time(
	clock_id
	,start_day
	,start_time
	,duration)
values((
	select clock_id from clock where clock_name='Cooking')
	,20140217
	,79200
	,1800);

insert into clock_time(
	clock_id
	,start_day
	,start_time
	,duration)
values(
	(select clock_id from clock where clock_name='Coding')
	,20140217
	,81000
	,10800);

insert into clock_time(
	clock_id
	,start_day
	,start_time
	,duration)
values(
	(select clock_id from clock where clock_name='Cooking')
	,20140217
	,91800
	,1800);