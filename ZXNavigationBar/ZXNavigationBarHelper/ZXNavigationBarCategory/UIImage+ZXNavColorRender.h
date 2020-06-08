//
//  UIImage+ZXNavColorRender.h
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/10.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZXNavColorRender)

/**
 图片渲染

 @param color 需要渲染的颜色
 @return 渲染后的图片
 */
- (UIImage *)zx_renderingColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
