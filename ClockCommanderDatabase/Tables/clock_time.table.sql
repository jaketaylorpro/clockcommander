create table clock_time
(
	clock_id integer references clock (clock_id)
	,clock_time_id integer primary key autoincrement
 	,start_day integer references dim_date
	,start_time integer not null
	,duration integer 
);