//
//  LoadingDelagate.h
//  ClockCommander
//
//  Created by Jacob Taylor on 3/2/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface BulkLoadingDelagate : NSObject

@property (strong,nonatomic) NSObject *mgr;
@property (strong,nonatomic) NSMutableDictionary *dict;
@property (nonatomic,assign) Class type;
@property (nonatomic,assign) SEL idGetter;
@property (nonatomic,copy) void(^callbackBlock)(void);

+(BulkLoadingDelagate *)createWithManager:(NSObject *)manager
                                 withData:(NSMutableDictionary *)dataDict
                                 withType:(Class)dataType
                             withIdGetter:(SEL)idGetterSel
                             withCallback:(void(^)(void))callbackBlock;

-(int)load:(void *)ld withColumnCount:(int)columnCount withValues:(char **)values withColumns:(char **)columns;

@end
