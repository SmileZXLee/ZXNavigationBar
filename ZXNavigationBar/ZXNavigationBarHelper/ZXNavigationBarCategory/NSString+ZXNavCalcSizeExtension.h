//
//  NSString+ZXNavCalcSizeExtension.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.3.6

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZXNavCalcSizeExtension)
- (CGFloat)zx_getRectHeightWithLimitW:(CGFloat)limitW fontSize:(CGFloat)fontSize;
- (CGFloat)zx_getRectWidthWithLimitH:(CGFloat)limitH fontSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
