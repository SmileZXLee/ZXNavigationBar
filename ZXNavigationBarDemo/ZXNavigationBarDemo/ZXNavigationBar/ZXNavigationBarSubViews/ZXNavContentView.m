//
//  ZXNavContentView.m
//  ZXNavigationBar
//
//  Created by 李兆祥 on 2020/3/10.
//  Copyright © 2020 ZXLee. All rights reserved.
//  https://github.com/SmileZXLee/ZXNavigationBar

#import "ZXNavContentView.h"
#import "ZXNavigationBarDefine.h"
#import "ZXNavigationBarController.h"
@implementation ZXNavContentView

- (instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor =[UIColor clearColor];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview];
}
- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       // [self  addSubview];
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}



-(void)addSubview{
    self.backgroundColor = [UIColor yellowColor];
    ZXNavigationBarController *baseVc = (ZXNavigationBarController *)self.nextResponder.nextResponder;
    int flag = [self addNavMargin:baseVc];
    if(flag != 0){
        NSArray *constraintArr =[self.superview constraints];
        if (constraintArr.count==0) {
            return;
        }
        if(flag == 2){
            __block int i =0;
            //顺序遍历
            [constraintArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLayoutConstraint * constraint = obj;
                if (constraint.firstAttribute == NSLayoutAttributeTop){
                    //constraint.adapterScreen = NO;
                    //constraint.constant = baseVc.zx_isEnableSafeArea ? ZXAppStatusBarHeight : ZXNavBarHeight;
                    i++;
                    if(i==2){
                        *stop = YES;
                    }
                }
                if (constraint.firstAttribute == NSLayoutAttributeBottom) {
                    //constraint.adapterScreen = NO;
                    constraint.constant = ((UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController).tabBar.frame.size.height;
                    i++;
                    if(i==2){
                        *stop = YES;
                    }
                }
            }];
        }else{
            __block int i =0;
            //顺序遍历
            [constraintArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSLayoutConstraint * constraint = obj;
                if (constraint.firstAttribute == NSLayoutAttributeTop) {
                    //constraint.adapterScreen = NO;
                    //constraint.constant = baseVc.zx_enableSafeArea ? ZXAppStatusBarHeight : ZXNavBarHeight;
                    i++;
                    if(i==2){
                        *stop = YES;
                    }
                }
            
            }];
        }
    }else{
        
    }
}


-(int)addNavMargin:(ZXNavigationBarController *)baseVc{
    //0代表不进行任何处理 1代表根据导航栏高度下移 2代表根据导航栏高度下移并且总的高度减去tabbar高度
    
    
    //vc.additionalSafeAreaInsets = UIEdgeInsetsMake(200, 0, 0, 0);
    //NSLog(@"%lf",vc.additionalSafeAreaInsets.top);
    if(![baseVc isKindOfClass:[UIViewController class]]){
        return 0;
    }
    if(baseVc.zx_hideBaseNavBar || !baseVc.navigationController){
        return 0;
    }
    if(baseVc.navigationController.viewControllers.count == 1){
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if([rootVC isKindOfClass:[UITabBarController class]]){
            if([((UITabBarController *)rootVC).childViewControllers containsObject:baseVc.navigationController]){
                return 2;
            }
        }
    }
    return 1;
}

@end
