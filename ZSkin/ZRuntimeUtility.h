//
//  ZRuntimeUtility.h
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/NSObject.h>
#import <objc/objc.h>

@interface ZRuntimeUtility : NSObject

+ (BOOL)isPropertyReadOnly:(Class)klass propertyName:(NSString *)propertyName;

+ (Class)propertyClassForPropertyName:(NSString *)propertyName ofClass:(Class)klass;

+ (NSArray *)propertyNames:(Class)klass;

@end
