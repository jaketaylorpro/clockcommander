//
//  SaveDelagate.m
//  ClockCommander
//
//  Created by Jacob Taylor on 3/4/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import "SaveDelagate.h"

@implementation SaveDelagate
@synthesize mgr,obj,idSetter;
+(SaveDelagate *)createWithManager:(NSObject *)manager withObject:(NSObject *)dataObject withSetter:(SEL)setter
{
    SaveDelagate *sd =[SaveDelagate alloc];
    sd.mgr=manager;
    sd.obj=dataObject;
    sd.idSetter=setter;
    return sd;
}
-(int)set:(void *)sd withColumnCount:(int)columnCount withValues:(char **)values withColumns:(char **)columns
{
    SaveDelagate *saveDelagate=(__bridge SaveDelagate *) sd;
    [saveDelagate.obj performSelector:saveDelagate.idSetter
                           withObject:[NSString stringWithCString:values[0]
                                                         encoding:NSASCIIStringEncoding]];
    return 0;
}
@end
