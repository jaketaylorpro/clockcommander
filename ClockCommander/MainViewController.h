//
//  MainViewController.h
//  ClockCommander
//
//  Created by Jacob Taylor on 2/17/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import "FlipsideViewController.h"
#import "CCClock.h"
#import "CCClockTime.h"
#import "CCDataMgr.h"
#import <sqlite3.h>
@interface MainViewController : UIViewController <FlipsideViewControllerDelegate, UIPopoverControllerDelegate, UITableViewDataSource,UITableViewDelegate> {
    sqlite3 *sqliteConnection;
}

@property (strong, nonatomic) CCClockTime *currentClockTime;
@property (strong, nonatomic) CCDataMgr *dataMgr;
@property (strong, nonatomic) NSNumber *grandTotalScore;
@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

-(void)startGrandCounter;
-(void)continueClockTime:(CCClockTime *)clockTime;
-(IBAction)startClock:(id)sender;
-(IBAction)stopClock:(id)sender;
@end
