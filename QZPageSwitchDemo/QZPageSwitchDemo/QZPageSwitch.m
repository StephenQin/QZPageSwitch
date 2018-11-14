//
//  FFRunkeeperSwitch.m
//  FFSwitchDemo
//
//  Created by Stephen Hu on 2018/11/11.
//  Copyright © 2018 Stephen Hu. All rights reserved.
//

#import "QZPageSwitch.h"
#import <objc/runtime.h>

@interface QZPageSwitch()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView  *titleLabelsContentView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *titleLabels;
@property (nonatomic, strong) UIView  *selectedTitleLabelsContentView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *selectedTitleLabels;
@property (nonatomic, strong) UIImageView  *selectedBackgroundView;
@property (nonatomic, strong) UIView  *titleMaskView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGRect initialSelectedBackgroundViewFrame;

@property (nonatomic, copy)   NSString *titleFontFamily;
@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) CGFloat animationSpringDamping;
@property (nonatomic, assign) CGFloat animationInitialSpringVelocity;
@property (nonatomic, assign) NSInteger selectedIndex;
@end
@implementation QZPageSwitch

#pragma mark ————— 赋值 —————
- (void)setSelectedBackgroundInset:(CGFloat)selectedBackgroundInset {
    _selectedBackgroundInset = selectedBackgroundInset;
    [self setNeedsLayout];
}
- (void)setTitles:(NSArray *)titles {
    for (NSString *str in titles) {
        UILabel *label = [[UILabel alloc] init];
        label.text = str;
        label.font = self.titleFont;
        label.textColor = self.titleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.titleLabelsContentView addSubview:label];
        [self.titleLabels addObject:label];
        UILabel *selectlabel = [[UILabel alloc] init];
        selectlabel.text = str;
        selectlabel.font = self.titleFont;
        selectlabel.textColor = self.selectedTitleColor;
        selectlabel.textAlignment = NSTextAlignmentCenter;
        selectlabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.selectedTitleLabelsContentView addSubview:selectlabel];
        [self.selectedTitleLabels addObject:selectlabel];
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

#pragma mark ————— 事件 —————
- (void)tapped:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:self];
    int index = (int)(location.x / (self.bounds.size.width  / (1.0 * self.titleLabels.count)));
    [self setSelectedIndex:index animated:YES];
}
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
            } completion:nil];
        } else {
            [self setNeedsLayout];
            [self layoutIfNeeded];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat selectedBackgroundWidth = self.bounds.size.width / (CGFloat)(self.titleLabels.count) - self.selectedBackgroundInset * 2.0;
    self.selectedBackgroundView.frame = CGRectMake(self.selectedBackgroundInset + (CGFloat)(self.selectedIndex) * (selectedBackgroundWidth + self.selectedBackgroundInset * 2.0), self.selectedBackgroundInset, selectedBackgroundWidth, self.bounds.size.height - self.selectedBackgroundInset * 2.0);
    self.titleLabelsContentView.frame = self.selectedTitleLabelsContentView.frame = self.bounds;
    self.layer.cornerRadius = self.bounds.size.height * 0.5;
    self.selectedBackgroundView.layer.cornerRadius = self.selectedBackgroundView.frame.size.height * 0.5;
    self.selectedBackgroundView.layer.masksToBounds = YES;
    CGFloat titleLabelMaxWidth = selectedBackgroundWidth;
    CGFloat titleLabelMaxHeight = self.bounds.size.height - self.selectedBackgroundInset * 2.0;
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size = [label sizeThatFits:CGSizeMake(titleLabelMaxWidth, titleLabelMaxHeight)];
        size.width = MIN(size.width, titleLabelMaxWidth);
        double x = floor((self.bounds.size.width / (CGFloat)self.titleLabels.count) * (CGFloat)idx + (self.bounds.size.width / (CGFloat)self.titleLabels.count - size.width) / 2.0);
        double y = floor((self.bounds.size.height - size.height) / 2);
        CGRect frame = CGRectMake(x, y, size.width, size.height);
        label.frame = frame;
        ((UILabel *)self.selectedTitleLabels[idx]).frame = frame;
    }];
}

#pragma mark ————— 基础设置 —————
- (instancetype)initWithTitles:(NSArray *)titles {
    if (self = [super initWithFrame:CGRectZero]) {
        self.titles = titles;
        [self finishInit];
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
    self.titleFontSize = 18.0;
    self.animationDuration = 0.3;
    self.animationSpringDamping = 0.75;
    self.animationInitialSpringVelocity = 0.0;
    self.backgroundColor = [UIColor blackColor];
    self.selectedBackgroundColor = [UIColor whiteColor];
    self.titleColor = [UIColor whiteColor];
    self.selectedTitleColor = [UIColor blackColor];
    [self.selectedBackgroundView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    self.titleFont = [UIFont fontWithName:self.titleFontFamily size:self.titleFontSize];
}
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
}

#pragma mark ————— kvo —————
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        self.titleMaskView.frame = self.selectedBackgroundView.frame;
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
- (NSArray *)titleLabels {
    if (!_titleLabels) {
        NSMutableArray *titleLabels = [NSMutableArray array];
        _titleLabels = titleLabels;
    }
    return _titleLabels;
}
- (NSArray *)selectedTitleLabels {
    if (!_selectedTitleLabels) {
        NSMutableArray *selectedTitleLabels = [NSMutableArray array];
        _selectedTitleLabels = selectedTitleLabels;
    }
    return _selectedTitleLabels;
}
@end
