//
//  ZSImageSkin.m
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZSImageSkin.h"

@import UIKit;

@implementation ZSImageSkin

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self)
    {
        self.path = path;
    }
    return self;
}


- (UIImage *)imageNamed:(NSString *)name
{
//    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/image/%@", self.path, name]];
    //TODO:imageNamed获取图片有缓存问题。暂时支持绝对全路径。
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/image/%@", self.path, name]];
    
    if (!image)
    {
        image = [UIImage imageNamed:name];
    }
    return image;
}


+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSString *)bundleName
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/%@", bundleName, name]];
    if (!image)
    {
        image = [UIImage imageNamed:name];
    }
    return image;
}
@end
