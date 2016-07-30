//
//  ZColorSkin.h
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZObject.h"

@class UIColor;

/**
 *  ZColorSkin
 */
@interface ZColorSkin : ZObject

/*
 *  a Category Class Named(Custom) should be created if you add any key to "color.plist"
 *  And the new property with the same name should be add to Category Class.
 *
 *  etc.
 *
 *  ZColorSkin+Custom.h
 *
 *  @interface ZColorSkin (Custom)
 *
 *  @property (nonatomic) UIColor *customColor;
 *
 *  @end
 *
 *
 *
 *  ZColorSkin+Custom.m
 *
 *  @implementation ZColorSkin (Custom)
 *
 *  DYNAMIC(customColor,setCustomColor,UIColor*)
 *
 *  @end
 */

@end
