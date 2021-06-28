//
//  UINavigationController+ZXNavBarAllHiddenExtension.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/20.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.4.1

#import "UINavigationController+ZXNavBarAllHiddenExtension.h"
#import <objc/runtime.h>
static BOOL isHideAllNavBar = NO;
@implementation UINavigationController (ZXNavBarAllHiddenExtension)
+ (void)zx_hideAllNavBar{
    isHideAllNavBar = YES;
    zx_nav_swizzleMethod([self class], @selector(pushViewController:animated:), @selector(swizzled_pushViewController:animated:));
}

+ (void)zx_removeAllNavBar{
    isHideAllNavBar = NO;
}

- (void)swizzled_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self swizzled_pushViewController:viewController animated:animated];
    Class zxNavVcCls1 = NSClassFromString(@"ZXNavigationBarController");
    Class zxNavVcCls2 = NSClassFromString(@"ZXNavigationBarTableViewController");
    if(isHideAllNavBar && ([viewController isKindOfClass:zxNavVcCls1] || [viewController isKindOfClass:zxNavVcCls2])){
        self.navigationBarHidden = YES;
    }
}

void zx_nav_swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector){
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}
@end
