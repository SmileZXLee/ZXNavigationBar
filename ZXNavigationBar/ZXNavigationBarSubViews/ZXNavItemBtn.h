//
//  ZXNavItemBtn.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.3.6

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXNavItemBtn : UIButton
///是否禁止设置title和attributedTitle
@property (assign, nonatomic, readonly)BOOL zx_disableSetTitle;
///NavItemBtn的frame更新回调
@property (copy, nonatomic) void (^zx_barItemBtnFrameUpdateBlock)(ZXNavItemBtn *barItemBtn);
///设置NavItemBtn的image颜色
@property (strong, nonatomic, nullable)UIColor *zx_imageColor;
///设置NavItemBtn的tintColor
@property (strong, nonatomic, nullable)UIColor *zx_tintColor;
///设置NavItemBtn的tintColor仅用于UIControlStateNormal状态(请在zx_imageColor和zx_tintColor之前设置)，默认为NO
@property (assign, nonatomic)UIColor *zx_useTintColorOnlyInStateNormal;
///设置NavItemBtn的字体大小
@property (assign, nonatomic)CGFloat zx_fontSize;
///禁止自动调整按钮图片和文字的布局，若要使contentEdgeInsets、titleEdgeInsets、imageEdgeInsets等，则需要将此属性设置为NO
@property (assign, nonatomic)BOOL zx_disableAutoLayoutImageAndTitle;
///设置NavItemBtn的固定宽度，若设置，则自动计算宽度无效，若要恢复初始值，可设置为-1
@property (assign, nonatomic)CGFloat zx_fixWidth;
///设置NavItemBtn的固定高度，若设置，则ZXNavDefalutItemSize无效，若要恢复初始值，可设置为-1
@property (assign, nonatomic)CGFloat zx_fixHeight;
///设置NavItemBtn image的固定大小，若要恢复初始值，可设置为CGSizeZero
@property (assign, nonatomic)CGSize zx_fixImageSize;
///设置NavItemBtn文字自动计算宽度后的附加宽度
@property (assign, nonatomic)CGFloat zx_textAttachWidth;
///设置NavItemBtn文字的附加高度
@property (assign, nonatomic)CGFloat zx_textAttachHeight;
///设置NavItemBtn的cornerRadius为高度的一半(圆形圆角)
@property (assign, nonatomic)BOOL zx_setCornerRadiusRounded;
///设置NavItemBtn内部图片x轴的偏移量，负数代表左移，无title且设置了zx_fixImageSize后生效，仅改变内容imageView的位移，不会改变原始NavItemBtn的frame
@property (assign, nonatomic)CGFloat zx_imageOffsetX;
///设置NavItemBtn的自定义view
@property (strong, nonatomic, nullable)UIView *zx_customView;
///NavItemBtn frame发生改变时的回调，可在这个block中return修改后的frame
@property(copy, nonatomic)CGRect(^zx_handleFrameBlock)(CGRect oldFrame);
///手动更新布局，一般内部会自动调用，用于高度定制时无法自动更新布局时调用
- (void)zx_updateLayout;
@end

NS_ASSUME_NONNULL_END
