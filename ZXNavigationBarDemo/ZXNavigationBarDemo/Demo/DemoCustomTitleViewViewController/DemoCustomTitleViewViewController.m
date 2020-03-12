//
//  DemoCustomTitleViewViewController.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/3/12.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "DemoCustomTitleViewViewController.h"
#import "DemoCustomTitleView.h"
@implementation DemoCustomTitleViewViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpView];
}

- (void)setUpNav{
    DemoCustomTitleView *customTitleView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DemoCustomTitleView class]) owner:nil options:nil]lastObject];
    [self zx_addCustomTitleView:customTitleView];
    
    [self zx_setRightBtnWithText:@"测试" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
        
    }];
}

- (void)setUpView{
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
