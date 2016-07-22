//
//  ViewController.m
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ViewControllerButton.h"
#import "ZSSkinManager.h"
#import "ZSSkin.h"
#import "NSObject+Skin.h"
#import "ZSSkinBinder.h"
#import "ZSSkinDefine.h"


@interface ViewControllerButton ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) ZSSkinBinder *binder;
@end


@implementation ViewControllerButton

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUIColor];
}

- (void)initUIColor
{
    [self.textField bind:VIEW(backgroundColor) to:SKIN(color.foreground)];
    
    [self.label bind:PATH(self.label, textColor) to:SKIN(color.background)];
    [self.label bind:LABEL(textColor) to:SKIN(color.background)];

    [self.button bind:VIEW(backgroundColor) to:SKIN(color.background)];
    [self.button bind:BUTTON(titleColorNormal) to:SKIN(color.foreground)];
    [self.button bind:BUTTON(titleColorHightlight) to:SKIN(color.foreground)];
    [self.button bind:BUTTON(titleColorSelected) to:SKIN(color.foreground)];
    
    [self.button2 bind:VIEW(backgroundColor) to:SKIN(color.foreground)];
    [self.button2 bind:BUTTON(titleColorNormal) to:SKIN(color.background)];
    [self.button2 bind:BUTTON(titleColorHightlight) to:SKIN(color.background)];
    [self.button2 bind:BUTTON(titleColorSelected) to:SKIN(color.background)];
    
    [self.button3 bind:^(ZSSkin *skin) {
        [self.button3 setBackgroundColor:skin.color.foreground];
        [self.button3 setTitleColor:skin.color.background forState:UIControlStateNormal];
        [self.button3 setTitle:skin.name forState:UIControlStateNormal];
        [self.button3.titleLabel setFont:[UIFont boldSystemFontOfSize:[skin.font.largeSize floatValue]]];
    }];
}

- (IBAction)clickToBindOrUnBind:(id)sender {
    UIButton *btn = (UIButton *)sender;

    NSString * oKeyPath = [btn bindInfo:@"backgroundColor"];
    if (oKeyPath)
    {
        [btn unBind:@"backgroundColor" to:oKeyPath];
        [btn setTitle:@"Click to bind" forState:UIControlStateNormal];
    }
    else
    {
        [btn bind:@"backgroundColor" to:@"color.foreground"];
        [btn setTitle:@"Click to unbind" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
