//
//  DemoFoldXibViewController.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/3/13.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "DemoFoldXibViewController.h"

@interface DemoFoldXibViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datas;
@property (assign, nonatomic) CGFloat lastOffsetY;

@end

@implementation DemoFoldXibViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpViewAndData];
}

- (void)setUpNav{
    self.title = @"可伸缩式导航栏";
    self.zx_navStatusBarStyle = ZXNavStatusBarStyleLight;
    [self.zx_navLeftBtn setTitle:@"首页" forState:UIControlStateNormal];
    self.zx_navBar.backgroundColor = [UIColor colorWithRed:16/255.0 green:94/255.0 blue:253/255.0 alpha:1];
    self.zx_navTintColor = [UIColor whiteColor];
    [self zx_setRightBtnWithImgName:@"recycle_icon" clickedBlock:nil];
}

- (void)setUpViewAndData{
    self.view.backgroundColor = [UIColor whiteColor];
    self.datas = @[@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳",@"武汉加油，中国加油🇨🇳"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - offsetY;
    CGFloat distance = offsetY - self.lastOffsetY;
    self.lastOffsetY = offsetY;
    if (distance > 0 && offsetY > 0) {
        //向上滚动，导航栏折叠
        if(!self.zx_navIsFolded){
            //如果没有折叠 就折叠
            [self setNavFold:YES];
        }
        
    }
    if (distance < 0 && distanceFromBottom > scrollView.height) {
        //向下滚动
        if(self.zx_navIsFolded){
            //如果有折叠 就展开
            [self setNavFold:NO];
        }
        
    }
}

- (void)setNavFold:(BOOL)shouldFold{
    [self zx_setNavFolded:shouldFold speed:3 foldingOffsetBlock:nil foldCompletionBlock:nil];
}

@end
