//
//  DemoBaseViewController.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/3/10.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "DemoBaseViewController.h"

@interface DemoBaseViewController ()

@end

@implementation DemoBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    NSLog(@"%@-dealloc",[self class]);
}

@end
