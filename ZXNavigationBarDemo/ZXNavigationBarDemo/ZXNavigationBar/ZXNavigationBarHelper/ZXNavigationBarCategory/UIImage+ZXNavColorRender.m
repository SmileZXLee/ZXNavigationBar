//
//  UIImage+ZXNavColorRender.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/10.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import "UIImage+ZXNavColorRender.h"

@implementation UIImage (ZXNavColorRender)
- (UIImage *)zx_renderingColor:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [color setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
@end
