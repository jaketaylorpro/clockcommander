//
//  MainViewController.m
//  ClockCommander
//
//  Created by Jacob Taylor on 2/17/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize clockData,currentClockModifier,currentClockName,currentClockTimeId;

NSString* DATABASE_NAME=@"com.jaketaylor.clockcommander";

NSString* TABLE_CLOCK=@"clock";
NSString* COLUMN_CLOCK_CLOCK_ID=@"clock_id";
NSString* COLUMN_CLOCK_CLOCK_NAME=@"clock_name";
NSString* COLUMN_CLOCK_MODIFIER=@"modifier";

NSString* TABLE_CLOCK_TIME=@"clock_time";
NSString* COLUMN_CLOCK_TIME_CLOCK_ID=@"clock_id";
NSString* COLUMN_CLOCK_TIME_CLOCK_TIME_ID=@"clock_time_id";
NSString* COLUMN_CLOCK_TIME_START_DAY=@"start_day";
NSString* COLUMN_CLOCK_TIME_START_TIME=@"start_time";
NSString* COLUMN_CLOCK_TIME_END_TIME=@"end_time";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self openSqlite];
    [self loadClocks];
    [self loadCurrentClockTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View Controller

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            self.flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (self.flipsidePopoverController) {
        [self.flipsidePopoverController dismissPopoverAnimated:YES];
        self.flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}
- (void)openSqlite
{//TODO handle the case where the db is already open
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *sqlFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:DATABASE_NAME];
    sqlite3_open([sqlFile UTF8String], &my_dbname);//TODO error handling; check if returns SQLITE_OK
}
-(void)closeSqlite
{
    sqlite3_close(my_dbname);
}
-(void)createClockTime:(NSInteger)clockId :(NSInteger)startDay :(NSInteger)startTime
{
    NSString *insertStatement = [NSString stringWithFormat:
                                 @"insert into %@ (%@) values (%@)"
                                 ,TABLE_CLOCK_TIME
                                 ,@[COLUMN_CLOCK_TIME_CLOCK_ID
                                    ,COLUMN_CLOCK_TIME_START_DAY
                                    ,COLUMN_CLOCK_TIME_START_TIME]
                                 ,@[clockId
                                    ,startDay
                                    ,startTime]];
    
}
@end
