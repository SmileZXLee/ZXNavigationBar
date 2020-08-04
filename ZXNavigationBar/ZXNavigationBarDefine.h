//
//  ZXNavigationBarDefine.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#ifndef ZXNavigationBarDefine_h
#define ZXNavigationBarDefine_h
#define ZXNavDefalutBacColor [UIColor whiteColor]
#define ZXNavDefalutTitleColor [UIColor blackColor]
#define ZXNavDefalutLineColor [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:0.8]
#define ZXNavDefalutItemTextColor [UIColor blackColor]

#define ZXNavDefalutTitleSize 17
#define ZXNavDefalutSubTitleSize 10
#define ZXNavDefalutItemFontSize 15

#define ZXNavDefalutItemSize 25
#define ZXNavDefalutItemMargin 10

/**
获取主Window

@return 主Window
*/
#define ZXMainWindow ([UIApplication sharedApplication].keyWindow ?: [UIApplication sharedApplication].windows.firstObject)
/**
 判断是否是刘海屏

 @return 是否是刘海屏
 */
#define ZXIsBangScreen ({\
int cFlag = 0;\
if (@available(iOS 11.0, *)) {\
if (ZXMainWindow.safeAreaInsets.bottom > 0) {\
cFlag = 1;\
}else{\
cFlag = 0;\
}\
}else{\
cFlag = 0;\
}\
cFlag;\
})

/**
判断手机是否是横屏

@return 手机是否是横屏
*/
#define ZXIsHorizontalScreen ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft)

/**
 获取屏幕宽度

 @return 屏幕宽度
 */
#define ZXScreenWidth [UIScreen mainScreen].bounds.size.width

/**
 获取屏幕高度

 @return 屏幕高度
 */
#define ZXScreenHeight [UIScreen mainScreen].bounds.size.height

/**
 获取状态栏高度

 @return 状态栏高度
 */
//#define ZXAppStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//适配iOS13以下系统开启热点或音频时的导航栏
#define ZXAppStatusBarHeight (ZXIsHorizontalScreen ? 0 : (ZXIsBangScreen ? 44 : 20))

/**
 获取导航栏高度
 
 @return 导航栏高度
 */
#define ZXNavBarHeight (ZXIsHorizontalScreen ? 44 : (ZXAppStatusBarHeight + 44))

/**
 获取安全区域顶部高度
 
 @return 安全区域顶部高度
 */
#define ZXSafeAreaTop ({\
int height = 0;\
if (@available(iOS 11.0, *)) {\
height = ZXMainWindow.safeAreaInsets.top;\
}else{\
height = 0;\
}\
height;\
})

/**
 获取安全区域底部高度
 
 @return 安全区域底部高度
 */
#define ZXSafeAreaBottom ({\
int height = 0;\
if (@available(iOS 11.0, *)) {\
height = ZXMainWindow.safeAreaInsets.bottom;\
}else{\
height = 0;\
}\
height;\
})

/**
 获取横屏后左右安全距离
 
 @return 横屏后左右安全距离
 */
#define ZXHorizontaledSafeArea ((ZXIsHorizontalScreen && ZXIsBangScreen)? 44 : 0)

#endif /* ZXNavigationBarDefine_h */
