//
//  ZSkinManager.m
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <objc/objc.h>
#import "ZSkinManager.h"
#import "ZSkin.h"
#import "ZSkinLoader.h"

NSString *ZSkinChangedNotificationKey = @"ZSkinChangedNotificationKey";

@interface ZSkinManager ()

@property (nonatomic) ZSkinLoader *skinLoader;
@property (readwrite, strong, nonatomic) NSArray *skins;

@end

@implementation ZSkinManager

+ (instancetype)instance
{
    static ZSkinManager *staticInstance = nil;
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
        _skinLoader = [ZSkinLoader new];
        _skins = [_skinLoader loadSkins];
        [self setSkin:[_skins firstObject]];
    }

    return self;
}


- (void)setSkin:(ZSkin *)skin
{
    if (skin != _skin)
    {
        _skin = skin;
        [[NSNotificationCenter defaultCenter] postNotificationName:ZSkinChangedNotificationKey
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
    assert(index >= 0 && index < self.skins.count);
    self.skin = [self.skins objectAtIndex:index];
}


- (ZSkin *)skinNamed:(NSString *)name
{
    if (name.length <= 0)return nil;

    for (ZSkin *skin in self.skins)
    {
        if ([skin.name isEqualToString:name])
        {
            return skin;
        }
    }
    return nil;
}
@end

