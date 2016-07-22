//
//  NSObject+Skin.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "NSObject+Skin.h"
#import "ZSSkinManager.h"
#import "ZSSkinBinder.h"
#import "ZSSkin.h"

@implementation NSObject (Skin)

- (void)bind:(NSString *)tKeyPath to:(NSString *)oKeyPath;
{
    [self bind:tKeyPath to:oKeyPath withParam:nil];
}


- (void)bind:(NSString *)tKeyPath to:(NSString *)oKeyPath withParam:(void *)param
{
    [[ZSSkinBinder instance] bind:self tKeyPath:tKeyPath observer:[ZSSkinManager instance] oKeyPatrh:oKeyPath parameter:param];
}


- (void)bind:(callBackBlock)callback
{
    [[ZSSkinBinder instance] bind:callback];
}


- (void)unBind:(NSString *)tKeyPath to:(NSString *)oKeyPath
{
    [[ZSSkinBinder instance] unBind:self tKeyPath:tKeyPath oKeyPath:oKeyPath];
}


- (NSString *)bindInfo:(NSString *)tKeyPath
{
    return [[ZSSkinBinder instance] bindInfo:self tKeyPath:tKeyPath];
}


@end
