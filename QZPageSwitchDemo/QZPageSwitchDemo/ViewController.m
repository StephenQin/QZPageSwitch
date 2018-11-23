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
@property (nonatomic, weak) QZPageSwitch *pageSwitch;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent  = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:252.0/255.0 green:182.0/255.0 blue:54.0/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor blackColor];
    
    QZPageSwitch *nSwitch = [[QZPageSwitch alloc] initWithTitles:@[@"好",@"滚动大小跟随",@"大家好"]];
    nSwitch.haveBackCorner = YES;
    nSwitch.haveSwitchCorner = YES;
    [nSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    nSwitch.backgroundColor = [UIColor yellowColor];
    nSwitch.titleColor = [UIColor purpleColor];
    nSwitch.selectedBackgroundColor = [UIColor blueColor];
    nSwitch.selectedTitleColor = [UIColor yellowColor];
    nSwitch.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    nSwitch.selectedBackgroundInset = 2;
    nSwitch.frame = CGRectMake(0, 0, 250, 30);
    [nSwitch setSelectedIndex:1 animated:NO];
    [nSwitch setBadgeValue:5 forIndex:1];
    nSwitch.followStyle     = QZPageSwitchFollowStyleNormal;
    nSwitch.distributionWay = QZPageSwitchDistributionWayNotScrollEqualWidth;
    self.navigationItem.titleView = nSwitch;
    self.pageSwitch = nSwitch;
    
    QZPageSwitch *tSwitch = [[QZPageSwitch alloc] initWithTitles:@[@"好",@"你是谁呀",@"大家好",@"我就是来玩儿的"]];
    [tSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    tSwitch.backgroundColor = [UIColor blackColor];
    tSwitch.titleColor = [UIColor redColor];
    tSwitch.selectedBackgroundColor = [UIColor blueColor];
    tSwitch.selectedTitleColor = [UIColor yellowColor];
    tSwitch.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    tSwitch.selectedBackgroundInset = 0;
    tSwitch.frame = CGRectMake(50, 10, 250, 30);
    tSwitch.followStyle     = QZPageSwitchFollowStyleMatch;
    tSwitch.distributionWay = QZPageSwitchDistributionWayNotScrollAdaptContent;
    [tSwitch setSelectedIndex:1 animated:NO];
    [tSwitch setBadgeValue:5 forIndex:1];
    tSwitch.spaceWidth = 5;
    tSwitch.marginWidth = 5;
    [self.view addSubview:tSwitch];
    
    QZPageSwitch *tSwitch2 = [[QZPageSwitch alloc] initWithTitles:@[@"好",@"你是谁呀",@"大家好",@"我就是来"]];
    tSwitch2.haveBackCorner = YES;
    tSwitch2.haveSwitchCorner = YES;
    [tSwitch2 addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    tSwitch2.backgroundColor = [UIColor yellowColor];
    tSwitch2.titleColor = [UIColor purpleColor];
    tSwitch2.followStyle     = QZPageSwitchFollowStyleMatch;
    tSwitch2.distributionWay = QZPageSwitchDistributionWayNotScrollEqualWidth;
    tSwitch2.selectedBackgroundColor = [UIColor blueColor];
    tSwitch2.selectedTitleColor = [UIColor yellowColor];
    tSwitch2.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    tSwitch2.selectedBackgroundInset = 0;
    tSwitch2.frame = CGRectMake(50, 70, 250, 30);
    [tSwitch2 setSelectedIndex:1 animated:NO];
    [tSwitch2 setBadgeValue:5 forIndex:1];
    [self.view addSubview:tSwitch2];
    
    QZPageSwitch *vSwitch = [[QZPageSwitch alloc] init];
    vSwitch.haveBackCorner = YES;
    vSwitch.haveSwitchCorner = YES;
    vSwitch.followStyle     = QZPageSwitchFollowStyleMatch;
    vSwitch.distributionWay = QZPageSwitchDistributionWayNotScrollAdaptContent;
    vSwitch.backgroundColor = [UIColor redColor];
    vSwitch.titleColor = [UIColor whiteColor];
    vSwitch.selectedBackgroundColor = [UIColor whiteColor];
    vSwitch.selectedTitleColor = [UIColor redColor];
    vSwitch.titleFont = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    vSwitch.selectedBackgroundInset = 5;
    vSwitch.frame = CGRectMake(50, 120, 250, 40);
    vSwitch.titles = @[@"昨",@"今天是个好好日子啊",@"明天"];
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
    
    UIButton *pageVcBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pageVcBtn.frame = CGRectMake(20, 280, kScreenWidth - 40, 50);
    [pageVcBtn setTitle:@"测试滚动视图" forState:UIControlStateNormal];
    pageVcBtn.titleLabel.textColor = [UIColor whiteColor];
    pageVcBtn.backgroundColor = [UIColor redColor];
    [pageVcBtn addTarget:self action:@selector(pageVcBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pageVcBtn];
}
- (void)pageVcBtnAction:(UIButton *)sender {
    pageViewController *pageVc = [pageViewController new];
    if (self.pageSwitch.selectedIndex == 1) {
        pageVc.switchStyle = QZPageSwitchFollowStyleMatch;
    }
    [self.navigationController pushViewController:pageVc animated:YES];
}
- (void)switchChange:(QZPageSwitch *)sender {
    NSLog(@"选择的角标是%ld",sender.selectedIndex);
    if ([sender badgeValueFromIndex:sender.selectedIndex] != 0) {
        [sender setBadgeValue:0 forIndex:sender.selectedIndex];
    }
}

@end
