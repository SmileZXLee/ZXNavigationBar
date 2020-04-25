//
//  ZXNavItemBtn.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import "ZXNavItemBtn.h"
#import "ZXNavigationBarDefine.h"
#import "UIImage+ZXNavColorRender.h"
#import "NSString+ZXNavCalcSizeExtension.h"

@implementation ZXNavItemBtn

#pragma mark - Setter
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    if(self.zx_tintColor){
        [self setTitleColor:self.zx_tintColor forState:state];
    }
    [self noticeUpdateFrame];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    if(self.zx_tintColor){
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }else{
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    [super setImage:image forState:state];
    if(!image){
        self.imageView.image = image;
    }
    [self noticeUpdateFrame];
}

- (void)setZx_tintColor:(UIColor *)zx_tintColor{
    _zx_tintColor = zx_tintColor;
    self.tintColor = zx_tintColor;
    [self resetImage];
    [self resetTitle];
}


- (void)setZx_imageColor:(UIColor *)zx_imageColor{
    _zx_imageColor = zx_imageColor;
    self.tintColor = zx_imageColor;
    [self resetImage];
}

#pragma mark - pirvate
- (void)noticeUpdateFrame{
    if(self.zx_barItemBtnFrameUpdateBlock){
        self.zx_barItemBtnFrameUpdateBlock(self);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layoutImageAndTitle];
}

- (void)resetImage{
    [self setImage:self.currentImage forState:self.state];
}


- (void)resetTitle{
    [self setTitle:self.currentTitle forState:self.state];
}

#pragma mark ButtonLayout
- (void)layoutImageAndTitle{
    CGFloat btnw = [[NSString stringWithFormat:@"%@",self.currentTitle] getRectWidthWithLimitH:self.frame.size.height fontSize:self.titleLabel.font.pointSize] + 5;
    if(self.imageView.image){
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame), 0, btnw, self.frame.size.height);
    }else{
        self.imageView.frame = CGRectZero;
        self.titleLabel.frame = CGRectMake(0, 0, btnw, self.frame.size.height);
    }
}

@end
