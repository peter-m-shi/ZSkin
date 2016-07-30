//
//  ZSkin.h
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZColorSkin.h"
#import "ZFontSkin.h"
#import "ZImageSkin.h"

/**
 *  ZSkin
 */
@interface ZSkin : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *path;
@property (nonatomic) ZColorSkin *color;
@property (nonatomic) ZFontSkin *font;
@property (nonatomic) ZImageSkin *image;

@end
