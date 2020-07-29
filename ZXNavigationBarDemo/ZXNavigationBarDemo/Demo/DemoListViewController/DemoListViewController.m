//
//  DemoListViewController.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/3/10.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "DemoListViewController.h"
#import "DemoXibViewController.h"
#import "DemoWeiboHotViewController.h"
#import "DemoCustomNavViewController.h"
#import "DemoCustomTitleViewViewController.h"
#import "DemoSystemBarViewController.h"
#import "DemoFoldFrameViewController.h"
#import "DemoFoldXibViewController.h"
#import "DemoCompatibleScrollViewViewController.h"
@interface DemoListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *datas;
@end

@implementation DemoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpViewAndData];
}

- (void)setUpNav{
    self.title = @"ZXNavigationBar";
    self.zx_navEnableSmoothFromSystemNavBar = YES;
}

- (void)setUpViewAndData{
    self.datas = @[@"ZXNavigationBar属性设置",@"仿微博热搜页面导航栏",@"可伸缩式导航栏(从Xib中设置tableView约束)",@"可伸缩式导航栏(通过Frame设置tableView约束)",@"自定义导航栏",@"自定义TitleView",@"跳转到使用系统导航栏的控制器",@"ScrollView与侧滑返回手势冲突处理"];
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, ZXNavBarHeight, self.view.frame.size.width, self.view.frame.size.height - ZXNavBarHeight);
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:{
            //跳转到ZXNavigationBar属性设置
            vc = [[DemoXibViewController alloc]init];
            break;
        }
        case 1:{
            //仿微博热搜页面导航栏
            vc = [[DemoWeiboHotViewController alloc]init];
            break;
        }
        case 2:{
            //可伸缩式导航栏(从Xib中设置tableView约束)
            vc = [[DemoFoldXibViewController alloc]init];
            break;
        }
        case 3:{
            //可伸缩式导航栏(通过Frame设置tableView约束)
            vc = [[DemoFoldFrameViewController alloc]init];
            break;
        }
        case 4:{
            //自定义导航栏
            vc = [[DemoCustomNavViewController alloc]init];
            break;
        }
        case 5:{
            //自定义TitleView
            vc = [[DemoCustomTitleViewViewController alloc]init];
            break;
        }
        case 6:{
            //跳转到使用系统导航栏的控制器
            vc = [[DemoSystemBarViewController alloc]init];
            break;
        }
        case 7:{
            //与ScrollView侧滑返回手势冲突处理
            vc = [[DemoCompatibleScrollViewViewController alloc]init];
            break;
        }

        default:
            break;
    }
    if(vc){
        vc.title = self.datas[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
