//
//  ViewController.m
//  QZPageSwitchDemo
//
//  Created by Stephen Hu on 2018/11/13.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "ViewController.h"
#import "QZPageSwitch.h"
#import "pageViewController.h"

#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent  = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:252.0/255.0 green:182.0/255.0 blue:54.0/255.0 alpha:1.0];
    
    QZPageSwitch *nSwitch = [[QZPageSwitch alloc] initWithTitles:@[@"你好",@"我好大家好大家好大家好",@"大家好"]];
    [nSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    nSwitch.backgroundColor = [UIColor yellowColor];
    nSwitch.titleColor = [UIColor purpleColor];
    nSwitch.selectedBackgroundColor = [UIColor blueColor];
    nSwitch.selectedTitleColor = [UIColor yellowColor];
    nSwitch.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    nSwitch.selectedBackgroundInset = 0;
    nSwitch.frame = CGRectMake(0, 0, 250, 30);
    [nSwitch setSelectedIndex:1 animated:NO];
    [nSwitch setBadgeValue:5 forIndex:1];
    self.navigationItem.titleView = nSwitch;
    
    QZPageSwitch *vSwitch = [[QZPageSwitch alloc] init];
    vSwitch.titles = @[@"昨天",@"今天",@"明天"];
    vSwitch.backgroundColor = [UIColor redColor];
    vSwitch.titleColor = [UIColor whiteColor];
    vSwitch.selectedBackgroundColor = [UIColor whiteColor];
    vSwitch.selectedTitleColor = [UIColor redColor];
    vSwitch.titleFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    vSwitch.selectedBackgroundInset = 5;
    vSwitch.frame = CGRectMake(50, 100, 250, 80);
    vSwitch.badgeValueFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    vSwitch.badgeValueBackgroundColor = [UIColor lightGrayColor];
    vSwitch.badgeValueTextColor = [UIColor redColor];
    [vSwitch setBadgeValue:99 forIndex:0];
    [vSwitch setBadgeValue:5000000 forIndex:2];
    [self.view addSubview:vSwitch];
    
    QZPageSwitch *imgSwitch = [[QZPageSwitch alloc] init];
    imgSwitch.titles = @[@"柯基",@"泰迪",@"小柴"];
    imgSwitch.backgroundColor = [UIColor colorWithRed:122.0/255.0 green:203.0/255.0 blue:108.0/255.0 alpha:1.0];
    imgSwitch.titleColor = [UIColor whiteColor];
    imgSwitch.selectedTitleColor = [UIColor colorWithRed:135.0/255.0 green:227.0/255.0 blue:120.0/255.0 alpha:1.0];
    imgSwitch.frame = CGRectMake(50, 200, 250, 50);
    imgSwitch.selectedBackgroundImage = [UIImage imageNamed:@"bg1"];
    [imgSwitch setBadgeValue:7 forIndex:1];
    [imgSwitch setBadgeValue:0 forIndex:0];
    [self.view addSubview:imgSwitch];
    
    UIButton *pageVcBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    pageVcBtn.frame = CGRectMake(20, 280, kScreenWidth - 40, 50);
    [pageVcBtn setTitle:@"滚动跟随" forState:UIControlStateNormal];
    pageVcBtn.titleLabel.textColor = [UIColor whiteColor];
    pageVcBtn.backgroundColor = [UIColor redColor];
    [pageVcBtn addTarget:self action:@selector(pageVcBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pageVcBtn];
}
- (void)pageVcBtnAction:(UIButton *)sender {
    pageViewController *pageVc = [pageViewController new];
    [self.navigationController pushViewController:pageVc animated:YES];
}
- (void)switchChange:(QZPageSwitch *)sender {
    NSLog(@"选择的角标是%ld",sender.selectedIndex);
    if ([sender badgeValueFromIndex:sender.selectedIndex] != 0) {
        [sender setBadgeValue:0 forIndex:sender.selectedIndex];
    }
}

@end
