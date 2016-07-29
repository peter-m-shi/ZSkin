//
//  ZBinder.m
//  ZSkinDemo
//
//  Created by peter.shi on 16/7/28.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZBinder.h"
#import "ZRuntimeUtility.h"

#pragma mark - ZSKVOBinder -

@interface ZBinder ()

@property (nonatomic, weak, readwrite) id target;
@property (nonatomic, copy, readwrite) NSString *identifier;
@end

@implementation ZBinder

- (instancetype)initWithTarget:(id)target identifier:(NSString *)identifier
{
    self = [super init];
    if (self)
    {
        self.target = target;
        self.identifier = identifier;
    }

    return self;
}


#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
- (NSString *)description
{
    NSMutableString *description = [NSMutableString new];

    [description appendString:[NSString stringWithFormat:@"#<%@: id = %p>\r\n", [self class], self]];

    for (NSString *property in [ZRuntimeUtility propertyNames:[self class]])
    {
        SEL selector = NSSelectorFromString(property);
        id value = [self performSelector:selector];
        [description appendString:[NSString stringWithFormat:@"   %@:%@\r\n", property, value]];
    }

    return description;
}
@end

#pragma mark - ZSKVOBinder -

@interface ZKVOBinder ()

@property (nonatomic, readwrite) id observer;
@property (nonatomic, copy, readwrite) NSString *tKeyPath;
@property (nonatomic, copy, readwrite) NSString *oKeyPath;
@property (nonatomic, readwrite) void *parameter;

@end

@implementation ZKVOBinder

- (instancetype)initWithTarget:(id)target
                    identifier:(NSString *)identifier
                      tKeyPath:(NSString *)tKeyPath
                      observer:(id)observer
                     oKeyPatrh:(NSString *)oKeyPath
                     parameter:(void *)parameter
{
    self = [super initWithTarget:target identifier:identifier];
    if (self)
    {
        self.tKeyPath = tKeyPath;
        self.observer = observer;
        self.oKeyPath = oKeyPath;
        self.parameter = parameter;
    }

    return self;
}

#pragma mark - KVO CallBack -


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    id value = [change objectForKey:@"new"];
    [self notifyTarget:value];
}


- (void)notifyTarget:(id)value
{
    if (nil == self.selector)
    {
        self.selector = [self selectorFromKeyPath:self];
    }

    if ([self.target respondsToSelector:self.selector])
    {
        NSMethodSignature *sig = [self.target methodSignatureForSelector:self.selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setTarget:self.target];
        [invocation setSelector:self.selector];
        [invocation setArgument:&value atIndex:2];
        if (self.parameter)
        {
            [invocation setArgument:self.parameter atIndex:3];
        }
        [invocation invoke];
    }
    else
    {
        NSLog(@"[ZKVOBinder] target:%@ not response SEL: %@", self.target, NSStringFromSelector(self.selector));
    }
}


- (SEL)selectorFromKeyPath:(ZKVOBinder *)binderInfo
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

#pragma mark - ZSBlockBinder -

@interface ZBlockBinder ()


@property (nonatomic, copy, readwrite) callBackBlock block;

@end

@implementation ZBlockBinder

- (instancetype)initWithTarget:(id)target
                    identifier:(NSString *)identifier
                         block:(callBackBlock)block
{
    self = [super initWithTarget:target identifier:identifier];
    if (self)
    {
        self.block = block;
    }

    return self;
}


@end
