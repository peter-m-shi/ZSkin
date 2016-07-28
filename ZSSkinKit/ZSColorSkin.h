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

/*
 *  a Category Class Named(Custom) should be created if you add any key to "color.plist"
 *  And the new property with the same name should be add to Category Class.
 *
 *  etc.
 *
 *  ZSColorSkin+Custom.h
 *
 *  @interface ZSColorSkin (Custom)
 *
 *  @property (nonatomic) UIColor *customColor;
 *
 *  @end
 *
 *
 *
 *  ZSColorSkin+Custom.m
 *
 *  @implementation ZSColorSkin (Custom)
 *
 *  DYNAMIC(customColor,setCustomColor,UIColor*)
 *
 *  @end
 */

@end
