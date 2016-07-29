//
//  NSObject+Skin.h
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "NSObject+Skin.h"
#import "ZSkinManager.h"
#import "ZBinderManager.h"
#import "ZSkin.h"

@implementation NSObject (Skin)

- (void)bind:(NSString *)tKeyPath to:(NSString *)oKeyPath;
{
    [self bind:tKeyPath to:oKeyPath withParam:nil];
}


- (void)bind:(NSString *)tKeyPath to:(NSString *)oKeyPath withParam:(void *)param
{
    [[ZBinderManager instance] bind:self
                          identifier:[self collectIdentifier]
                            tKeyPath:tKeyPath
                            observer:[ZSkinManager instance]
                           oKeyPatrh:oKeyPath
                           parameter:param];
}


- (void)bind:(callBackBlock)callback
{
    [[ZBinderManager instance] bind:self identifier:[self collectIdentifier] callback:callback];
}


- (void)unBind:(NSString *)tKeyPath to:(NSString *)oKeyPath
{
    [[ZBinderManager instance] unBind:self tKeyPath:tKeyPath oKeyPath:oKeyPath];
}


- (NSString *)bindInfo:(NSString *)tKeyPath
{
    return [[ZBinderManager instance] bindInfo:self tKeyPath:tKeyPath];
}


#pragma mark - private function -


- (NSString *)collectIdentifier
{
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    assert(callStackSymbols.count >= 3);

    NSString *callStackInfo;
    for (NSString *symbol in callStackSymbols)
    {
        if ([symbol rangeOfString:@"-[NSObject(Skin)"].length <= 0
            && [symbol rangeOfString:@"-[ZBindingAssistant setObject:forKeyedSubscript:]"].length <= 0)
        {
            callStackInfo = [symbol componentsSeparatedByString:@"0x"].lastObject;
            break;
        }
    }

    NSString *identifier = [NSString stringWithFormat:@"%p_%@_0x%@", self, [self class], callStackInfo];

    return identifier;
}
@end
