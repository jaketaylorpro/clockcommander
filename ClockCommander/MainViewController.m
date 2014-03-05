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
@synthesize dataMgr,currentClockTime,flipsidePopoverController,grandTotalScore;


UITableView* myTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    @try {
        //initialize properties
        dataMgr = [CCDataMgr alloc];
        // Do any additional setup after loading the view, typically from a nib.
        [self openSqlite];
        [dataMgr loadClocksWithConnection:sqliteConnection
                             withCallback:^{[myTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];}];
        currentClockTime=(CCClockTime *)[dataMgr loadCurrentClockTimeWithConnection:sqliteConnection
                                                                       withCallback:^{[self continueClockTime:currentClockTime];}];
        grandTotalScore=(NSNumber *)[dataMgr loadGrandTotalWithConnection:sqliteConnection withCallback:^{[self startGrandCounter];}];
        //todo need to load grand total
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@;%@"
              ,exception.name
              ,exception.reason);
    }
    @finally {

    }
    
}
- (void)dealloc {
    [self closeSqlite];
    dataMgr=nil;
    currentClockTime=nil;
    
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
        [flipsidePopoverController dismissPopoverAnimated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    flipsidePopoverController = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            UIPopoverController *popoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
            flipsidePopoverController = popoverController;
            popoverController.delegate = self;
        }
    }
}

- (IBAction)togglePopover:(id)sender
{
    if (flipsidePopoverController) {
        [flipsidePopoverController dismissPopoverAnimated:YES];
        flipsidePopoverController = nil;
    } else {
        [self performSegueWithIdentifier:@"showAlternate" sender:sender];
    }
}
- (void)openSqlite
{//TODO handle the case where the db is already open
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *sqlFile = [[paths objectAtIndex:0] stringByAppendingPathComponent:DATABASE_NAME];
    sqlite3_open([sqlFile UTF8String], &sqliteConnection);//TODO error handling; check if returns SQLITE_OK
}
-(void)closeSqlite
{
    sqlite3_close(sqliteConnection);
}
-(void)startGrandCounter
{
    //
}
-(void)continueClockTime:(CCClockTime *)clockTime
{
    //TODO need to load grant total
}
-(IBAction)startClock:(id)sender
{
    NSCalendar* CALENDAR_GREGORIAN = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//TODO find a way to load this just once
    NSDate* now = [NSDate date];
    NSDateComponents *nowC = [CALENDAR_GREGORIAN components:(NSYearCalendarUnit  | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    CCClock *selectedClock=[dataMgr getClockByIndex:[[myTableView indexPathForSelectedRow] indexAtPosition:1]];
    CCClockTime *newClockTime=[CCClockTime init];
    newClockTime.clockId=selectedClock.clock_id;
    newClockTime.startDay=[nowC day]+(100*[nowC month])+(10000*[nowC year]);
    newClockTime.startTime=[nowC second] + (60 * [nowC minute]) + (60*60* [nowC hour]);
    [dataMgr saveClockTime:newClockTime withConnection:sqliteConnection];
}
-(IBAction)stopClock:(id)sender
{
    [dataMgr updateClockTime:currentClockTime withConnection:sqliteConnection];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    myTableView=tableView;
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataMgr.allClocks count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyReuseIdentifier";//TODO do i need to use a row id here?
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    CCClock *clock=[dataMgr getClockByIndex:[indexPath indexAtPosition:1]];
    cell.textLabel.text=[NSString stringWithFormat:@"%d:%@"
                         ,clock.clock_id
                         ,clock.name];
    return cell;
}

@end
