//
//  ZSSkin.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSColorSkin.h"
#import "ZSFontSkin.h"
#import "ZSImageSkin.h"

@interface ZSSkin : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *path;
@property (nonatomic) ZSColorSkin *color;
@property (nonatomic) ZSFontSkin *font;
@property (nonatomic) ZSImageSkin *picture;

@end
