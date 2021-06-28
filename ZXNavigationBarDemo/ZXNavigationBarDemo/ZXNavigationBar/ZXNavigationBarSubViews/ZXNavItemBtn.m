//
//  ZXNavItemBtn.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar
//  V1.4.1

#import "ZXNavItemBtn.h"
#import "ZXNavigationBarDefine.h"
#import "UIImage+ZXNavColorRender.h"
#import "NSString+ZXNavCalcSizeExtension.h"
#import "NSAttributedString+ZXNavCalcSizeExtension.h"
@interface ZXNavItemBtn()
///NavItemBtn frame发生改变时的回调
@property(copy, nonatomic)void(^zx_frameUpdateBlock)(CGRect frame);
@end
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
    self.zx_fixMarginLeft = -1;
    self.zx_fixMarginRight = -1;
    self.zx_fixImageSize = CGSizeZero;
}

#pragma mark - Public
- (void)zx_updateLayout{
    [self zx_layoutImageAndTitle];
    [self noticeUpdateFrame];
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    if(self.zx_customView && title && title.length){
        return;
    }
    [super setTitle:title forState:state];
    if(self.zx_tintColor){
        [self setTitleColor:self.zx_tintColor forState:state];
    }
    [self zx_layoutImageAndTitle];
    [self noticeUpdateFrame];
}

- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state{
    if(self.zx_customView && title && title.length){
        return;
    }
    [super setAttributedTitle:title forState:state];
    [self zx_layoutImageAndTitle];
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
    [self zx_layoutImageAndTitle];
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

- (void)setZx_disableAutoLayoutImageAndTitle:(BOOL )zx_disableAutoLayoutImageAndTitle{
    _zx_disableAutoLayoutImageAndTitle = zx_disableAutoLayoutImageAndTitle;
    [self zx_layoutImageAndTitle];
    [self noticeUpdateFrame];
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

- (void)setZx_fixMarginLeft:(CGFloat)zx_fixMarginLeft{
    _zx_fixMarginLeft = zx_fixMarginLeft;
    [self.superview setValue:@1 forKey:@"shouldRefLayout"];
    [self noticeUpdateFrame];
}

- (void)setZx_fixMarginRight:(CGFloat)zx_fixMarginRight{
    _zx_fixMarginRight = zx_fixMarginRight;
    [self.superview setValue:@1 forKey:@"shouldRefLayout"];
    [self noticeUpdateFrame];
}

- (void)setZx_fontSize:(CGFloat)zx_fontSize{
    _zx_fontSize = zx_fontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:zx_fontSize];
    [self.superview setValue:@1 forKey:@"shouldRefLayout"];
    [self zx_layoutImageAndTitle];
    [self noticeUpdateFrame];
}

- (void)setZx_fixImageSize:(CGSize)zx_fixImageSize{
    _zx_fixImageSize = zx_fixImageSize;
    [self.superview setValue:@1 forKey:@"shouldRefLayout"];
    [self zx_layoutImageAndTitle];
    [self noticeUpdateFrame];
}

- (void)setZx_textAttachWidth:(CGFloat)zx_textAttachWidth{
    _zx_textAttachWidth = zx_textAttachWidth;
    [self.superview setValue:@1 forKey:@"shouldRefLayout"];
    [self zx_layoutImageAndTitle];
    [self noticeUpdateFrame];
}

- (void)setZx_textAttachHeight:(CGFloat)zx_textAttachHeight{
    _zx_textAttachHeight = zx_textAttachHeight;
    [self.superview setValue:@1 forKey:@"shouldRefLayout"];
    [self zx_layoutImageAndTitle];
    [self noticeUpdateFrame];
}

- (void)setZx_setCornerRadiusRounded:(BOOL)zx_setCornerRadiusRounded{
    _zx_setCornerRadiusRounded = zx_setCornerRadiusRounded;
    [self noticeUpdateFrame];
}

- (void)setZx_imageOffsetX:(CGFloat)zx_imageOffsetX{
    _zx_imageOffsetX = zx_imageOffsetX;
    [self zx_layoutImageAndTitle];
}

- (void)setZx_customView:(UIView *)zx_customView{
    if(!zx_customView){
        if([self.subviews containsObject:_zx_customView]){
            [_zx_customView removeFromSuperview];
        }
        _zx_customView = nil;
        [self noticeUpdateFrame];
        return;
    }
    _zx_customView = zx_customView;
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
    [self zx_layoutImageAndTitle];
}

- (void)resetImage{
    BOOL isStateFocused = NO;
    if(@available(iOS 9.0, *)){
        isStateFocused = self.state == UIControlStateFocused;
    }
    if(self.zx_useTintColorOnlyInStateNormal || isStateFocused){
        [self setImage:[self imageForState:UIControlStateNormal] forState:UIControlStateNormal];
    }else{
        [self setImage:self.currentImage forState:self.state];
    }
}


- (void)resetTitle{
    BOOL isStateFocused = NO;
    if(@available(iOS 9.0, *)){
        isStateFocused = self.state == UIControlStateFocused;
    }
    if(self.zx_useTintColorOnlyInStateNormal || isStateFocused){
        [self setTitle:[self titleForState:UIControlStateNormal] forState:UIControlStateNormal];
    }else{
        [self setTitle:self.currentTitle forState:self.state];
    }
}

#pragma mark ButtonLayout
- (void)zx_layoutImageAndTitle{
    if(self.zx_disableAutoLayoutImageAndTitle){
        return;
    }
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
        BOOL useFixImageSize = NO;
        CGFloat imageHeight = self.frame.size.height;
        CGFloat imageWidth = self.frame.size.height;
        if(!CGSizeEqualToSize(self.zx_fixImageSize,CGSizeZero)){
            imageHeight = self.zx_fixImageSize.height;
            imageWidth = self.zx_fixImageSize.width;
            useFixImageSize = YES;
        }
        CGFloat imageViewX = 0;
        if(!(self.currentTitle.length || self.currentAttributedTitle.length) && useFixImageSize){
            imageViewX = (self.frame.size.width - imageWidth) / 2 + self.zx_imageOffsetX;
        }
        self.imageView.frame = CGRectMake(imageViewX, (self.frame.size.height - imageHeight) / 2, imageWidth, imageHeight);
        self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame), 0, btnw, self.frame.size.height);
    }else{
        self.imageView.frame = CGRectZero;
        self.titleLabel.frame = CGRectMake(0, 0, btnw, self.frame.size.height);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if(self.zx_touchesBeganBlock){
        self.zx_touchesBeganBlock();
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if(self.zx_touchesEndBlock){
        self.zx_touchesEndBlock();
    }
}

@end
