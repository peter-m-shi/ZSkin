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
    [[ZBinderManager instance] bind:self
                         identifier:[self collectIdentifier]
                           tKeyPath:tKeyPath
                           observer:[ZSkinManager instance]
                          oKeyPatrh:oKeyPath
                          parameter:nil];
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
    NSArray *callStackSymbols = [NSThread callStackReturnAddresses];
    assert(callStackSymbols.count >= 4);

    NSString *identifier = [NSString stringWithFormat:@"%p_%@_%@_%@", self, [self class], callStackSymbols[2],callStackSymbols[3]];

    return identifier;
}
@end
