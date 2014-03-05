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
@synthesize dataMgr,currentClockTime,flipsidePopoverController,grandTotalScore
    ,myTableView,myGrandTimerLabel,myCurrentClockLabel,myCurrentTimerLabel;

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
        grandTotalScore=(GrandTotal *)[dataMgr loadGrandTotalWithConnection:sqliteConnection withCallback:^{[self startGrandCounter];}];
        //todo need to load grand total
    }
    @catch (NSException *exception) {
        NSLog(@"exception:ViewDidLoad: %@;%@"
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
    //refactor, extract method
    double d=CACurrentMediaTime()-currentClockTime.start_day_seconds-currentClockTime.start_time+grandTotalScore.grand_total;
    int dh=(int)(d/60.0/60.0);
    int dm=(int)((d-(dh*60*60))/60);
    int ds=(int)(d-(dh*60*60)-(dm*60));
    [myGrandTimerLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d",dh,dm,ds]];
    [myGrandTimerLabel setTextColor: d<0
        ? [UIColor colorWithRed:255 green:0 blue:0 alpha:0]
        : [UIColor colorWithRed:0 green:255 blue:0 alpha:0]];
}
-(void)refreshCurrentClock
{
    //refactor, extract method
    double d=CACurrentMediaTime()-currentClockTime.start_day_seconds-currentClockTime.start_time;
    int dh=(int)(d/60.0/60.0);
    int dm=(int)((d-(dh*60*60))/60);
    int ds=(int)(d-(dh*60*60)-(dm*60));
    [myCurrentTimerLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d",dh,dm,ds]];
}
-(void)startCurrentCounter
{
    [myCurrentClockLabel setText:currentClockTime.clock_name];
    NSInvocation *invocation=[[NSInvocation alloc] init];
    [invocation setSelector:@selector(refreshCurrentClock)];
    [invocation setTarget:self];
    [NSTimer scheduledTimerWithTimeInterval:0.5 invocation:invocation repeats:true];
}
-(void)continueClockTime:(CCClockTime *)clockTime
{
    //TODO
}
-(IBAction)startClock:(id)sender
{
    @try {
        NSCalendar* CALENDAR_GREGORIAN = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//TODO find a way to load this just once
        NSDate* now = [NSDate date];
        NSDateComponents *nowC = [CALENDAR_GREGORIAN components:(NSYearCalendarUnit  | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
        CCClock *selectedClock=[dataMgr getClockByIndex:[[myTableView indexPathForSelectedRow] indexAtPosition:1]];
        CCClockTime *newClockTime=[CCClockTime alloc];
        newClockTime.clock_id=selectedClock.clock_id;
        newClockTime.start_day=[nowC day]+(100*[nowC month])+(10000*[nowC year]);
        newClockTime.start_day_seconds=[now timeIntervalSince1970]-([nowC hour]*60*60)+([nowC minute]*60)-([nowC second]);
        newClockTime.start_time=[nowC second] + (60 * [nowC minute]) + (60*60* [nowC hour]);
        [dataMgr saveClockTime:newClockTime withConnection:sqliteConnection];
        currentClockTime=newClockTime;
        [self startCurrentCounter];
    }
    @catch (NSException *exception) {
        NSLog(@"exception:StartClock: %@;%@"
              ,exception.name
              ,exception.reason);
    }
    @finally {
        
    }
    
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
