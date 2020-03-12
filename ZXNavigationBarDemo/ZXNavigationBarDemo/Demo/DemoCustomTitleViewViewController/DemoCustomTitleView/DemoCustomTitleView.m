//
//  DemoCustomTitleView.m
//  ZXNavigationBarDemo
//
//  Created by 李兆祥 on 2020/3/12.
//  Copyright © 2020 ZXLee. All rights reserved.
//

#import "DemoCustomTitleView.h"
@interface DemoCustomTitleView()
@property (weak, nonatomic) IBOutlet UIView *titleView;

@end
@implementation DemoCustomTitleView

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleView.layer.cornerRadius = self.titleView.frame.size.height / 2;
    self.titleView.clipsToBounds = YES;
}

@end
