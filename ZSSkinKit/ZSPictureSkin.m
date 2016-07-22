//
//  ZSPictureSkin.m
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZSPictureSkin.h"

@implementation ZSPictureSkin

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
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", self.path, name]];
}


+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSString *)bundleName
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/%@", bundleName, name]];
}
@end
