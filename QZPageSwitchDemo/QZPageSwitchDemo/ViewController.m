//
//  ViewController.m
//  QZPageSwitchDemo
//
//  Created by Stephen Hu on 2018/11/13.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "ViewController.h"
#import "QZPageSwitch.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent  = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:252.0/255.0 green:182.0/255.0 blue:54.0/255.0 alpha:1.0];
    
    QZPageSwitch *nSwitch = [[QZPageSwitch alloc] initWithTitles:@[@"你好",@"我好",@"大家好"]];
    [nSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    nSwitch.backgroundColor = [UIColor yellowColor];
    nSwitch.titleColor = [UIColor purpleColor];
    nSwitch.selectedBackgroundColor = [UIColor blueColor];
    nSwitch.selectedTitleColor = [UIColor yellowColor];
    nSwitch.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    nSwitch.selectedBackgroundInset = 0;
    nSwitch.frame = CGRectMake(0, 0, 250, 30);
    self.navigationItem.titleView = nSwitch;
    [nSwitch setSelectedIndex:1 animated:NO];
    
    QZPageSwitch *vSwitch = [[QZPageSwitch alloc] init];
    vSwitch.titles = @[@"昨天",@"今天",@"明天"];
    vSwitch.backgroundColor = [UIColor redColor];
    vSwitch.titleColor = [UIColor whiteColor];
    vSwitch.selectedBackgroundColor = [UIColor whiteColor];
    vSwitch.selectedTitleColor = [UIColor redColor];
    vSwitch.titleFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    vSwitch.selectedBackgroundInset = 5;
    vSwitch.frame = CGRectMake(50, 100, 250, 80);
    [self.view addSubview:vSwitch];
    
    QZPageSwitch *imgSwitch = [[QZPageSwitch alloc] init];
    imgSwitch.titles = @[@"柯基",@"泰迪",@"小柴"];
    imgSwitch.backgroundColor = [UIColor colorWithRed:122.0/255.0 green:203.0/255.0 blue:108.0/255.0 alpha:1.0];
    imgSwitch.titleColor = [UIColor whiteColor];
    imgSwitch.selectedTitleColor = [UIColor colorWithRed:135.0/255.0 green:227.0/255.0 blue:120.0/255.0 alpha:1.0];
    imgSwitch.frame = CGRectMake(50, 200, 250, 50);
    imgSwitch.selectedBackgroundImage = [UIImage imageNamed:@"bg1"];
    [self.view addSubview:imgSwitch];
}

- (void)switchChange:(QZPageSwitch *)sender {
    NSLog(@"选择的角标是%ld",sender.selectedIndex);
}

@end
