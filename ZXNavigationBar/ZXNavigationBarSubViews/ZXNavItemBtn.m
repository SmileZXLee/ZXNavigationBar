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
#import "NSAttributedString+ZXNavCalcSizeExtension.h"
@implementation ZXNavItemBtn
#pragma mark - Init
- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if(self){
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUp];
    }
    return self;
}

- (void)setUp{
    self.zx_fixWidth = -1;
    self.zx_fixHeight = -1;
    self.zx_fixImageSize = CGSizeZero;
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    if(self.zx_customView && title && title.length){
        return;
    }
    if(self.zx_disableSetTitle && title && !self.zx_customView){
        NSLog(@"zx_subLeftBtn/zx_subRightBtn不支持设置title，仅支持设置图片！");
        return;
    }
    [super setTitle:title forState:state];
    if(self.zx_tintColor){
        [self setTitleColor:self.zx_tintColor forState:state];
    }
    [self noticeUpdateFrame];
}

- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state{
    if(self.zx_customView && title && title.length){
        return;
    }
    if(self.zx_disableSetTitle && title && !self.zx_customView){
        NSLog(@"zx_subLeftBtn/zx_subRightBtn不支持设置attributedTitle，仅支持设置图片！");
        return;
    }
    [super setAttributedTitle:title forState:state];
    [self noticeUpdateFrame];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    if(self.zx_customView && image){
        return;
    }
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

- (void)setZx_fixWidth:(CGFloat)zx_fixWidth{
    _zx_fixWidth = zx_fixWidth;
    [self.superview setValue:@1 forKey:@"shouldRefLayout"];
    [self noticeUpdateFrame];
}

- (void)setZx_fixHeight:(CGFloat)zx_fixHeight{
    _zx_fixHeight = zx_fixHeight;
    [self.superview setValue:@1 forKey:@"shouldRefLayout"];
    [self noticeUpdateFrame];
}

- (void)setZx_fontSize:(CGFloat)zx_fontSize{
    _zx_fontSize = zx_fontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:zx_fontSize];
    [self.superview setValue:@1 forKey:@"shouldRefLayout"];
    [self noticeUpdateFrame];
}

- (void)setZx_fixImageSize:(CGSize)zx_fixImageSize{
    _zx_fixImageSize = zx_fixImageSize;
    [self.superview setValue:@1 forKey:@"shouldRefLayout"];
    [self layoutImageAndTitle];
    [self noticeUpdateFrame];
}

- (void)setZx_textAttachWidth:(CGFloat)zx_textAttachWidth{
    _zx_textAttachWidth = zx_textAttachWidth;
    [self.superview setValue:@1 forKey:@"shouldRefLayout"];
    [self layoutImageAndTitle];
    [self noticeUpdateFrame];
}

- (void)setZx_customView:(UIView *)zx_customView{
    _zx_customView = zx_customView;
    if(!zx_customView){
        return;
    }
    if(![self.subviews containsObject:zx_customView]){
        [self addSubview:zx_customView];
    }
    if(CGRectEqualToRect(zx_customView.frame, CGRectZero)){
        CGFloat customViewWidth = self.zx_fixWidth < 0 ? ZXNavDefalutItemSize : self.zx_fixWidth;
        CGFloat customViewHeight = self.zx_fixHeight < 0 ? ZXNavDefalutItemSize : self.zx_fixWidth;
        zx_customView.frame = CGRectMake(0, 0, customViewWidth, customViewHeight);
    }
    if(zx_customView.frame.size.width){
        self.zx_fixWidth = zx_customView.frame.size.width + zx_customView.frame.origin.x * 2;
    }
    if(zx_customView.frame.size.height){
        self.zx_fixHeight = zx_customView.frame.size.height + zx_customView.frame.origin.y * 2;
    }
    [self setImage:nil forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateNormal];
    [self setAttributedTitle:nil forState:UIControlStateNormal];
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
    CGFloat btnw = 0;
    if(self.currentAttributedTitle){
        btnw = [self.currentAttributedTitle zx_getAttrRectWidthWithLimitH:self.frame.size.height fontSize:self.titleLabel.font.pointSize] + 5;
    }else{
        if(self.currentTitle && self.currentTitle.length){
            btnw = [self.currentTitle zx_getRectWidthWithLimitH:self.frame.size.height fontSize:self.titleLabel.font.pointSize] + 5;
        }
        
    }
    btnw += self.zx_textAttachWidth;
    if(self.imageView.image){
        CGFloat imageHeight = self.frame.size.height;
        CGFloat imageWidth = self.frame.size.height;
        if(!CGSizeEqualToSize(self.zx_fixImageSize,CGSizeZero)){
            imageHeight = self.zx_fixImageSize.height;
            imageWidth = self.zx_fixImageSize.width;
        }
        self.imageView.frame = CGRectMake(0, (self.frame.size.height - imageHeight) / 2, imageWidth, imageHeight);
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame), 0, btnw, self.frame.size.height);
    }else{
        self.imageView.frame = CGRectZero;
        self.titleLabel.frame = CGRectMake(0, 0, btnw, self.frame.size.height);
    }
}

@end
