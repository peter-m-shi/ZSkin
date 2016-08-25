//
//  ZBindingAssistant.h
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSkinDefine.h"

/// Assigns a keypath to an object property, automatically setting the given key
/// path on every `next`. When the keypath value changed, the binding is automatically
/// disposed of.
///
/// There are two different versions of this macro:
///
///  - ZSB(TARGET, KEYPATH) will bind the `KEYPATH` of `TARGET` to the
///    given KEYPATH.
///  - ZSB(TARGET, KEYPATH) is the same as the above, but `NILVALUE` defaults to
///    `nil`.
///
///
/// Examples
///
///  ZSB(self, objectProperty) = SK(color.background);
///
/// WARNING: Under certain conditions, use of this macro can be thread-unsafe.
///          See the documentation of -setKeyPath:onObject:nilValue:.

#define ZSB(TARGET, ...) \
        (ZSB_(TARGET, __VA_ARGS__)) \

/// Do not use this directly. Use the ZSB macro above.
#define ZSB_(TARGET, KEYPATH) \
    [[ZBindingAssistant alloc] initWithTarget:(TARGET)][@__keypath(TARGET, KEYPATH)]

/**
 *  ZBindingAssistant
 */
@interface ZBindingAssistant : NSMutableDictionary

- (id)initWithTarget:(id)target;
- (void)setObject:(NSString *)tKeyPath forKeyedSubscript:(NSString *)oKeyPath;

@end
