//
//  NSObject+Skin.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "NSObject+Skin.h"
#import "ZSSkinManager.h"
#import "ZSBinderManager.h"
#import "ZSSkin.h"

@implementation NSObject (Skin)

- (void)bind:(NSString *)tKeyPath to:(NSString *)oKeyPath;
{
    [self bind:tKeyPath to:oKeyPath withParam:nil];
}


- (void)bind:(NSString *)tKeyPath to:(NSString *)oKeyPath withParam:(void *)param
{
    [[ZSBinderManager instance] bind:self
                          identifier:[self collectIdentifier]
                            tKeyPath:tKeyPath
                            observer:[ZSSkinManager instance]
                           oKeyPatrh:oKeyPath
                           parameter:param];
}


- (void)bind:(callBackBlock)callback
{
    [[ZSBinderManager instance] bind:self identifier:[self collectIdentifier] callback:callback];
}


- (void)unBind:(NSString *)tKeyPath to:(NSString *)oKeyPath
{
    [[ZSBinderManager instance] unBind:self tKeyPath:tKeyPath oKeyPath:oKeyPath];
}


- (NSString *)bindInfo:(NSString *)tKeyPath
{
    return [[ZSBinderManager instance] bindInfo:self tKeyPath:tKeyPath];
}


#pragma mark - private function -


- (NSString *)collectIdentifier
{
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    NSAssert(callStackSymbols.count >= 3, @"Object bind callStackSymbols count is too less.");

    NSString *callStackInfo;
    for (NSString *symbol in callStackSymbols)
    {
        if ([symbol rangeOfString:@"-[NSObject(Skin)"].length <= 0
            && [symbol rangeOfString:@"-[ZSBindingAssistant setObject:forKeyedSubscript:]"].length <= 0)
        {
            callStackInfo = [symbol componentsSeparatedByString:@"0x"].lastObject;
            break;
        }
    }

    NSString *identifier = [NSString stringWithFormat:@"%p_%@_0x%@", self, [self class], callStackInfo];

    return identifier;
}
@end
