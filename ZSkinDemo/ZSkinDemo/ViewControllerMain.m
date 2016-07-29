//
//  ViewControllerMain.m
//  ZSThemeKitDemo
//
//  Created by peter.shi on 16/7/20.
//  Copyright © 2016年 peter.shi. All rights reserved.
//

#import "ViewControllerMain.h"
#import "ViewControllerButton.h"

@interface ViewControllerMain ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *menuList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewControllerMain

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];


    [self prepareData];
}


- (void)prepareData
{
    [super prepareData];

    self.menuList = [NSMutableArray new];
    [self.menuList addObject:@"label"];
    [self.menuList addObject:@"button"];
    [self.menuList addObject:@"image"];
}


- (void)didReceiveMemoryWarning
{
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIndentifier = @"SimpleTableIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIndentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIndentifier];
    }

    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.menuList objectAtIndex:row];
    cell.backgroundColor = [UIColor clearColor];


    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menuList.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
        {
            //lable
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewControllerLabel"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            //button
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            //image
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewControllerImage"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

@end
