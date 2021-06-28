//
//  ZXNavHistoryStackContentView.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/12/22.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.4.1

#import "ZXNavHistoryStackContentView.h"
#import "ZXNavHistoryStackCell.h"

#import "ZXNavigationBarDefine.h"
#import "UIView+ZXNavFrameExtension.h"

#import <UIKit/UIFeedbackGenerator.h>
static NSString *historyStackViewCellReuseIdentifier = @"ZXNavHistoryStackCell";
@interface ZXNavHistoryStackContentView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UIView *coverView;
@property (assign, nonatomic) BOOL isShowed;
@property (strong, nonatomic) ZXNavHistoryStackModel *selectedHistoryStackModel;
@end
@implementation ZXNavHistoryStackContentView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUp];
    }
    return self;
}

- (void)setUp{
    [self addSubview:self.coverView];
    [self addSubview:self.zx_historyStackView];
    self.zx_historyStackView.delegate = self;
    self.zx_historyStackView.dataSource = self;
    [self.zx_historyStackView registerClass:[ZXNavHistoryStackCell class] forCellWithReuseIdentifier:historyStackViewCellReuseIdentifier];
    self.coverView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(coverViewTouch)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverViewTouch)];
    [self.coverView addGestureRecognizer:panGestureRecognizer];
    [self.coverView addGestureRecognizer:tapGestureRecognizer];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orientationDidChange:)name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.frame = [UIScreen mainScreen].bounds;
    self.coverView.frame = self.frame;
    if(self.isShowed){
        [self updateHistoryStackViewFrameWithHide:NO];
    }
}

- (void)coverViewTouch{
    if(self.isShowed){
        [self zx_hide];
    }
}

- (instancetype)zx_show{
    [ZXMainWindow addSubview:self];
    [self updateHistoryStackViewFrameWithHide:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];
        [self updateHistoryStackViewFrameWithHide:NO];
    }completion:^(BOOL finished) {
        self.isShowed = YES;
    }];
    
    return self;
}

- (void)zx_hide{
    self.isShowed = NO;
    [UIView animateWithDuration:0.15 animations:^{
        self.coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [self updateHistoryStackViewFrameWithHide:YES];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)updateHistoryStackViewFrameWithHide:(BOOL)isHide{
    if(isHide){
        self.zx_historyStackView.frame = CGRectMake(self.zx_historyStackViewLeft + 20, ZXAppStatusBarHeight + ZXNavHistoryStackCellHeight / 2, 0, 0);
    }else{
        self.zx_historyStackView.frame = CGRectMake(self.zx_historyStackViewLeft, ZXAppStatusBarHeight, ZXNavHistoryStackViewWidth, self.zx_historyStackArray.count * ZXNavHistoryStackCellHeight);
    }
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.zx_historyStackView.frame.size.width, ZXNavHistoryStackCellHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ZXNavHistoryStackModel *historyStackModel = self.zx_historyStackArray[indexPath.row];
    [self doPopViewController:historyStackModel];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.zx_historyStackArray.count;
}
 
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZXNavHistoryStackCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:historyStackViewCellReuseIdentifier forIndexPath:indexPath];
    cell.historyStackViewStyle = self.zx_historyStackViewStyle;
    cell.historyStackModel = self.zx_historyStackArray[indexPath.row];
    return cell;
}

#pragma mark - Private
- (void)handlePanGestureWithPoint:(CGPoint)point{
    if(point.x > CGRectGetMaxX(self.zx_historyStackView.frame) || point.y > CGRectGetMaxY(self.zx_historyStackView.frame)){
        if(self.selectedHistoryStackModel){
            self.selectedHistoryStackModel.isSelected = NO;
            self.selectedHistoryStackModel = nil;
            [self.zx_historyStackView reloadData];
        }
    }else{
        if(self.selectedHistoryStackModel){
            self.selectedHistoryStackModel.isSelected = NO;
        }
        NSIndexPath *indexPath = [self.zx_historyStackView indexPathForItemAtPoint:point];
        ZXNavHistoryStackModel *historyStackModel = self.zx_historyStackArray[indexPath.row];
        if(indexPath && !(self.selectedHistoryStackModel && self.selectedHistoryStackModel == historyStackModel)){
            historyStackModel.isSelected = YES;
            [self.zx_historyStackView reloadData];
            self.selectedHistoryStackModel = historyStackModel;
            if (@available(iOS 10.0, *)){
                UIImpactFeedbackGenerator *impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleLight];
                [impactFeedbackGenerator impactOccurred];
            }
        }
    }
}

- (void)handlePanGestureEnd{
    [self doPopViewController:self.selectedHistoryStackModel];
}


- (void)doPopViewController:(ZXNavHistoryStackModel *)historyStackModel{
    if(historyStackModel && historyStackModel.viewController && historyStackModel.viewController.navigationController){
        [historyStackModel.viewController.navigationController popToViewController:historyStackModel.viewController animated:YES];
        [self zx_hide];
    }
}

- (void)orientationDidChange:(NSNotification *)sender{
    if(self.isShowed){
        [self zx_hide];
    }
}

#pragma mark - LazyLoad
- (ZXNavHistoryStackView *)zx_historyStackView{
    if(!_zx_historyStackView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _zx_historyStackView = [[ZXNavHistoryStackView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _zx_historyStackView.backgroundColor = [UIColor whiteColor];
        _zx_historyStackView.clipsToBounds = YES;
        _zx_historyStackView.layer.cornerRadius = 12;
        if(self.zx_historyStackViewStyle == ZXNavHistoryStackViewStyleLight){
            _zx_historyStackView.backgroundColor = ZXNavHistoryStackViewStyleLightBackgroundColor;
        }else{
            _zx_historyStackView.backgroundColor = ZXNavHistoryStackViewStyleDarkBackgroundColor;
        }
        
    }
    return _zx_historyStackView;
}

- (UIView *)coverView{
    if(!_coverView){
        _coverView = [[UIView alloc]init];
    }
    return _coverView;
}

- (void)setZx_historyStackArray:(NSMutableArray<ZXNavHistoryStackModel *> *)zx_historyStackArray{
    _zx_historyStackArray = zx_historyStackArray;
    if(zx_historyStackArray.count){
        ZXNavHistoryStackModel *firstHistoryStackModel = zx_historyStackArray.firstObject;
        ZXNavHistoryStackModel *lastHistoryStackModel = zx_historyStackArray.lastObject;
        firstHistoryStackModel.isSelected = YES;
        self.selectedHistoryStackModel = firstHistoryStackModel;
        lastHistoryStackModel.isLast = YES;
    }
}

- (void)setZx_historyStackViewStyle:(ZXNavHistoryStackViewStyle)zx_historyStackViewStyle{
    _zx_historyStackViewStyle = zx_historyStackViewStyle;
    [self.zx_historyStackView reloadData];
}

- (void)setZx_historyStackViewLeft:(CGFloat)zx_historyStackViewLeft{
    _zx_historyStackViewLeft = zx_historyStackViewLeft;
    self.zx_historyStackView.zx_x = zx_historyStackViewLeft;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
