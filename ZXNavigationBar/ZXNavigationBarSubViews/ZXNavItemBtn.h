//
//  ZXNavItemBtn.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

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
///设置NavItemBtn的字体大小
@property (assign, nonatomic)CGFloat zx_fontSize;
///设置NavItemBtn的固定宽度，若设置，则自动计算宽度无效
@property (assign, nonatomic)CGFloat zx_fixWidth;
///设置NavItemBtn的固定高度，若设置，则ZXNavDefalutItemSize无效
@property (assign, nonatomic)CGFloat zx_fixHeight;
///设置NavItemBtn image的固定大小
@property (assign, nonatomic)CGSize zx_fixImageSize;
///设置NavItemBtn自动计算宽度后的附加宽度
@property (assign, nonatomic)CGFloat zx_textAttachWidth;
@end

NS_ASSUME_NONNULL_END
