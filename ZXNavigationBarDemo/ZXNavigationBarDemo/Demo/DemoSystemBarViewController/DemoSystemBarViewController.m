//
//  DemoSystemBarViewController.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/3/11.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "DemoSystemBarViewController.h"

@implementation DemoSystemBarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统导航栏";
    self.zx_showSystemNavBar = YES;
    self.view.backgroundColor = [UIColor whiteColor];
}
@end
