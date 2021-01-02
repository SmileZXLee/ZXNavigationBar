//
//  DemoCompatibleScrollViewViewController.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/7/29.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "DemoCompatibleScrollViewViewController.h"
#define random(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/255.0]
#define randomColor random(arc4random_uniform(200), arc4random_uniform(200), arc4random_uniform(200), 255.0)

@interface DemoCompatibleScrollViewViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIScrollView *topScrollView;
@end

@implementation DemoCompatibleScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpView];
    
}

- (void)setUpNav{
    [self zx_setMultiTitle:self.title subTitle:@"兼容设置多ScrollView与侧滑返回手势演示"];
    //加这一行代码即可解决ScrollView与侧滑返回手势冲突问题（这里演示同时兼容两个scrollView的情况）
    [self zx_setPopGestureCompatibleScrollViews:@[self.topScrollView,self.scrollView]];
    //当导航控制器为ZXNavigationBarNavigationController或继承于ZXNavigationBarNavigationController时，如果需要更复杂的定制化的情况，可以使用下方的方式，以下代码的作用是在scrollView滚动到第一页的时候，支持pop手势多层级同时触发，为了更好的展示效果，建议关闭scrollView的bounces

    /*
    self.scrollView.bounces = NO;
    __weak typeof(self) weakSelf = self;
    self.zx_popGestureShouldRecognizeSimultaneously = ^BOOL(UIGestureRecognizer * _Nonnull otherGestureRecognizer) {
        if(weakSelf.scrollView.contentOffset.x <= 0){
            return YES;
        }
        return NO;
    };
     */
}


- (void)setUpView{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topScrollView];
    [self.view addSubview:self.scrollView];
    [self setUpScrollViewData];
}

- (void)setUpScrollViewData{
    [self layoutScrollViewSubviews:self.topScrollView];
    [self layoutScrollViewSubviews:self.scrollView];
}

- (void)layoutScrollViewSubviews:(UIScrollView *)scrollView{
    scrollView.pagingEnabled = YES;
    UIView *lastView;
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for(int i = 0; i < 10; i++){
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = randomColor;
        view.frame = CGRectMake(i * scrollView.zx_width, 0, scrollView.zx_width, scrollView.zx_height);
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.frame = view.bounds;
        titleLabel.font = [UIFont boldSystemFontOfSize:70];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = [NSString stringWithFormat:@"%d",i + 1];
        [view addSubview:titleLabel];
        [scrollView addSubview:view];
        lastView = view;
    }
    if(lastView){
        [scrollView setContentSize:CGSizeMake(CGRectGetMaxX(lastView.frame), 0)];
    }
    [scrollView setContentOffset:CGPointZero];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.topScrollView.frame = CGRectMake(0, ZXNavBarHeight, self.view.zx_width, 200);
    self.scrollView.frame = CGRectMake(0, ZXNavBarHeight + 200, self.view.zx_width, self.view.zx_height - ZXNavBarHeight - 200);
    [self setUpScrollViewData];
}


- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIScrollView *)topScrollView{
    if(!_topScrollView){
        _topScrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_topScrollView];
    }
    return _topScrollView;
}

@end
