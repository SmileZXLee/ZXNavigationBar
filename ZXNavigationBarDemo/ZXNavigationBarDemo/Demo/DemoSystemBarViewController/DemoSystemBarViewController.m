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
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 10, ZXScreenWidth, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"这是一个系统导航栏的控制器";
    [self.view addSubview:label];
}
@end
