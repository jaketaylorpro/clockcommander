//
//  LoadingDelagate.m
//  ClockCommander
//
//  Created by Jacob Taylor on 3/2/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import "BulkLoadingDelagate.h"

@implementation BulkLoadingDelagate
@synthesize dict,mgr,type,idGetter;
+(BulkLoadingDelagate *)createWithManager:(CCDataMgr *)manager withData:(NSMutableDictionary *)dataDict withType:(Class)dataType withIdGetter:(SEL)idGetterSel withCallback:(void(^)(void))callbackBlock
{
    BulkLoadingDelagate *ld =[BulkLoadingDelagate alloc];
    ld.mgr=manager;
    ld.dict=dataDict;
    ld.type=dataType;
    ld.idGetter=idGetterSel;
    ld.callbackBlock=callbackBlock;
    return ld;
}
-(int)load:(void *)ld withColumnCount:(int)columnCount withValues:(char **)values withColumns:(char **)columns
{
    
    BulkLoadingDelagate *loadingDelagate=(__bridge_transfer BulkLoadingDelagate *)ld;
    id obj=[loadingDelagate.type alloc];
    for(int i=0;i<columnCount;i++)
    {
        [obj setValue:[NSString stringWithCString:values[i] encoding:NSUTF8StringEncoding]
                 forKey:[NSString stringWithCString:columns[i] encoding:NSUTF8StringEncoding]];
    }
    [loadingDelagate.dict setValue:obj forKey:[NSString stringWithFormat:@"%d"
                                                ,(int)[obj performSelector:loadingDelagate.idGetter]]];
    loadingDelagate.callbackBlock();
    return 0;
}
@end
