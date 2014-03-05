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
NSString* COL_C_CLOCK_ID=@"clock_id";
NSString* COL_C_NAME=@"name";
NSString* COL_C_MODIFIER=@"modifier";

NSString* TABLE_CLOCK_TIME=@"clock_time";
NSString* COL_CT_CLOCK_ID=@"clock_id";
NSString* COL_CT_CLOCK_TIME_ID=@"clock_time_id";
NSString* COL_CT_START_DAY=@"start_day";
NSString* COL_CT_START_TIME=@"start_time";
NSString* COL_CT_DURATION=@"duration";


NSString* VIEW_GRAND_TOTAL=@"grand_total";
NSString* COL_GT_GRAND_TOTAL=@"grand_total";

NSString* VIEW_CLOCK_TIME_V=@"clock_time_v";
NSString* COL_CTV_CLOCK_ID=@"clock_id";
NSString* COL_CTV_CLOCK_NAME=@"clock_name";
NSString* COL_CTV_CLOCK_TIME_ID=@"clock_time_id";
NSString* COL_CTV_START_DAY=@"start_day";
NSString* COL_CTV_START_DAY_SECONDS=@"start_day_seconds";
NSString* COL_CTV_START_TIME=@"start_time";
NSString* COL_CTV_DURATION=@"duration";

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
    
    SaveDelagate *sd=[SaveDelagate createWithManager:self
                                          withObject:clockTime
                                          withSetter:@selector(setClock_time_id:)];
    NSString *insertStatement = [NSString stringWithFormat:
                                 @"insert into %@ (%@) values (%@);select %@"
                                 ,TABLE_CLOCK_TIME
                                 ,[NSString stringWithFormat:
                                   @"%@,%@,%@"
                                   ,COL_CT_CLOCK_ID
                                   ,COL_CT_START_DAY
                                   ,COL_CT_START_TIME]
                                 ,[NSString stringWithFormat:
                                   @"%d,%d,%d"
                                   ,clockTime.clock_id
                                   ,clockTime.start_day
                                   ,clockTime.start_time]
                                 ,@"select last_insert_rowid();"];
    sqlite3_exec(connection,[insertStatement UTF8String], saveCallback,(__bridge void *) sd, NULL);//TODO error handling
    return;
}

-(void)saveClock:(CCClock *)clock withConnection:(sqlite3 *)connection
{
    SaveDelagate *sd=[SaveDelagate createWithManager:self
                                        withObject:clock
                                          withSetter:@selector(setClock_id:)];
    NSString *insertStatement = [NSString stringWithFormat:
                                 @"insert into %@ (%@) values (%@);select %@"
                                 ,TABLE_CLOCK
                                 ,[NSString stringWithFormat:
                                   @"%@,%@"
                                   ,COL_C_NAME
                                   ,COL_C_MODIFIER]
                                 ,[NSString stringWithFormat:
                                   @"%@,%f"
                                   ,clock.name
                                   ,clock.modifier]
                                 ,@"select last_insert_rowid();"];
    sqlite3_exec(connection,[insertStatement UTF8String], saveCallback, (__bridge void *) sd, NULL);//TODO error handling
    return;
}
int saveCallback(void *sd,int columnCount, char **values,char **columns)
{
    return [(__bridge SaveDelagate *)sd set:sd withColumnCount:columnCount withValues:values withColumns:columns];
}
-(void)updateClockTime:(CCClockTime *)clockTime withConnection:(sqlite3 *)connection
{
    NSCalendar* CALENDAR_GREGORIAN = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//TODO find a way to load this just once
    NSDate* now = [NSDate date];
    NSDateComponents *nowC = [CALENDAR_GREGORIAN components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    int duration =  [nowC second] + (60 * [nowC minute]) + (60*60* [nowC hour]) - clockTime.start_time;
    NSString *updateStatement = [NSString stringWithFormat:
                                 @"update %@ set %@ = %d where %@ = %d"
                                 ,TABLE_CLOCK_TIME
                                 ,COL_CT_DURATION
                                 ,duration
                                 ,COL_CT_CLOCK_TIME_ID
                                 ,clockTime.clock_time_id];
    sqlite3_exec(connection,[updateStatement UTF8String], NULL, NULL, NULL);//TODO error handling
}
-(CCClockTime *)loadCurrentClockTimeWithConnection:(sqlite3 *)connection withCallback:(void(^)(void))callbackBlock
{
    CCClockTime *clockTime=[CCClockTime alloc];
    SingleLoadingDelagate *ld=[SingleLoadingDelagate createWithManager:self
                                                            withObject:clockTime
                                                          withCallback:callbackBlock];
    NSString *selectStatement = [NSString stringWithFormat:
                                 @"select %@,%@,%@,%@,%@,%@ from %@ where %@ is null"
                                 ,COL_CTV_CLOCK_TIME_ID
                                 ,COL_CTV_CLOCK_ID
                                 ,COL_CTV_CLOCK_NAME
                                 ,COL_CTV_START_DAY
                                 ,COL_CTV_START_DAY_SECONDS
                                 ,COL_CTV_START_TIME
                                 ,VIEW_CLOCK_TIME_V
                                 ,COL_CTV_DURATION];
    sqlite3_exec(connection, [selectStatement UTF8String],loadCallback,(__bridge void *)ld,nil);
    return clockTime;
}
int loadCallback(void *ld,int columnCount, char **values,char **columns)
{
    return [(__bridge SingleLoadingDelagate *)ld set:ld withColumnCount:columnCount withValues:values withColumns:columns];
}
-(NSMutableDictionary *)loadClocksWithConnection:(sqlite3 *)connection withCallback:(void(^)(void))callbackBlock
{
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithCapacity:10];
    BulkLoadingDelagate *ld=[BulkLoadingDelagate createWithManager:self
                                                  withData:dict
                                                  withType:[CCClock class]
                                              withIdGetter:@selector(getClock_id)
                                              withCallback:callbackBlock];
    NSString *selectStatement = [NSString stringWithFormat:
                                 @"select %@,%@,%@ from %@"
                                 ,COL_C_CLOCK_ID
                                 ,COL_C_NAME
                                 ,COL_C_MODIFIER
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
                                              withIdGetter:@selector(getClock_time_id)
                                              withCallback:callbackBlock];
    NSString *selectStatement = [NSString stringWithFormat:
                                 @"select %@,%@,%@,%@,%@ from %@"
                                 ,COL_CT_CLOCK_TIME_ID
                                 ,COL_CT_CLOCK_ID
                                 ,COL_CT_START_DAY
                                 ,COL_CT_START_TIME
                                 ,COL_CT_DURATION
                                 ,TABLE_CLOCK_TIME];
    sqlite3_exec(connection, [selectStatement UTF8String],bulkLoadCallback,(__bridge void *)ld,nil);
    allClockTimes=dict;
    return dict;
}
int bulkLoadCallback(void *ld, int columnCount, char **values, char **columns)
{
    return [(__bridge BulkLoadingDelagate *)ld load:ld withColumnCount:columnCount withValues:values withColumns:columns];
}
-(GrandTotal *)loadGrandTotalWithConnection:(sqlite3 *)connection withCallback:(void (^)(void))callbackBlock
{
    GrandTotal *grandTotal=[GrandTotal alloc];
    SingleLoadingDelagate *ld=[SingleLoadingDelagate createWithManager:self
                                                            withObject:grandTotal
                                                          withCallback:callbackBlock];
    NSString *selectStatement = [NSString stringWithFormat:
                                 @"select %@ from %@"
                                 ,COL_GT_GRAND_TOTAL
                                 ,VIEW_GRAND_TOTAL];
    sqlite3_exec(connection, [selectStatement UTF8String],loadCallback,(__bridge void *)ld,nil);
    return grandTotal;
}
@end
