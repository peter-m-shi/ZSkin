//
//  ZSSkinManager.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZSSkin;

extern NSString *ZSSkinChangedNotificationKey;

@interface ZSSkinManager : NSObject

@property (readwrite, strong, nonatomic) ZSSkin *currentSkin;
@property (readonly, strong, nonatomic) NSArray *skins;

+ (instancetype)instance;

- (void)setSkinWithIndex:(NSInteger)index;

- (void)setSkinWithName:(NSString *)name;

@end
