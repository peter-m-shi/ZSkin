//
//  ViewControllerImage.m
//  ZSThemeKitDemo
//
//  Created by peter.shi on 16/7/21.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ViewControllerImage.h"
#import "NSObject+Skin.h"

@interface ViewControllerImage ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (nonatomic) int count;
@end

@implementation ViewControllerImage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.button bind:^(ZSSkin *skin) {
        [self.button setImage:[skin.picture imageNamed:@"folder1/test.png"] forState:UIControlStateNormal];
    }];

    [self.image bind:^(ZSSkin *skin) {
        [self.image setImage:[skin.picture imageNamed:@"folder1/test.png"]];
    }];

    [self.image2 setBackgroundColor:[UIColor redColor]];
    [self.image2 bind:^(ZSSkin *skin) {
        if (self.count % 2 == 0)
        {
            [self.image2 setImage:[ZSImageSkin imageNamed:@"aspectSelect_btn0_normal" inBundle:@"1403909a57b446bb8e55094e7450ff8f"]];
        }
        else
        {
            [self.image2 setImage:[ZSImageSkin imageNamed:@"aspectSelect_btn0_normal" inBundle:@"e02ae0e472604e47bfcf389e4ccf37ba"]];
        }
        self.count += 1;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
