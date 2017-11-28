//
//  UIResponder+Dealloc.m
//  ZSkin
//
//  Created by peter.shi on 27/11/2017.
//  Copyright © 2017 peter.shi. All rights reserved.
//

#import "UIResponder+Dealloc.h"
#import <objc/runtime.h>

@implementation UIResponder (Dealloc)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originalFunction = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method newFunction = class_getInstanceMethod(self, @selector(swizz_dealloc));
        method_exchangeImplementations(originalFunction, newFunction);
    });
}


- (void)swizz_dealloc {
    if (self) {
        if ([NSStringFromClass([self class]) characterAtIndex:0] != '_') {
            [[NSNotificationCenter defaultCenter] postNotificationName:KUIResponderDeallocNotification object:self];
        }
    }
    [self swizz_dealloc];
}
@end
