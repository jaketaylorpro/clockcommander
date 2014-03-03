//
//  CCDataMgr.m
//  ClockCommander
//
//  Created by Jacob Taylor on 3/2/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import "CCDataMgr.h"

@implementation CCDataMgr
@synthesize allClocks,allClockTimes;

NSString* DATABASE_NAME=@"com.jaketaylor.clockcommander.db";

NSString* TABLE_CLOCK=@"clock";
NSString* COLUMN_CLOCK_CLOCK_ID=@"clock_id";
NSString* COLUMN_CLOCK_CLOCK_NAME=@"clock_name";
NSString* COLUMN_CLOCK_MODIFIER=@"modifier";

NSString* TABLE_CLOCK_TIME=@"clock_time";
NSString* COLUMN_CLOCK_TIME_CLOCK_ID=@"clock_id";
NSString* COLUMN_CLOCK_TIME_CLOCK_TIME_ID=@"clock_time_id";
NSString* COLUMN_CLOCK_TIME_START_DAY=@"start_day";
NSString* COLUMN_CLOCK_TIME_START_TIME=@"start_time";
NSString* COLUMN_CLOCK_TIME_DURATION=@"duration";


//getters
-(CCClock *)getClockById:(int)id
{
    return [allClocks valueForKey:[@(id) stringValue]];
}
-(CCClock *)getClockByIndex:(int)index
{
    return [allClocks valueForKey:[[allClocks keyEnumerator] allObjects][index]];
}
-(CCClock *)getClockTimeById:(int)id
{
    return [allClockTimes valueForKey:[@(id) stringValue]];
}


//sql
-(void)saveClockTime:(CCClockTime *)clockTime withConnection:(sqlite3 *)connection
{
    NSString *insertStatement = [NSString stringWithFormat:
                                 @"insert into %@ (%@) values (%@)"
                                 ,TABLE_CLOCK_TIME
                                 ,[NSString stringWithFormat:
                                   @"%@,%@,%@"
                                   ,COLUMN_CLOCK_TIME_CLOCK_ID
                                   ,COLUMN_CLOCK_TIME_START_DAY
                                   ,COLUMN_CLOCK_TIME_START_TIME]
                                 ,[NSString stringWithFormat:
                                   @"%d,%d,%d"
                                   ,clockTime.clockId
                                   ,clockTime.startDay
                                   ,clockTime.startTime]];
    sqlite3_exec(connection,[insertStatement UTF8String], NULL, NULL, NULL);//TODO error handling
    return;
}
-(void)saveClock:(CCClock *)clock withConnection:(sqlite3 *)connection
{
    NSString *insertStatement = [NSString stringWithFormat:
                                 @"insert into %@ (%@) values (%@)"
                                 ,TABLE_CLOCK
                                 ,[NSString stringWithFormat:
                                   @"%@,%@"
                                   ,COLUMN_CLOCK_CLOCK_NAME
                                   ,COLUMN_CLOCK_MODIFIER]
                                 ,[NSString stringWithFormat:
                                   @"%@,%f"
                                   ,clock.name
                                   ,clock.modifier]];
    sqlite3_exec(connection,[insertStatement UTF8String], NULL, NULL, NULL);//TODO error handling
    return;
}

-(void)updateClockTime:(CCClockTime *)clockTime withConnection:(sqlite3 *)connection
{
    NSCalendar* CALENDAR_GREGORIAN = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//TODO find a way to load this just once
    NSDate* now = [NSDate date];
    NSDateComponents *nowC = [CALENDAR_GREGORIAN components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    int duration =  [nowC second] + (60 * [nowC minute]) + (60*60* [nowC hour]) - clockTime.startTime;
    NSString *updateStatement = [NSString stringWithFormat:
                                 @"update %@ set %@ = %d where %@ = %d"
                                 ,TABLE_CLOCK_TIME
                                 ,COLUMN_CLOCK_TIME_DURATION
                                 ,duration
                                 ,COLUMN_CLOCK_TIME_CLOCK_TIME_ID
                                 ,clockTime.clockTimeId];
    sqlite3_exec(connection,[updateStatement UTF8String], NULL, NULL, NULL);//TODO error handling
}
-(CCClockTime *)loadCurrentClockTimeWithConnection:(sqlite3 *)connection withCallback:(void(^)(void))callbackBlock
{
    CCClockTime *clockTime=[CCClockTime alloc];
    SingleLoadingDelagate *ld=[SingleLoadingDelagate createWithManager:self
                                                              withData:clockTime
                                                          withCallback:callbackBlock];
    NSString *selectStatement = [NSString stringWithFormat:
                                 @"select %@,%@,%@,%@ from %@ where %@ is null"
                                 ,COLUMN_CLOCK_TIME_CLOCK_TIME_ID
                                 ,COLUMN_CLOCK_TIME_CLOCK_ID
                                 ,COLUMN_CLOCK_TIME_START_DAY
                                 ,COLUMN_CLOCK_TIME_START_TIME
                                 ,TABLE_CLOCK_TIME
                                 ,COLUMN_CLOCK_TIME_DURATION];
    sqlite3_exec(connection, [selectStatement UTF8String],loadCallback,(__bridge void *)ld,nil);
    allClocks=dict;
    return clockTime;
}
int loadCallback(void *ld,int columnCount, char **values,char **columns)
{
    return [(_bridge SingleLoadingDelaget*)ld set:ld withColumnCount:columnCount withValues:values with Columns:columns];
}
-(NSMutableDictionary *)loadClocksWithConnection:(sqlite3 *)connection withCallback:(void(^)(void))callbackBlock
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:10];
    BulkLoadingDelagate *ld=[BulkLoadingDelagate createWithManager:self
                                                  withData:dict
                                                  withType:[CCClock class]
                                              withIdGetter:@selector(getClockId:)
                                              withCallback:callbackBlock];
    NSString *selectStatement = [NSString stringWithFormat:
                                 @"select %@,%@,%@ from %@"
                                 ,COLUMN_CLOCK_CLOCK_ID
                                 ,COLUMN_CLOCK_CLOCK_NAME
                                 ,COLUMN_CLOCK_MODIFIER
                                 ,TABLE_CLOCK];
    sqlite3_exec(connection, [selectStatement UTF8String],bulkLoadCallback,(__bridge void *)ld,nil);
    allClocks=dict;
    return dict;
}
-(NSMutableDictionary *)loadClockTimesWithConnection:(sqlite3 *)connection withCallback:(void(^)(void))callbackBlock
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:10];
    BulkLoadingDelagate *ld=[BulkLoadingDelagate createWithManager:self
                                                  withData:dict
                                                  withType:[CCClockTime class]
                                              withIdGetter:@selector(getClockTimeId:)
                                              withCallback:callbackBlock];
    NSString *selectStatement = [NSString stringWithFormat:
                                 @"select %@,%@,%@,%@,%@ from %@"
                                 ,COLUMN_CLOCK_TIME_CLOCK_TIME_ID
                                 ,COLUMN_CLOCK_TIME_CLOCK_ID
                                 ,COLUMN_CLOCK_TIME_START_DAY
                                 ,COLUMN_CLOCK_TIME_START_TIME
                                 ,COLUMN_CLOCK_TIME_DURATION
                                 ,TABLE_CLOCK_TIME];
    sqlite3_exec(connection, [selectStatement UTF8String],bulkLoadCallback,(__bridge void *)ld,nil);
    allClockTimes=dict;
    return dict;
}
int bulkLoadCallback(void *ld, int columnCount, char **values, char **columns)
{
    return [(__bridge BulkLoadingDelagate*)ld load:ld withColumnCount:columnCount withValues:values withColumns:columns];
}



@end
