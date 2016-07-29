//
//  ZSFontSkin.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSObject.h"

@interface ZSFontSkin : ZSObject

@property (nonatomic) NSString *familyName;
@property (nonatomic) NSNumber *largeSize;
@property (nonatomic) NSNumber *middleSize;
@property (nonatomic) NSNumber *smallSize;
@property (nonatomic) NSNumber *headerSize;

@end
