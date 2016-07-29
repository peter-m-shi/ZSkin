//
//  ViewController.m
//  ZSkin
//
//  Created by peter.shi on 16/7/14.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ViewControllerButton.h"
#import "ZSkinKit.h"
#import "ZColorSkin+Custom.h"

@interface MyButton : UIButton
@end

@implementation MyButton

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    NSLog(@"My Button setBackgroundColor be called");
    [super setBackgroundColor:backgroundColor];
}

@end

@interface ViewControllerButton ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) MyButton *myButton;

@end


@implementation ViewControllerButton

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGRect frame = CGRectMake(self.button4.frame.origin.x + 50,self.button4.frame.origin.y,self.button4.frame.size.width,self.button4.frame.size.height);
    self.myButton = [[MyButton alloc] initWithFrame:frame];
    [self.view addSubview:self.myButton];

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
    ZSB(self.button, backgroundColor) = SK(color.background);
    ZSB(self.button, titleColorNormal) = SK(color.foreground);
    ZSB(self.button, titleColorHightlight) = SK(color.foreground);
    ZSB(self.button, titleColorSelected) = SK(color.foreground);
    
    ZSB(self.button2, backgroundColor) = SK(color.foreground);
    ZSB(self.button2, titleColorNormal) = SK(color.background);
    ZSB(self.button2, titleColorHightlight) = SK(color.background);
    ZSB(self.button2, titleColorSelected) = SK(color.background);
    
    //Custom Binding
    [self.button3 bind:^(ZSkin *skin) {
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

- (IBAction)clickTestRebind:(id)sender {
    //Binding in repeatable function
    [self.button4 bind:^(ZSkin *skin) {
        //TODO:do something
        NSLog(@"repeatable examle called back");
    }];

    ZSB(self.myButton, backgroundColor) = SK(color.foreground);ZSB(self.myButton, titleColorNormal) = SK(color.background);
    
    for (int i = 0; i < 3; i++) {
        [self test];
    }
}

- (void)test
{
    ZSB(self.myButton, titleColorHightlight) = SK(color.background);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
