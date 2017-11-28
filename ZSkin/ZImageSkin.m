//
//  ZImageSkin.m
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZImageSkin.h"

@import UIKit;

#pragma mark - ZImageSkin Class -

@implementation ZImageSkin

#pragma mark - private function -


- (NSString *)imageFilePath:(NSString *)name {
    return [NSString stringWithFormat:@"%@/image/%@", self.path, name];
}


- (UIImage *)imageNamed:(NSString *)name {
    UIImage *image = [UIImage imageWithContentsOfFile:[self imageFilePath:name]];

    if (!image) {
        image = [UIImage imageNamed:name];
    }
    return image;
}

//TODO:缓存

@end
