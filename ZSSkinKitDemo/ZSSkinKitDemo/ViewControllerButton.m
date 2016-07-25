//
//  ViewController.m
//  ZSSkinKit
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ViewControllerButton.h"
#import "ZSSkinKit.h"

@interface ViewControllerButton ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UITextField *textField;

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
    //Binding By Literal
    [self.textField bind:@"backgroundColor" to:@"color.background"];

    //Binding By Macro Definition
    [self.textField bind:OP(self.textField, backgroundColor) to:SK(color.background)];
    [self.textField bind:OPView(backgroundColor) to:SK(color.foreground)];
    [self.label bind:OPLabel(textColor) to:SK(color.background)];

    //Binding By Assignment As RAC
    OBS(self.button, backgroundColor) = SK(color.background);
    OBS(self.button, titleColorNormal) = SK(color.foreground);
    OBS(self.button, titleColorHightlight) = SK(color.foreground);
    OBS(self.button, titleColorSelected) = SK(color.foreground);
    
    OBS(self.button2, backgroundColor) = SK(color.foreground);
    OBS(self.button2, titleColorNormal) = SK(color.background);
    OBS(self.button2, titleColorHightlight) = SK(color.background);
    OBS(self.button2, titleColorSelected) = SK(color.background);
    
    //Custom Binding
    [self.button3 bind:^(ZSSkin *skin) {
        [self.button3 setBackgroundColor:skin.color.foreground];
        [self.button3 setTitleColor:skin.color.background forState:UIControlStateNormal];
        [self.button3 setTitle:skin.name forState:UIControlStateNormal];
        [self.button3.titleLabel setFont:[UIFont boldSystemFontOfSize:[skin.font.largeSize floatValue]]];
    }];
}


- (IBAction)clickToBindOrUnBind:(id)sender
{
    UIButton *btn = (UIButton *)sender;

    //Dynamic Binding And UnBinding
    NSString *oKeyPath = [btn bindInfo:@"backgroundColor"];
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
