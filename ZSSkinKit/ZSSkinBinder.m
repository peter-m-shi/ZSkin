//
//  ZSSkinBinder.m
//  ZSSkinKitDemo
//
//  Created by peter.shi on 16/7/18.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZSSkinBinder.h"
#import "ZSSkinManager.h"
#import "ZSSkin.h"

@import UIKit;

#pragma mark - ZSBinderInfo -

@interface ZSBinderInfo : NSObject

@property (nonatomic) id target;
@property (nonatomic) id observer;
@property (nonatomic) NSString *tKeyPath;
@property (nonatomic) NSString *oKeyPath;
@property (nonatomic) SEL selector;
@property (nonatomic) void *parameter;

@end

@implementation ZSBinderInfo

- (instancetype)initWithTarget:(id)target
                      tKeyPath:(NSString *)tKeyPath
                      observer:(id)observer
                     oKeyPatrh:(NSString *)oKeyPath
                     parameter:(void *)parameter
{
    self = [super init];
    if (self)
    {
        _target = target;
        _tKeyPath = tKeyPath;
        _observer = observer;
        _oKeyPath = oKeyPath;
        _parameter = parameter;
    }

    return self;
}

@end

#pragma mark - ZSSkinBinder -

#define K_SKIN_MANAGER_KEY_PATH @"self.skinManager.skin"

@interface ZSSkinBinder ()

@property (nonatomic) ZSSkinManager *skinManager;
@property (nonatomic) NSMutableDictionary *binderInfoMap;
@property (nonatomic) NSMutableArray *callbacks;

@end

@implementation ZSSkinBinder

+ (instancetype)instance
{
    static ZSSkinBinder *staticInstance = nil;
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
    self.skinManager = [ZSSkinManager instance];
    self.binderInfoMap = [NSMutableDictionary new];
    self.callbacks = [NSMutableArray new];
}

- (void)initObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(skinDidChanged:)
                                                 name:ZSSkinChangedNotificationKey
                                               object:nil];
}

- (void)bind:(id)target tKeyPath:(NSString *)tKeyPath observer:(id)observer oKeyPatrh:(NSString *)oKeyPath parameter:(void *)parameter
{
    NSString *realKeyPath = [NSString stringWithFormat:@"%@.%@", K_SKIN_MANAGER_KEY_PATH, oKeyPath];

    NSMutableArray *binderInfoList = self.binderInfoMap[realKeyPath];
    if (nil == binderInfoList)
    {
        binderInfoList = [NSMutableArray new];
    }

    ZSBinderInfo *info = [[ZSBinderInfo alloc] initWithTarget:target
                                                     tKeyPath:tKeyPath
                                                     observer:observer
                                                    oKeyPatrh:oKeyPath
                                                    parameter:parameter];
    [binderInfoList addObject:info];

    [self.binderInfoMap setObject:binderInfoList forKey:realKeyPath];

    [self addObserver:self
           forKeyPath:realKeyPath
              options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
              context:&info];
}

- (void)unBind:(id)target tKeyPath:(NSString *)tKeyPath oKeyPath:(NSString *)oKeyPath
{
    NSString *realKeyPath = [NSString stringWithFormat:@"%@.%@", K_SKIN_MANAGER_KEY_PATH, oKeyPath];

    NSMutableArray *binderInfoList = self.binderInfoMap[realKeyPath];

    for (int i = (int)binderInfoList.count - 1; i >= 0; --i)
    {
        ZSBinderInfo *binderInfo = binderInfoList[i];
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
    for (NSMutableArray *binderInfoList in [self.binderInfoMap allValues])
    {
        for (ZSBinderInfo *binderInfo in binderInfoList)
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

- (void)bind:(callBackBlock)callback
{
    [self.callbacks addObject:[callback copy]];
    if (callback)
    {
        id skin = self.skinManager.skin;
        callback(skin);
    }
}

#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSMutableArray *binderInfoList = self.binderInfoMap[keyPath];
    assert(binderInfoList);

    for (ZSBinderInfo *binderInfo in binderInfoList)
    {
        id value = [change objectForKey:@"new"];
        [self notifyTarget:binderInfo value:value];
    }
}


- (void)skinDidChanged:(NSNotification *)notification
{
    for (id callback in self.callbacks)
    {
        if (callback)
        {
            ((callBackBlock)callback)(notification.object);
        }
    }
}

- (void)notifyTarget:(ZSBinderInfo *)binderInfo value:(id)value
{
    if (nil == binderInfo.selector)
    {
        binderInfo.selector = [self selectorFromKeyPath:binderInfo];
    }

    if ([binderInfo.target respondsToSelector:binderInfo.selector])
    {
        NSMethodSignature *sig = [binderInfo.target methodSignatureForSelector:binderInfo.selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:binderInfo.target];
        [invocation setSelector:binderInfo.selector];
        [invocation setArgument:&value atIndex:2];
        if (binderInfo.parameter)
        {
            [invocation setArgument:binderInfo.parameter atIndex:3];
        }
        [invocation invoke];
    }
    else
    {
        NSLog(@"[ZSSkinBinder] target:%@ not response SEL: %@", binderInfo.target, NSStringFromSelector(binderInfo.selector));
    }
}


- (SEL)selectorFromKeyPath:(ZSBinderInfo *)binderInfo
{
    NSString *headChar = [binderInfo.tKeyPath substringToIndex:1];
    NSString *bodyStr = [binderInfo.tKeyPath substringFromIndex:1];
    NSString *formatStr = @"set%@%@:";
    if ([binderInfo.target isKindOfClass:[UIButton class]] && [binderInfo.tKeyPath isEqualToString:@"titleColor"])
    {
        formatStr = @"set%@%@:forState:";
    }
    NSString *selectorStr = [NSString stringWithFormat:formatStr, [headChar uppercaseString], bodyStr];
    return NSSelectorFromString(selectorStr);
}
@end