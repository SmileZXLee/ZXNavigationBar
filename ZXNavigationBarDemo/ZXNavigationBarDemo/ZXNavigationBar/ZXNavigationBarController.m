//
//  ZXNavigationBarController.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import "ZXNavigationBarController.h"
#import "UIImage+ZXNavBundleExtension.h"
@interface ZXNavigationBarController ()
@property(assign, nonatomic)CGFloat orgNavOffset;
@property(assign, nonatomic)BOOL setFold;
@property(assign, nonatomic)BOOL isNavFoldAnimating;
@property(strong, nonatomic)CADisplayLink *displayLink;
@property(copy, nonatomic)foldingOffsetBlock offsetBlock;
@property(copy, nonatomic)foldCompletionBlock completionBlock;
@property(strong, nonatomic)NSLayoutConstraint * xibTopConstraint;
@end

@implementation ZXNavigationBarController
static ZXNavStatusBarStyle defaultNavStatusBarStyle = ZXNavStatusBarStyleDefault;
#pragma mark - Init
- (void)viewDidLoad {
    [super viewDidLoad];
    self.orgNavOffset = -1;
    self.zx_navFixHeight = -1;
    if(self.navigationController && !self.zx_hideBaseNavBar){
        [self initNavBar];
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
        [self setAutoBack];
    }
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
    self.zx_navTitleView = navBar.zx_titleView;
    self.zx_navTitleLabel = navBar.zx_titleLabel;
    self.zx_navLeftBtn = navBar.zx_leftBtn;
    self.zx_navRightBtn = navBar.zx_rightBtn;
    self.zx_navSubRightBtn = navBar.zx_subRightBtn;
    self.zx_navLineView = navBar.lineView;
    self.zx_navBacImageView = navBar.zx_bacImageView;
    self.zx_navBar = navBar;
    self.zx_navTitleLabel.text = self.zx_navTitle;
    [self adjustNavContainerOffset:[self getCurrentNavHeight]];
    self.zx_isEnableSafeArea = YES;
    [self relayoutSubviews];
}

#pragma mark 设置自动显示返回Button且点击pop到上一个控制器
- (void)setAutoBack{
    if(self.navigationController && self.navigationController.viewControllers.count > 1){
        UIImage *backImg = [UIImage imageFromBundleWithImageName:@"back_icon"];
        [self.zx_navLeftBtn setImage:backImg forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [self zx_leftClickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark Xib加载情况下，调整约束自动下移导航栏高度
- (void)adjustNavContainerOffset:(CGFloat)offset{
    if(self.zx_disableNavAutoSafeLayout){
        offset = 0;
    }
    if(self.zx_isEnableSafeArea){
        if (@available(iOS 11.0, *)) {
            offset -= [UIApplication sharedApplication].delegate.window.safeAreaInsets.top;
        }
    }
    if(self.xibTopConstraint){
        [self updateTopConstraint:self.xibTopConstraint offset:offset];
        return;
    }
    NSArray *constraintArr = [self.view constraints];
    [constraintArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLayoutConstraint * constraint = obj;
        if (constraint.firstAttribute == NSLayoutAttributeTop){
            if(self.orgNavOffset == -1){
                self.orgNavOffset = constraint.constant;
            }
            [self updateTopConstraint:constraint offset:offset];
            self.xibTopConstraint = constraint;
            *stop = YES;
        }
    }];
}

#pragma mark 更新容器顶部约束
- (void)updateTopConstraint:(NSLayoutConstraint *)constraint offset:(CGFloat)offset{
    CGFloat handleOffset = self.orgNavOffset + offset;
    if(self.zx_handleAdjustNavContainerOffsetBlock){
        handleOffset = self.zx_handleAdjustNavContainerOffsetBlock(self.orgNavOffset,self.orgNavOffset + offset);
    }
    constraint.constant = handleOffset;
    self.xibTopConstraint = constraint;
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
        NSLog(@"%lf",self.zx_navBar.height);
        if(self.zx_navBar.height > ZXAppStatusBarHeight){
            self.zx_navBar.height -= self.zx_navFoldingSpeed;
            if(self.xibTopConstraint){
                self.xibTopConstraint.constant -= self.zx_navFoldingSpeed;
            }
            if(self.offsetBlock){
                self.offsetBlock(-self.zx_navFoldingSpeed);
            }
            [self setAlphaOfNavSubViews:(self.zx_navBar.height - ZXAppStatusBarHeight) / ([self getCurrentNavHeight] - ZXAppStatusBarHeight)];
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
        if(self.zx_navBar.height < [self getCurrentNavHeight]){
            self.zx_navBar.height += self.zx_navFoldingSpeed;
            if(self.xibTopConstraint){
                self.xibTopConstraint.constant += self.zx_navFoldingSpeed;
            }
            if(self.offsetBlock){
                self.offsetBlock(self.zx_navFoldingSpeed);
            }
            [self setAlphaOfNavSubViews:(self.zx_navBar.height - ZXAppStatusBarHeight) / ([self getCurrentNavHeight] - ZXAppStatusBarHeight)];
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
        self.zx_navRightBtn.zx_tintColor = zx_navTintColor;
        self.zx_navSubRightBtn.zx_tintColor = zx_navTintColor;
    }
    self.zx_navTitleLabel.textColor = zx_navTintColor;
    [self.zx_navLeftBtn setTitleColor:zx_navTintColor forState:UIControlStateNormal];
    [self.zx_navRightBtn setTitleColor:zx_navTintColor forState:UIControlStateNormal];
    [self.zx_navSubRightBtn setTitleColor:zx_navTintColor forState:UIControlStateNormal];
    if(self.zx_navLeftBtn.currentImage){
        [self.zx_navLeftBtn setImage:[self.zx_navLeftBtn.currentImage zx_renderingColor:zx_navTintColor] forState:UIControlStateNormal];
    }
    if(self.zx_navRightBtn.currentImage){
        [self.zx_navRightBtn setImage:[self.zx_navRightBtn.currentImage zx_renderingColor:zx_navTintColor] forState:UIControlStateNormal];
    }
    if(self.zx_navSubRightBtn.currentImage){
        [self.zx_navSubRightBtn setImage:[self.zx_navSubRightBtn.currentImage zx_renderingColor:zx_navTintColor] forState:UIControlStateNormal];
    }
}

- (void)setZx_hideBaseNavBar:(BOOL)zx_hideBaseNavBar{
    if(_zx_hideBaseNavBar != zx_hideBaseNavBar){
        if(zx_hideBaseNavBar){
            [self adjustNavContainerOffset:0];
        }else{
            if(self.zx_isEnableSafeArea && [[UIDevice currentDevice].systemVersion doubleValue] >= 11){
                [self adjustNavContainerOffset:([self getCurrentNavHeight] - ZXAppStatusBarHeight)];
            }else{
                [self adjustNavContainerOffset:[self getCurrentNavHeight]];
            }
        }
        
    }
    _zx_hideBaseNavBar = zx_hideBaseNavBar;
    if(self.zx_navBar){
        self.zx_navBar.hidden = zx_hideBaseNavBar;
    }
}

- (void)setZx_isEnableSafeArea:(BOOL)zx_isEnableSafeArea{
    if(@available(iOS 11.0, *)) {
        if(_zx_isEnableSafeArea != zx_isEnableSafeArea){
            if(zx_isEnableSafeArea){
                [self adjustNavContainerOffset:([self getCurrentNavHeight] - ZXAppStatusBarHeight)];
            }else{
                [self adjustNavContainerOffset:[self getCurrentNavHeight]];
            }
        }
    }
    _zx_isEnableSafeArea = zx_isEnableSafeArea;
}

- (void)setZx_navStatusBarStyle:(ZXNavStatusBarStyle)zx_navStatusBarStyle{
    _zx_navStatusBarStyle = zx_navStatusBarStyle;
    defaultNavStatusBarStyle = zx_navStatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setZx_showSystemNavBar:(BOOL)zx_showSystemNavBar{
    _zx_showSystemNavBar = zx_showSystemNavBar;
    if(self.navigationController){
        self.zx_hideBaseNavBar = YES;
        self.navigationController.navigationBar.translucent = !zx_showSystemNavBar;
        self.navigationController.navigationBarHidden = !zx_showSystemNavBar;
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
    zx_disableNavAutoSafeLayout = zx_disableNavAutoSafeLayout;
    [self adjustNavContainerOffset:0];
}

- (void)setZx_navEnableSmoothFromSystemNavBar:(BOOL)zx_navEnableSmoothFromSystemNavBar{
    _zx_navEnableSmoothFromSystemNavBar = zx_navEnableSmoothFromSystemNavBar;
    if(self.zx_navBar){
        [self.zx_navBar setValue:@(zx_navEnableSmoothFromSystemNavBar) forKey:@"zx_navEnableSmoothFromSystemNavBar"];
        [UIApplication sharedApplication].keyWindow.backgroundColor = self.zx_navBar.backgroundColor;
    }
}

- (void)setZx_handleAdjustNavContainerOffsetBlock:(CGFloat (^)(CGFloat, CGFloat))zx_handleAdjustNavContainerOffsetBlock{
    _zx_handleAdjustNavContainerOffsetBlock = zx_handleAdjustNavContainerOffsetBlock;
    if(zx_handleAdjustNavContainerOffsetBlock){
        [self adjustNavContainerOffset:self.xibTopConstraint.constant - self.orgNavOffset];
    }
}

- (void)setZx_navFixHeight:(int)zx_navFixHeight{
    _zx_navFixHeight = zx_navFixHeight;
    [self relayoutSubviews];
    [self adjustNavContainerOffset:[self getCurrentNavHeight]];
}




#pragma mark - Public
#pragma mark 设置左侧Button图片和点击回调
- (void)zx_setLeftBtnWithImgName:(NSString *)imgName clickedBlock:(leftBtnClickedBlock)clickBlock{
    [self.zx_navLeftBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_leftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        clickBlock(btn);
    };
}

#pragma mark 设置最右侧Button图片和点击回调
- (void)zx_setRightBtnWithImgName:(NSString *)imgName clickedBlock:(rightBtnClickedBlock)clickBlock{
    [self.zx_navRightBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_rightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        clickBlock(btn);
    };
}

#pragma mark 设置右侧第二个Button图片和点击回调
- (void)zx_setSubRightBtnWithImgName:(NSString *)imgName clickedBlock:(subRightBtnClickedBlock)clickBlock{
    [self.zx_navSubRightBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_subRightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        clickBlock(btn);
    };
}

#pragma mark 设置左侧Button文字和点击回调
- (void)zx_setLeftBtnWithText:(NSString *)btnText clickedBlock:(leftBtnClickedBlock)clickBlock{
    [self.zx_navLeftBtn setTitle:btnText forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_leftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        clickBlock(btn);
    };
}

#pragma mark 设置最右侧Button图片和点击回调
- (void)zx_setRightBtnWithText:(NSString *)btnText clickedBlock:(rightBtnClickedBlock)clickBlock{
    [self.zx_navRightBtn setTitleColor:self.zx_navTitleLabel.textColor forState:UIControlStateNormal];
    [self.zx_navRightBtn setTitle:btnText forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_rightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        clickBlock(btn);
    };
}

#pragma mark 设置右侧第二个按钮图片和点击回调
- (void)zx_setSubRightBtnWithText:(NSString *)btnText clickedBlock:(subRightBtnClickedBlock)clickBlock{
    [self.zx_navSubRightBtn setTitleColor:self.zx_navTitleLabel.textColor forState:UIControlStateNormal];
    [self.zx_navSubRightBtn setTitle:btnText forState:UIControlStateNormal];
    ((ZXNavigationBar *)self.zx_navBar).zx_subRightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        clickBlock(btn);
    };
}

#pragma mark 左侧Button点击回调
- (void)zx_leftClickedBlock:(leftBtnClickedBlock)clickBlock{
    ((ZXNavigationBar *)self.zx_navBar).zx_leftBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        clickBlock(btn);
    };
}

#pragma mark 最右侧Button点击回调
- (void)zx_rightClickedBlock:(rightBtnClickedBlock)clickBlock{
    ((ZXNavigationBar *)self.zx_navBar).zx_rightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        clickBlock(btn);
    };
}

#pragma mark 右侧第二个Button点击回调
- (void)zx_subRightClickedBlock:(subRightBtnClickedBlock)clickBlock{
    ((ZXNavigationBar *)self.zx_navBar).zx_subRightBtnClickedBlock = ^(ZXNavItemBtn * _Nonnull btn) {
        clickBlock(btn);
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
    if(self.zx_navCustomNavBar){
        [self.zx_navCustomNavBar removeFromSuperview];
    }
    [self.zx_navBar addSubview:navBar];
    self.zx_navCustomNavBar = navBar;
    self.zx_navBar.zx_customNavBar = navBar;
}

#pragma mark 添加自定义TitleView
- (void)zx_addCustomTitleView:(UIView *)customTitleView{
    if(self.zx_navCustomTitleView){
        [self.zx_navCustomTitleView removeFromSuperview];
    }
    self.zx_navTitleLabel.text = @"";
    [self.zx_navTitleView addSubview:customTitleView];
    self.zx_navCustomTitleView = customTitleView;
    self.zx_navBar.zx_customTitleView = customTitleView;
}

#pragma mark 设置大小标题的效果
- (void)zx_setMultiTitle:(NSString *)title subTitle:(NSString *)subTitle{
    [self.zx_navBar zx_setMultiTitle:title subTitle:subTitle];
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

#pragma mark - Other
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refNavStatusFromWillAppear:YES];
    if(@available(iOS 11.0, *)){
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(self.zx_showSystemNavBar){
        self.navigationController.navigationBarHidden = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.zx_navEnableSmoothFromSystemNavBar){
        [self refNavStatusFromWillAppear:NO];
    }
    if(self.navigationController){
        self.navigationController.interactivePopGestureRecognizer.enabled = self.navigationController.viewControllers.firstObject != self;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle{
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
    if(!self.isNavFoldAnimating){
        [self relayoutSubviews];
    }
}


@end
