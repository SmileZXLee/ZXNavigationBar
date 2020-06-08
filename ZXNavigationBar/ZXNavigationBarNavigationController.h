//
//  ZXNavigationBarNavigationController.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/5/29.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXNavigationBarNavigationController : UINavigationController

/**
 是否禁用push控制器自动隐藏tabbar
 */
@property (assign, nonatomic)BOOL zx_disableAutoHidesBottomBarWhenPushed;

/**
 是否禁用全屏pop手势，若禁用，则pop触发范围为屏幕宽度的五分之一
 */
@property (assign, nonatomic)BOOL zx_disableFullScreenGesture;


/**
 pop手势的触发范围比例，0-1，默认为1，即代表全屏触发
 */
@property (assign, nonatomic) CGFloat zx_popGestureCoverRatio;

/**
 监听自定义pop手势进度。currentViewController代表当前正在pop的控制器，popOffsetProgress范围为0-1，0代表即将开始pop，1代表完成pop
 */
@property(nonatomic,copy)void(^zx_handleCustomPopGesture)(UIViewController *currentViewController,CGFloat popOffsetProgress);
@end

NS_ASSUME_NONNULL_END
