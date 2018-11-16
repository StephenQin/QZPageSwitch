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
    imgSwitch.frame = CGRectMake(50, 0, kScreenWidth - 100, 50);
    imgSwitch.selectedBackgroundImage = [UIImage imageNamed:@"bg1"];
    imgSwitch.followStyle = self.switchStyle;
    [imgSwitch addTarget:self action:@selector(aaa:) forControlEvents:UIControlEventValueChanged];
    [imgSwitch setSelectedIndex:2 animated:NO];
    [self.view addSubview:imgSwitch];
    
    UIScrollView *pageView = [[UIScrollView alloc] initWithFrame:CGRectMake(50, 60, kScreenWidth - 100, 400)];
    UIView *cotainView = [[UIView alloc] initWithFrame:pageView.bounds];
    cotainView.backgroundColor = [UIColor magentaColor];
    UIImageView *kejiView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"keji.jpg"]];
    UIImageView *taidiView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"taidi.jpg"]];
    UIImageView *xiaochaiView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiaochai.jpg"]];
    CGRect kejiFrame = CGRectMake(0, 0, pageView.bounds.size.width, pageView.bounds.size.height);
    kejiView.frame = kejiFrame;
    CGRect taidiFrame = CGRectMake(pageView.bounds.size.width, 0, pageView.bounds.size.width, pageView.bounds.size.height);
    taidiView.frame = taidiFrame;
    CGRect xiaochaiFrame = CGRectMake(pageView.bounds.size.width * 2, 0, pageView.bounds.size.width, pageView.bounds.size.height);
    xiaochaiView.frame = xiaochaiFrame;
    [cotainView addSubview:kejiView];
    [cotainView addSubview:taidiView];
    [cotainView addSubview:xiaochaiView];
    [pageView addSubview:cotainView];
    [self.view addSubview:pageView];
    imgSwitch.switchPageView = pageView;
//    [imgSwitch setSelectedIndex:2 animated:NO];
}

- (void)aaa:(QZPageSwitch *)imgSwitch {
    if (imgSwitch.selectedIndex == 2) {
        
    }
}

@end
