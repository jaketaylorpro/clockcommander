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
+(SingleLoadingDelagate *)createWithManager:(NSObject *)manager withObject:(NSObject *)dataObject withCallback:(void(^)(void))callbackBlock
{
    SingleLoadingDelagate *ld =[SingleLoadingDelagate alloc];
    ld.mgr=manager;
    ld.obj=dataObject;
    ld.callbackBlock=callbackBlock;
    return ld;
}
-(int)set:(void *)ld withColumnCount:(int)columnCount withValues:(char **)values withColumns:(char **)columns
{
    //todo handle accidental multiple row return
    SingleLoadingDelagate *loadingDelagate=(__bridge SingleLoadingDelagate *)ld;
    for(int i=0;i<columnCount;i++)
    {
        [obj setValue:[NSString stringWithCString:values[i] encoding:NSASCIIStringEncoding]
               forKey:[NSString stringWithCString:columns[i] encoding:NSASCIIStringEncoding]];
    }
    loadingDelagate.callbackBlock();
    return 0;
}
@end
