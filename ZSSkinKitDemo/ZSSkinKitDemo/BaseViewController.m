//
//  BaseViewController.m
//  ZSThemeKitDemo
//
//  Created by peter.shi on 16/7/20.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "BaseViewController.h"
#import "ZSSkinManager.h"
#import "NSObject+Skin.h"
#import "ZSSkinDefine.h"

@interface BaseViewController ()

@property (nonatomic) UISegmentedControl *segment;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
    [self prepareData];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:ZSSkinChangedNotificationKey
                                               object:nil];
    [self.view bind:@"backgroundColor" to:@"color.error"];
}

- (void)prepareData
{
    self.skin = [ZSSkinManager instance].skin;

    [self.segment removeAllSegments];
    for (int i = 0; i < [ZSSkinManager instance].skins.count; ++i)
    {
        ZSSkin *skin = [[ZSSkinManager instance].skins objectAtIndex:i];
        [self.segment insertSegmentWithTitle:skin.name atIndex:i animated:NO];
        if (self.skin == skin)
        {
            [self.segment setSelectedSegmentIndex:i];
        }
    }
}


- (void)prepareUI
{
    CGRect rect = CGRectMake(0,self.view.frame.size.height - 30,self.view.frame.size.width,30);
    self.segment = [[UISegmentedControl alloc] initWithFrame:rect];
    [self.segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
}

- (IBAction)segmentValueChanged:(id)sender
{
    self.skin = [[ZSSkinManager instance].skins objectAtIndex:self.segment.selectedSegmentIndex];
    [ZSSkinManager instance].skin = self.skin;
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

- (void)receiveNotification:(NSNotification *)notification
{
    NSLog(@"receive skin change notifaction");
    self.title = self.skin.name;
}
@end
