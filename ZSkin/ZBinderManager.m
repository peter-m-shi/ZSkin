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
    [self collectGarbage];
    
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
    oKeyPath:(NSString *)oKeyPath
   parameter:(void *)parameter
{
    [self collectGarbage];
    
    // 判断oKeyPath是否合法
    if (![self isOKeyPathValid:oKeyPath])
    {
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%@.%@", K_SKIN_MANAGER_KEY_PATH, oKeyPath];

    if ([self binderExisted:key identifier:identifier])
    {
        NSLog(@"existed binder identifier:%@",identifier);
        return;
    }

    ZKVOBinder *binder = [[ZKVOBinder alloc] initWithTarget:target
                                                 identifier:identifier
                                                   tKeyPath:tKeyPath
                                                   observer:observer
                                                  oKeyPatrh:oKeyPath
                                                  parameter:parameter];
    [self appendBinder:binder forKey:key];
}


- (void)unBind:(id)target tKeyPath:(NSString *)tKeyPath oKeyPath:(NSString *)oKeyPath
{
    NSString *key = [NSString stringWithFormat:@"%@.%@", K_SKIN_MANAGER_KEY_PATH, oKeyPath];

    NSMutableArray *binderList = self.binderMap[key];

    for (int i = (int)binderList.count - 1; i >= 0; --i)
    {
        ZKVOBinder *binder = binderList[i];
        if (binder.target == target
            && [binder.tKeyPath isEqualToString:tKeyPath]
            && [binder.oKeyPath isEqualToString:oKeyPath])
        {
            [binderList removeObjectAtIndex:i];
            break;
        }
    }
}


- (NSString *)bindInfo:(id)target tKeyPath:(NSString *)tKeyPath
{
    for (NSMutableArray *binderList in [self.binderMap allValues])
    {
        for (ZKVOBinder *binder in binderList)
        {
            if (binder.target == target
                && [binder.tKeyPath isEqualToString:tKeyPath])
            {
                return binder.oKeyPath;
            }
        }
    }

    return nil;
}


#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"


#pragma mark - Notification CallBack -


- (void)skinDidChanged:(NSNotification *)notification
{
    [self collectGarbage];

    for (ZBinder *binder in self.binderMap[K_BINDER_KEY_NORAML])
    {
        if ([binder isKindOfClass:[ZBlockBinder class]])
        {
            callBackBlock block = ((ZBlockBinder *)binder).block;
            if (block)
            {((callBackBlock)block)(binder.target, notification.object);}
        }
    }
}


#pragma mark - private function -

- (void)collectGarbage
{
    for (NSString *key in [self.binderMap allKeys])
    {
        NSMutableArray *array = self.binderMap[key];
        for (int i = (int)array.count - 1; i >= 0; --i)
        {
            ZBinder *binder = array[i];
            if (!binder.target)
            {
                NSLog(@"Garbage Collect : binder = %@", binder);
                [array removeObjectAtIndex:i];
            }
        }
        [self.binderMap setObject:array forKey:key];
    }
}

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
    NSMutableArray *binderList = [self binderListWithKey:key];
    [binderList addObject:binder];
    [self.binderMap setObject:binderList forKey:key];

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
            block(binder.target, self.skinManager.skin);
        }
    }
    else
    {
        assert(false);
    }
}


- (NSMutableArray *)binderListWithKey:(NSString *)key
{
    NSMutableArray *binderList = self.binderMap[key];
    if (nil == binderList)
    {
        binderList = [NSMutableArray new];
    }
    return binderList;
}

- (BOOL)isOKeyPathValid:(NSString *)oKeyPath {
    if (!oKeyPath) {
        [self log:@"oKeyPath is nil"];
        return NO;
    }
    NSArray *oKeyPaths = [oKeyPath componentsSeparatedByString:@"."];
    if (oKeyPaths.count != 2) {
        [self log:@"oKeyPath must be like 'color.background'"];
        return NO;
    }
    SEL sel = NSSelectorFromString(oKeyPaths[0]);
    if (![self.skinManager.skin respondsToSelector:sel]) {
        [self log:[NSString stringWithFormat:@"Object 'skin' doesn't have a method named '%@'", oKeyPaths[0]]];
        return NO;
    }
    NSObject *obj = [self.skinManager.skin performSelector:sel];
    SEL sel2 = NSSelectorFromString(oKeyPaths[1]);
    if (![obj respondsToSelector:sel2]) {
        [self log:[NSString stringWithFormat:@"Object 'skin.%@' doesn't have a method named '%@'", oKeyPaths[0], oKeyPaths[1]]];
        return NO;
    }
    return YES;
}

- (void)log:(NSString *)logStr {
#ifdef DEBUG
    NSAssert(NO, logStr);
#else
    NSLog(logStr);
#endif
}


- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

    [description appendString:[NSString stringWithFormat:@"%@",self.binderMap]];

    [description appendString:@">"];
    return description;
}

@end
