//
//  ZXNavHistoryStackContentView.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/12/22.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.4.1

#import <UIKit/UIKit.h>
#import "ZXNavHistoryStackView.h"
#import "ZXNavHistoryStackModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface ZXNavHistoryStackContentView : UIView
@property (strong, nonatomic) ZXNavHistoryStackView *zx_historyStackView;
@property (strong, nonatomic) NSMutableArray<ZXNavHistoryStackModel *> *zx_historyStackArray;
///导航栏历史堆栈视图与屏幕左侧的距离，与返回按钮与屏幕左侧的距离相同，交由内部处理，修改此属性无效
@property (assign, nonatomic) CGFloat zx_historyStackViewLeft;
///导航栏历史堆栈视图显示样式
@property (assign, nonatomic) ZXNavHistoryStackViewStyle zx_historyStackViewStyle;
- (instancetype)zx_show;
- (void)zx_hide;
@end

NS_ASSUME_NONNULL_END
