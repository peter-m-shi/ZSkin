//
//  NSObject+KeyPath.m
//  ZSkin
//
//  Created by peter.shi. on 2017/11/23.
//  Copyright © 2017年 peter.shi. All rights reserved.
//

#import "NSObject+KeyPath.h"

@implementation NSObject (KeyPath)

- (Class)classOfKeyPath:(NSString *)keyPath {
    NSObject *obj = [self objectOfKeyPath:keyPath];
    return obj ? [obj class] : Nil;
}


- (BOOL)isValidKeyPath:(NSString *)keyPath {
    return [self objectOfKeyPath:keyPath] ? YES : NO;
}


- (NSObject *)objectOfKeyPath:(NSString *)keyPath {
    if (!keyPath) {
        [self dealError:[NSError errorWithDomain:@"keyPath is nil" code:0 userInfo:nil]];
        return nil;
    }

    NSArray *keyPaths = [keyPath componentsSeparatedByString:@"."];

    NSObject *obj = self;
    for (NSString *subKeyPath in keyPaths) {
        SEL sel = NSSelectorFromString(subKeyPath);
        if (![obj respondsToSelector:sel]) {
            NSString *domain = [NSString stringWithFormat:@"keyPath:'%@' is invalid", keyPath];
            [self dealError:[NSError errorWithDomain:domain code:0 userInfo:nil]];
            return nil;
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        obj = [obj performSelector:sel];
#pragma clang diagnostic pop
    }
    if ([obj isEqual:self]) {
        return nil;
    }
    return obj;
}


- (void)dealError:(NSError *)error {
#ifdef DEBUG
    NSAssert(NO, error.domain);
#else
    NSLog(error.domain);
#endif
}

@end
