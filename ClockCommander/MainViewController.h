//
//  MainViewController.h
//  ClockCommander
//
//  Created by Jacob Taylor on 2/17/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import "FlipsideViewController.h"
#import <sqlite3.h>
@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate, UITableViewDataSource> {
    sqlite3 *my_dbname;
}

@property (strong, nonatomic) NSMutableArray *clockData;
@property (atomic) int *currentClockTimeId;
@property (atomic) float *currentClockModifier;
@property (strong, atomic) NSString *currentClockName;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

-(IBAction)startClock:(id)sender;
-(IBAction)stopClock:(id)sender;

-(void) openSqlite;
-(void) closeSqlite;
-(void) loadClocks;
-(void) loadCurrentClockTime;
-(void) createClockTime :(NSInteger)clockId :(NSInteger)startDay :(NSInteger)startTime;
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
NSString* COLUMN_CLOCK_TIME_END_TIME;// = "end_time";