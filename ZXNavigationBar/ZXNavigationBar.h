//
//  ZXNavigationBar.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.3.6

#import <UIKit/UIKit.h>
#import "ZXNavigationBarDefine.h"
#import "UIImage+ZXNavColorRender.h"
#import "UIView+ZXNavFrameExtension.h"
#import "NSString+ZXNavCalcSizeExtension.h"
#import "NSAttributedString+ZXNavCalcSizeExtension.h"
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
 最左侧Button
 */
@property (weak, nonatomic)ZXNavItemBtn *zx_leftBtn;
/**
 左侧第二个Button
 */
@property (weak, nonatomic)ZXNavItemBtn *zx_subLeftBtn;
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
@property (weak, nonatomic, readonly)ZXNavTitleView *zx_titleView;
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
 是否开启系统导航栏与自定义导航栏平滑过渡(务必仅当存在系统导航栏与自定义导航栏过渡时启用，非必要请勿启用，否则可能造成自定义导航栏跳动，若当前控制器显示了系统导航栏，请于当前控制器pop的上一个控制器中使用self.zx_navEnableSmoothFromSystemNavBar = YES)
 */
@property (assign, nonatomic, readonly)BOOL zx_navEnableSmoothFromSystemNavBar;
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
@property (weak, nonatomic)UIView *lineView ZXNavigationBarDeprecated("从版本1.3.6起，此属性过期，请使用zx_lineView");
/**
 分割线
 */
@property (weak, nonatomic)UIView *zx_lineView;
/**
 分割线的高度，默认为1
 */
@property (assign, nonatomic)CGFloat zx_lineViewHeight;
/**
 最左侧Button点击回调
 */
@property (copy, nonatomic) void (^zx_leftBtnClickedBlock)(ZXNavItemBtn *btn);
/**
 左侧第二个Button点击回调
 */
@property (copy, nonatomic) void (^zx_subLeftBtnClickedBlock)(ZXNavItemBtn *btn);
/**
 最右侧Button点击回调
 */
@property (copy, nonatomic) void (^zx_rightBtnClickedBlock)(ZXNavItemBtn *btn);
/**
 右侧第二个Button点击回调
 */
@property (copy, nonatomic) void (^zx_subRightBtnClickedBlock)(ZXNavItemBtn *btn);

/**
 导航栏背景色Components
 */
@property (strong, nonatomic, readonly) NSArray* zx_backgroundColorComponents;
/**
 设置大小标题效果

 @param title 大标题
 @param subTitle 小标题
 */
- (void)zx_setMultiTitle:(NSString *)title subTitle:(NSString *)subTitle;

/**
 设置大小标题效果

 @param title 大标题
 @param subTitle 小标题
 @param subTitleFont 小标题字体
 @param subTitleColor 小标题颜色
 */
- (void)zx_setMultiTitle:(NSString *)title subTitle:(NSString *)subTitle subTitleFont:(UIFont *)subTitleFont subTitleTextColor:(UIColor *)subTitleColor;

@end

NS_ASSUME_NONNULL_END
