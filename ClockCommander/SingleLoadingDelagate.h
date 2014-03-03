//
//  SingleLoadingDelagate.h
//  ClockCommander
//
//  Created by Jacob Taylor on 3/3/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCDataMgr.h"
@interface SingleLoadingDelagate : NSObject

@property (strong,nonatomic) CCDataMgr *mgr;
@property (strong,nonatomic) NSObject *obj;
@property (nonatomic,assign) Class type;
@property (nonatomic,assign) SEL idGetter;
@property (nonatomic,copy) void(^callbackBlock)(void);

+(SingleLoadingDelagate *)createWithManager:(CCDataMgr *)manager
                                 withData:(NSMutableDictionary *)dataArray
                             withCallback:(void(^)(void))callbackBlock;

-(int)load:(void *)ld withColumnCount:(int)columnCount withValues:(char **)values withColumns:(char **)columns;

@end
