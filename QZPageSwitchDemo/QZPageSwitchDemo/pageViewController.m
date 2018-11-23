//
//  pageViewController.m
//  QZPageSwitchDemo
//
//  Created by Stephen Hu on 2018/11/15.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "pageViewController.h"

#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
@interface pageViewController ()

@end

@implementation pageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    QZPageSwitch *imgSwitch = [[QZPageSwitch alloc] init];
    imgSwitch.titles = @[@"柯基",@"泰日天",@"小柴"];
    imgSwitch.backgroundColor = [UIColor colorWithRed:122.0/255.0 green:203.0/255.0 blue:108.0/255.0 alpha:1.0];
    imgSwitch.titleColor = [UIColor whiteColor];
    imgSwitch.selectedTitleColor = [UIColor colorWithRed:135.0/255.0 green:227.0/255.0 blue:120.0/255.0 alpha:1.0];
    imgSwitch.frame = CGRectMake(50, 0, kScreenWidth - 100, 35);
    imgSwitch.selectedBackgroundImage = [UIImage imageNamed:@"bg1"];
    imgSwitch.followStyle = self.switchStyle;
    [imgSwitch addTarget:self action:@selector(aaa:) forControlEvents:UIControlEventValueChanged];
    [imgSwitch setSelectedIndex:2 animated:NO];
    [self.view addSubview:imgSwitch];
    
    QZPageSwitch *imgSwitch2 = [[QZPageSwitch alloc] init];
    imgSwitch2.haveBackCorner = YES;
    imgSwitch2.haveSwitchCorner = YES;
    imgSwitch2.titles = @[@"柯基大屁股",@"泰日天",@"小柴在睡觉"];
    imgSwitch2.backgroundColor = [UIColor colorWithRed:122.0/255.0 green:203.0/255.0 blue:108.0/255.0 alpha:1.0];
    imgSwitch2.titleColor = [UIColor whiteColor];
    imgSwitch2.selectedTitleColor = [UIColor colorWithRed:135.0/255.0 green:227.0/255.0 blue:120.0/255.0 alpha:1.0];
    imgSwitch2.frame = CGRectMake(50, 40, kScreenWidth - 100, 35);
    imgSwitch2.selectedBackgroundImage = [UIImage imageNamed:@"bg1"];
    imgSwitch2.followStyle = self.switchStyle;
    [imgSwitch2 addTarget:self action:@selector(aaa:) forControlEvents:UIControlEventValueChanged];
    [imgSwitch2 setSelectedIndex:2 animated:NO];
    imgSwitch2.distributionWay = QZPageSwitchDistributionWayNotScrollAdaptContent;
    imgSwitch2.selectedBackgroundInset = 0;
    [self.view addSubview:imgSwitch2];
    
    QZPageSwitch *imgSwitch3 = [[QZPageSwitch alloc] init];
    imgSwitch3.haveBackCorner = YES;
    imgSwitch3.haveSwitchCorner = YES;
    imgSwitch3.titles = @[@"柯基大屁股",@"泰日天今天好像很乖",@"柴"];
    imgSwitch3.backgroundColor = [UIColor colorWithRed:122.0/255.0 green:203.0/255.0 blue:108.0/255.0 alpha:1.0];
    imgSwitch3.titleColor = [UIColor whiteColor];
    imgSwitch3.selectedTitleColor = [UIColor colorWithRed:135.0/255.0 green:227.0/255.0 blue:120.0/255.0 alpha:1.0];
    imgSwitch3.frame = CGRectMake(50, 80, kScreenWidth - 100, 35);
    imgSwitch3.selectedBackgroundImage = [UIImage imageNamed:@"bg1"];
    imgSwitch3.followStyle = self.switchStyle;
    [imgSwitch3 addTarget:self action:@selector(aaa:) forControlEvents:UIControlEventValueChanged];
    [imgSwitch3 setSelectedIndex:2 animated:NO];
    imgSwitch3.distributionWay = QZPageSwitchDistributionWayNotScrollAdaptContent;
    imgSwitch3.selectedBackgroundInset = 0;
    imgSwitch3.spaceWidth = 3;
    imgSwitch3.marginWidth = 8;
    [self.view addSubview:imgSwitch3];
    
    UIScrollView *pageView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 120, kScreenWidth - 100, 350)];
    UIView *cotainView     = [[UIView alloc] initWithFrame:pageView.bounds];
    cotainView.backgroundColor = [UIColor magentaColor];
    UIImageView *kejiView      = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keji.jpg"]];
    UIImageView *taidiView     = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taidi.jpg"]];
    UIImageView *xiaochaiView  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiaochai.jpg"]];
    CGRect kejiFrame  = CGRectMake(0, 0, pageView.bounds.size.width, pageView.bounds.size.height);
    kejiView.frame    = kejiFrame;
    CGRect taidiFrame = CGRectMake(pageView.bounds.size.width, 0, pageView.bounds.size.width, pageView.bounds.size.height);
    taidiView.frame   = taidiFrame;
    CGRect xiaochaiFrame = CGRectMake(pageView.bounds.size.width * 2, 0, pageView.bounds.size.width, pageView.bounds.size.height);
    xiaochaiView.frame   = xiaochaiFrame;
    [cotainView addSubview:kejiView];
    [cotainView addSubview:taidiView];
    [cotainView addSubview:xiaochaiView];
    [pageView   addSubview:cotainView];
    [self.view  addSubview:pageView];
    imgSwitch.switchPageView  = pageView;
    imgSwitch2.switchPageView = pageView;
    imgSwitch3.switchPageView = pageView;
}

- (void)aaa:(QZPageSwitch *)imgSwitch {
    if (imgSwitch.selectedIndex == 2) {
        
    }
}

@end
