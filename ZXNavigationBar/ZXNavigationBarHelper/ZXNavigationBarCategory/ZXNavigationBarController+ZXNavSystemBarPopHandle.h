//
//  ZXNavigationBarController+ZXNavSystemBarPopHandle.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/5/29.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.3.6

//Thanks to @onegray https://github.com/onegray/UIViewController-BackButtonHandler Respect!

#import "ZXNavigationBarController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol BackButtonHandlerProtocol <NSObject>
@optional

-(BOOL)zx_navSystemBarPopHandle;
@end
@interface UIViewController (ZXNavSystemBarPopHandle)<BackButtonHandlerProtocol>

@end

NS_ASSUME_NONNULL_END
