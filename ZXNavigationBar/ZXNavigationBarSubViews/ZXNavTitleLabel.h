//
//  ZXNavTitleLabel.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXNavTitleLabel : UILabel
@property (copy, nonatomic) void (^zx_titleLabelFrameUpdateBlock)(ZXNavTitleLabel *titleLabel);
@end

NS_ASSUME_NONNULL_END
