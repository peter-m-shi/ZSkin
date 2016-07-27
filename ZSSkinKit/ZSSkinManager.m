//
//  ZSSkinManager.m
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <objc/objc.h>
#import "ZSSkinManager.h"
#import "ZSSkin.h"
#import "ZSSkinLoader.h"

NSString *ZSSkinChangedNotificationKey = @"ZSSkinChangedNotificationKey";

@interface ZSSkinManager ()

@property (nonatomic) ZSSkinLoader *skinLoader;
@property (readwrite, strong, nonatomic) NSArray *skins;

@end

@implementation ZSSkinManager

+ (instancetype)instance
{
    static ZSSkinManager *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
    return staticInstance;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        _skinLoader = [ZSSkinLoader new];
        _skins = [_skinLoader loadSkins];
        [self setSkin:[_skins firstObject]];
    }

    return self;
}


- (void)setSkin:(ZSSkin *)skin
{
    if (skin != _skin)
    {
        _skin = skin;
        [_skinLoader loadSkin:_skin];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZSSkinChangedNotificationKey
                                                            object:_skin
                                                          userInfo:nil];
    }
}


- (void)setSkinNamed:(NSString *)name
{
    self.skin = [self skinNamed:name];
}


- (void)setSkinIndexed:(NSInteger)index
{
    assert(index >= 0 < self.skins.count);
    self.skin = [self.skins objectAtIndex:index];
}


- (ZSSkin *)skinNamed:(NSString *)name
{
    if (name.length <= 0)return nil;

    for (ZSSkin *skin in self.skins)
    {
        if ([skin.name isEqualToString:name])
        {
            return skin;
        }
    }
    return nil;
}
@end

