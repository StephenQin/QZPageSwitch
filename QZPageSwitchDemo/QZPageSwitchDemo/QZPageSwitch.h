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
/**选中背景颜色*/
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
/**标题颜色*/
@property (nonatomic, strong) UIColor *titleColor;
/**选中标题颜色*/
@property (nonatomic, strong) UIColor *selectedTitleColor;
/**title字体*/
@property (nonatomic, strong) UIFont  *titleFont;
/**选择的角标*/
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

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
@end

NS_ASSUME_NONNULL_END
