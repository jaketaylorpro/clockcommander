//
//  CCClockTime.h
//  ClockCommander
//
//  Created by Jacob Taylor on 3/2/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCClockTime : NSObject

@property (atomic,getter = getClockTimeId) int clockTimeId;
@property (atomic) int clockId;
@property (atomic) int startTime;
@property (atomic) int startDay;
@property (atomic) int duration;

@end