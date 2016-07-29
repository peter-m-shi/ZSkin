//
//  BaseViewController.h
//  ZSThemeKitDemo
//
//  Created by peter.shi on 16/7/20.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSkin.h"

@interface BaseViewController : UIViewController

@property (nonatomic) ZSkin *skin;

- (void)prepareUI;
- (void)prepareData;

@end
