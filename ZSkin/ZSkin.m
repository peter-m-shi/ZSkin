//
//  ZSkin.m
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZSkin.h"

@implementation ZSkin

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

    [description appendString:@">\r\n"];
    [description appendString:[NSString stringWithFormat:@"color:%@\r\n",self.color]];
    [description appendString:[NSString stringWithFormat:@"font:%@\r\n",self.font]];
    [description appendString:[NSString stringWithFormat:@"image:%@\r\n",self.image]];

    return description;
}

@end
