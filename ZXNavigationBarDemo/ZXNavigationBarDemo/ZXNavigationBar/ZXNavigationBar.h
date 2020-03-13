//
//  ZXNavigationBar.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import <UIKit/UIKit.h>
#import "ZXNavigationBarDefine.h"
#import "UIImage+ZXNavColorRender.h"
#import "UIView+ZXNavFrameExtension.h"
#import "NSString+ZXNavCalcSizeExtension.h"
#import "ZXNavTitleLabel.h"
#import "ZXNavItemBtn.h"
#import "ZXNavBacImageView.h"
#import "ZXNavTitleView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZXNavigationBar : UIView
/**
 设置左右Button的大小(宽高相等)
 */
@property (assign, nonatomic)CGFloat zx_itemSize;
/**
 设置Item之间的间距
 */
@property (assign, nonatomic)CGFloat zx_itemMargin;
/**
 左侧Button
 */
@property (weak, nonatomic)ZXNavItemBtn *zx_leftBtn;
/**
 最右侧Button
 */
@property (weak, nonatomic)ZXNavItemBtn *zx_rightBtn;
/**
 右侧第二个Button
 */
@property (weak, nonatomic)ZXNavItemBtn *zx_subRightBtn;
/**
 titleView，显示在正中间的标题View
 */
@property (weak, nonatomic)ZXNavTitleView *zx_titleView;
/**
 titleLabel，显示在正中间的标题Label
 */
@property (weak, nonatomic)ZXNavTitleLabel *zx_titleLabel;
/**
 导航栏背景ImageView
 */
@property (weak, nonatomic)ZXNavBacImageView *zx_bacImageView;
/**
 导航栏背景渐变的CAGradientLayer
 */
@property (weak, nonatomic, nullable)CAGradientLayer *zx_gradientLayer;
/**
 导航栏背景图片
 */
@property (strong, nonatomic ,nullable)UIImage *zx_bacImage;
/**
 自定义的titleView，是TitleView的SubView
 */
@property (weak, nonatomic)UIView *zx_customTitleView;
/**
 自定义的导航栏View，是ZXNavigationBar的SubView
 */
@property (weak, nonatomic)UIView *zx_customNavBar;
/**
 分割线
 */
@property (weak, nonatomic)UIView *lineView;
/**
 左侧Button点击回调
 */
@property (copy, nonatomic) void (^zx_leftBtnClickedBlock)(ZXNavItemBtn *btn);
/**
 最右侧Button点击回调
 */
@property (copy, nonatomic) void (^zx_rightBtnClickedBlock)(ZXNavItemBtn *btn);
/**
 右侧第二个Button点击回调
 */
@property (copy, nonatomic) void (^zx_subRightBtnClickedBlock)(ZXNavItemBtn *btn);
/**
 设置大小标题效果

 @param title 大标题
 @param subTitle 小标题
 */
- (void)zx_setMultiTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end

NS_ASSUME_NONNULL_END
