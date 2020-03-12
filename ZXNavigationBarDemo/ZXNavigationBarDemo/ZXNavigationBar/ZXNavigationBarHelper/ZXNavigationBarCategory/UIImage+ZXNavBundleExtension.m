//
//  UIImage+ZXNavBundleExtension.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/11.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import "UIImage+ZXNavBundleExtension.h"
#import "ZXNavigationBar.h"
@implementation UIImage (ZXNavBundleExtension)

+ (UIImage *)imageFromBundleWithImageName:(NSString *)imageName{
    static UIImage *image = nil;
    if (image == nil) {
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[ZXNavigationBar class]] pathForResource:@"ZXNavigationBar" ofType:@"bundle"]];
        image = [[UIImage imageWithContentsOfFile:[bundle pathForResource:imageName ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

@end
