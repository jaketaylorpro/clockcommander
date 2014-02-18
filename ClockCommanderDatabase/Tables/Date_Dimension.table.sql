create table Date_Dimension
(
	date_key integer primary key
	,full_date text
	,day_of_week integer
	,day_num_in_month integer
	,day_num_overall integer
	,day_name text
	,day_abbrev text
	,weekday_flag text
	,week_num_in_year integer
	,week_num_overall integer
	,week_begin_date text
	,week_begin_date_key integer
	,month integer
	,month_num_overall integer
	,month_name text
	,month_abbrev text
	,quarter integer
	,year integer
	,yearmo integer
	,fiscal_month integer
	,fiscal_quarter integer
	,fiscal_year integer
	,last_day_in_month_flag text
	,same_day_year_ago_date text
);