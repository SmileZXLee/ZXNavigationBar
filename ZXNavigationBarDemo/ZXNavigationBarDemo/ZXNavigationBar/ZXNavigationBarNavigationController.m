//
//  ZXNavigationBarNavigationController.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/5/29.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.3.6

#import "ZXNavigationBarNavigationController.h"
#import <objc/runtime.h>
#import "ZXNavigationBarController.h"
@interface ZXNavigationBarNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property (assign, nonatomic) CGFloat touchBeginX;
@property (assign, nonatomic) BOOL doingPopGesture;
@property (strong, nonatomic, nullable) ZXNavigationBarController *zx_topViewController;
@property (strong, nonatomic) id orgInteractivePopGestureRecognizerDelegate;
@end

@implementation ZXNavigationBarNavigationController

- (void)viewDidLoad {
    self.orgInteractivePopGestureRecognizerDelegate = self.interactivePopGestureRecognizer.delegate;
    [super viewDidLoad];
    self.delegate = self;
    self.zx_popGestureCoverRatio = 1;
    [self addFullScreenGesture];
}

#pragma mark - 重写父类pop和push相关方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    self.navigationBarHidden = YES;
    [self updateTopViewController:viewController];
    if(!self.zx_disableAutoHidesBottomBarWhenPushed){
        [viewController setHidesBottomBarWhenPushed:self.viewControllers.count  >= 1];
    }
    [super pushViewController:viewController animated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    if(self.childViewControllers.count > 1 && !self.doingPopGesture){
        [self updateTopViewController:self.childViewControllers[self.childViewControllers.count - 2]];
    }
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated{
    if(self.viewControllers.firstObject && !self.doingPopGesture){
        [self updateTopViewController:self.viewControllers.firstObject];
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(viewController && !self.doingPopGesture){
        [self updateTopViewController:viewController];
    }
    return [super popToViewController:viewController animated:animated];
}

#pragma mark - public
- (void)zx_disablePopGesture{
    if(self.zx_popGestureRecognizer){
        [self.view removeGestureRecognizer:self.zx_popGestureRecognizer];
    }
}

#pragma mark - Private
#pragma mark 添加全屏手势
- (void)addFullScreenGesture{
    self.interactivePopGestureRecognizer.enabled = NO;
    UIPanGestureRecognizer *popGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleNavigationTransition:)];
    popGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:popGestureRecognizer];
    _zx_popGestureRecognizer = popGestureRecognizer;
}

#pragma mark 处理pop手势
- (void)handleNavigationTransition:(UIPanGestureRecognizer *)panGesture{
    if(self.zx_topViewController && !self.doingPopGesture){
        if(self.zx_topViewController.zx_handlePopBlock){
            BOOL shouldPop = self.zx_topViewController.zx_handlePopBlock(self.zx_topViewController,ZXNavPopBlockFromPopGesture);
            if(!shouldPop){
                return;
            }
        }
    }
    CGFloat panGestureX = [panGesture locationInView:self.view].x;
    self.doingPopGesture = YES;
    [self.orgInteractivePopGestureRecognizerDelegate performSelector:@selector(handleNavigationTransition:) withObject:panGesture];
    CGFloat popOffsetX = panGestureX - self.touchBeginX;
    if(self.zx_handleCustomPopGesture){
        if(panGesture.state == UIGestureRecognizerStateEnded){
            self.doingPopGesture = NO;
            if(popOffsetX > self.view.frame.size.width / 2){
                if(@available(iOS 10.0, *)){
                    
                }else{
                    self.zx_handleCustomPopGesture(self.zx_topViewController,1);
                }
            }else{
                if(@available(iOS 10.0, *)){
                    
                }else{
                    self.zx_handleCustomPopGesture(self.zx_topViewController,0);
                }
                
            }
        }else{
            if(popOffsetX >= 0){
                self.zx_handleCustomPopGesture(self.zx_topViewController,(popOffsetX / self.view.frame.size.width));
            }else{
                self.zx_handleCustomPopGesture(self.zx_topViewController,0);
            }
        }
    }
}

#pragma mark 更新栈顶控制器
- (void)updateTopViewController:(UIViewController *)viewController{
    self.zx_topViewController = nil;
    if(viewController && [viewController isKindOfClass:[ZXNavigationBarController class]]){
        self.zx_topViewController = (ZXNavigationBarController *)viewController;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer{
    if(gestureRecognizer != self.zx_popGestureRecognizer){
        return YES;
    }
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    /* **********************************************/
    // Thanks to @forkingdog  https://github.com/forkingdog/FDFullscreenPopGesture Respect!
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    BOOL isLeftToRight = [UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight;
    CGFloat multiplier = isLeftToRight ? 1 : - 1;
    if ((translation.x * multiplier) <= 0) {
        return NO;
    }
    /* **********************************************/
    CGFloat panGestureX = [gestureRecognizer locationInView:self.view].x;
    CGFloat coverW = self.zx_popGestureCoverRatio * self.view.frame.size.width;
    if(panGestureX > coverW){
        return NO;
    }
    self.touchBeginX = [gestureRecognizer locationInView:self.view].x;
    return self.childViewControllers.count != 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    BOOL shouldRecognizeSimultaneously = NO;
    if(self.zx_popGestureShouldRecognizeSimultaneously){
        shouldRecognizeSimultaneously = self.zx_popGestureShouldRecognizeSimultaneously(otherGestureRecognizer);
    }
    return shouldRecognizeSimultaneously;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    UIViewController *topViewController = self.topViewController;
        if(topViewController){
            id<UIViewControllerTransitionCoordinator> transitionCoordinator = topViewController.transitionCoordinator;
            if(transitionCoordinator){
                if(@available(iOS 10.0, *)){
                    [transitionCoordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context){
                        if([context isCancelled]){
                            if(self.zx_handleCustomPopGesture){
                                self.zx_handleCustomPopGesture(self.zx_topViewController,0);
                            }
                            
                        }else{
                            if(self.zx_handleCustomPopGesture){
                                self.zx_handleCustomPopGesture(self.zx_topViewController,1);
                            }
                        }
                    }];
                }
            }
        }
}


#pragma mark - getter&setter
- (void)setZx_disableFullScreenGesture:(BOOL)zx_disableFullScreenGesture{
    _zx_disableFullScreenGesture = zx_disableFullScreenGesture;
    if(zx_disableFullScreenGesture){
        self.zx_popGestureCoverRatio = 0.1;
    }else{
        self.zx_popGestureCoverRatio = 1;
    }
}


- (void)setZx_popGestureCoverRatio:(CGFloat)zx_popGestureCoverRatio{
    if(zx_popGestureCoverRatio > 1){
        _zx_popGestureCoverRatio = 1;
    }else if(zx_popGestureCoverRatio < 0){
        _zx_popGestureCoverRatio = 0;
    }else{
        _zx_popGestureCoverRatio = zx_popGestureCoverRatio;
    }
}
@end
