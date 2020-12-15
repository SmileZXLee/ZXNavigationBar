//
//  ZXNavigationBarController.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.3.6

#import "ZXNavigationBarController.h"

#import <objc/message.h>
#import "UIImage+ZXNavBundleExtension.h"


@implementation ZXXibTopConstraintModel

@end
@interface ZXNavigationBarController ()<UIGestureRecognizerDelegate>
@property(assign, nonatomic)BOOL setFold;
@property(assign, nonatomic)CGFloat lastNavAlphe;
@property(assign, nonatomic)BOOL isNavFoldAnimating;
@property(assign, nonatomic)BOOL doAutoSysBarAlphe;
@property(strong, nonatomic)UIColor *orgWindowColor;
@property(strong, nonatomic)CADisplayLink *displayLink;
@property(copy, nonatomic)foldingOffsetBlock offsetBlock;
@property(copy, nonatomic)foldCompletionBlock completionBlock;
@property(strong, nonatomic)NSMutableArray<ZXXibTopConstraintModel *> *xibTopConstraintArr;
@end

@implementation ZXNavigationBarController
static ZXNavStatusBarStyle defaultNavStatusBarStyle = ZXNavStatusBarStyleDefault;
#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.zx_navFixHeight = -1;
    if(self.navigationController && !self.zx_hideBaseNavBar && !self.zx_disableAutoSetCustomNavBar){
        [self initNavBar];
        [self setAutoBack];
    }
    [self checkDoAutoSysBarAlpha];
    [self hanldeCustomPopGesture];
}

#pragma mark - private
#pragma mark 初始化导航栏
-(void)initNavBar{
    ZXNavigationBar *navBar = [[ZXNavigationBar alloc]init];
    [self.view addSubview:navBar];
    [self.view bringSubviewToFront:navBar];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CGFLOAT_MIN * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view bringSubviewToFront:navBar];
    });
    _zx_navTitleView = navBar.zx_titleView;
    self.zx_navTitleLabel = navBar.zx_titleLabel;
    self.zx_navLeftBtn = navBar.zx_leftBtn;
    self.zx_navSubLeftBtn = navBar.zx_subLeftBtn;
    self.zx_navRightBtn = navBar.zx_rightBtn;
    self.zx_navSubRightBtn = navBar.zx_subRightBtn;
    self.zx_navLineView = navBar.zx_lineView;
    self.zx_navBacImageView = navBar.zx_bacImageView;
    self.zx_navBar = navBar;
    self.zx_navTitleLabel.text = self.zx_navTitle;
    [self adjustNavContainerOffset:[self getCurrentNavHeight]];
    [self relayoutSubviews];
}

#pragma mark 设置自动显示返回Button且点击pop到上一个控制器
- (void)setAutoBack{
    if(self.navigationController && self.navigationController.viewControllers.count > 1){
        UIImage *backImg = [self getBackBtnImage];
        [self.zx_navLeftBtn setImage:backImg forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [self zx_leftClickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
            if(!(weakSelf.zx_handlePopBlock && !weakSelf.zx_handlePopBlock(weakSelf,ZXNavPopBlockFromBackButtonClick))){
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

#pragma mark Xib加载情况下，调整约束自动下移导航栏高度
- (void)adjustNavContainerOffset:(CGFloat)offset{
    [self adjustNavContainerOffset:offset checkSafeArea:YES];
}

#pragma mark Xib加载情况下，调整约束自动下移导航栏高度
- (void)adjustNavContainerOffset:(CGFloat)offset checkSafeArea:(BOOL)checkSafeArea{
    if(self.zx_disableAutoSetCustomNavBar){
        return;
    }
    if(self.xibTopConstraintArr.count){
        for (ZXXibTopConstraintModel *constraintModel in self.xibTopConstraintArr) {
            [self updateTopConstraint:constraintModel offset:offset checkSafeArea:checkSafeArea];
        }
        return;
    }
    NSArray *constraintArr = [self.view constraints];
    [self.xibTopConstraintArr removeAllObjects];
    [constraintArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLayoutConstraint *constraint = obj;
        if (constraint.firstAttribute == NSLayoutAttributeTop){
            id secondItem = constraint.secondItem;
            UIView *secondView = nil;
            BOOL isToSafeArea = YES;
            if([secondItem isKindOfClass:[UILayoutGuide class]]){
                secondView = ((UILayoutGuide *)secondItem).owningView;
            }
            if([secondItem isKindOfClass:[UIView class]]){
                secondView = secondItem;
                isToSafeArea = NO;
            }
            if(!secondView || self.view == secondView){
                ZXXibTopConstraintModel *constraintModel = [[ZXXibTopConstraintModel alloc]init];
                constraintModel.orgOffset = constraint.constant;
                constraintModel.constraint = constraint;
                constraintModel.isToSafeArea = isToSafeArea;
                [self updateTopConstraint:constraintModel offset:offset checkSafeArea:checkSafeArea];
                [self.xibTopConstraintArr addObject:constraintModel];
                if(!self.zx_enableAdjustNavContainerAll){
                    *stop = YES;
                }
            }
            
        }
    }];
}

#pragma mark 更新容器顶部约束
- (void)updateTopConstraint:(ZXXibTopConstraintModel *)constraintModel offset:(CGFloat)offset checkSafeArea:(BOOL)checkSafeArea{
    if(self.zx_disableAutoSetCustomNavBar){
        return;
    }
    if(self.zx_disableNavAutoSafeLayout){
        offset = 0;
    }
    CGFloat orgNavOffset = constraintModel.orgOffset;
    CGFloat handleOffset = orgNavOffset + offset;
    if(self.zx_handleAdjustNavContainerOffsetBlock){
        handleOffset = self.zx_handleAdjustNavContainerOffsetBlock(orgNavOffset,orgNavOffset + offset);
    }
    if(constraintModel.isToSafeArea && checkSafeArea){
        if (@available(iOS 11.0, *)) {
            handleOffset -= ZXMainWindow.safeAreaInsets.top;
        }
    }
    constraintModel.constraint.constant = handleOffset;
}

#pragma mark 开启DisplayLink
- (void)startDisplayLink{
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateNavFoldingFrame:)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark 刷新导航栏位置
- (void)relayoutSubviews{
    if(self.zx_navBar){
        if(self.zx_navIsFolded){
            self.zx_navBar.frame = CGRectMake(0, 0, ZXScreenWidth, ZXAppStatusBarHeight);
        }else{
            self.zx_navBar.frame = CGRectMake(0, 0, ZXScreenWidth, [self getCurrentNavHeight]);
        }
    }
}

#pragma mark 折叠导航栏时更新导航栏高度
- (void)updateNavFoldingFrame:(CADisplayLink *)displayLink{
    self.isNavFoldAnimating = YES;
    if(self.setFold){
        if(self.zx_navBar.zx_height > ZXAppStatusBarHeight){
            if(self.zx_navBar.zx_height - self.zx_navFoldingSpeed < 0){
                self.zx_navBar.zx_height = 0;
            }else{
                self.zx_navBar.zx_height -= self.zx_navFoldingSpeed;
            }
            for (ZXXibTopConstraintModel *constraintModel in self.xibTopConstraintArr) {
                constraintModel.constraint.constant -= self.zx_navFoldingSpeed;
            }
            if(self.offsetBlock){
                self.offsetBlock(-self.zx_navFoldingSpeed);
            }
            [self setAlphaOfNavSubViews:(self.zx_navBar.zx_height - ZXAppStatusBarHeight) / ([self getCurrentNavHeight] - ZXAppStatusBarHeight)];
        }else{
            self.isNavFoldAnimating = NO;
            [self.displayLink invalidate];
            self.displayLink = nil;
            _zx_navIsFolded = self.setFold;
            if(self.completionBlock){
                self.completionBlock();
            }
            [self setAlphaOfNavSubViews:0];
            [self relayoutSubviews];
        }
    }else{
        if(self.zx_navBar.zx_height < [self getCurrentNavHeight]){
            self.zx_navBar.zx_height += self.zx_navFoldingSpeed;
            for (ZXXibTopConstraintModel *constraintModel in self.xibTopConstraintArr) {
                constraintModel.constraint.constant += self.zx_navFoldingSpeed;
            }
            if(self.offsetBlock){
                self.offsetBlock(self.zx_navFoldingSpeed);
            }
            [self setAlphaOfNavSubViews:(self.zx_navBar.zx_height - ZXAppStatusBarHeight) / ([self getCurrentNavHeight] - ZXAppStatusBarHeight)];
        }else{
            self.isNavFoldAnimating = NO;
            [self.displayLink invalidate];
            self.displayLink = nil;
            _zx_navIsFolded = self.setFold;
            if(self.completionBlock){
                self.completionBlock();
            }
            [self setAlphaOfNavSubViews:1];
            [self relayoutSubviews];
        }
    }
}

#pragma mark 设置导航栏子视图透明度
- (void)setAlphaOfNavSubViews:(CGFloat)alpha{
    for(UIView *subView in self.zx_navBar.subviews){
        subView.alpha = alpha;
    }
}

#pragma mark 获取当前需要设置的导航栏高度
- (CGFloat)getCurrentNavHeight{
    if(self.zx_navFixHeight == -1){
        return ZXNavBarHeight;
    }
    return self.zx_navFixHeight;
}

#pragma mark 获取返回按钮的图片
- (UIImage *)getBackBtnImage{
    UIImage *backImg = nil;
    if(self.zx_backBtnImageName && self.zx_backBtnImageName.length){
        backImg = [UIImage imageNamed:self.zx_backBtnImageName];
    }
    if(!backImg){
        backImg = [UIImage zx_imageFromBundleWithImageName:@"back_icon"];
    }
    return backImg;
}

#pragma mark 刷新导航栏状态
- (void)refNavStatusFromWillAppear:(BOOL)fromWillAppear{
    if(!self.zx_navEnableSmoothFromSystemNavBar || !fromWillAppear){
        self.navigationController.navigationBarHidden = !self.zx_showSystemNavBar;
    }
    if(self.zx_navEnableSmoothFromSystemNavBar){
        if(!self.zx_showSystemNavBar){
            self.navigationController.navigationBar.translucent = YES;
        }else{
            self.navigationController.navigationBar.translucent = NO;
        }
    }
}

#pragma mark 监听自定义pop手势进度，导航控制器需为ZXNavigationBarNavigationController或继承于ZXNavigationBarNavigationController
- (void)hanldeCustomPopGesture{
    if(self.navigationController && [self.navigationController isKindOfClass:[ZXNavigationBarNavigationController class]]){
        __weak ZXNavigationBarNavigationController *nav = (ZXNavigationBarNavigationController *)self.navigationController;
        __weak typeof(self) weakSelf = self;
        nav.zx_handleCustomPopGesture = ^(UIViewController * _Nonnull currentViewController, CGFloat popOffsetProgress) {
            if(currentViewController == weakSelf){
                if(weakSelf.zx_handleCustomPopGesture){
                    weakSelf.zx_handleCustomPopGesture(popOffsetProgress);
                }
                if(weakSelf.doAutoSysBarAlphe){
                    nav.navigationBar.alpha = 1 - popOffsetProgress;
                    if(nav.navigationBar.alpha == 0){
                        [UIApplication sharedApplication].keyWindow.backgroundColor = weakSelf.orgWindowColor;
                    }else{
                        if([UIApplication sharedApplication].keyWindow.backgroundColor != weakSelf.orgWindowColor){
                            weakSelf.orgWindowColor = [UIApplication sharedApplication].keyWindow.backgroundColor;
                            if(nav.navigationBar.backgroundColor){
                                [UIApplication sharedApplication].keyWindow.backgroundColor = nav.navigationBar.backgroundColor;
                            }else{
                                [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
                            }
                        }
                        
                    }
                }
            }
        };
    }
}



#pragma mark - Setter
-(void)setZx_navTitle:(NSString *)zx_navTitle{
    _zx_navTitle = zx_navTitle;
    self.zx_navTitleLabel.text = zx_navTitle;
}

- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    self.zx_navTitle = title;
}

- (void)setZx_navTintColor:(UIColor *)zx_navTintColor{
    _zx_navTintColor = zx_navTintColor;
    if(self.zx_navBar){
        self.zx_navLeftBtn.zx_tintColor = zx_navTintColor;
        self.zx_navSubLeftBtn.zx_tintColor = zx_navTintColor;
        self.zx_navRightBtn.zx_tintColor = zx_navTintColor;
        self.zx_navSubRightBtn.zx_tintColor = zx_navTintColor;
    }
    self.zx_navTitleLabel.textColor = zx_navTintColor;
}

- (void)setZx_navTitleColor:(UIColor *)zx_navTitleColor{
    _zx_navTitleColor = zx_navTitleColor;
    self.zx_navTitleLabel.textColor = zx_navTitleColor;
}

- (void)setZx_navTitleFontSize:(CGFloat )zx_navTitleFontSize{
    _zx_navTitleFontSize = zx_navTitleFontSize;
    self.zx_navTitleLabel.font = [UIFont systemFontOfSize:zx_navTitleFontSize];
}

- (void)setZx_backBtnImageName:(NSString *)zx_backBtnImageName{
    _zx_backBtnImageName = zx_backBtnImageName;
    if(self.navigationController && self.navigationController.viewControllers.count > 1 && !self.zx_hideBaseNavBar){
        UIImage *backImg = [self getBackBtnImage];
        [self.zx_navLeftBtn setImage:backImg forState:UIControlStateNormal];
    }
    
}

- (void)setZx_navTitleFont:(UIFont *)zx_navTitleFont{
    _zx_navTitleFont = zx_navTitleFont;
    self.zx_navTitleLabel.font = zx_navTitleFont;
}

- (void)setZx_navBarBackgroundColor:(UIColor *)zx_navBarBackgroundColor{
    _zx_navBarBackgroundColor = zx_navBarBackgroundColor;
    self.zx_navBar.backgroundColor = zx_navBarBackgroundColor;
}

- (void)setZx_navBarBackgroundColorAlpha:(CGFloat)zx_navBarBackgroundColorAlpha{
    if(zx_navBarBackgroundColorAlpha < 0){
        zx_navBarBackgroundColorAlpha = 0;
    }else if(zx_navBarBackgroundColorAlpha > 1){
        zx_navBarBackgroundColorAlpha = 1;
    }
    _zx_navBarBackgroundColorAlpha = zx_navBarBackgroundColorAlpha;
    if(self.zx_navBar){
        CGFloat r = 1;
        CGFloat g = 1;
        CGFloat b = 1;
        if(self.zx_navBar.zx_backgroundColorComponents){
            r = [self.zx_navBar.zx_backgroundColorComponents[0] floatValue];
            g = [self.zx_navBar.zx_backgroundColorComponents[1] floatValue];
            b = [self.zx_navBar.zx_backgroundColorComponents[2] floatValue];
        }
        SEL sel = NSSelectorFromString(@"privateSetBackgroundColor:");
        if([self.zx_navBar respondsToSelector:sel]){
            IMP imp = [self.zx_navBar methodForSelector:sel];
            void (*func)(id, SEL, UIColor *) = (void *)imp;
            func(self.zx_navBar, sel, [UIColor colorWithRed:r green:g blue:b alpha:zx_navBarBackgroundColorAlpha]);
        }
        
    }
}

- (void)setZx_navBarBackgroundImage:(UIImage *)zx_navBarBackgroundImage{
    _zx_navBarBackgroundImage = zx_navBarBackgroundImage;
    self.zx_navBar.zx_bacImage = zx_navBarBackgroundImage;
}

- (void)setZx_navLineViewBackgroundColor:(UIColor *)zx_navLineViewBackgroundColor{
    _zx_navLineViewBackgroundColor = zx_navLineViewBackgroundColor;
    self.zx_navLineView.backgroundColor = zx_navLineViewBackgroundColor;
}

- (void)setZx_navLineViewHeight:(CGFloat)zx_navLineViewHeight{
    _zx_navLineViewHeight = zx_navLineViewHeight;
    if(self.zx_navBar){
        self.zx_navBar.zx_lineViewHeight = zx_navLineViewHeight;
    }
}


- (void)setZx_hideBaseNavBar:(BOOL)zx_hideBaseNavBar{
    if(_zx_hideBaseNavBar != zx_hideBaseNavBar){
        if(zx_hideBaseNavBar){
            [self adjustNavContainerOffset:0 checkSafeArea:NO];
        }else{
            [self adjustNavContainerOffset:[self getCurrentNavHeight]];
        }
        
    }
    _zx_hideBaseNavBar = zx_hideBaseNavBar;
    if(self.zx_navBar){
        self.zx_navBar.hidden = zx_hideBaseNavBar;
    }
}


- (void)setZx_navStatusBarStyle:(ZXNavStatusBarStyle)zx_navStatusBarStyle{
    _zx_navStatusBarStyle = zx_navStatusBarStyle;
    defaultNavStatusBarStyle = zx_navStatusBarStyle;
    if(!self.zx_disableAutoSetStatusBarStyle){
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)setZx_showSystemNavBar:(BOOL)zx_showSystemNavBar{
    _zx_showSystemNavBar = zx_showSystemNavBar;
    if(self.navigationController){
        self.zx_hideBaseNavBar = YES;
        self.navigationController.navigationBar.translucent = !zx_showSystemNavBar;
        self.navigationController.navigationBarHidden = !zx_showSystemNavBar;
        [self checkDoAutoSysBarAlpha];
    }
}

- (void)setZx_navItemSize:(CGFloat)zx_navItemSize{
    _zx_navItemSize = zx_navItemSize;
    if(self.zx_navBar){
        self.zx_navBar.zx_itemSize = zx_navItemSize;
    }
}

- (void)setZx_navItemMargin:(CGFloat)zx_navItemMargin{
    _zx_navItemMargin = zx_navItemMargin;
    if(self.zx_navBar){
        self.zx_navBar.zx_itemMargin = zx_navItemMargin;
    }
    
}

- (void)setZx_disableNavAutoSafeLayout:(BOOL)zx_disableNavAutoSafeLayout{
    _zx_disableNavAutoSafeLayout = zx_disableNavAutoSafeLayout;
    [self adjustNavContainerOffset:0];
}

- (void)setZx_navEnableSmoothFromSystemNavBar:(BOOL)zx_navEnableSmoothFromSystemNavBar{
    _zx_navEnableSmoothFromSystemNavBar = zx_navEnableSmoothFromSystemNavBar;
    if(self.zx_navBar){
        [self.zx_navBar setValue:@(zx_navEnableSmoothFromSystemNavBar) forKey:@"zx_navEnableSmoothFromSystemNavBar"];
        [UIApplication sharedApplication].keyWindow.backgroundColor = self.zx_navBar.backgroundColor;
        [self checkDoAutoSysBarAlpha];
    }
}

- (void)setZx_handleAdjustNavContainerOffsetBlock:(CGFloat (^)(CGFloat, CGFloat))zx_handleAdjustNavContainerOffsetBlock{
    _zx_handleAdjustNavContainerOffsetBlock = zx_handleAdjustNavContainerOffsetBlock;
    if(zx_handleAdjustNavContainerOffsetBlock){
        ZXXibTopConstraintModel *constraintModel = self.xibTopConstraintArr.firstObject;
        if(constraintModel){
            [self adjustNavContainerOffset:constraintModel.constraint.constant - constraintModel.orgOffset];
        }
    }
}

- (void)setZx_navFixHeight:(int)zx_navFixHeight{
    _zx_navFixHeight = zx_navFixHeight;
    [self relayoutSubviews];
    [self adjustNavContainerOffset:[self getCurrentNavHeight]];
}

- (void)setZx_handleCustomPopGesture:(void (^)(CGFloat))zx_handleCustomPopGesture{
    _zx_handleCustomPopGesture = zx_handleCustomPopGesture;
    if(!(self.navigationController && [self.navigationController isKindOfClass:[ZXNavigationBarNavigationController class]])){
        NSAssert(NO, @"监听自定义手势时，您的导航控制器需为ZXNavigationBarNavigationController或继承于ZXNavigationBarNavigationController");
    }
}

- (void)setZx_disableFullScreenGesture:(BOOL)zx_disableFullScreenGesture{
    _zx_disableFullScreenGesture = zx_disableFullScreenGesture;
    if(!(self.navigationController && [self.navigationController isKindOfClass:[ZXNavigationBarNavigationController class]])){
        NSAssert(NO, @"监听自定义手势时，您的导航控制器需为ZXNavigationBarNavigationController或继承于ZXNavigationBarNavigationController");
    }else{
        ((ZXNavigationBarNavigationController *)self.navigationController).zx_disableFullScreenGesture = zx_disableFullScreenGesture;
    }
}

- (void)setZx_popGestureCoverRatio:(CGFloat)zx_popGestureCoverRatio{
    _zx_popGestureCoverRatio = zx_popGestureCoverRatio;
    if(!(self.navigationController && [self.navigationController isKindOfClass:[ZXNavigationBarNavigationController class]])){
        NSAssert(NO, @"监听自定义手势时，您的导航控制器需为ZXNavigationBarNavigationController或继承于ZXNavigationBarNavigationController");
    }else{
        ((ZXNavigationBarNavigationController *)self.navigationController).zx_popGestureCoverRatio = zx_popGestureCoverRatio;
    }
}

- (void)setZx_popGestureShouldRecognizeSimultaneously:(BOOL (^)(UIGestureRecognizer * _Nonnull))zx_popGestureShouldRecognizeSimultaneously{
    _zx_popGestureShouldRecognizeSimultaneously = zx_popGestureShouldRecognizeSimultaneously;
    if(self.navigationController && [self.navigationController isKindOfClass:[ZXNavigationBarNavigationController class]]){
        ZXNavigationBarNavigationController *navigationController = (ZXNavigationBarNavigationController *)self.navigationController;
        navigationController.zx_popGestureShouldRecognizeSimultaneously = ^BOOL(UIGestureRecognizer * _Nonnull otherGestureRecognizer) {
            return zx_popGestureShouldRecognizeSimultaneously(otherGestureRecognizer);
        };
    }
}


- (NSMutableArray<ZXXibTopConstraintModel *> *)xibTopConstraintArr{
    if(!_xibTopConstraintArr){
        _xibTopConstraintArr = [NSMutableArray array];
    }
    return _xibTopConstraintArr;
}

#pragma mark - Public
#pragma mark 设置左侧Button图片和点击回调
- (void)zx_setLeftBtnWithImgName:(NSString *)imgName clickedBlock:(leftBtnClickedBlock)clickBlock{
    [self.zx_navLeftBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_leftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 设置左侧第二个Button图片和点击回调
- (void)zx_setSubLeftBtnWithImgName:(NSString *)imgName clickedBlock:(subLeftBtnClickedBlock)clickBlock{
    [self.zx_navSubLeftBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_subLeftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 设置最右侧Button图片和点击回调
- (void)zx_setRightBtnWithImgName:(NSString *)imgName clickedBlock:(rightBtnClickedBlock)clickBlock{
    [self.zx_navRightBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_rightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 设置右侧第二个Button图片和点击回调
- (void)zx_setSubRightBtnWithImgName:(NSString *)imgName clickedBlock:(subRightBtnClickedBlock)clickBlock{
    [self.zx_navSubRightBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_subRightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 设置左侧Button文字和点击回调
- (void)zx_setLeftBtnWithText:(NSString *)btnText clickedBlock:(leftBtnClickedBlock)clickBlock{
    [self.zx_navLeftBtn setTitle:btnText forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_leftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 设置左侧第二个按钮文字和点击回调
- (void)zx_setSubLeftBtnWithText:(NSString *)btnText clickedBlock:(subLeftBtnClickedBlock)clickBlock{
    [self.zx_navSubLeftBtn setTitleColor:self.zx_navTitleLabel.textColor forState:UIControlStateNormal];
    [self.zx_navSubLeftBtn setTitle:btnText forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_subLeftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 设置最右侧Button文字和点击回调
- (void)zx_setRightBtnWithText:(NSString *)btnText clickedBlock:(rightBtnClickedBlock)clickBlock{
    [self.zx_navRightBtn setTitleColor:self.zx_navTitleLabel.textColor forState:UIControlStateNormal];
    [self.zx_navRightBtn setTitle:btnText forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_rightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 设置右侧第二个按钮文字和点击回调
- (void)zx_setSubRightBtnWithText:(NSString *)btnText clickedBlock:(subRightBtnClickedBlock)clickBlock{
    [self.zx_navSubRightBtn setTitleColor:self.zx_navTitleLabel.textColor forState:UIControlStateNormal];
    [self.zx_navSubRightBtn setTitle:btnText forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_subRightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 设置左侧按钮的图片地址和点击回调
- (void)zx_setLeftBtnWithImgUrl:(NSString *)imgUrlStr placeholderImgName:(NSString *)placeholderImgName clickedBlock:(nullable leftBtnClickedBlock)clickBlock{
    [self setNavItemBtnWithItem:self.zx_navLeftBtn imgUrl:imgUrlStr placeholderImgName:placeholderImgName];
    ((ZXNavigationBar *)self.zx_navBar).zx_leftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
    
}

#pragma mark 设置左侧第二个按钮图片地址和点击回调
- (void)zx_setSubLeftBtnWithImgUrl:(NSString *)imgUrlStr placeholderImgName:(NSString *)placeholderImgName clickedBlock:(nullable subLeftBtnClickedBlock)clickBlock{
    [self setNavItemBtnWithItem:self.zx_navSubLeftBtn imgUrl:imgUrlStr placeholderImgName:placeholderImgName];
    ((ZXNavigationBar *)self.zx_navBar).zx_subLeftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
    
}

#pragma mark 设置右侧按钮图片地址和点击回调
- (void)zx_setRightBtnWithImgUrl:(NSString *)imgUrlStr placeholderImgName:(NSString *)placeholderImgName clickedBlock:(nullable rightBtnClickedBlock)clickBlock{
    [self setNavItemBtnWithItem:self.zx_navRightBtn imgUrl:imgUrlStr placeholderImgName:placeholderImgName];
    ((ZXNavigationBar *)self.zx_navBar).zx_rightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
    
}

#pragma mark 设置右侧第二个按钮图片地址和点击回调
- (void)zx_setSubRightBtnWithImgUrl:(NSString *)imgUrlStr placeholderImgName:(NSString *)placeholderImgName clickedBlock:(nullable subRightBtnClickedBlock)clickBlock{
    [self setNavItemBtnWithItem:self.zx_navSubRightBtn imgUrl:imgUrlStr placeholderImgName:placeholderImgName];
    ((ZXNavigationBar *)self.zx_navBar).zx_subRightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
    
}

#pragma mark 设置左侧按钮图片和点击回调
- (void)zx_setLeftBtnWithImg:(UIImage *)img clickedBlock:(nullable leftBtnClickedBlock)clickBlock{
    [self.zx_navLeftBtn setImage:img forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_leftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
    
}

#pragma mark 设置左侧第二个按钮图片和点击回调
- (void)zx_setSubLeftBtnWithImg:(UIImage *)img clickedBlock:(nullable subLeftBtnClickedBlock)clickBlock{
    [self.zx_navSubLeftBtn setImage:img forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_subLeftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
    
}

#pragma mark 设置右侧按钮图片和点击回调
- (void)zx_setRightBtnWithImg:(UIImage *)img clickedBlock:(nullable rightBtnClickedBlock)clickBlock{
    [self.zx_navRightBtn setImage:img forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_rightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
    
}

#pragma mark 设置右侧第二个按钮图片和点击回调
- (void)zx_setSubRightBtnWithImg:(UIImage *)img clickedBlock:(nullable subRightBtnClickedBlock)clickBlock{
    [self.zx_navSubRightBtn setImage:img forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_subRightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
    
}

#pragma mark 左侧Button点击回调
- (void)zx_leftClickedBlock:(leftBtnClickedBlock)clickBlock{
    ((ZXNavigationBar *)self.zx_navBar).zx_leftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 左侧第二个Button点击回调
- (void)zx_subLeftClickedBlock:(subLeftBtnClickedBlock)clickBlock{
    ((ZXNavigationBar *)self.zx_navBar).zx_subLeftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 最右侧Button点击回调
- (void)zx_rightClickedBlock:(rightBtnClickedBlock)clickBlock{
    ((ZXNavigationBar *)self.zx_navBar).zx_rightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 右侧第二个Button点击回调
- (void)zx_subRightClickedBlock:(subRightBtnClickedBlock)clickBlock{
    ((ZXNavigationBar *)self.zx_navBar).zx_subRightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        if(clickBlock){
            clickBlock(btn);
        }
    };
}

#pragma mark 设置导航栏背景渐变
- (void)zx_setNavGradientBacFrom:(UIColor *)fromColor to:(UIColor *)toColor{
    if(self.zx_navBar){
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.colors = [NSArray arrayWithObjects:(id)fromColor.CGColor,(id)toColor.CGColor,nil];
        self.zx_navBar.zx_gradientLayer = gradientLayer;
    }
    
}

#pragma mark 移除导航栏背景渐变
- (void)zx_removeNavGradientBac{
    if(self.zx_navBar){
        self.zx_navBar.zx_gradientLayer = nil;
    }
}

#pragma mark 添加自定义导航栏
- (void)zx_addCustomNavBar:(UIView *)navBar{
    if(_zx_navCustomNavBar){
        [_zx_navCustomNavBar removeFromSuperview];
    }
    [self.zx_navBar addSubview:navBar];
    _zx_navCustomNavBar = navBar;
    self.zx_navBar.zx_customNavBar = navBar;
}

#pragma mark 添加自定义TitleView
- (void)zx_addCustomTitleView:(UIView *)customTitleView{
    if(_zx_navCustomTitleView){
        [_zx_navCustomTitleView removeFromSuperview];
    }
    self.zx_navTitleLabel.text = @"";
    [self.zx_navTitleView addSubview:customTitleView];
    _zx_navCustomTitleView = customTitleView;
    self.zx_navBar.zx_customTitleView = customTitleView;
}

#pragma mark 设置大小标题的效果
- (void)zx_setMultiTitle:(NSString *)title subTitle:(NSString *)subTitle{
    [self.zx_navBar zx_setMultiTitle:title subTitle:subTitle];
}

#pragma mark 设置大小标题的效果
- (void)zx_setMultiTitle:(NSString *)title subTitle:(NSString *)subTitle subTitleFont:(UIFont *)subTitleFont subTitleTextColor:(UIColor *)subTitleColor{
    [self.zx_navBar zx_setMultiTitle:title subTitle:subTitle subTitleFont:subTitleFont subTitleTextColor:subTitleColor];
}

#pragma mark 设置导航栏折叠效果
- (void)zx_setNavFolded:(BOOL)folded speed:(int)speed foldingOffsetBlock:(foldingOffsetBlock)offsetBlock foldCompletionBlock:(foldCompletionBlock)completionBlock{
    self.offsetBlock = offsetBlock;
    self.completionBlock = completionBlock;
    if(speed > 0 && speed < 6){
        _zx_navFoldingSpeed = speed;
    }else{
        _zx_navFoldingSpeed = 3;
    }
    if(self.setFold != folded){
        self.setFold = folded;
        [self startDisplayLink];
    }else{
        self.setFold = folded;
    }
    
}

#pragma mark 通过ScrollView滚动自动控制导航栏透明效果
- (void)zx_setNavTransparentGradientsWithScrollView:(UIScrollView *)scrollView fullChangeHeight:(CGFloat)fullChangeHeight changeLimitNavAlphe:(CGFloat)changeLimitNavAlphe transparentGradientsTransparentBlock:(transparentGradientsTransparentBlock)transparentBlock transparentGradientsOpaqueBlock:(transparentGradientsOpaqueBlock)opaqueBlock{
    
    [self zx_setNavTransparentGradientsWithScrollView:scrollView fullChangeHeight:fullChangeHeight changeLimitNavAlphe:changeLimitNavAlphe transparentGradientsChangingBlock:nil transparentGradientsTransparentBlock:transparentBlock transparentGradientsOpaqueBlock:opaqueBlock];
}

- (void)zx_setNavTransparentGradientsWithScrollView:(UIScrollView *)scrollView fullChangeHeight:(CGFloat)fullChangeHeight changeLimitNavAlphe:(CGFloat)changeLimitNavAlphe transparentGradientsChangingBlock:(__nullable transparentGradientsChangingBlock)changeBlock transparentGradientsTransparentBlock:(transparentGradientsTransparentBlock)transparentBlock transparentGradientsOpaqueBlock:(transparentGradientsOpaqueBlock)opaqueBlock{
    if(changeLimitNavAlphe < 0 || changeLimitNavAlphe > 1){
        changeLimitNavAlphe = 0.7;
    }
    //获取ScrollView当前滚动的y值
    CGFloat offsetY = scrollView.contentOffset.y;
    //offsetY 到 fullChangeHeight变化时 导航栏透明度从0 到 1
    CGFloat navAlphe = offsetY / fullChangeHeight;
    navAlphe = navAlphe < 0 ? 0 : navAlphe > 1 ? 1 : navAlphe;
    if(self.lastNavAlphe >= 0 && self.lastNavAlphe <= 1){
        //导航栏透明度正在改变
        if(changeBlock){
           changeBlock(navAlphe);
        }else{
           self.zx_navBarBackgroundColorAlpha = navAlphe;
        }
    }
    //当上次的导航栏透明度小于changeLimitNavAlphe且当前导航栏透明度大于changeLimitNavAlphe时，才有必要改变导航栏颜色
    if(navAlphe > changeLimitNavAlphe && self.lastNavAlphe <= changeLimitNavAlphe){
        if(opaqueBlock){
            opaqueBlock();
        }
    }
    //当上次的导航栏透明度大于changeLimitNavAlphe且当前导航栏透明度小于changeLimitNavAlphe时，才有必要改变导航栏颜色
    if(navAlphe < changeLimitNavAlphe && self.lastNavAlphe >= changeLimitNavAlphe){
        if(transparentBlock){
            transparentBlock();
        }
    }
    //记录上次的导航栏透明度
    self.lastNavAlphe = navAlphe;
}

#pragma mark 设置与pop手势冲突的scrollView数组以兼容pop手势与scrollView手势
- (void)zx_setPopGestureCompatibleScrollViews:(NSArray <UIScrollView *>*)scrollViewArr{
    if(scrollViewArr && scrollViewArr.count){
        if(!self.navigationController){
            NSAssert(NO, @"当前控制器不是导航控制器的子控制器！");
            return;
        }
        NSArray *navGestureArray = self.navigationController.view.gestureRecognizers;
        for(UIScrollView *scrollView in scrollViewArr){
            if([self.navigationController isKindOfClass:[ZXNavigationBarNavigationController class]]){
                ZXNavigationBarNavigationController *navigationController = (ZXNavigationBarNavigationController *)self.navigationController;
                for(UIGestureRecognizer *gestureRecognizer in navGestureArray) {
                    if (gestureRecognizer == navigationController.zx_popGestureRecognizer) {
                        scrollView.bounces = NO;
                        navigationController.zx_popGestureShouldRecognizeSimultaneously = ^BOOL(UIGestureRecognizer * _Nonnull otherGestureRecognizer) {
                            if(otherGestureRecognizer.view != scrollView){
                                return NO;;
                            }
                            if(scrollView.contentOffset.x <= 0){
                                return YES;
                            }else{
                                return NO;
                            }
                        };
                        break;
                    }
                        
                }
            }else{
                for(UIGestureRecognizer *gestureRecognizer in navGestureArray) {
                    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                        [scrollView.panGestureRecognizer requireGestureRecognizerToFail:gestureRecognizer];
                        break;
                    }
                    
                }
            }
        }
    }
}

#pragma mark 设置与pop手势冲突的scrollView以兼容pop手势与scrollView手势
- (void)zx_setPopGestureCompatibleScrollView:(UIScrollView *)scrollView{
    if(scrollView){
        [self zx_setPopGestureCompatibleScrollViews:@[scrollView]];
    }
    
}


#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!self.zx_disableAutoSetCustomNavBar){
        [self refNavStatusFromWillAppear:YES];
        if(@available(iOS 11.0, *)){
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    if(_zx_navStatusBarStyle != 0){
        [self setZx_navStatusBarStyle:_zx_navStatusBarStyle];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.zx_disableAutoSetCustomNavBar){
        return;
    }
    if(self.zx_showSystemNavBar){
        self.navigationController.navigationBarHidden = NO;
    }
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.zx_navEnableSmoothFromSystemNavBar && !self.zx_disableAutoSetCustomNavBar){
        [self refNavStatusFromWillAppear:NO];
    }
    if(self.navigationController && ![self.navigationController isKindOfClass:NSClassFromString(@"ZXNavigationBarNavigationController")]){
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
        self.navigationController.interactivePopGestureRecognizer.enabled = self.navigationController.viewControllers.firstObject != self;
    }
    if(!self.navigationController){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    if(self.navigationController && [self.navigationController isKindOfClass:[ZXNavigationBarNavigationController class]]){
        SEL selector = NSSelectorFromString(@"updateTopViewController:");
        IMP imp = [self.navigationController methodForSelector:selector];
        void (*func) (id, SEL, ZXNavigationBarController *) = (void *)imp;
        func(self.navigationController,selector,self);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    if(self.zx_disableAutoSetStatusBarStyle){
        return [super preferredStatusBarStyle];
    }
    [super preferredStatusBarStyle];
    ZXNavStatusBarStyle statusBarStyle = self.zx_navStatusBarStyle;
    if(statusBarStyle == 0x00){
        statusBarStyle = defaultNavStatusBarStyle;
    }
    if(statusBarStyle == ZXNavStatusBarStyleLight){
        return UIStatusBarStyleLightContent;
    }else{
        return UIStatusBarStyleDefault;
    }
    
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if(self.zx_disableAutoSetCustomNavBar){
        return;
    }
    if(!self.isNavFoldAnimating){
        [self relayoutSubviews];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(self.zx_handlePopBlock){
        return self.zx_handlePopBlock(self,ZXNavPopBlockFromPopGesture);
    }
    return YES;
}

#pragma mark - Private
#pragma mark 通过SDWebImage设置导航栏item
- (void)setNavItemBtnWithItem:(UIButton *)btn imgUrl:(NSString *)imgUrlStr placeholderImgName:(NSString *)placeholderImgName{
    NSURL *imgUrl = [NSURL URLWithString:imgUrlStr];
    UIImage *placeholderImage = [UIImage imageNamed:placeholderImgName];
    SEL sel = NSSelectorFromString(@"sd_setImageWithURL:forState:placeholderImage:completed:");
    if([btn respondsToSelector:sel]){
        ((void (*)(id,SEL,NSURL *, UIControlState,UIImage *,id))objc_msgSend)(btn, sel,imgUrl,UIControlStateNormal,placeholderImage,nil);
    }else{
        NSAssert(NO, @"请导入SDWebImage并在pch文件中#import <SDWebImage/UIButton+WebCache.h>");
    }
}

#pragma mark 点击了系统导航栏返回按钮处理
- (BOOL)zx_navSystemBarPopHandle{
    if(self.doAutoSysBarAlphe){
        self.orgWindowColor = [UIApplication sharedApplication].keyWindow.backgroundColor;
        if(self.navigationController.navigationBar.backgroundColor){
           [UIApplication sharedApplication].keyWindow.backgroundColor = self.navigationController.navigationBar.backgroundColor;
        }else{
            [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor whiteColor];
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.navigationController.navigationBar.alpha = 0.0;
        } completion:^(BOOL finished) {
            [UIApplication sharedApplication].keyWindow.backgroundColor = self.orgWindowColor;
        }];
    }
    if(self.zx_handlePopBlock){
        return self.zx_handlePopBlock(self,ZXNavPopBlockFromBackButtonClick);
    }
    return YES;
}

#pragma mark 获取上一个控制器
- (ZXNavigationBarController *)getPreviousViewController{
    if(self.navigationController && self.navigationController.childViewControllers.count > 1){
        return self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 2];
    }
    return nil;
}

#pragma mark 验证是否需要自动调整系统导航栏透明度
- (void)checkDoAutoSysBarAlpha{
    ZXNavigationBarController *previousViewController = [self getPreviousViewController];
    BOOL doAutoSysBarAlphe = NO;
    if([previousViewController isKindOfClass:[ZXNavigationBarController class]]){
        if(previousViewController.zx_navEnableSmoothFromSystemNavBar && self.zx_showSystemNavBar){
            doAutoSysBarAlphe = YES;
        }
    }
    self.doAutoSysBarAlphe = doAutoSysBarAlphe;
}

@end
