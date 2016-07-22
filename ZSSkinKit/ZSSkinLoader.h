//
//  ZSSkinLoader.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZSSkin;

@interface ZSSkinLoader : NSObject

+ (NSArray *)loadSkins;

+ (ZSSkin *)loadSkin:(NSString *)name;

@end
