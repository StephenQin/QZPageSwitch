//
//  FFRunkeeperSwitch.h
//  FFSwitchDemo
//
//  Created by Stephen Hu on 2018/11/11.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QZPageSwitch : UIControl

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
