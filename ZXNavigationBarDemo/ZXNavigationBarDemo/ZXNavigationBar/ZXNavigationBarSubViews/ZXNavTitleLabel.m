//
//  ZXNavTitleLabel.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/7.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import "ZXNavTitleLabel.h"

@implementation ZXNavTitleLabel

- (void)setText:(NSString *)text{
    [super setText:text];
    [self noticeUpdateFrame];
}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    [self noticeUpdateFrame];
}

- (void)setFont:(UIFont *)font{
    [super setFont:font];
    [self noticeUpdateFrame];
}

- (void)noticeUpdateFrame{
    if(self.zx_titleLabelFrameUpdateBlock){
        self.zx_titleLabelFrameUpdateBlock(self);
    }
}

@end
