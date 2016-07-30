//
//  ZImageSkin.m
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZImageSkin.h"

@import UIKit;

@implementation ZImageSkin

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


- (UIImage *)imageNamed:(NSString *)name maskColor:(UIColor *)color
{
    UIImage *image = [self imageNamed:name];
    if (image)
    {
        UIImage *mask = [self imageWithColor:color size:image.size];
        image = [self overlapWithImage:mask toImage:image];
    }
    return image;
}


- (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color
{
    UIImage *image = [self imageNamed:name];
    if (image)
    {
        //TODO:颜色重绘处理
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


#pragma mark - private function -


- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    assert(color);
    assert(!CGSizeEqualToSize(size,CGSizeZero));

    UIGraphicsBeginImageContext(size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));

    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return result;
}


- (UIImage *)overlapWithImage:(UIImage *)image toImage:(UIImage *)original
{
    CGSize size = CGSizeMake(original.size.width, original.size.height);

    UIGraphicsBeginImageContext(size);

    [original drawInRect:CGRectMake(0, 0, original.size.width, original.size.height)];
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return result;
}
@end
