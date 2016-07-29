//
//  ZBindingAssistant.m
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ZBindingAssistant.h"
#import "ZSkinKit.h"

@interface ZBindingAssistant ()

// The object to bind to.
@property (nonatomic, strong, readonly) id target;

@end

@implementation ZBindingAssistant

- (id)initWithTarget:(id)target
{
    // This is often a programmer error, but this prevents crashes if the target
    // object has unexpectedly deallocated.
    if (target == nil)
    {return nil;}

    self = [super init];
    if (self == nil)
    {return nil;}

    _target = target;

    return self;
}


- (void)setObject:(NSString *)tKeyPath forKeyedSubscript:(NSString *)oKeyPath
{
    [self.target bind:oKeyPath to:tKeyPath];
}

@end
