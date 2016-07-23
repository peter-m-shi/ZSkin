//
//  ZSColorSkin.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSObject.h"

@class UIColor;

@interface ZSColorSkin : ZSObject

@property (nonatomic) UIColor *defaultc;
@property (nonatomic) UIColor *foreground;
@property (nonatomic) UIColor *background;
@property (nonatomic) UIColor *explain;
@property (nonatomic) UIColor *desc;
@property (nonatomic) UIColor *stress;
@property (nonatomic) UIColor *weakStress;
@property (nonatomic) UIColor *link;
@property (nonatomic) UIColor *warnning;
@property (nonatomic) UIColor *error;
@property (nonatomic) UIColor *highlight;
@property (nonatomic) UIColor *enable;
@property (nonatomic) UIColor *selected;
@property (nonatomic) UIColor *disabled;
@property (nonatomic) UIColor *hover;

@end
