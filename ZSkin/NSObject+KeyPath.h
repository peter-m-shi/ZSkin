//
//  NSObject+KeyPath.h
//  ZSkin
//
//  Created by peter.shi. on 2017/11/23.
//  Copyright © 2017年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KeyPath)

- (Class)classOfKeyPath:(NSString *)keyPath;

- (BOOL)isValidKeyPath:(NSString *)keyPath;

@end
