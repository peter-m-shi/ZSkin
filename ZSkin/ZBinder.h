//
//  ZBinder.h
//  ZSkinDemo
//
//  Created by peter.shi on 16/7/28.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSkinDefine.h"

@interface ZBinder : NSObject

@property (nonatomic, weak, readonly) id target;
@property (nonatomic, copy, readonly) NSString *identifier;

@end

@interface ZKVOBinder : ZBinder

@property (nonatomic, readonly) id observer;
@property (nonatomic, copy, readonly) NSString *tKeyPath;
@property (nonatomic, copy, readonly) NSString *oKeyPath;
@property (nonatomic) SEL selector;
@property (nonatomic, readonly) void *parameter;

- (instancetype)initWithTarget:(id)target
                    identifier:(NSString *)identifier
                      tKeyPath:(NSString *)tKeyPath
                      observer:(id)observer
                     oKeyPatrh:(NSString *)oKeyPath
                     parameter:(void *)parameter;

@end

@interface ZBlockBinder : ZBinder

@property (nonatomic, copy, readonly) callBackBlock block;

- (instancetype)initWithTarget:(id)target
                    identifier:(NSString *)identifier
                         block:(callBackBlock)block;
@end
