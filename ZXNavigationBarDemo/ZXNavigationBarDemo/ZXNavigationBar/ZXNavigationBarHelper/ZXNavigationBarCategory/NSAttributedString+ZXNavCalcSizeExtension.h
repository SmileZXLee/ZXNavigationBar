//
//  NSAttributedString+ZXNavCalcSizeExtension.h
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/10/23.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.3.6

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (ZXNavCalcSizeExtension)
- (CGFloat)zx_getAttrRectWidthWithLimitH:(CGFloat)limitH fontSize:(CGFloat)fontSize;
- (CGFloat)zx_getAttrRectHeightWithLimitW:(CGFloat)limitW fontSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
