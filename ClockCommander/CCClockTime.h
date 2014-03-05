//
//  CCClockTime.h
//  ClockCommander
//
//  Created by Jacob Taylor on 3/2/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCClockTime : NSObject

@property (atomic,getter = getClock_time_id,setter = setClock_time_id:) int clock_time_id;
@property (atomic) int clock_id;
@property (atomic) NSString *clock_name;
@property (atomic) int start_time;
@property (atomic) int start_day;
@property (atomic) int start_day_seconds;
@property (atomic) int duration;

@end
