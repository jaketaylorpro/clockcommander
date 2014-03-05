//
//  CCClock.h
//  ClockCommander
//
//  Created by Jacob Taylor on 3/2/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCClock : NSObject

@property (atomic,getter = getClock_id,setter = setClock_id:) int clock_id;
@property (atomic) float modifier;
@property (strong, atomic) NSString *name;


@end
