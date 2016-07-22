//
//  ZSPictureSkin.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface ZSPictureSkin : NSObject

@property (nonatomic) NSString *path;

- (id)initWithPath:(NSString *)path;

- (UIImage *)imageNamed:(NSString *)name;

+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSString *)bundleName;

@end
