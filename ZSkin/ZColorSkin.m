//
//  ZColorSkin.m
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZColorSkin.h"
#import "ZRuntimeUtility.h"

@import UIKit;

@implementation ZColorSkin

- (id)handleParseFor:(id)value key:(NSString *)key {
    id result;

    NSString *str = value;
    unsigned int intValue = [str intValue];
    float alpha = 1;

    if ([str characterAtIndex:0] == '0' && [str characterAtIndex:1] == 'x') {
        NSScanner *scanner = [NSScanner scannerWithString:str];
        [scanner scanHexInt:&intValue];
    }

    Class klass = [ZRuntimeUtility propertyClassForPropertyName:key ofClass:[self class]];
    if ([klass isEqual:[UIColor class]]) {
        SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@Color", value]);
        if ([UIColor respondsToSelector:selector]) {
            //ext. "red"
            result = [UIColor performSelector:selector];
        }
        else if (([str characterAtIndex:0] == '0' && [str characterAtIndex:1] == 'x') || [str characterAtIndex:0] == '#') {
            //rgb ext. "0xffeeff" or "#ffeeff"
            //rgba ext. "0xffeeff99" or "#ffeeff99"
            if (str.length == 8) {
                float r = ((float)((intValue & 0xff0000) >> 16)) / 255.0;
                float g = ((float)((intValue & 0xff00) >> 8)) / 255.0;
                float b = ((float)((intValue & 0xff) >> 0)) / 255.0;
                result = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
            }
            else if (str.length == 10) {
                float r = ((float)((intValue & 0xff000000) >> 24)) / 255.0;
                float g = ((float)((intValue & 0xff0000) >> 16)) / 255.0;
                float b = ((float)((intValue & 0xff00) >> 8)) / 255.0;
                alpha = ((float)((intValue & 0xff) >> 0)) / 255.0;
                result = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
            }
        }
        else {
            //format ext. "122,122,122" or "122,122,122,0.5"
            NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@","];
            NSArray *ret = [str componentsSeparatedByCharactersInSet:set];
            if (ret.count >= 3) {
                float r = [ret[0] floatValue] / 255;
                float g = [ret[1] floatValue] / 255;
                float b = [ret[2] floatValue] / 255;
                if (ret.count >= 4) {
                    alpha = [ret[3] floatValue];
                }
                result = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
            }
        }
    }
    else if ([klass isEqual:[NSNumber class]]) {
        result = [NSNumber numberWithInt:intValue];
    }

    if (result) {
        return result;
    }
    return [super handleParseFor:value key:key];
}


@end
