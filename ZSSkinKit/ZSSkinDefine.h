//
//  ZSSkinDefine.h
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <objc/objc.h>
#import "UIButton+ExProperty.h"

@class ZSSkin;

typedef void (^callBackBlock)(ZSSkin *skin);

#define PATH(target,keypath) @__keypath(target,keypath)
#define VIEW(keypath) @__keypath(UIView.new,keypath)
#define BUTTON(keypath) @__keypath(UIButton.new,keypath)
#define LABEL(keypath) @__keypath(UILabel.new,keypath)
#define SKIN(keypath) @__keypath(ZSSkin.new,keypath)

#define __keypath(OBJ, PATH) \
(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))

