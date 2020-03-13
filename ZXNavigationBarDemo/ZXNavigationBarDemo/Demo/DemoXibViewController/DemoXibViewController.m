//
//  DemoXibViewController.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/3/10.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "DemoXibViewController.h"
#import "DemoSystemBarViewController.h"
@interface DemoXibViewController ()

@end

@implementation DemoXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏标题
    self.title = @"ZXNavigationBar";
    
    //设置最右侧的Button的图片和点击回调
    [self zx_setRightBtnWithImgName:@"set_icon" clickedBlock:^(UIButton * _Nonnull btn) {
        NSLog(@"点击了最右侧的Button");
    }];
    //最左侧的按钮添加”返回“文字，当当前控制器不是第0个的时候，ZXNavigationBar会自动显示返回图片，且点击返回上一个控制器
    [self.zx_navLeftBtn setTitle:@"返回" forState:UIControlStateNormal];
}

#pragma mark - Actions

#pragma mark 点击了设置背景色橙色
- (IBAction)changeBacColorAction:(UISwitch *)sender {
    if(sender.on){
        self.zx_navBar.backgroundColor = [UIColor orangeColor];
    }else{
        self.zx_navBar.backgroundColor = [UIColor whiteColor];
    }
    
}

#pragma mark 点击了设置背景图片
- (IBAction)setBacImageAction:(UISwitch *)sender {
    if(sender.on){
        
        self.zx_navBar.zx_bacImage = [UIImage imageNamed:@"nav_bac"];
    }else{
        self.zx_navBar.zx_bacImage = nil;
    }
}

#pragma mark 点击了设置TintColor黄色
- (IBAction)ChangeTintColorAction:(UISwitch *)sender {
    if(sender.on){
        self.zx_navTintColor = [UIColor yellowColor];
    }else{
        self.zx_navTintColor = [UIColor blackColor];
    }
}

#pragma mark 点击了设置大小标题效果
- (IBAction)setBigSubTitleAction:(UISwitch *)sender {
    if(sender.on){
        [self zx_setMultiTitle:@"ZXNavigationBar" subTitle:@"subTitle"];
    }else{
        self.title = @"ZXNavigationBar";
    }
}

#pragma mark 点击了设置StatusBar白色
- (IBAction)changeStatusBarAction:(UISwitch *)sender {
    if(sender.on){
        self.zx_isLightStatusBar = YES;
    }else{
        self.zx_isLightStatusBar = NO;
    }
}

#pragma mark 点击了设置两边Item大小为30
- (IBAction)changeItemSizeAction:(UISwitch *)sender {
    if(sender.on){
        self.zx_navItemSize = 30;
    }else{
        self.zx_navItemSize = ZXNavDefalutItemSize;
    }
}

#pragma mark 点击了设置两边Item边距为0
- (IBAction)changeItemMarginAction:(UISwitch *)sender {
    if(sender.on){
        self.zx_navItemMargin = 0;
    }else{
        self.zx_navItemMargin = ZXNavDefalutItemMargin;
    }
}

#pragma mark 点击了设置渐变背景
- (IBAction)changeGradientBacAction:(UISwitch *)sender {
    if(sender.on){
        [self zx_setNavGradientBacFrom:[UIColor magentaColor] to:[UIColor cyanColor]];
    }else{
        [self zx_removeNavGradientBac];
    }
    
}

#pragma mark 点击了更换为系统的导航栏
- (IBAction)changeSystemNavBarAction:(UISwitch *)sender {
    if(sender.on){
        self.zx_showSystemNavBar = YES;
    }else{
        self.zx_showSystemNavBar = NO;
        self.zx_hideBaseNavBar = NO;
    }
    
}

#pragma mark 点击了右侧显示两个Item
- (IBAction)changeRightSubBtnAction:(UISwitch *)sender {
    if(sender.on){
        [self zx_setSubRightBtnWithImgName:@"light_icon" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
            NSLog(@"点击了右侧第二个Button");
        }];
    }else{
        [self.zx_navSubRightBtn setImage:nil forState:UIControlStateNormal];
    }
}


@end
