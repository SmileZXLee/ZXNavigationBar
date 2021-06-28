//
//  ZXNavHistoryStackCell.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/12/22.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.4.1

#import <UIKit/UIKit.h>
#import "ZXNavHistoryStackModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZXNavHistoryStackCell : UICollectionViewCell
@property (strong, nonatomic) ZXNavHistoryStackModel *historyStackModel;
@property (assign, nonatomic) ZXNavHistoryStackViewStyle historyStackViewStyle;
@end

NS_ASSUME_NONNULL_END
