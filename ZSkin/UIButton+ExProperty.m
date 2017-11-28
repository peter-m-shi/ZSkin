//
//  UIButton+ExProperty..m
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "UIButton+ExProperty.h"

@implementation UIButton (ExProperty)

- (UIColor *)titleColorNormal {
    return [self titleColorForState:UIControlStateNormal];
}


- (void)setTitleColorNormal:(UIColor *)titleColorNormal {
    [self setTitleColor:titleColorNormal forState:UIControlStateNormal];
}


- (UIColor *)titleColorHightlight {
    return [self titleColorForState:UIControlStateHighlighted];
}


- (void)setTitleColorHightlight:(UIColor *)titleColorHightlight {
    [self setTitleColor:titleColorHightlight forState:UIControlStateHighlighted];
}


- (UIColor *)titleColorSelected {
    return [self titleColorForState:UIControlStateSelected];
}


- (void)setTitleColorSelected:(UIColor *)titleColorSelected {
    [self setTitleColor:titleColorSelected forState:UIControlStateSelected];
}

@end
