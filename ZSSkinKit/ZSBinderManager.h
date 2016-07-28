//
//  ZSBinderManager.h
//  ZSSkinKitDemo
//
//  Created by peter.shi on 16/7/18.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSSkinDefine.h"

@class ZSSkin;

@interface ZSBinderManager : NSObject

+ (instancetype)instance;

- (void)bind:(id)target
  identifier:(NSString *)identifier
    callback:(callBackBlock)callback;

- (void)bind:(id)target
  identifier:(NSString *)identifier
    tKeyPath:(NSString *)tKeyPath
    observer:(id)observer
   oKeyPatrh:(NSString *)oKeyPath
   parameter:(void *)parameter;

- (void)unBind:(id)target tKeyPath:(NSString *)tKeyPath oKeyPath:(NSString *)oKeyPath;

- (NSString *)bindInfo:(id)target tKeyPath:(NSString *)tKeyPath;


@end
