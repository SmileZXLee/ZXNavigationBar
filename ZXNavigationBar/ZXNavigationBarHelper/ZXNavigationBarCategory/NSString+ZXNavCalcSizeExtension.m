//
//  NSString+ZXNavCalcSizeExtension.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.3.6

#import "NSString+ZXNavCalcSizeExtension.h"

@implementation NSString (ZXNavCalcSizeExtension)
- (CGFloat)zx_getRectWidthWithLimitH:(CGFloat)limitH fontSize:(CGFloat)fontSize{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, limitH)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                     context:nil];
    return rect.size.width;
}
- (CGFloat)zx_getRectHeightWithLimitW:(CGFloat)limitW fontSize:(CGFloat)fontSize{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(limitW,MAXFLOAT )
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                     context:nil];
    return rect.size.height;
}
@end
