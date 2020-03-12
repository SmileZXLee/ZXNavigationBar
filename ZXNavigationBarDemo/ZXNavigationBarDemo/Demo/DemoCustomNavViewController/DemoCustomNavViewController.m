//
//  DemoCustomNavViewController.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/3/12.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "DemoCustomNavViewController.h"
#import "DemoCustomNav.h"
@interface DemoCustomNavViewController()
@property (weak, nonatomic) UILabel *noticeLabel;
@end
@implementation DemoCustomNavViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpView];
}

- (void)setUpNav{
    DemoCustomNav *customNav = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DemoCustomNav class]) owner:nil options:nil]lastObject];
    [self zx_addCustomNavBar:customNav];
}

- (void)setUpView{
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *noticeLabel = [[UILabel alloc]init];
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.text = @"使用侧滑手势可以返回主页";
    noticeLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:noticeLabel];
    self.noticeLabel = noticeLabel;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.noticeLabel.frame = CGRectMake(0, ZXNavBarHeight + 10, self.view.frame.size.width, 30);
}
@end
