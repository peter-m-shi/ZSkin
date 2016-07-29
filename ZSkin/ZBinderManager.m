//
//  ZBinderManager.m
//  ZSkinDemo
//
//  Created by peter.shi on 16/7/18.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZBinderManager.h"
#import "ZSkinManager.h"
#import "ZSkin.h"
#import "ZBinder.h"

@import UIKit;


#pragma mark - ZBinderManager -

#define K_BINDER_KEY_NORAML @"self.normal"
#define K_SKIN_MANAGER_KEY_PATH @"self.skinManager.skin"

@interface ZBinderManager ()

@property (nonatomic) ZSkinManager *skinManager;
@property (nonatomic) NSMutableDictionary *binderMap;

@end

@implementation ZBinderManager

+ (instancetype)instance
{
    static ZBinderManager *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
    return staticInstance;
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initVariable];
        [self initObserver];
    }

    return self;
}


- (void)initVariable
{
    self.skinManager = [ZSkinManager instance];
    self.binderMap = [NSMutableDictionary new];
}


- (void)initObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(skinDidChanged:)
                                                 name:ZSkinChangedNotificationKey
                                               object:nil];
}


- (void)bind:(id)target
  identifier:(NSString *)identifier
    callback:(callBackBlock)callback
{
    NSString *key = K_BINDER_KEY_NORAML;
    if ([self binderExisted:key identifier:identifier])
    {
        NSLog(@"existed binder identifier:%@",identifier);
        return;
    }

    ZBlockBinder *binder = [[ZBlockBinder alloc] initWithTarget:target identifier:identifier block:callback];

    [self appendBinder:binder forKey:key];
}


- (void)bind:(id)target
  identifier:(NSString *)identifier
    tKeyPath:(NSString *)tKeyPath
    observer:(id)observer
   oKeyPatrh:(NSString *)oKeyPath
   parameter:(void *)parameter
{
    NSString *key = [NSString stringWithFormat:@"%@.%@", K_SKIN_MANAGER_KEY_PATH, oKeyPath];

    if ([self binderExisted:key identifier:identifier])
    {
        NSLog(@"existed binder identifier:%@",identifier);
        return;
    }

    ZKVOBinder *info = [[ZKVOBinder alloc] initWithTarget:target
                                                 identifier:identifier
                                                   tKeyPath:tKeyPath
                                                   observer:observer
                                                  oKeyPatrh:oKeyPath
                                                  parameter:parameter];
    [self appendBinder:info forKey:key];
}


- (void)unBind:(id)target tKeyPath:(NSString *)tKeyPath oKeyPath:(NSString *)oKeyPath
{
    NSString *key = [NSString stringWithFormat:@"%@.%@", K_SKIN_MANAGER_KEY_PATH, oKeyPath];

    NSMutableArray *binderInfoList = self.binderMap[key];

    for (int i = (int)binderInfoList.count - 1; i >= 0; --i)
    {
        ZKVOBinder *binderInfo = binderInfoList[i];
        if (binderInfo.target == target
            && [binderInfo.tKeyPath isEqualToString:tKeyPath]
            && [binderInfo.oKeyPath isEqualToString:oKeyPath])
        {
            [binderInfoList removeObjectAtIndex:i];
            break;
        }
    }
}


- (NSString *)bindInfo:(id)target tKeyPath:(NSString *)tKeyPath
{
    for (NSMutableArray *binderInfoList in [self.binderMap allValues])
    {
        for (ZKVOBinder *binderInfo in binderInfoList)
        {
            if (binderInfo.target == target
                && [binderInfo.tKeyPath isEqualToString:tKeyPath])
            {
                return binderInfo.oKeyPath;
            }
        }
    }

    return nil;
}


#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"


#pragma mark - Notification CallBack -


- (void)skinDidChanged:(NSNotification *)notification
{
    for (ZBinder *binder in self.binderMap[K_BINDER_KEY_NORAML])
    {
        if ([binder isKindOfClass:[ZBlockBinder class]])
        {
            callBackBlock block = ((ZBlockBinder *)binder).block;
            if (block)
            {((callBackBlock)block)(notification.object);}
        }
    }
}


#pragma mark - private function -


- (BOOL)binderExisted:(NSString *)key identifier:(NSString *)identifier
{
    for (ZBinder *binder in self.binderMap[key])
    {
        if ([binder.identifier isEqualToString:identifier])
        {
            return YES;
        }
    }
    return NO;
}


- (void)appendBinder:(ZBinder *)binder forKey:(NSString *)key
{
    NSMutableArray *binderInfoList = [self binderListWithKey:key];
    [binderInfoList addObject:binder];
    [self.binderMap setObject:binderInfoList forKey:key];

    if ([binder isKindOfClass:[ZKVOBinder class]])
    {
        [self addObserver:binder
               forKeyPath:key
                  options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                  context:nil];
    }
    else if ([binder isKindOfClass:[ZBlockBinder class]])
    {
        callBackBlock block = ((ZBlockBinder *)binder).block;
        if (block)
        {
            block(self.skinManager.skin);
        }
    }
    else
    {
        assert(false);
    }
}


- (NSMutableArray *)binderListWithKey:(NSString *)key
{
    NSMutableArray *binderInfoList = self.binderMap[key];
    if (nil == binderInfoList)
    {
        binderInfoList = [NSMutableArray new];
    }
    return binderInfoList;
}




@end