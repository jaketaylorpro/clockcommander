//
//  CCDataMgr.h
//  ClockCommander
//
//  Created by Jacob Taylor on 3/2/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "CCClockTime.h"
#import "CCClock.h"
#import "BulkLoadingDelagate.h"

@interface CCDataMgr : NSObject



@property (strong, nonatomic) NSMutableDictionary *allClocks;
@property (strong, nonatomic) NSMutableDictionary *allClockTimes;

//clock
-(NSMutableDictionary *) loadClocksWithConnection:(sqlite3 *)connection withCallback:(void(^)(void))callbackBlock;
-(CCClock *)getClockById:(int)id;
-(CCClock *)getClockByIndex:(int)index;
-(void)saveClock:(CCClock *)clock withConnection:(sqlite3 *)connection;

//clocktime
-(CCClockTime *)getClockTimeById:(int)id;
-(NSMutableDictionary *) loadClockTimesWithConnection:(sqlite3 *)connection withCallback:(void(^)(void))callbackBlock;
-(NSObject *) loadCurrentClockTimeWithConnection:(sqlite3 *)connection withCallback:(void(^)(void))callbackBlock;
-(void)saveClockTime:(CCClockTime *)clockTime withConnection:(sqlite3 *)connection;
-(void)updateClockTime:(CCClockTime *)clockTime withConnection:(sqlite3 *)connection;
@end

NSString* DATABASE_NAME;//="com.jaketaylor.clockcommander";

NSString* TABLE_CLOCK;// = "clock";
NSString* COLUMN_CLOCK_CLOCK_ID;// = "clock_id";
NSString* COLUMN_CLOCK_CLOCK_NAME;// = "clock_name";
NSString* COLUMN_CLOCK_MODIFIER;// = "modifier";

NSString* TABLE_CLOCK_TIME;// = "clock_time";
NSString* COLUMN_CLOCK_TIME_CLOCK_ID;// = "clock_id";
NSString* COLUMN_CLOCK_TIME_CLOCK_TIME_ID;// = "clock_time_id";
NSString* COLUMN_CLOCK_TIME_START_DAY;// = "start_day";
NSString* COLUMN_CLOCK_TIME_START_TIME;// = "start_time";
NSString* COLUMN_CLOCK_TIME_DURATION;// = "duration";
