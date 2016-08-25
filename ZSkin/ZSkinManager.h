//
//  ZSkinManager.h
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZSkin;

/**
 *  a notification named ZSkinChangedNotificationKey will be posted when the selected skin be changed.
 */
extern NSString *ZSkinChangedNotificationKey;

/**
 *  ZSkinManager
 */
@interface ZSkinManager : NSObject

/**
 * current selected skin
 */
@property (readwrite, strong, nonatomic) ZSkin *skin;

/**
 * supported skin array
 */
@property (readonly, strong, nonatomic) NSArray *skins;

/**
 * shared instance
 */
+ (instancetype)instance;

/**
 *  set skin with given name seleted.
 *
 *  @param name of skin
 */
- (void)setSkinNamed:(NSString *)name;

/**
 *  set skin with given index of supported skins array seleted.
 *
 *  @param index of skins array
 *  a assert will be triggered if given index not valid
 */
- (void)setSkinIndexed:(NSInteger)index;

/**
 *  get skin with given name.
 *
 *  @param name of skin
 *
 *  @return skin object,nil if not found.
 */
- (ZSkin *)skinNamed:(NSString *)name;

@end
