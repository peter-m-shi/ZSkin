//
//  ZSBindingAssistant.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSSkinDefine.h"

/// Assigns a keypath to an object property, automatically setting the given key
/// path on every `next`. When the keypath value changed, the binding is automatically
/// disposed of.
///
/// There are two different versions of this macro:
///
///  - OBS(TARGET, KEYPATH) will bind the `KEYPATH` of `TARGET` to the
///    given KEYPATH.
///  - OBS(TARGET, KEYPATH) is the same as the above, but `NILVALUE` defaults to
///    `nil`.
///
///
/// Examples
///
///  OBS(self, objectProperty) = @"color.background";
///
/// WARNING: Under certain conditions, use of this macro can be thread-unsafe.
///          See the documentation of -setKeyPath:onObject:nilValue:.

#define OBS(TARGET, ...) \
        (OBS_(TARGET, __VA_ARGS__)) \

/// Do not use this directly. Use the RAC macro above.
#define OBS_(TARGET, KEYPATH) \
    [[ZSBindingAssistant alloc] initWithTarget:(TARGET)][@__keypath(TARGET, KEYPATH)]

@interface ZSBindingAssistant : NSMutableDictionary

- (id)initWithTarget:(id)target;
- (void)setObject:(NSString *)tKeyPath forKeyedSubscript:(NSString *)oKeyPath;

@end
