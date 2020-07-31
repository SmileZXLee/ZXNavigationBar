//
//  DemoWeiboHotViewController.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/3/12.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "DemoWeiboHotViewController.h"
#import "UIView+ZXNavFrameExtension.h"
#import "DemoSystemBarViewController.h"
@interface DemoWeiboHotViewController()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *datas;
@end
@implementation DemoWeiboHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpViewAndData];
}

- (void)setUpNav{
    //设置导航栏背景色RGB中Alpha为0
    self.zx_navBarBackgroundColorAlpha = 0;
    //左侧按钮添加”返回“文字
    [self.zx_navLeftBtn setTitle:@"返回" forState:UIControlStateNormal];
    //设置最右侧按钮的图片和点击事件
    __weak typeof(self) weakSelf = self;
    [self zx_setRightBtnWithImgName:@"right_more_icon" clickedBlock:^(ZXNavItemBtn * _Nonnull btn) {
        NSLog(@"点击了最右边的按钮");
        DemoSystemBarViewController *vc = [[DemoSystemBarViewController alloc]init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    self.zx_navEnableSmoothFromSystemNavBar = YES;
    [self setLightNav];
}

- (void)setUpViewAndData{
    self.datas = @[@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳"];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark 设置导航栏为黑色
- (void)setDarkNav{
    //设置导航栏文字标题和两侧按钮的颜色为黑色
    [self setZx_navTintColor:[UIColor blackColor]];
    //设置导航栏文字标题
    self.title = @"微博热搜";
    //隐藏分割线
    self.zx_navLineView.hidden = NO;
    //设置状态栏为黑色
    self.zx_navStatusBarStyle = ZXNavStatusBarStyleDefault;
}

#pragma mark 设置导航栏为白色
- (void)setLightNav{
    //设置导航栏文字标题和两侧按钮的颜色为白色
    [self setZx_navTintColor:[UIColor whiteColor]];
    //设置导航栏文字标题
    self.title = @"";
    //显示分割线
    self.zx_navLineView.hidden = YES;
    //设置状态栏为白色
    self.zx_navStatusBarStyle = ZXNavStatusBarStyleLight;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self zx_setNavTransparentGradientsWithScrollView:scrollView fullChangeHeight:100 changeLimitNavAlphe:0.7 transparentGradientsTransparentBlock:^{
        [self setLightNav];
    } transparentGradientsOpaqueBlock:^{
        [self setDarkNav];
    }];
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
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *headerImageView = [[UIImageView alloc]init];
    headerImageView.image = [UIImage imageNamed:@"weibo_hot_bac.jpg"];
    return headerImageView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.view.frame.size.width * 0.5;
}
@end
