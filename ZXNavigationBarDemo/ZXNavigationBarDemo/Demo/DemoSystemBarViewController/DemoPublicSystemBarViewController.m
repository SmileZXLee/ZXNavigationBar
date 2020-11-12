//
//  DemoPublicSystemBarViewController.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/8/4.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "DemoPublicSystemBarViewController.h"
#import "DemoXibViewController.h"

@interface DemoPublicSystemBarViewController ()

@end

@implementation DemoPublicSystemBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"系统导航栏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 20);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"这是一个系统导航栏的控制器";
    [self.view addSubview:label];
    
    //注意，因导航栏默认被隐藏，请手动设置显示导航栏
    self.navigationController.navigationBarHidden = NO;
    //如果希望view从导航栏下方开始，请设置导航栏为不透明
    self.navigationController.navigationBar.translucent = NO;
}

@end
