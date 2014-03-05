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
#import "SingleLoadingDelagate.h"
#import "SaveDelagate.h"
#import "GrandTotal.h"

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
-(GrandTotal *) loadGrandTotalWithConnection:(sqlite3 *)connection withCallback:(void(^)(void))callbackBlock;
@end

NSString* DATABASE_NAME;//="com.jaketaylor.clockcommander";

NSString* TABLE_CLOCK;// = "clock";
NSString* COL_C_CLOCK_ID;// = "clock_id";
NSString* COL_C_NAME;// = "name";
NSString* COL_C_MODIFIER;// = "modifier";

NSString* TABLE_CLOCK_TIME;// = "clock_time";
NSString* COL_CT_CLOCK_ID;// = "clock_id";
NSString* COL_CT_CLOCK_TIME_ID;// = "clock_time_id";
NSString* COL_CT_START_DAY;// = "start_day";
NSString* COL_CT_START_TIME;// = "start_time";
NSString* COL_CT_DURATION;// = "duration";

NSString* VIEW_GRAND_TOTAL;//="grand_total"
NSString* COL_GT_GRAND_TOTAL;//="grand_total"

NSString* VIEW_CLOCK_TIME_V;// = "clock_time_v";
NSString* COL_CTV_CLOCK_ID;// = "clock_id";
NSString* COL_CTV_CLOCK_NAME;// = "clock_name";
NSString* COL_CTV_CLOCK_TIME_ID;// = "clock_time_id";
NSString* COL_CTV_START_DAY;// = "start_day";
NSString* COL_CTV_START_DAY_SECONDS;// = "start_day_seconds";
NSString* COL_CTV_START_TIME;// = "start_time";
NSString* COL_CTV_DURATION;// = "duration";
