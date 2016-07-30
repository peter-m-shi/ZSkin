//
//  ZFontSkin.h
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZObject.h"

/**
 *  ZFontSkin
 */
@interface ZFontSkin : ZObject

@property (nonatomic) NSString *familyName;
@property (nonatomic) NSNumber *largeSize;
@property (nonatomic) NSNumber *middleSize;
@property (nonatomic) NSNumber *smallSize;
@property (nonatomic) NSNumber *headerSize;

@end
