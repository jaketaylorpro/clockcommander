//
//  SingleLoadingDelagate.m
//  ClockCommander
//
//  Created by Jacob Taylor on 3/3/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import "SingleLoadingDelagate.h"

@implementation SingleLoadingDelagate
@synthesize obj,mgr;
+(SingleLoadingDelagate *)createWithManager:(CCDataMgr *)manager withData:(NSObject *)data withCallback:(void(^)(void))callbackBlock
{
    SingleLoadingDelagate *ld =[SingleLoadingDelagate alloc];
    ld.mgr=manager;
    ld.obj=data;
    ld.callbackBlock=callbackBlock;
    return ld;
}
-(int)load:(void *)ld withColumnCount:(int)columnCount withValues:(char **)values withColumns:(char **)columns
{
    SingleLoadingDelagate *loadingDelagate=(__bridge_transfer SingleLoadingDelagate *)ld;
    for(int i=0;i<columnCount;i++)
    {
        [loadingDelagate.obj setValue:[NSString stringWithCString:values[i] encoding:NSUTF8StringEncoding]
               forKey:[NSString stringWithCString:columns[i] encoding:NSUTF8StringEncoding]];
    }
    loadingDelagate.callbackBlock();
    return 0;
}
@end
