//
//  FFRunkeeperSwitch.m
//  FFSwitchDemo
//
//  Created by Stephen Hu on 2018/11/11.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "QZPageSwitch.h"
#import <objc/runtime.h>

#ifdef DEBUG
#define QZLog(FORMAT, ...) fprintf(stderr, "%s:%d\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define FLog(FORMAT, ...) nil
#endif
@interface QZPageSwitch()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView  *titleLabelsContentView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *titleLabels;
@property (nonatomic, strong) UIView  *selectedTitleLabelsContentView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *selectedTitleLabels;
@property (nonatomic, strong) UIImageView  *selectedBackgroundView;
@property (nonatomic, strong) UIView  *titleMaskView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, copy)   NSString *titleFontFamily;
@property (nonatomic, strong) NSMutableArray<UILabel *> *badgeLabels;
@property (nonatomic, assign) CGRect initialSelectedBackgroundViewFrame;
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, assign) CGFloat animationSpringDamping;
@property (nonatomic, assign) CGFloat animationInitialSpringVelocity;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@end
@implementation QZPageSwitch {
    CGFloat _lastOffSetX;
    CGRect  _bgFrame;
    BOOL    _isRight;
}

#pragma mark ————— 取值 —————
- (NSInteger)badgeValueFromIndex:(NSInteger)index {
    return self.badgeLabels[index].text.integerValue;
}
#pragma mark ————— 赋值 —————
- (void)setSelectedBackgroundInset:(CGFloat)selectedBackgroundInset {
    _selectedBackgroundInset = selectedBackgroundInset;
    [self setNeedsLayout];
}
- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    for (NSString *str in titles) {
        UILabel *label = [[UILabel alloc] init];
        label.text = str;
        label.font = self.titleFont;
        label.textColor = self.titleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.titleLabelsContentView addSubview:label];
        [self.titleLabels addObject:label];
        UILabel *selectlabel = [[UILabel alloc] init];
        selectlabel.text = str;
        selectlabel.font = self.titleFont;
        selectlabel.textColor = self.selectedTitleColor;
        selectlabel.textAlignment = NSTextAlignmentCenter;
        selectlabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.selectedTitleLabelsContentView addSubview:selectlabel];
        [self.selectedTitleLabels addObject:selectlabel];
        UILabel *badgeLabel = [[UILabel alloc] init];
        badgeLabel.text = @"";
        badgeLabel.font = self.badgeValueFont;
        badgeLabel.textColor = self.badgeValueTextColor;
        badgeLabel.backgroundColor = self.badgeValueBackgroundColor;
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self addSubview:badgeLabel];
        [self.badgeLabels addObject:badgeLabel];
    }
}
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    for (UILabel *lable in self.selectedTitleLabels) {
        lable.textColor = selectedTitleColor;
    }
}
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    for (UILabel *label in self.selectedTitleLabels) {
        label.font = titleFont;
    }
    for (UILabel *label in self.titleLabels) {
        label.font = titleFont;
    }
}
- (void)setBadgeValueFont:(UIFont *)badgeValueFont {
    _badgeValueFont = badgeValueFont;
    for (UILabel *label in self.badgeLabels) {
        label.font = badgeValueFont;
    }
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    for (UILabel *label in self.titleLabels) {
        label.textColor = titleColor;
    }
}
- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    _selectedBackgroundColor = selectedBackgroundColor;
    self.selectedBackgroundView.backgroundColor = selectedBackgroundColor;
}
- (void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    _selectedBackgroundImage = selectedBackgroundImage;
    self.selectedBackgroundView.image = selectedBackgroundImage;
}
- (void)setBadgeValue:(NSInteger)badgeValue forIndex:(NSInteger)index {
    if (badgeValue == 0) {
        self.badgeLabels[index].text = @"";
    } else {
        self.badgeLabels[index].text = [NSString stringWithFormat:@"%ld",badgeValue];
    }
    [self setNeedsLayout];
}
- (void)setBadgeValueTextColor:(UIColor *)badgeValueTextColor {
    _badgeValueTextColor = badgeValueTextColor;
    [self.badgeLabels setValue:badgeValueTextColor forKeyPath:@"textColor"];
    [self setNeedsLayout];
}
- (void)setBadgeValueBackgroundColor:(UIColor *)badgeValueBackgroundColor {
    _badgeValueBackgroundColor = badgeValueBackgroundColor;
    [self.badgeLabels setValue:badgeValueBackgroundColor forKeyPath:@"backgroundColor"];
}
- (void)setSwitchPageView:(UIScrollView *)switchPageView {
    _switchPageView = switchPageView;
    if (switchPageView) {
        switchPageView.pagingEnabled = YES;
        switchPageView.contentSize = CGSizeMake(switchPageView.bounds.size.width * self.titles.count, switchPageView.bounds.size.height);
        [switchPageView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        // 可以设置偏移
        if (self.selectedIndex > 0) {
            CGPoint contentOffset = CGPointMake(self.selectedIndex * switchPageView.bounds.size.width, 0);
            [switchPageView setContentOffset:contentOffset animated:NO];
        }
    }
}
#pragma mark ————— action —————
// 点击switch滑块
- (void)tapped:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self];
    int index = (int)(location.x / (self.bounds.size.width  / (1.0 * self.titleLabels.count)));
    BOOL animated =  (self.selectedIndex + 1 == index || self.selectedIndex - 1 == index) ? YES : NO;
    [self setSelectedIndex:index animated:animated];
}
// 拖动switch滑块
- (void)pan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.initialSelectedBackgroundViewFrame = self.selectedBackgroundView.frame;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGRect frame = self.initialSelectedBackgroundViewFrame;
        frame.origin.x += [gesture translationInView:self].x;
        frame.origin.x = MAX(MIN(frame.origin.x, self.bounds.size.width - self.selectedBackgroundInset - frame.size.width), self.selectedBackgroundInset);
        self.selectedBackgroundView.frame = frame;
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
        int index = MAX(0, MIN(self.titleLabels.count - 1, (self.selectedBackgroundView.center.x / (self.bounds.size.width / (1.0 * self.titleLabels.count)))));
        [self setSelectedIndex:index animated:YES];
    }
}
// 设置选中哪一个switch滑块
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    if (selectedIndex <= self.titleLabels.count) {
        BOOL catchHalfSwitch = NO;
        if (self.selectedIndex == selectedIndex) {
            catchHalfSwitch = YES;
        }
        self.selectedIndex = selectedIndex;
        if (animated) {
            if (!catchHalfSwitch) {
                [self sendActionsForControlEvents:UIControlEventValueChanged];
            }
            [UIView animateWithDuration:self.animationDuration delay:0.0 usingSpringWithDamping:self.animationSpringDamping initialSpringVelocity:self.animationInitialSpringVelocity options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut animations:^{
                [self setNeedsLayout];
                [self layoutIfNeeded];
            } completion:^(BOOL finished) { // 动画结束切换scrollview的位置
                if (self.switchPageView) {
                    CGPoint contentOffset = CGPointMake(selectedIndex * self.switchPageView.bounds.size.width, 0);
                    [self.switchPageView setContentOffset:contentOffset animated:NO];
                }
            }];
        } else {
            [self setNeedsLayout];
            [self layoutIfNeeded];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
            if (self.switchPageView) {
                CGPoint contentOffset = CGPointMake(selectedIndex * self.switchPageView.bounds.size.width, 0);
                [self.switchPageView setContentOffset:contentOffset animated:NO];
            }
        }
    }
}
// 布局
- (void)layoutSubviews {
    [super layoutSubviews];
    // 均分的宽度，均分时的最大宽度，超出需要压缩，自适应时小于等于这个宽度保持原有宽度，超出的压缩成等宽；
    CGFloat selectedBackgroundWidth = self.bounds.size.width / (CGFloat)(self.titleLabels.count) - self.selectedBackgroundInset * 2.0;
    self.titleLabelsContentView.frame = self.selectedTitleLabelsContentView.frame = self.bounds;
    self.layer.cornerRadius = self.haveBackCorner ? self.bounds.size.height * 0.5 : 0;
    CGFloat titleLabelMaxWidth = selectedBackgroundWidth;
    CGFloat titleLabelMaxHeight = self.bounds.size.height - self.selectedBackgroundInset * 2.0;
     __block CGFloat totalWidth = 0;
    NSInteger countForLongLabel = 0;
//    CGFloat aveSpaceMore = 0.0;
    CGFloat lastAveWidth = 0.0; // 超出宽度的switch最终约定宽度
    if (self.distributionWay == QZPageSwitchDistributionWayNotScrollAdaptContent) {
        CGFloat totalWidth = 0;
        CGFloat shotTotalWidth = 0;
        for (UILabel *label in self.titleLabels) {
            CGSize size = [label sizeThatFits:CGSizeMake(titleLabelMaxWidth, titleLabelMaxHeight)];
            totalWidth += size.width;
            if (size.width > titleLabelMaxWidth) {
                countForLongLabel++;
            } else {
                shotTotalWidth += size.width;
            }
        }
        if (totalWidth > self.bounds.size.width - self.marginWidth * 2 - self.spaceWidth * (self.titleLabels.count - 1)) { // 超出宽度,计算平均需要减少多少
            /*CGFloat spaceMore = totalWidth - (self.bounds.size.width - self.marginWidth * 2 - self.spaceWidth * (self.titleLabels.count - 1));
            aveSpaceMore = spaceMore / countForLongLabel;这么计算的话，是减少相同宽度的值，那么就会有被剪掉过多的情况*/
            // 需要知道没有超出1/n宽度的占了多长,剩下的超出的均分；
            lastAveWidth = floor((self.bounds.size.width - self.marginWidth * 2 - self.spaceWidth * (self.titleLabels.count - 1) - shotTotalWidth) / countForLongLabel);
        } else { // 没有超出宽度 self.marginWidth 设置为self.spaceWidth的一半
            self.spaceWidth = (self.bounds.size.width - totalWidth) / self.titleLabels.count;
            self.marginWidth = self.spaceWidth * 0.5;
        }
    }
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        double x = 0.0;
        CGSize size = [label sizeThatFits:CGSizeMake(titleLabelMaxWidth, titleLabelMaxHeight)];
        if (self.distributionWay == QZPageSwitchDistributionWayNotScrollEqualWidth) {
            size.width = MIN(size.width, titleLabelMaxWidth);
            x = floor((self.bounds.size.width / (CGFloat)self.titleLabels.count) * (CGFloat)idx + (self.bounds.size.width / (CGFloat)self.titleLabels.count - size.width) / 2.0);
        } else if (self.distributionWay == QZPageSwitchDistributionWayNotScrollAdaptContent) {
            if (size.width <= titleLabelMaxWidth) { // 小于1/n
                x = self.marginWidth + self.spaceWidth * idx + totalWidth;
                totalWidth += size.width;
            } else { // 大于1/n
//                size.width -= aveSpaceMore; 这是剪掉相同的宽度
                if (lastAveWidth) {
                    if (size.width >= lastAveWidth) {
                        size.width = lastAveWidth; // 这是改成相同的宽度避免出现全部变成省略号
                    } else {
                        self.spaceWidth += (lastAveWidth - size.width) / self.titleLabels.count; // 短的距离用来均分成间距
                        [self setNeedsLayout];
                    }
                }
                x = self.marginWidth + self.spaceWidth * idx + totalWidth;
                totalWidth += size.width;
            }
        }
        double y = floor((self.bounds.size.height - size.height) / 2);
        CGRect frame = CGRectMake(x, y, size.width, size.height);
        label.frame = frame;
        ((UILabel *)self.selectedTitleLabels[idx]).frame = frame;
        // 设置 badgeValue
        CGPoint badgeCenter = CGPointMake(x + size.width , y);
        UILabel *badgeLabel = self.badgeLabels[idx];
        CGSize badgeSize = [badgeLabel sizeThatFits:CGSizeMake(50, 30)];
        if (badgeSize.width > 50) {
            badgeSize.width = 50;
            if (badgeLabel.text.integerValue > 100) {
                badgeLabel.text = @"100+";
            }
        }
        badgeSize.width = badgeSize.height > badgeSize.width ? badgeSize.height : badgeSize.width;
        badgeLabel.center = badgeCenter;
        CGFloat badgeWidth = badgeSize.width;
        CGFloat badgeHeight = badgeSize.height;
        if (badgeSize.width != 0) {
            badgeWidth  += 2;
            badgeHeight += 2;
        }
        badgeLabel.bounds = CGRectMake(0, 0, badgeWidth, badgeHeight);
        badgeLabel.layer.cornerRadius = badgeHeight * 0.5;
        badgeLabel.layer.masksToBounds = YES;
    }];
    switch (self.followStyle) { //根据followStyle设置switch滑块的frame
        case QZPageSwitchFollowStyleNormal:
            if (self.distributionWay == QZPageSwitchDistributionWayNotScrollAdaptContent) {
                self.followStyle = QZPageSwitchFollowStyleMatch; // 这时如果是文字自适应分布，那就改变followStyle
                [self setNeedsLayout];
                [self layoutIfNeeded];
            } else {
                self.selectedBackgroundView.frame = CGRectMake(self.selectedBackgroundInset + (CGFloat)(self.selectedIndex) * (selectedBackgroundWidth + self.selectedBackgroundInset * 2.0), self.selectedBackgroundInset, selectedBackgroundWidth, self.bounds.size.height - self.selectedBackgroundInset * 2.0);
            }
            break;
        case QZPageSwitchFollowStyleMatch:
        {
            if (!self.switchPageView.decelerating && !self.switchPageView.isTracking) { // 点击或拖动switch或计算默认位置
                _bgFrame =  self.selectedBackgroundView.frame = [self expectedFrameForSelectedBackgroundViewToIndex:self.selectedIndex];
                QZLog(@"1switch的frame是%@",NSStringFromCGRect(self.selectedBackgroundView.frame));
            } else {// 拖动switchPageView
                QZLog(@"2switch的frame是%@",NSStringFromCGRect(self.selectedBackgroundView.frame));
                QZLog(@"self.selectedIndex = %zd",self.selectedIndex);
            }
        }
            break;
    }
    self.selectedBackgroundView.layer.cornerRadius = self.haveSwitchCorner ? self.selectedBackgroundView.frame.size.height * 0.5 : 0; 
    self.selectedBackgroundView.layer.masksToBounds = YES;
}
// scrollview的contentOffset监听方法
- (void)moveSwitchBySwitchPageView:(UIScrollView *)switchPageView {
    if (!switchPageView.isDragging && !switchPageView.isDecelerating) {return;}// 选择switch引起的偏移
    if (switchPageView.contentOffset.x < 0 || switchPageView.contentOffset.x > switchPageView.contentSize.width - switchPageView.bounds.size.width) {return;}
    CGFloat currentOffSetX = switchPageView.contentOffset.x;
    CGFloat offsetProgress = currentOffSetX / switchPageView.bounds.size.width;
    CGRect bgFrame = self.selectedBackgroundView.frame;
    NSInteger index     = floor(offsetProgress);
    NSInteger ceilIndex = ceilf(offsetProgress);
    CGFloat progress = offsetProgress - (NSInteger)offsetProgress;
    NSInteger toIndex = 0;
    NSInteger fromIndex = 0;
    QZLog(@"index = %zd,向%@滚动",index,_isRight ? @"右" : @"左");
    switch (self.followStyle) {
        case QZPageSwitchFollowStyleNormal:
        {
            bgFrame.origin.x = (self.bounds.size.width / self.titles.count) * offsetProgress + self.selectedBackgroundInset;
            self.selectedBackgroundView.frame = bgFrame;
        }
            break;
        case QZPageSwitchFollowStyleMatch:
        {
            _lastOffSetX = switchPageView.bounds.size.width * self.selectedIndex;
            if (self.selectedIndex - index != 0) {
                _bgFrame = [self expectedFrameForSelectedBackgroundViewToIndex:index];
                self.selectedIndex = _isRight ? index : ceilIndex;
            }
            if (progress == 0.0) {progress = 1.0;}
            fromIndex = currentOffSetX / switchPageView.bounds.size.width;
            toIndex = progress == 1.0 ? fromIndex : fromIndex + 1;
            CGRect toFrame = [self expectedFrameForSelectedBackgroundViewToIndex:toIndex];
            bgFrame.origin.x = (toFrame.origin.x - _bgFrame.origin.x) * progress + _bgFrame.origin.x;
            bgFrame.size.width = (toFrame.size.width - _bgFrame.size.width) * progress + _bgFrame.size.width;
            self.selectedBackgroundView.frame = bgFrame;
        }
            break;
    }
}
// QZPageSwitchFollowStyleMatch时计算对应index的滑块的frame
- (CGRect)expectedFrameForSelectedBackgroundViewToIndex:(NSInteger)toIndex {
    NSString *desc = [NSString stringWithFormat:@"%s方法中数组越界,请传如合理的角标数值",__func__];
    BOOL condition = toIndex < self.titleLabels.count;
    NSAssert(condition, desc);
    UILabel *toLabel = self.titleLabels[toIndex];
    CGRect toFrame   = toLabel.frame;
    CGFloat toHeight  = self.bounds.size.height - self.selectedBackgroundInset * 2;
    CGFloat toWidth;
    NSInteger x;
    if (toFrame.size.width + 6 < toHeight) {
        toWidth = toHeight;
        x = toFrame.origin.x - (toHeight - toFrame.size.width) * 0.5;
    } else {
        toWidth = toFrame.size.width + 6;
        x = toFrame.origin.x - 3;
    }
    return CGRectMake(x, self.selectedBackgroundInset, toWidth, toHeight);
}
#pragma mark ————— 基础设置 —————
- (instancetype)initWithTitles:(NSArray *)titles {
    if (self = [super initWithFrame:CGRectZero]) {
        [self finishInit];
        self.titles = titles;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self finishInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self finishInit];
    return self;
}
- (void)makeupUI {
    self.backgroundColor = [UIColor redColor];
}
- (void)finishInit {
    // 添加view
    [self addSubview:self.titleLabelsContentView];
    [self addSubview:self.selectedBackgroundView];
    [self addSubview:self.selectedTitleLabelsContentView];
    self.titleMaskView.backgroundColor = [UIColor blackColor];
    self.selectedTitleLabelsContentView.layer.mask = self.titleMaskView.layer;
    [self addGestureRecognizer:self.tapGesture];
    [self addGestureRecognizer:self.panGesture];
    
    // 给变量赋值
    self.titleFontFamily = @"HelveticaNeue";
    self.selectedIndex = 0;
    self.selectedBackgroundInset = 2;
    self.titleFontSize = 16.0;
    self.animationDuration = 0.25;
    self.animationSpringDamping = 0.75;
    self.animationInitialSpringVelocity = 0.0;
    self.backgroundColor = [UIColor blackColor];
    self.selectedBackgroundColor = [UIColor whiteColor];
    self.titleColor = [UIColor whiteColor];
    self.selectedTitleColor = [UIColor blackColor];
    [self.selectedBackgroundView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    self.titleFont = [UIFont fontWithName:self.titleFontFamily size:self.titleFontSize];
    self.badgeValueFont = [UIFont fontWithName:self.titleFontFamily size:self.titleFontSize];
    self.badgeValueTextColor = [UIColor whiteColor];
    self.badgeValueBackgroundColor = [UIColor redColor];
    self.followStyle = QZPageSwitchFollowStyleNormal;
    self.distributionWay = QZPageSwitchDistributionWayNotScrollEqualWidth;
    self.marginWidth = 2;
    self.spaceWidth  = 2;
}
- (void)dealloc {
    [self.selectedBackgroundView removeObserver:self forKeyPath:@"frame"];
    if (self.switchPageView)
    [self.switchPageView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark ————— kvo —————
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"] && object == self.selectedBackgroundView) {
        self.titleMaskView.frame = self.selectedBackgroundView.frame;
    } else if ([keyPath isEqualToString:@"contentOffset"] && object == self.switchPageView) {// 根据scrollview的偏移量来设置滑块的位置
        CGFloat oldOffsetX = [change[NSKeyValueChangeOldKey] CGPointValue].x;
        CGFloat newOffsetX = [change[NSKeyValueChangeNewKey] CGPointValue].x;
        CGFloat deltaX     = newOffsetX - oldOffsetX;
        _isRight = deltaX > 0 ? YES : NO;
        QZLog(@"向%@滚动",_isRight ? @"右" : @"左");
        [self moveSwitchBySwitchPageView:self.switchPageView];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark ————— UIGestureRecognizerDelegate —————
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return CGRectContainsPoint(self.selectedBackgroundView.frame, [gestureRecognizer locationInView:self]);
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

#pragma mark ————— lazyLoad —————
- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panGesture.delegate = self;
        _panGesture = panGesture;
    }
    return _panGesture;
}
- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        _tapGesture = tapGesture;
    }
    return _tapGesture;
}
- (UIView *)titleMaskView {
    if (!_titleMaskView) {
        UIView *titleMaskView = [UIView new];
        _titleMaskView = titleMaskView;
    }
    return _titleMaskView;
}
- (UIImageView *)selectedBackgroundView {
    if (!_selectedBackgroundView) {
        UIImageView *selectedBackgroundView = [UIImageView new];
        _selectedBackgroundView = selectedBackgroundView;
    }
    return _selectedBackgroundView;
}
- (UIView *)selectedTitleLabelsContentView {
    if (!_selectedTitleLabelsContentView) {
        UIView *selectedTitleLabelsContentView = [UIView new];
        _selectedTitleLabelsContentView = selectedTitleLabelsContentView;
    }
    return _selectedTitleLabelsContentView;
}
- (UIView *)titleLabelsContentView {
    if (!_titleLabelsContentView) {
        UIView *titleLabelsContentView = [UIView new];
        _titleLabelsContentView = titleLabelsContentView;
    }
    return _titleLabelsContentView;
}
- (NSMutableArray<UILabel *> *)badgeLabels {
    if (!_badgeLabels) {
        NSMutableArray *badgeLabels = [NSMutableArray array];
        _badgeLabels = badgeLabels;
    }
    return _badgeLabels;
}
- (NSMutableArray<UILabel *> *)titleLabels {
    if (!_titleLabels) {
        NSMutableArray *titleLabels = [NSMutableArray array];
        _titleLabels = titleLabels;
    }
    return _titleLabels;
}
- (NSMutableArray<UILabel *> *)selectedTitleLabels {
    if (!_selectedTitleLabels) {
        NSMutableArray *selectedTitleLabels = [NSMutableArray array];
        _selectedTitleLabels = selectedTitleLabels;
    }
    return _selectedTitleLabels;
}
@end
