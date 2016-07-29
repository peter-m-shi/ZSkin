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
    NSArray *callStackSymbols = [NSThread callStackSymbols];
    assert(callStackSymbols.count >= 4);

    NSString *callStackInfo1 = [callStackSymbols[2] componentsSeparatedByString:@"0x"].lastObject;
    NSString *callStackInfo2 = [callStackSymbols[3] componentsSeparatedByString:@"0x"].lastObject;
    NSString *identifier = [NSString stringWithFormat:@"%p_%@_0x%@_0x%@", self, [self class], callStackInfo1,callStackInfo2];

//    NSLog(@"id : %@",identifier);
    return identifier;
}
@end
