//
//  ZXNavigationBar.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import "ZXNavigationBar.h"
@interface ZXNavigationBar()
@property (assign, nonatomic)BOOL shouldRefLayout;
@end
@implementation ZXNavigationBar

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initNavBar];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self relayoutSubviews];
}

#pragma mark - private
#pragma mark 初始化导航栏
- (void)initNavBar{
    self.backgroundColor = ZXNavDefalutBacColor;
    _zx_itemSize = ZXNavDefalutItemSize;
    _zx_itemMargin = ZXNavDefalutItemMargin;
    ZXNavBacImageView *bacImageView = [[ZXNavBacImageView alloc]init];
    bacImageView.clipsToBounds = YES;
    bacImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.zx_bacImageView = bacImageView;
    [self addSubview:bacImageView];
    
    ZXNavItemBtn *leftBtn = [[ZXNavItemBtn alloc]init];
    [leftBtn addTarget:self action:@selector(leftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:ZXNavDefalutItemFontSize];
    leftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftBtn setTitleColor:ZXNavDefalutItemTextColor forState:UIControlStateNormal];
    leftBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    ZXNavItemBtn *rightBtn = [[ZXNavItemBtn alloc]init];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:ZXNavDefalutItemFontSize];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightBtn setTitleColor:ZXNavDefalutItemTextColor forState:UIControlStateNormal];
    rightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    ZXNavItemBtn *subRightBtn = [[ZXNavItemBtn alloc]init];
    [subRightBtn addTarget:self action:@selector(subRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    subRightBtn.titleLabel.font = [UIFont systemFontOfSize:ZXNavDefalutItemFontSize];
    subRightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [subRightBtn setTitleColor:ZXNavDefalutItemTextColor forState:UIControlStateNormal];
    subRightBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [subRightBtn setValue:@1 forKey:@"zx_disableSetTitle"];
    
    ZXNavItemBtn *subLeftBtn = [[ZXNavItemBtn alloc]init];
    [subLeftBtn addTarget:self action:@selector(subLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    subLeftBtn.titleLabel.font = [UIFont systemFontOfSize:ZXNavDefalutItemFontSize];
    subLeftBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [subLeftBtn setTitleColor:ZXNavDefalutItemTextColor forState:UIControlStateNormal];
    subLeftBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [subLeftBtn setValue:@1 forKey:@"zx_disableSetTitle"];
    
    ZXNavTitleView *titleView = [[ZXNavTitleView alloc]init];
    ZXNavTitleLabel *titleLabel = [[ZXNavTitleLabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:ZXNavDefalutTitleSize];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = ZXNavDefalutTitleColor;
    titleLabel.numberOfLines = 1;
    
    UIView* lineView = [[UIView alloc]init];
    lineView.backgroundColor = ZXNavDefalutLineColor;
    [self addSubview:leftBtn];
    [self addSubview:rightBtn];
    [self addSubview:subRightBtn];
    [self addSubview:subLeftBtn];
    [self addSubview:titleLabel];
    [self addSubview:titleView];
    [self addSubview:lineView];
    
    self.zx_leftBtn = leftBtn;
    self.zx_rightBtn = rightBtn;
    self.zx_subRightBtn = subRightBtn;
    self.zx_subLeftBtn = subLeftBtn;
    self.zx_titleLabel = titleLabel;
    self.lineView = lineView;
    self.zx_titleView = titleView;
    
    CGFloat orgRigthBtnX = rightBtn.zx_x;
    CGFloat orgLeftBtnX = leftBtn.zx_x;
    __weak typeof(self) weakSelf = self;
    rightBtn.zx_barItemBtnFrameUpdateBlock = ^(ZXNavItemBtn * _Nonnull barItemBtn) {
        [weakSelf layoutItemBtn:barItemBtn];
        barItemBtn.zx_x = orgRigthBtnX - (barItemBtn.zx_width + 5 - weakSelf.zx_itemSize) - weakSelf.zx_itemMargin * 10;
        [weakSelf refNavBar];
    };
    
    subRightBtn.zx_barItemBtnFrameUpdateBlock = ^(ZXNavItemBtn * _Nonnull barItemBtn) {
        [weakSelf relayoutSubviews];
    };
    
    leftBtn.zx_barItemBtnFrameUpdateBlock = ^(ZXNavItemBtn * _Nonnull barItemBtn) {
        [weakSelf layoutItemBtn:barItemBtn];
        rightBtn.zx_x = orgLeftBtnX + (barItemBtn.zx_width + 5 - weakSelf.zx_itemSize);
        [weakSelf refNavBar];

    };
    [self relayoutSubviews];
}

#pragma mark 当Button中有文字时，刷新Button布局
- (void)layoutItemBtn:(ZXNavItemBtn *)barItemBtn{
    if(barItemBtn.zx_fixWidth >= 0){
        barItemBtn.zx_width = barItemBtn.zx_fixWidth;
        return;
    }
    if(barItemBtn.currentAttributedTitle && barItemBtn.currentAttributedTitle.length){
        CGFloat btnw = [barItemBtn.currentAttributedTitle zx_getAttrRectWidthWithLimitH:barItemBtn.zx_height fontSize:barItemBtn.titleLabel.font.pointSize];
        if(barItemBtn.imageView.image){
            btnw = btnw + barItemBtn.imageView.zx_width;
        }
        barItemBtn.zx_width = btnw + barItemBtn.zx_textAttachWidth + 5;
    }else if(barItemBtn.currentTitle){
        CGFloat btnw = [barItemBtn.currentTitle zx_getRectWidthWithLimitH:barItemBtn.zx_height fontSize:barItemBtn.titleLabel.font.pointSize];
        if(!barItemBtn.currentTitle.length){
            btnw = 0;
        }
        if(barItemBtn.imageView.image){
            btnw = btnw + barItemBtn.imageView.zx_width;
        }
        barItemBtn.zx_width = btnw + barItemBtn.zx_textAttachWidth + 5;
    }
}

#pragma mark 获取ItemBtn最终高度
- (CGFloat)getItemBtnHeight:(ZXNavItemBtn *)barItemBtn{
    if(barItemBtn.zx_fixHeight >= 0){
        return barItemBtn.zx_fixHeight;
    }
    if(!barItemBtn.currentAttributedTitle && !barItemBtn.currentTitle && !CGSizeEqualToSize(barItemBtn.zx_fixImageSize,CGSizeZero)){
        return barItemBtn.zx_fixImageSize.height;
    }
    return self.zx_itemSize;
}

#pragma mark 获取ItemBtn无文字时的最终宽度
- (CGFloat)getItemBtnWidth:(ZXNavItemBtn *)barItemBtn{
    if(barItemBtn.zx_fixWidth >= 0){
        return barItemBtn.zx_fixWidth;
    }
    if(!barItemBtn.currentAttributedTitle && !barItemBtn.currentTitle && !CGSizeEqualToSize(barItemBtn.zx_fixImageSize,CGSizeZero)){
        return barItemBtn.zx_fixImageSize.width;
    }
    return self.zx_itemSize;
}

#pragma mark 刷新导航栏titleView布局
- (void)refNavBar{
    self.zx_titleLabel.zx_width = CGRectGetMinX(self.zx_rightBtn.frame) - self.zx_itemMargin * 3 - self.zx_itemSize;
    self.zx_titleView.zx_width = self.zx_titleLabel.zx_width;
}

#pragma mark 点击了左侧Button
- (void)leftBtnAction:(ZXNavItemBtn *)btn{
    !self.zx_leftBtnClickedBlock ? : self.zx_leftBtnClickedBlock(btn);
}

#pragma mark 点击了右侧Button
- (void)rightBtnAction:(ZXNavItemBtn *)btn{
    !self.zx_rightBtnClickedBlock ? : self.zx_rightBtnClickedBlock(btn);
}

#pragma mark 点击右侧第二个Button
- (void)subRightBtnAction:(ZXNavItemBtn *)btn{
    !self.zx_subRightBtnClickedBlock ? : self.zx_subRightBtnClickedBlock(btn);
}

#pragma mark 点击左侧第二个Button
- (void)subLeftBtnAction:(ZXNavItemBtn *)btn{
    !self.zx_subLeftBtnClickedBlock ? : self.zx_subLeftBtnClickedBlock(btn);
}

#pragma mark 刷新子控件布局
- (void)relayoutSubviews{
    if(self.zx_leftBtn && self.zx_rightBtn && self.zx_titleLabel){
        CGFloat centerOffSet = ZXAppStatusBarHeight;
        CGSize leftBtnSize = CGSizeZero;
        CGFloat leftBtnFinalHeight = [self getItemBtnHeight:self.zx_leftBtn];
        CGFloat leftBtnFinalWidth = [self getItemBtnWidth:self.zx_leftBtn];
        if((self.zx_leftBtn.zx_size.height == 0 && self.zx_leftBtn.zx_size.width == 0) || self.shouldRefLayout){
            leftBtnSize = CGSizeMake(leftBtnFinalWidth, leftBtnFinalHeight);
        }else{
            leftBtnSize = self.zx_leftBtn.zx_size;
        }
        self.zx_leftBtn.frame = CGRectMake(self.zx_itemMargin + ZXHorizontaledSafeArea,(self.zx_height - leftBtnFinalHeight + centerOffSet) / 2, leftBtnSize.width, leftBtnSize.height);
        CGSize rightBtnSize = CGSizeZero;
        CGFloat rightBtnW = 0;
        CGFloat rightBtnFinalHeight = [self getItemBtnHeight:self.zx_rightBtn];
        CGFloat rightBtnFinalWidth = [self getItemBtnWidth:self.zx_rightBtn];
        if((self.zx_rightBtn.zx_size.height == 0 && self.zx_rightBtn.zx_size.width == 0 && self.zx_rightBtn.zx_x == 0) || self.shouldRefLayout){
            rightBtnSize = CGSizeMake(rightBtnFinalWidth, rightBtnFinalHeight);
            rightBtnW = self.zx_itemSize;
        }else{
            rightBtnSize = self.zx_rightBtn.zx_size;
            rightBtnW = self.zx_rightBtn.zx_width;
        }
        self.zx_rightBtn.frame = CGRectMake(self.zx_width - self.zx_itemMargin - rightBtnW - ZXHorizontaledSafeArea,(self.zx_height - rightBtnFinalHeight + centerOffSet) / 2, rightBtnSize.width,rightBtnSize.height);
        if(self.shouldRefLayout){
            [self layoutItemBtn:self.zx_leftBtn];
            [self layoutItemBtn:self.zx_rightBtn];
        }
        CGFloat subRightBtnFinalHeight = [self getItemBtnHeight:self.zx_subRightBtn];
        CGFloat subRightBtnFinalWidth = [self getItemBtnWidth:self.zx_subRightBtn];
        if(self.zx_subRightBtn.imageView.image){
            self.zx_subRightBtn.frame = CGRectMake(CGRectGetMinX(self.zx_rightBtn.frame) - self.zx_itemMargin - subRightBtnFinalWidth, (self.zx_height - subRightBtnFinalHeight + centerOffSet) / 2, subRightBtnFinalWidth, subRightBtnFinalHeight);
        }else{
            self.zx_subRightBtn.frame = CGRectMake(CGRectGetMinX(self.zx_rightBtn.frame) - self.zx_itemMargin, self.zx_rightBtn.zx_y, 0, 0);
        }
        CGFloat subLeftBtnFinalHeight = [self getItemBtnHeight:self.zx_subLeftBtn];
        CGFloat subLeftBtnFinalWidth = [self getItemBtnWidth:self.zx_subLeftBtn];
        if(self.zx_subLeftBtn.imageView.image){
            self.zx_subLeftBtn.frame = CGRectMake(CGRectGetMaxX(self.zx_leftBtn.frame) + self.zx_itemMargin, (self.zx_height - subLeftBtnFinalHeight + centerOffSet) / 2, subLeftBtnFinalWidth, subLeftBtnFinalHeight);
        }else{
            self.zx_subLeftBtn.frame = CGRectMake(CGRectGetMaxX(self.zx_leftBtn.frame) - self.zx_itemMargin, self.zx_leftBtn.zx_y, 0, 0);
        }
        CGFloat rightBtnFakeWidth = self.zx_rightBtn.zx_width;
        if(self.zx_subRightBtn.imageView.image){
            rightBtnFakeWidth = self.zx_rightBtn.zx_width + self.zx_itemSize + self.zx_itemMargin;
        }
        CGFloat maxItemWidth = MAX(CGRectGetMaxX(self.zx_subLeftBtn.frame),rightBtnFakeWidth);
        self.zx_titleLabel.frame = CGRectMake(maxItemWidth + 2 * self.zx_itemMargin + ZXHorizontaledSafeArea, centerOffSet, self.zx_width - 2 * maxItemWidth - 4 * self.zx_itemMargin - ZXHorizontaledSafeArea * 2, self.zx_height - centerOffSet);
        self.zx_titleView.frame = self.zx_titleLabel.frame;
        self.lineView.frame = CGRectMake(0, self.zx_height - 1, self.zx_width, 1);
        self.zx_bacImageView.frame = self.frame;
        self.shouldRefLayout = NO;
    }
    if(self.zx_gradientLayer){
        self.zx_gradientLayer.frame = self.bounds;
    }
    if(self.zx_customNavBar){
        self.zx_customNavBar.frame = self.bounds;
    }
    if(self.zx_customTitleView){
        self.zx_customTitleView.frame = self.zx_titleView.bounds;
    }
}

#pragma mark - Setter

- (void)setZx_bacImage:(UIImage *)zx_bacImage{
    _zx_bacImage = zx_bacImage;
    self.zx_bacImageView.image = zx_bacImage;
}

- (void)setZx_itemSize:(CGFloat)zx_itemSize{
    _zx_itemSize = zx_itemSize;
    self.shouldRefLayout = YES;
    [self relayoutSubviews];
}

- (void)setZx_itemMargin:(CGFloat)zx_itemMargin{
    _zx_itemMargin = zx_itemMargin;
    self.shouldRefLayout = YES;
    [self relayoutSubviews];
}

- (void)setZx_gradientLayer:(CAGradientLayer *)zx_gradientLayer{
    if(!zx_gradientLayer && _zx_gradientLayer){
        [_zx_gradientLayer removeFromSuperlayer];
    }
    if(zx_gradientLayer){
        if(_zx_gradientLayer){
            [_zx_gradientLayer removeFromSuperlayer];
        }
        [self.layer insertSublayer:zx_gradientLayer atIndex:0];
    }
    _zx_gradientLayer = zx_gradientLayer;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    if(self.zx_navEnableSmoothFromSystemNavBar){
        [UIApplication sharedApplication].keyWindow.backgroundColor = backgroundColor;
    }
    CGFloat components[3];
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,1,1,8,4,rgbColorSpace,(CGBitmapInfo)kCGImageAlphaNoneSkipLast);

    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
    _zx_backgroundColorComponents = @[@(components[0]),@(components[1]),@(components[2])];
}

- (void)privateSetBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
}

#pragma mark - public
#pragma mark 设置大小标题效果
- (void)zx_setMultiTitle:(NSString *)title subTitle:(NSString *)subTitle{
    [self zx_setMultiTitle:title subTitle:subTitle subTitleFont:[UIFont systemFontOfSize:ZXNavDefalutSubTitleSize] subTitleTextColor:self.zx_titleLabel.textColor];
}

#pragma mark 设置大小标题效果
- (void)zx_setMultiTitle:(NSString *)title subTitle:(NSString *)subTitle subTitleFont:(UIFont *)subTitleFont subTitleTextColor:(UIColor *)subTitleColor{
    NSString *appendedStr = [NSString stringWithFormat:@"%@\n%@",title,subTitle];
    NSMutableAttributedString *titleAttrStr = [[NSMutableAttributedString alloc] initWithString:appendedStr];
    [titleAttrStr addAttribute:NSFontAttributeName value:subTitleFont range:NSMakeRange(title.length, appendedStr.length - title.length)];
    [titleAttrStr addAttribute:NSForegroundColorAttributeName value:subTitleColor range:NSMakeRange(title.length, appendedStr.length - title.length)];
    self.zx_titleLabel.numberOfLines = 2;
    self.zx_titleLabel.attributedText = titleAttrStr;
}

@end
