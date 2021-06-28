//
//  UINavigationController+ZXNavBarAllHiddenExtension.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/20.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.4.1

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (ZXNavBarAllHiddenExtension)

/**
 隐藏所有导航栏【可有效避免可能出现的状态栏颜色黑白切换或导航栏跳动的问题】(请在appdelegate的didFinishLaunchingWithOptions中设置，并确保在根控制器初始化之前，若导航控制器为ZXNavigationBarNavigationController或其子控制器，无需进行此项设置)
 */
+ (void)zx_hideAllNavBar;

/**
 取消隐藏所有导航栏
 */
+ (void)zx_removeAllNavBar;
@end

NS_ASSUME_NONNULL_END
