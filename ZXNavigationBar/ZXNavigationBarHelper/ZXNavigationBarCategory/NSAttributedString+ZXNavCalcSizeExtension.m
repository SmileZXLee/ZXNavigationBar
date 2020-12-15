//
//  NSAttributedString+ZXNavCalcSizeExtension.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/10/23.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.3.6

#import "NSAttributedString+ZXNavCalcSizeExtension.h"

@implementation NSAttributedString (ZXNavCalcSizeExtension)
- (CGFloat)zx_getAttrRectWidthWithLimitH:(CGFloat)limitH fontSize:(CGFloat)fontSize{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.attributedText = self;
    return [label sizeThatFits:CGSizeMake(MAXFLOAT, limitH)].width;
}
- (CGFloat)zx_getAttrRectHeightWithLimitW:(CGFloat)limitW fontSize:(CGFloat)fontSize{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.attributedText = self;
    return [label sizeThatFits:CGSizeMake(limitW,MAXFLOAT )].height;
}
@end
