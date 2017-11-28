//
//  BaseViewController.m
//  ZSThemeKitDemo
//
//  Created by peter.shi on 16/7/20.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "BaseViewController.h"
#import "ZSkinManager.h"
#import "NSObject+Skin.h"
#import "ZSkinDefine.h"
#import "ZBinderManager.h"

@interface BaseViewController ()

@property (nonatomic) UISegmentedControl *segment;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self prepareUI];
    [self prepareData];

    [self.view bind:@"backgroundColor" to:@"color.error"];
}


- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:ZSkinChangedNotificationKey
                                               object:nil];
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void)prepareData
{
    self.skin = [ZSkinManager instance].skin;

    [self.segment removeAllSegments];
    for (int i = 0; i < [ZSkinManager instance].skins.count; ++i)
    {
        ZSkin *skin = [[ZSkinManager instance].skins objectAtIndex:i];
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
//    //Change skin with index number
//    [[ZSkinManager instance] setSkinIndexed:0];
//
//    //Change skin with name string
//    [[ZSkinManager instance] setSkinNamed:@"dark"];

    //Change skin
    self.skin = [[ZSkinManager instance].skins objectAtIndex:self.segment.selectedSegmentIndex];
    NSLog(@"%@",[ZBinderManager instance]);
    [ZSkinManager instance].skin = self.skin;
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
    ZSkin *skin = notification.object;
    NSLog(@"%@ receive skin change notification:%@", self.class, skin);
    self.title = skin.name;
}
@end
