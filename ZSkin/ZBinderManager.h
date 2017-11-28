//
//  ZBinderManager.h
//  ZSkin
//
//  Created by peter.shi on 16/7/18.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSkinDefine.h"

@class ZSkin;

/**
 *  ZBinderManager
 */
@interface ZBinderManager : NSObject

+ (instancetype)instance;

/**
 *  Bind a skin changed event with block
 *
 *  @param target     object
 *  @param identifier automatic collected
 *  @param callback   will be called when the current skin changed
 */
- (void)bind:(id)target
  identifier:(NSString *)identifier
    callback:(callBackBlock)callback;

/**
 *  Bind a skin changed event with Key-Value Observing(KVO)
 *
 *  @param target     object
 *  @param identifier automatic collected
 *  @param tKeyPath   keypath of target
 *  @param observer   observer
 *  @param oKeyPath   keypath of observer
 *  @param parameter  parameters if needed
 */
- (void)bind:(id)target
  identifier:(NSString *)identifier
    tKeyPath:(NSString *)tKeyPath
    observer:(id)observer
    oKeyPath:(NSString *)oKeyPath
   parameter:(void *)parameter;

/**
 *  UnBind a skin changed event binding
 *
 *  @param target   object
 *  @param tKeyPath keypath of target
 *  @param oKeyPath keypath of observer
 */
- (void)unBind:(id)target tKeyPath:(NSString *)tKeyPath oKeyPath:(NSString *)oKeyPath;

/**
 *  Get a KVO is already existed
 *
 *  @param target   object
 *  @param tKeyPath keypath of target
 *
 *  @return keypath of observer if existed
 */
- (NSString *)bindInfo:(id)target tKeyPath:(NSString *)tKeyPath;


@end
