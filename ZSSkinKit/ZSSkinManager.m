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
        [self setCurrentSkin:[_skins firstObject]];
    }

    return self;
}


- (void)setCurrentSkin:(ZSSkin *)skin
{
    if (skin != _currentSkin)
    {
        _currentSkin = skin;
        [_skinLoader loadSkin:_currentSkin];
        [[NSNotificationCenter defaultCenter] postNotificationName:ZSSkinChangedNotificationKey
                                                            object:_currentSkin
                                                          userInfo:nil];
    }
}

@end

