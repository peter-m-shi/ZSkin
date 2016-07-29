//
//  NSObject+Skin.h
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSkinDefine.h"

@class ZSkin;

@interface NSObject (Skin)

/**
 *  bind property
 *
 *  @param tKeyPath property of object
 *  @param oKeyPath property of config
 */
- (void)bind:(NSString *)tKeyPath to:(NSString *)oKeyPath;

/**
 *  bind property with param
 *
 *  @param tKeyPath property of target
 *  @param oKeyPath peroperty of config
 *  @param param    param
 */
- (void)bind:(NSString *)tKeyPath to:(NSString *)oKeyPath withParam:(void *)param;

/**
 *  bind skin changed event
 *
 *  @param callback when skin changed will be invoked
 */
- (void)bind:(callBackBlock)callback;

/**
 *  unbind property
 *
 *  @param tKeyPath property of object
 *  @param oKeyPath property of config
 */
- (void)unBind:(NSString *)tKeyPath to:(NSString *)oKeyPath;

/**
 *  get bind info of object
 *
 *  @param tKeyPath property of object
 *
 *  @return property,nil if no property be binded
 */
- (NSString *)bindInfo:(NSString *)tKeyPath;

@end
