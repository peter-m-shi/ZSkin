//
//  ZBinderManager.m
//  ZSkin
//
//  Created by peter.shi on 16/7/18.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZBinderManager.h"
#import "ZSkinManager.h"
#import "ZSkin.h"
#import "ZBinder.h"
#import "NSObject+KeyPath.h"
#import "ZRuntimeUtility.h"
#import "UIResponder+Dealloc.h"

#pragma mark - ZBinderManager -

#define K_BINDER_KEY_NORMAL @"self.normal"
#define K_SKIN_MANAGER_KEY_PATH @"self.skinManager.skin"

@interface ZBinderManager ()

@property (nonatomic) ZSkinManager *skinManager;
@property (nonatomic) NSMutableDictionary *binderMap;

@end

@implementation ZBinderManager

+ (instancetype)instance {
    static ZBinderManager *staticInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticInstance = [[self alloc] init];
    });
    return staticInstance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self initVariable];
        [self initObserver];
    }

    return self;
}


- (void)initVariable {
    self.skinManager = [ZSkinManager instance];
    self.binderMap = [NSMutableDictionary new];
}


- (void)initObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                           selector:@selector(skinDidChanged:)
                           name:ZSkinChangedNotificationKey
                           object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                           selector:@selector(responderDidDealloced:)
                           name:KUIResponderDeallocNotification
                           object:nil];
}


- (void)bind:(id)target
  identifier:(NSString *)identifier
    callback:(callBackBlock)callback {

    NSString *key = K_BINDER_KEY_NORMAL;
    if ([self binderExisted:key identifier:identifier]) {
        NSLog(@"existed binder identifier:%@", identifier);
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
   parameter:(void *)parameter {

    // Verify validity of oKeyPath
    if (![self.skinManager.skin isValidKeyPath:oKeyPath]) {
        return;
    }

    // can not find the property named "bacgroundColor" of UIView by runtime,so add some codes for special deal
    Class tClass;
    if ([@"backgroundColor" isEqualToString:tKeyPath] && [target isKindOfClass:[UIView class]]) {
        tClass = [UIColor class];
    }
    else {
        tClass = [ZRuntimeUtility propertyClassForPropertyName:tKeyPath ofClass:[target class]];
    }
    // Verify the property type of target is equal to the object of oKeyPath
    Class oClass = [self.skinManager.skin classOfKeyPath:oKeyPath];
    if (![[oClass new] isKindOfClass:tClass]) {
        return;
    }

    NSString *key = [NSString stringWithFormat:@"%@.%@", K_SKIN_MANAGER_KEY_PATH, oKeyPath];

    if ([self binderExisted:key identifier:identifier]) {
        NSLog(@"existed binder identifier:%@", identifier);
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


- (void)unBind:(id)target tKeyPath:(NSString *)tKeyPath oKeyPath:(NSString *)oKeyPath {
    NSString *key = [NSString stringWithFormat:@"%@.%@", K_SKIN_MANAGER_KEY_PATH, oKeyPath];
    
    NSMutableArray *binderList = self.binderMap[key];
    NSMutableArray *removeArray = [NSMutableArray array];
    
    for (int i = (int)binderList.count - 1; i >= 0; --i) {
        ZKVOBinder *binder = binderList[i];
        if (binder.target == target
            && [binder.tKeyPath isEqualToString:tKeyPath]
            && [binder.oKeyPath isEqualToString:oKeyPath]) {
            [removeArray addObject:binder];
            [self removeObserver:binder forKeyPath:key];
        }
    }
    [binderList removeObjectsInArray:removeArray];
}


- (NSString *)bindInfo:(id)target tKeyPath:(NSString *)tKeyPath {
    for (NSMutableArray *binderList in [self.binderMap allValues]) {
        for (ZKVOBinder *binder in binderList) {
            if (binder.target == target
                && [binder.tKeyPath isEqualToString:tKeyPath]) {
                return binder.oKeyPath;
            }
        }
    }

    return nil;
}


#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"


#pragma mark - Notification CallBack -


- (void)skinDidChanged:(NSNotification *)notification {

    for (ZBinder *binder in self.binderMap[K_BINDER_KEY_NORMAL]) {
        if ([binder isKindOfClass:[ZBlockBinder class]]) {
            callBackBlock block = ((ZBlockBinder *)binder).block;
            if (block) {
                ((callBackBlock)block)(binder.target, notification.object);
            }
        }
    }
}


#pragma mark - private function -


- (void)responderDidDealloced:(NSNotification *)notification {
    [self.binderMap enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableArray *array = obj;
        NSUInteger preCount = array.count;
        NSEnumerator *enumerator = [array reverseObjectEnumerator];
        id object;
        while ((object = [enumerator nextObject]) != nil) {
            ZBinder *binder = object;
            BOOL needRemove = YES;
            if ([binder isKindOfClass:[ZKVOBinder class]]) {
                needRemove = [binder.pointer isEqualToString:[NSString stringWithFormat:@"%p", notification.object]];
                if (needRemove) {
                    [self removeObserver:binder forKeyPath:key];
                }
            }

            if (needRemove) {
                if (!binder.target) {
                    [array removeObject:binder];
                }
            }
        }

        if (array.count != preCount) {
            [self.binderMap setObject:array forKey:key];
        }
    }];
}


- (BOOL)binderExisted:(NSString *)key identifier:(NSString *)identifier {
    for (ZBinder *binder in self.binderMap[key]) {
        if ([binder.identifier isEqualToString:identifier]) {
            return YES;
        }
    }
    return NO;
}


- (void)appendBinder:(ZBinder *)binder forKey:(NSString *)key {
    NSMutableArray *binderList = [self binderListWithKey:key];
    [binderList addObject:binder];
    [self.binderMap setObject:binderList forKey:key];

    if ([binder isKindOfClass:[ZKVOBinder class]]) {
        NSLog(@"**append** %@,(%p) %@", [binder.target class], binder.target, binder.pointer);

        [self addObserver:binder
              forKeyPath:key
              options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
              context:nil];
    }
    else if ([binder isKindOfClass:[ZBlockBinder class]]) {
        callBackBlock block = ((ZBlockBinder *)binder).block;
        if (block) {
            block(binder.target, self.skinManager.skin);
        }
    }
    else {
        assert(false);
    }
}


- (NSMutableArray *)binderListWithKey:(NSString *)key {
    NSMutableArray *binderList = self.binderMap[key];

    if (nil == binderList) {
        binderList = [NSMutableArray new];
    }

    return binderList;
}


- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];

    [description appendString:[NSString stringWithFormat:@"%@", self.binderMap]];
    [description appendString:@">"];

    return description;
}

@end
