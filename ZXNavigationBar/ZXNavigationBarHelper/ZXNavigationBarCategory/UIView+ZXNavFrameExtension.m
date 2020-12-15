//
//  UIView+ZXNavFrameExtension.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.3.6

#import "UIView+ZXNavFrameExtension.h"

@implementation UIView (ZXNavFrameExtension)
- (CGFloat)zx_x{
    return self.frame.origin.x;
}

- (void)setZx_x:(CGFloat)zx_x{
    self.frame = CGRectMake(zx_x, self.zx_y, self.zx_width, self.zx_height);
}

- (CGFloat)zx_y{
    return self.frame.origin.y;
}

- (void)setZx_y:(CGFloat)zx_y{
    self.frame = CGRectMake(self.zx_x, zx_y, self.zx_width, self.zx_height);
}

- (CGFloat)zx_width{
    return self.frame.size.width;
}

- (void)setZx_width:(CGFloat)zx_width{
    self.frame = CGRectMake(self.zx_x, self.zx_y, zx_width, self.zx_height);
}

- (CGFloat)zx_height{
    return self.frame.size.height;
}

- (void)setZx_height:(CGFloat)zx_height{
    self.frame = CGRectMake(self.zx_x, self.zx_y, self.zx_width, zx_height);
}

- (CGFloat)zx_right{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setZx_right:(CGFloat)zx_right{
    CGRect frame = self.frame;
    frame.origin.x = zx_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)zx_bottom{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setZx_bottom:(CGFloat)zx_bottom{
    CGRect frame = self.frame;
    frame.origin.y = zx_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)zx_centerX{
    return self.center.x;
}

- (void)setZx_centerX:(CGFloat)zx_centerX{
    self.center = CGPointMake(zx_centerX, self.center.y);
}

- (CGFloat)zx_centerY{
    return self.center.y;
}

- (void)setZx_centerY:(CGFloat)zx_centerY{
    self.center = CGPointMake(self.center.x, zx_centerY);
}

- (CGPoint)zx_origin{
    return self.frame.origin;
}

- (void)setZx_origin:(CGPoint)zx_origin{
    CGRect frame = self.frame;
    frame.origin = zx_origin;
    self.frame = frame;
}

- (CGSize)zx_size{
    return self.frame.size;
}

- (void)setZx_size:(CGSize)zx_size{
    CGRect frame = self.frame;
    frame.size = zx_size;
    self.frame = frame;
}
@end
