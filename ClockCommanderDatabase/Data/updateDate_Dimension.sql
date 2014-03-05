alter table date_dimension add YYYY_MM_DD text;
update date_dimension 
	set YYYY_MM_DD=substr(date_key,1,4) 
		|| '-' || substr(date_key,5,2)
		|| '-' || substr(date_key,7,2);

alter table date_dimension add seconds_from_epoch integer;
update date_dimension
	set seconds_from_epoch=strftime('%s',date(YYYY_MM_DD));