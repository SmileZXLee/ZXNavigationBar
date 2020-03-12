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
}

- (void)setUpViewAndData{
    self.datas = @[@"ZXNavigationBar属性设置",@"仿微博热搜页面导航栏",@"自定义导航栏",@"自定义TitleView",@"跳转到使用系统导航栏的控制器"];
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
            //自定义导航栏
            vc = [[DemoCustomNavViewController alloc]init];
            break;
        }
        case 3:{
            //自定义TitleView
            vc = [[DemoCustomTitleViewViewController alloc]init];
            break;
        }
        case 4:{
            //跳转到使用系统导航栏的控制器
            vc = [[DemoSystemBarViewController alloc]init];
            break;
        }
        default:
            break;
    }
    if(vc){
        [self.navigationController pushViewController:vc animated:YES];
    }
}



@end
