//
//  ZSkinDefine.h
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <objc/objc.h>
#import <objc/runtime.h>
#import "UIButton+ExProperty.h"

@class ZSkin;

typedef void (^callBackBlock)(ZSkin *skin);

//
#define OP(target,keypath) @__keypath(target,keypath)
#define OPLayer(keypath) @__keypath(CALayer.new,keypath)
#define OPView(keypath) @__keypath(UIView.new,keypath)
#define OPBtn(keypath) @__keypath(UIButton.new,keypath)
#define OPLabel(keypath) @__keypath(UILabel.new,keypath)

#define SK(keypath) @__keypath(ZSkin.new,keypath)

#define __keypath(OBJ, PATH) \
(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))

/**
 Synthsize a dynamic object property in @implementation scope.
 It allows us to add custom properties to existing classes in categories.
 
 @warning #import <objc/runtime.h>
 *******************************************************************************
 Example:
 @interface NSObject (MyAdd)
 @property (nonatomic, strong) UIColor *myColor;
 @end
 
 #import <objc/runtime.h>
 @implementation NSObject (MyAdd)
 PROPERTY(myColor, setMyColor, UIColor *)
 @end
 */
#ifndef DYNAMIC
#define DYNAMIC(_getter_, _setter_, _type_) \
- (void)_setter_ : (_type_)object { \
[self willChangeValueForKey:@#_getter_]; \
objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC); \
[self didChangeValueForKey:@#_getter_]; \
} \
- (_type_)_getter_ { \
return objc_getAssociatedObject(self, @selector(_setter_:)); \
}
#endif