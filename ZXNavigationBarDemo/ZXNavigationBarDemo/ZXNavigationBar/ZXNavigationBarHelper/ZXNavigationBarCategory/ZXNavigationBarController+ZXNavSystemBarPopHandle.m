//
//  ZXNavigationBarController+ZXNavSystemBarPopHandle.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/5/29.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.3.6

//Thanks to @onegray https://github.com/onegray/UIViewController-BackButtonHandler Respect!

#import "ZXNavigationBarController+ZXNavSystemBarPopHandle.h"
#import <objc/runtime.h>

@implementation UIViewController (ZXNavSystemBarPopHandle)

@end

@implementation UINavigationController (ZXNavSystemBarPopHandle)

+ (void)load {
    Method originalMethod = class_getInstanceMethod([self class], @selector(navigationBar:shouldPopItem:));
    Method overloadingMethod = class_getInstanceMethod([self class], @selector(overloaded_navigationBar:shouldPopItem:));
    method_setImplementation(originalMethod, method_getImplementation(overloadingMethod));
}

- (BOOL)overloaded_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(zx_navSystemBarPopHandle)]) {
        shouldPop = [vc zx_navSystemBarPopHandle];
    }
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // Workaround for iOS7.1. Thanks to @boliva - http://stackoverflow.com/posts/comments/34452906
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

@end
