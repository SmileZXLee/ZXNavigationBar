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
    [self addSubview:titleLabel];
    [self addSubview:titleView];
    [self addSubview:lineView];
    
    self.zx_leftBtn = leftBtn;
    self.zx_rightBtn = rightBtn;
    self.zx_subRightBtn = subRightBtn;
    self.zx_titleLabel = titleLabel;
    self.lineView = lineView;
    self.zx_titleView = titleView;
    
    CGFloat orgRigthBtnX = rightBtn.x;
    CGFloat orgLeftBtnX = leftBtn.x;
    __weak typeof(self) weakSelf = self;
    rightBtn.zx_barItemBtnFrameUpdateBlock = ^(ZXNavItemBtn * _Nonnull barItemBtn) {
        [weakSelf layoutItemBtn:barItemBtn];
        barItemBtn.x = orgRigthBtnX - (barItemBtn.width + 5 - weakSelf.zx_itemSize) - weakSelf.zx_itemMargin * 10;
        [weakSelf refNavBar];
    };
    
    subRightBtn.zx_barItemBtnFrameUpdateBlock = ^(ZXNavItemBtn * _Nonnull barItemBtn) {
        [weakSelf relayoutSubviews];
    };
    
    leftBtn.zx_barItemBtnFrameUpdateBlock = ^(ZXNavItemBtn * _Nonnull barItemBtn) {
        [weakSelf layoutItemBtn:barItemBtn];
        rightBtn.x = orgLeftBtnX + (barItemBtn.width + 5 - weakSelf.zx_itemSize);
        [weakSelf refNavBar];

    };
    [self relayoutSubviews];
}

#pragma mark 当Button中有文字时，刷新Button布局
- (void)layoutItemBtn:(ZXNavItemBtn *)barItemBtn{
    if(barItemBtn.currentTitle && barItemBtn.currentTitle.length){
        CGFloat btnw = [[NSString stringWithFormat:@"%@",barItemBtn.currentTitle] getRectWidthWithLimitH:barItemBtn.height fontSize:barItemBtn.titleLabel.font.pointSize];
        if(!barItemBtn.currentTitle.length){
            btnw = 0;
        }
        if(barItemBtn.imageView.image){
            btnw = btnw + barItemBtn.imageView.width;
        }
        barItemBtn.width = btnw + 5;
    }
}

#pragma mark 刷新导航栏titleView布局
- (void)refNavBar{
    self.zx_titleLabel.width = CGRectGetMinX(self.zx_rightBtn.frame) - self.zx_itemMargin * 3 - self.zx_itemSize;
    self.zx_titleView.width = self.zx_titleLabel.width;
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

#pragma mark 刷新子控件布局
- (void)relayoutSubviews{
    if(self.zx_leftBtn && self.zx_rightBtn && self.zx_titleLabel){
        CGFloat centerOffSet = ZXAppStatusBarHeight;
        CGSize leftBtnSize = CGSizeZero;
        if((self.zx_leftBtn.size.height == 0 && self.zx_leftBtn.size.width == 0) || self.shouldRefLayout){
            leftBtnSize = CGSizeMake(self.zx_itemSize, self.zx_itemSize);
        }else{
            leftBtnSize = self.zx_leftBtn.size;
        }
        self.zx_leftBtn.frame = CGRectMake(self.zx_itemMargin,(self.height - self.zx_itemSize + centerOffSet) / 2, leftBtnSize.width, leftBtnSize.height);
        CGSize rightBtnSize = CGSizeZero;
        CGFloat rightBtnW = 0;
        if((self.zx_rightBtn.size.height == 0 && self.zx_rightBtn.size.width == 0 && self.zx_rightBtn.x == 0) || self.shouldRefLayout){
            rightBtnSize = CGSizeMake(self.zx_itemSize, self.zx_itemSize);
            rightBtnW = self.zx_itemSize;
        }else{
            rightBtnSize = self.zx_rightBtn.size;
            rightBtnW = self.zx_rightBtn.width;
        }
        self.zx_rightBtn.frame = CGRectMake(self.width - self.zx_itemMargin - rightBtnW,(self.height - self.zx_itemSize + centerOffSet) / 2, rightBtnSize.width,rightBtnSize.height);
        if(self.shouldRefLayout){
            [self layoutItemBtn:self.zx_leftBtn];
            [self layoutItemBtn:self.zx_rightBtn];
        }
        if(self.zx_subRightBtn.imageView.image){
            self.zx_subRightBtn.frame = CGRectMake(CGRectGetMinX(self.zx_rightBtn.frame) - self.zx_itemMargin - self.zx_itemSize, self.zx_rightBtn.y, self.zx_itemSize, self.zx_itemSize);
        }else{
            self.zx_subRightBtn.frame = CGRectMake(CGRectGetMinX(self.zx_rightBtn.frame) - self.zx_itemMargin, self.zx_rightBtn.y, 0, 0);
        }
        CGFloat rightBtnFakeWidth = self.zx_rightBtn.width;
        if(self.zx_subRightBtn.imageView.image){
            rightBtnFakeWidth = self.zx_rightBtn.width + self.zx_itemSize + self.zx_itemMargin;
        }
        CGFloat maxItemWidth = MAX(self.zx_leftBtn.width,rightBtnFakeWidth);
        self.zx_titleLabel.frame = CGRectMake(maxItemWidth + 2 * self.zx_itemMargin, centerOffSet, self.width - 2 * maxItemWidth - 4 * self.zx_itemMargin, self.height - centerOffSet);
        self.zx_titleView.frame = self.zx_titleLabel.frame;
        self.lineView.frame = CGRectMake(0, self.height - 1, self.width, 1);
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
}

#pragma mark - public
#pragma mark 设置大小标题效果
- (void)zx_setMultiTitle:(NSString *)title subTitle:(NSString *)subTitle{
    NSString *appendedStr = [NSString stringWithFormat:@"%@\n%@",title,subTitle];
    NSMutableAttributedString *titleAttrStr = [[NSMutableAttributedString alloc] initWithString:appendedStr];
    [titleAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ZXNavDefalutSubTitleSize] range:NSMakeRange(title.length, appendedStr.length - title.length)];
    self.zx_titleLabel.numberOfLines = 2;
    self.zx_titleLabel.attributedText = titleAttrStr;
}

@end
