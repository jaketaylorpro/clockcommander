//
//  SaveDelagate.h
//  ClockCommander
//
//  Created by Jacob Taylor on 3/4/14.
//  Copyright (c) 2014 jaketaylor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveDelagate : NSObject

@property (strong,nonatomic) NSObject *mgr;
@property (strong,nonatomic) NSObject *obj;
@property (nonatomic,assign) SEL idSetter;

+(SaveDelagate *)createWithManager:(NSObject *)manager
                        withObject:(NSObject *)dataObject
                        withSetter:(SEL)setter;

-(int)set:(void *)ld withColumnCount:(int)columnCount withValues:(char **)values withColumns:(char **)columns;

@end
