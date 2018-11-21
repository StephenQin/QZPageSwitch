//
//  FFRunkeeperSwitch.h
//  FFSwitchDemo
//
//  Created by Stephen Hu on 2018/11/11.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, QZPageSwitchFollowStyle) {
    QZPageSwitchFollowStyleNormal = 0, // 均分
    QZPageSwitchFollowStyleMatch,      // 随文字宽度变化
};
typedef NS_ENUM(NSInteger, QZPageSwitchDistributionWay) {
    QZPageSwitchDistributionWayNotScrollEqualWidth = 0, // 不可滚动均分
    QZPageSwitchDistributionWayNotScrollAdaptContent,   // 不可滚动自适应位置
};
@interface QZPageSwitch : UIControl
/*
 先判断间隙加上label总宽度是否超出设置宽度 ？
 1. 不超出 按照预想布局
 2. 超出 计算超出的宽度值
    1、宽度 < n分之一的保持宽度全部显示超出的压缩为等宽
 */
/**titles数组*/
@property (nonatomic, copy) NSArray *titles;
/**滑块背景颜色*/
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
/**标题颜色*/
@property (nonatomic, strong) UIColor *titleColor;
/**选中标题颜色*/
@property (nullable, nonatomic, strong) UIColor *selectedTitleColor;
/**滑块的内边距*/
@property (nonatomic, assign) CGFloat selectedBackgroundInset;
/**title字体*/
@property (nonatomic, strong) UIFont *titleFont;
/**选择的角标*/
@property (nonatomic, assign, readonly) NSInteger selectedIndex;
/**滑块的背景图片*/
@property (nullable, nonatomic, strong) UIImage *selectedBackgroundImage;
/**badgeValue字体*/
@property (nonatomic, strong) UIFont *badgeValueFont;
/**badgeValue文字颜色*/
@property (nonatomic, strong) UIColor *badgeValueTextColor;
/**badgeValue背景颜色*/
@property (nonatomic, strong) UIColor *badgeValueBackgroundColor;
/**被监听的滚动试图*/
@property (nonatomic, strong) UIScrollView *switchPageView;
/**前后的间隙*/
@property (nonatomic, assign) CGFloat marginWidth;
/**switch之间的间隙*/
@property (nonatomic, assign) CGFloat spaceWidth;
/**滑块的匹配模式*/
@property (nonatomic, assign) QZPageSwitchFollowStyle followStyle;
/**文字标题的分布方式*/
@property (nonatomic, assign) QZPageSwitchDistributionWay distributionWay;

/**
 初始化方法

 @param titles 标题数组
 @return 实例
 */
- (instancetype)initWithTitles:(NSArray *)titles;
/**
 设置选中的角标

 @param selectedIndex 角标
 @param animated 是否开启动画
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
/**
 给指定的选项设置badgeValue

 @param badgeValue 具体的值
 @param index 选项角标
 */
- (void)setBadgeValue:(NSInteger)badgeValue forIndex:(NSInteger)index;
/**
 获取指定的badgeValue
 
 @param index 选项角标
 */
- (NSInteger)badgeValueFromIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
